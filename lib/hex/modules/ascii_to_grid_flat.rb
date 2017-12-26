# This module contains the methods relatives to ascii map reading
module AsciiToGridFlat

  # Read an ascii file and load it into the hexagon grid. The input grid is supposed to be odd flat topped (odd-q) and will be stored into an axial representation.
  #
  # @param file_path [String] the name of the ascii file to read. For how to create this file, please see : https://github.com/czuger/rhex#reading-a-grid-from-an-ascii-file
  def read_ascii_file_flat_topped_odd( file_path )
    File.open( file_path ) do |file|

      odd = 0
      base_q = 0
      line_q = 0

      file.each_line do |line|
        elements = line.split
        elements.each_with_index do |element, index|
          # puts "element = %c, index = %d || q = %d, r = %d" % [element, index, index*2 + odd, base_q - index]
          # cset( index*2 + odd, base_q - index, color: element.to_sym, border: nil )
          q = index*2 + odd
          r = base_q - index
          @hexes[ [ q, r ] ] = AxialHex.new( q, r, color: element.to_sym )
        end

        odd = ( odd.odd? ? 0 : 1 )

        line_q += 1
        if line_q >= 2
          line_q = 0
          base_q += 1
        end

      end
    end
  end


  # Write an ascii file representing an axial hex grid as an flat topped (odd-q) hex representation.
  #
  # @param file_path [String] the name of the ascii file to read. For how to create this file, please see : https://github.com/czuger/rhex#reading-a-grid-from-an-ascii-file
  def write_ascii_file_flat_topped_odd( file_path )
    File.open( file_path, 'w' ) do |file|

      base_r = 0
      base_q = 0
      line_q = 0
      line = []


      loop do
        r = base_r
        q = base_q
        odd = ( base_q == 0 ? '' : ' ' )

        while( ( hex = cget( q, r ) ) ) do
          line << hex.color
          q += 2
          r -= 1
        end

        break if line.empty?

        file.puts( odd + line.join( ' ' ) )

        base_q = ( base_q == 0 ? 1 : 0 )

        line_q += 1
        if line_q >= 2
          line_q = 0
          base_r += 1
        end
        line = []
      end

    end
  end

end
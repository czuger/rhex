# This module contains the methods relatives to ascii map reading
module AsciiToGrid

  # Read an ascii file and load it into the hexagon grid.
  #
  # @param file_path [String] the name of the ascii file to read. For how to create this file, please see : https://github.com/czuger/rhex#reading-a-grid-from-an-ascii-file
  #
  # @see https://github.com/czuger/rhex#reading-a-grid-from-an-ascii-file
  #
  def read_ascii_file( file_path )
    File.open( file_path ) do |file|

      r = max_r = 0

      file.each_line do |line|
        elements = line.split
        q = 0
        elements.each do |element|
          # puts "r = #{r} q = #{q}, test = #{( r == 0 || q == 0 )}"
          border = true if ( r == 0 || q == 0 )
          # shifted_q = q - ( r/2 )
          shifted_q = q
          cset( shifted_q, r, color: element.to_sym, border: border )
          q += 1
        end
        r += 1
        max_r = [ max_r, r ].max
      end

      0.upto( max_r - 1 ).each do |row|
        maxq = @hexes.map{ |key, e| e.q if e.r == row }.compact.max
        hex = cget( maxq, row )
        hex.border = true if hex
      end

      @hexes.each{ |key, e| e.border = true if e.r == ( max_r - 1 ) }
    end
  end

end
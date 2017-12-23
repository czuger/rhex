# This module contains the methods relatives to ascii map reading
module AsciiToGridFlat

  # Read an ascii file and load it into the hexagon grid.
  #
  # @param file_path [String] the name of the ascii file to read. For how to create this file, please see : https://github.com/czuger/rhex#reading-a-grid-from-an-ascii-file
  #
  # @see https://github.com/czuger/rhex#reading-a-grid-from-an-ascii-file
  #
  def read_ascii_file_flat( file_path )
    File.open( file_path ) do |file|

      odd = 0
      base_q = 0
      line_q = 0

      file.each_line do |line|
        elements = line.split
        # p elements
        elements.each_with_index do |element, index|
          # p element, index
          cset( base_q - index, index*2 + odd, color: element.to_sym, border: nil )
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

end
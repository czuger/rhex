# This module contains the methods relatives to ascii map reading
module AsciiToGrid

  #  Read an ascii file and load it into the hexagon grid.
  #  - +file_path+ :  is the name of the ascii file to read. For how to create this file, please see : https://github.com/czuger/rhex#reading-a-grid-from-an-ascii-file
  def read_ascii_file( file_path )
    File.open( file_path ) do |file|

      r = max_q = max_r = 0
      file.each_line do |line|
        elements = line.split
        q = 0
        elements.each do |element|
          border = true if ( r == 0 || q == 0 )
          cset( q, r, val: element, border: border )
          q += 1
          max_q = [ max_q, q ].max
        end
        r += 1
        max_r = [ max_r, r ].max
      end

      0.upto( max_q - 1 ).each do |q|
        hex = cget( q, max_r - 1 )
        hex.border! if hex
      end

      0.upto( max_r - 1 ).each do |row|
        hex = cget( max_q - 1, row )
        hex.border! if hex
      end

    end
  end
end
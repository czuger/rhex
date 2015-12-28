module AsciiToGrid

  # TODO : add the notion of border hexes (know if the hex will be fully displayed or not)
  def read_ascii_file( file_path )
    File.open( file_path ) do |file|
      r = 0
      file.each_line do |line|
        elements = line.split
        q = 0
        elements.each do |element|
          set( q - ( r/2.0 ).floor, r, element )
          q += 1
        end
        r += 1
      end
    end
  end

end
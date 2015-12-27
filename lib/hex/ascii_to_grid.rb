module AsciiToGrid

  def read_ascii_file( file_path )
    File.open( file_path ) do |file|
      r = 0
      file.each_line do |line|
        elements = line.split
        q = 0
        elements.each do |element|
          set( q, r, element )
          q += 1
        end
        r += 1
      end
    end
  end

end
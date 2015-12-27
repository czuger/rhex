module AsciiToGrid

  def read_ascii_file( file_path )
    File.open( file_path ) do |file|
      r = 0
      file.each_line do |line|
        int_r = r.floor
        elements = line.split
        q = 0
        elements.each do |element|
          set( int_r.odd? ? q + 1 : q, int_r, element )
          q += 2
        end
        r += 0.5
      end
    end
  end

end
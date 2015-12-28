# A module to transform hex grid to bitmap

begin
  gem 'rmagick'
  require 'rmagick'
rescue Gem::LoadError
  puts 'Caution : Rmagick is not installed'
end

module GridToPic

  def to_pic( pic_name, exit_on_error = true )
    unless defined?( Magick::Image )
      puts 'Rmagick is not installed !!! You can\'t dump hex grid to pic'
      exit if exit_on_error
    end

    maxx = @hexes.keys.map{ |k| k[0] }.max * Hex::Axial.width
    maxy = @hexes.keys.map{ |k| k[1] }.max * Hex::Axial.height * 3.0/4.0

    canvas = Magick::Image.new( maxx, maxy )
    gc = Magick::Draw.new
    gc.stroke_antialias( true )
    gc.stroke( 'black' )

    half_width = Hex::Axial.width / 2.0
    quarter_height = Hex::Axial.height / 4.0

    @hexes.each do | _, hex|
      x, y = hex.to_xy

      color = get_color( hex )
      gc.fill( color.to_s )

      gc.polygon( x - half_width, y + quarter_height,
                  x, y + 2*quarter_height,
                  x + half_width, y + quarter_height,
                  x + half_width, y - quarter_height,
                  x, y - 2*quarter_height,
                  x - half_width, y - quarter_height )
    end

    gc.draw(canvas)
    canvas.write( pic_name )
  end

  private

  def get_color( hex )
    color = @element_to_color_hash[ hex.val ]
    color ? color : :white
  end

end
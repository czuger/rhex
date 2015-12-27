# A module to transform hex grid to bitmap

begin
  gem 'rmagick'
  require 'rmagick'
rescue Gem::LoadError
  puts 'Caution : Rmagick is not installed'
end

module GridToPic

  def to_pic( pic_name, exit_on_error = true )
    unless defined?( Magick::Image ) && defined?( Magick::HatchFill ) && defined?( Magick::Draw )
      puts 'Rmagick is not installed !!! You can\'t dump hex grid to pic'
      exit if exit_on_error
    end

    canvas = Magick::Image.new( 500, 500 )
    gc = Magick::Draw.new
    width = Hex::Axial::R * 2
    quarter_width = width / 4.0
    height = Math.sqrt(3)/2 * width
    half_height = height / 2.0

    @hexes.each do |pos, hex|
      x, y = hex.to_xy

      color = get_color( hex )
      gc.stroke( 'black' )
      gc.fill( color.to_s )
      gc.polygon( x-quarter_width, y-half_height, x+quarter_width, y-half_height, x+quarter_width*2, y,
                  x+quarter_width, y+half_height, x-quarter_width, y+half_height, x-quarter_width*2, y )
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
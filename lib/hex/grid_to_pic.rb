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

    maxx = @hexes.keys.map{ |k| k[0] }.max * @width
    maxy = @hexes.keys.map{ |k| k[1] }.max * @height * 3.0/4.0

    canvas = Magick::Image.new( maxx, maxy )
    gc = Magick::Draw.new
    gc.stroke_antialias( true )
    gc.stroke( 'black' )

    @hexes.each{ | _, hex| draw_hex( gc, hex ) }

    gc.draw(canvas)
    canvas.write( pic_name )
  end

  def set_hex_dimensions

    @height = Hex::Axial::HEX_RAY * 2.0
    @width =  Math.sqrt(3)/2.0 * @height

    @half_width = @width / 2.0
    @quarter_height = @height / 4.0

  end

  private

  def get_color( hex )
    color = @element_to_color_hash[ hex.val ]
    color ? color : :white
  end

  def draw_hex( gc, hex )
    x, y = hex.to_xy

    color = get_color( hex )
    gc.fill( color.to_s )

    gc.polygon( x - @half_width, y + @quarter_height,
                x, y + 2*@quarter_height,
                x + @half_width, y + @quarter_height,
                x + @half_width, y - @quarter_height,
                x, y - 2*@quarter_height,
                x - @half_width, y - @quarter_height )
  end

end
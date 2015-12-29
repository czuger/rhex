# A module to transform hex grid to bitmap

begin
  gem 'rmagick'
  require 'rmagick'
rescue Gem::LoadError
  puts 'Caution : Rmagick is not installed'
end

module GridToPic

  attr_reader :hex_height, :hex_width

  def to_pic( pic_name, exit_on_error = true )
    unless defined?( Magick::Image ) && defined?( Magick::HatchFill ) && defined?( Magick::Draw )
      puts 'Rmagick is not installed !!! You can\'t dump hex grid to pic'
      exit if exit_on_error
    end

    maxx = @hexes.keys.map{ |k| k[0] }.max * @hex_width
    maxy = @hexes.keys.map{ |k| k[1] }.max * @hex_height * 3.0/4.0

    canvas = Magick::Image.new( maxx, maxy )
    gc = Magick::Draw.new
    gc.stroke_antialias( true )
    gc.stroke( 'black' )

    @hexes.each{ | _, hex| draw_hex( gc, hex ) }

    gc.draw(canvas)
    canvas.write( pic_name )
  end

  private

  def set_hex_dimensions

    @hex_height = @hex_ray * 2.0
    @hex_width =  Math.sqrt(3)/2.0 * @hex_height

    @half_width = @hex_width / 2.0
    @quarter_height = @hex_height / 4.0

  end

  def get_color( hex )
    color = @element_to_color_hash[ hex.val ]
    color ? color : :white
  end

  def draw_hex( gc, hex )
    x, y = to_xy( hex )

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
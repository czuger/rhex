# A module to transform hex grid to bitmap

begin
  gem 'rmagick'
  require 'rmagick'
rescue Gem::LoadError
  puts 'Caution : Rmagick is not installed'
end

# This module contain the methods to draw a grid to a picture file.
module GridToPic

  # Draw the hex grid in a Magick::Image object
  #
  # @param exit_on_error [Boolean] by default, if you call this method and rmagic is not installed, the program exit with an error. You can disable it and make the program continue.
  #
  # @return [Magick::Image] a Magick::Image object
  #
  def to_rmagick_image( exit_on_error = true )
    unless defined?( Magick::Image ) && defined?( Magick::HatchFill ) && defined?( Magick::Draw )
      puts 'Rmagick is not installed !!! You can\'t dump hex grid to pic'
      exit if exit_on_error
    end

    maxx = ( @hexes.keys.map{ |k| k[0] + k[1]/2 }.max ) * @hex_width - ( @hex_width / 2 ) + 1
    maxy = @hexes.keys.map{ |k| k[1] }.max * ( ( @hex_height * 3.0 )/ 4.0 ).ceil - ( @hex_width / 4 ).ceil - 2

    # maxx = ( ( @hexes.keys.map{ |k| k[0] + k[1]/2 }.max ) + 0.5 ) * @hex_width
    # maxy = ( ( @hexes.keys.map{ |k| k[1] }.max * 3.0/4.0 ) + 0.5 ) + @hex_heig

    canvas = Magick::Image.new( maxx, maxy )

    gc = Magick::Draw.new
    gc.stroke_antialias( true )
    gc.stroke( 'black' )
    gc.stroke_opacity( '60%' )

    @hexes.each{ | _, hex| draw_hex( gc, hex ) }

    gc.draw(canvas)

    canvas
  end

  # Draw the hex grid on a Magick::Object and save it to a file
  #
  # @param exit_on_error [Boolean] by default, if you call this method and rmagic is not installed, the program exit with an error. You can disable it and make the program continue
  # @param pic_name [String] the name of the picture file (can be *.bmp, *.png, *.jpg)
  #
  # @return [Boolean] true if the file was created successfully, false otherwise
  #
  def to_pic( pic_name, exit_on_error = true )
    canvas = to_rmagick_image( exit_on_error )
    canvas.write( pic_name )
  end

  private

  def set_hex_dimensions

    # p :call

    @hex_height = @hex_ray * 2.0
    @hex_width =  Math.sqrt(3)/2.0 * @hex_height

    @half_width = @hex_width / 2.0
    @quarter_height = @hex_height / 4.0

  end

  def get_color( hex )
    color = @element_to_color_hash[ hex.color ]
    color ? color : :white
  end

  def draw_hex( gc, hex )
    x, y = to_xy( hex )

    # p hex
    # puts [ x, y ]

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
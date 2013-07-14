$LOAD_PATH << "."

require 'RMagick'
require 'couple'

include Magick

class Pixel
  def initialize(row, col, image)
    @image = image
    @rmagick_pixel = view[row][col]
    @row = row
    @col = col
  end

  def color_equal?(pixel)
    color == pixel.color
  end

  def row
    @row
  end

  def col
    @col
  end

  def image
    @image
  end

  def color
    @rmagick_pixel.to_color(AllCompliance, false, QuantumDepth, true)
  end

  def neighbor(number)
    next_col = @col + 1 + number
    Pixel.new(@row, next_col, @image)
  end

  def view
    Image::View.new(@image, 0,0, @image.columns, @image.rows)
  end
end

def is_it_contained_in?(contained_path, container_path)
  container = Image.read(container_path).first
  contained = Image.read(contained_path).first

  couples = find_couples(contained, container)
  couples.map { |c| c.match? }.any?
end

def find_couples(contained, container)
  couples = []
  ced_c, ced_r = 0, 0
  pixel = Pixel.new(ced_r, ced_r, contained)
  container.each_pixel do |cer_pixel, cer_c, cer_r|
    couple = Couple.new(pixel, Pixel.new(cer_r , cer_c, container))
    if couple.same_color?
      couples << couple
    end
  end
  couples
end


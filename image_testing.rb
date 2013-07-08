require 'RMagick'

include Magick

class NoPixel
  def color_equal?(pixel)
    true
  end
end

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

  def image
    @image
  end

  def color
    @rmagick_pixel.to_color(AllCompliance, false, QuantumDepth, true)
  end

  def neighbor(number)
    next_col = @col + 1 + number
    if next_col < @image.columns
      Pixel.new(0, next_col, @image)
    else
      NoPixel.new
    end
  end

  def view
    Image::View.new(@image, 0,0, @image.columns, @image.rows)
  end
end

def is_it_contained_in?(contained_path, container_path)
  container = Image.read(container_path).first
  contained = Image.read(contained_path).first
  found_ar = []

  couples = find_couples(contained, container)
  couples.map(&:patern_match?).any?
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

# Couple of pixels, each from a different image
class Couple
  def initialize(ced_pixel, cer_pixel)
    @ced_pixel = ced_pixel
    @cer_pixel = cer_pixel
  end

  # Check if the neighbor from the right side
  # of a pixel has the same color as the right side neighbor
  # of the other pixel
  def same_neighbor?(neighbor_number)
    @ced_pixel.neighbor(neighbor_number).color_equal?(@cer_pixel.neighbor(neighbor_number))
  end

  def same_color?
    @ced_pixel.color == @cer_pixel.color
  end

  def patern_match?
    if same_color?
      conditions = ""
      length = @ced_pixel.image.columns
      (length - 1).times do |i|
       conditions << "if same_neighbor?(#{i})\n"
      end
      conditions << "same_neighbor?(length)\n"
      (length - 1).times do |i|
       conditions << "end\n"
      end

      eval(conditions)
    end
  end
end


require 'RMagick'

include Magick

class NoPixel
  def color_equal?(pixel)
    true
  end
end

class Pixel

  def initialize(rmagick_pixel, row, col, image)
    @rmagick_pixel = rmagick_pixel
    @row = row
    @col = col
    @image = image
  end

  def color_equal?(pixel)
    color == pixel.color
  end

  def color
    @rmagick_pixel.to_color(AllCompliance, false, QuantumDepth, true)
  end

  def neighbor(number)
    view = Image::View.new(@image, 0,0, @image.columns, @image.rows )
    next_col = @col + 1 + number
    if next_col < @image.columns
      Pixel.new(view[0][next_col], 0, next_col, @image)
    else
      NoPixel.new
    end
  end

end

def is_it_contained_in?(contained_path, container_path)
  container = Image.read(container_path).first
  contained = Image.read(contained_path).first
  found_ar = []

  contained.each_pixel do |ced_pixel, ced_c, ced_r|
    container.each_pixel do |cer_pixel, cer_c, cer_r|
      if pixels_match?(Pixel.new(ced_pixel, ced_r, ced_c, contained), Pixel.new(cer_pixel, cer_r , cer_c, container), contained.columns)
        found_ar << true
      end
    end
  end

  if found_ar.length == (contained.columns * contained.rows)
    return true
  else
    return false
  end
end


def pixels_match?(ced_pixel, cer_pixel, image_length)
  if ced_pixel.color == cer_pixel.color
    conditions = ""

    (image_length - 1).times do |i|
     conditions << "if ced_pixel.neighbor(#{i}).color_equal?(cer_pixel.neighbor(#{i}))\n"
    end
    conditions << "ced_pixel.neighbor(#{image_length}).color_equal?(cer_pixel.neighbor(#{image_length}))\n"
    (image_length - 1).times do |i|
     conditions << "end\n"
    end

    eval(conditions)
  end
end


require 'RMagick'

include Magick

class Pixel

  def initialize(rmagick_pixel)
    @rmagick_pixel = rmagick_pixel
  end

  def color
    @rmagick_pixel.to_color(AllCompliance, false, QuantumDepth, true)
  end

  def right_neighbor
    0
  end

end

def is_it_contained_in?(contained_path, container_path)
  container = Image.read(container_path).first
  contained = Image.read(contained_path).first

  found_ar = []

  contained.each_pixel do |ced_pixel|
    container.each_pixel do |cer_pixel|
      if pixels_match?(Pixel.new(ced_pixel), Pixel.new(cer_pixel))
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


def pixels_match?(ced_pixel, cer_pixel)
  ced_pixel.color == cer_pixel.color && ced_pixel.right_neighbor == cer_pixel.right_neighbor
end


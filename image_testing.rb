require 'RMagick'

include Magick

def is_it_contained_in?(contained_path, container_path)
  container = Image.read(container_path).first
  contained = Image.read(contained_path).first

  found_ar = []

  contained.each_pixel do |ced_pixel|
    container.each_pixel do |cer_pixel|
      if ced_pixel == cer_pixel
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

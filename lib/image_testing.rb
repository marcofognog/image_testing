$LOAD_PATH << "."

require 'RMagick'
require 'couple'
require 'pixel'

include Magick

def is_it_contained_in?(contained_path, container_path)
  container = Image.read(container_path).first
  contained = Image.read(contained_path).first

  couples = find_couples(contained, container)
  couples.map { |c| c.match? }.any?
end

def find_couples(contained, container)
  couples = []
  ced_c, ced_r = 0, 0
  first_pixel = Pixel.new(ced_r, ced_r, contained)
  container.each_pixel do |cer_pixel, cer_c, cer_r|
    couple = Couple.new(first_pixel, Pixel.new(cer_r, cer_c, container))
    if couple.same_color?
      couples << couple
    end
  end
  couples
end


$LOAD_PATH << "."

require 'rmagick'
require 'couple'
require 'segment'
require 'pixel'

include Magick


def is_it_contained_in?(contained_path, container_path)
  container = Image.read(container_path).first
  contained = Image.read(contained_path).first

  container_segment = Segment.new(0,0, container.columns, container.rows, container)
  contained_segment = Segment.new(0,0, contained.columns, contained.rows, contained)
  contained_segment.is_contained_in?(container_segment)
end


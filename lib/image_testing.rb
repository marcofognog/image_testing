$LOAD_PATH << "."

require 'rmagick'
require 'couple'
require 'segment'
require 'pixel'

include Magick


def is_it_contained_in?(contained_path, container_path, strategy = :full)
  container = Image.read(container_path).first
  contained = Image.read(contained_path).first

  if strategy == :full
    container_segment = Segment.new(0,0, container.columns, container.rows, container)
    contained_segment = Segment.new(0,0, contained.columns, contained.rows, contained)

    return contained_segment.is_contained_in?(container_segment)
  elsif strategy == :four_corners
    measure = 10

    corner1 = {
      :x_start => 0,
      :x_width => measure,
      :y_start => 0,
      :y_width => measure
    }
    corner2 = {
      :x_start => contained.columns - measure,
      :x_width => measure,
      :y_start => 0,
      :y_width => measure
    }
    corner3 = {
      :x_start => 0,
      :x_width => measure,
      :y_start =>  contained.rows - measure,
      :y_width => measure
    }
    corner4 = {
      :x_start => contained.columns - measure,
      :x_width => measure,
      :y_start => contained.rows - measure,
      :y_width => measure
    }

    corners = [corner1, corner2, corner3, corner4]
    found_corners = []
    container_segment = Segment.new(0,0, container.columns, container.rows, container)

    corners.each do |corner|
      contained_segment = Segment.new(corner[:x_start], corner[:y_start], corner[:x_width], corner[:y_width], contained)
      found_corners << corner if contained_segment.is_contained_in?(container_segment)
    end
    return found_corners.count == 4
  else
    raise "Invalid comparison strategy."
  end

end



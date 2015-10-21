require 'comparator'

class Segment

  def initialize(x_start, y_start, width, height, rmagick_image)
    @x_start = x_start
    @y_start = y_start
    @width = width
    @height = height
    @image = rmagick_image
  end

  def x
    @x_start
  end

  def y
    @y_start
  end

  def each_pixel
    @image.get_pixels(@x_start, @y_start, @width, @height).each_with_index do |p, n|
      yield(p, n%columns, n/columns)
    end
    self
  end

  def columns
    @width
  end

  def rows
    @height
  end

  def create_view
    @view ||= @image.view(@x_start,@y_start, @width, @height)
  end

  def is_contained_in?(container_segment)
    Comparator.compare(container_segment, self)
  end

end


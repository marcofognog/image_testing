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
    @image.view(@x_start,@y_start, @width, @height)
  end

  def is_contained_in?(container_segment)
    couples = find_couples(container_segment)
    couples.map { |c| c.match? }.any?
  end

  def find_couples(container)
    couples = []
    ced_c, ced_r = 0,0
    first_pixel = Pixel.new(ced_r, ced_c, self)
    container.each_pixel do |cer_pixel, cer_c, cer_r|
      tested_pixel = Pixel.new(cer_r, cer_c, container)
      if tested_pixel.color == first_pixel.color
        couples << Couple.new(first_pixel, tested_pixel)
      end
    end
    couples
  end

end


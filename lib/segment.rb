class Segment
  
  def initialize(x_start, y_start, x_finish, y_finish, rmagick_image)
    @x_start, @y_start, @x_finish, @y_finish = x_start, y_start, x_finish, y_finish
    @image = rmagick_image
  end
  
  def each_pixel
    @image.get_pixels(@x_start, @y_start, @x_finish, @y_finish).each_with_index do |p, n|
      yield(p, n%columns, n/columns)
    end
    self
  end
  
  def columns
    @x_finish - @x_start
  end
  
  def rows
    @y_finish - @y_start
  end
  
  def view(x, y, width, height)
    @image.view(x, y, width, height)
  end

  def is_contained_in?(container_segment)
    couples = find_couples(container_segment)
    couples.map { |c| c.match? }.any?
  end

  def find_couples(container)
    couples = []
    ced_c, ced_r = 0, 0
    first_pixel = Pixel.new(ced_r, ced_r, self)
    container.each_pixel do |cer_pixel, cer_c, cer_r|
      couple = Couple.new(first_pixel, Pixel.new(cer_r, cer_c, container))
      if couple.same_color?
        couples << couple
      end
    end
    couples
  end

end


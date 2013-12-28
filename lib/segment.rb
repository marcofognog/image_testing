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

end


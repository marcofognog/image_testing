class Pixel
  def initialize(row, col, image)
    @image = image
    @rmagick_pixel = view[row][col]
    @row = row
    @col = col
  end

  def color_equal?(pixel)
    color == pixel.color
  end

  def row
    @row
  end

  def col
    @col
  end

  def image
    @image
  end

  def color
    @rmagick_pixel.to_color(AllCompliance, false, QuantumDepth, true)
  end

  def neighbor(row_number, number)
    next_col = @col + number
    Pixel.new(@row + row_number, next_col, @image)
  end

  def view
    image.view(0,0, @image.columns, @image.rows)
  end
end

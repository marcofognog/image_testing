# Couple of pixels, each from a different image
class Couple
  
  def initialize(ced_pixel, cer_pixel)
    @ced_pixel = ced_pixel
    @cer_pixel = cer_pixel
  end

  def total_neighbors
    @ced_pixel.image.columns - 1
  end

  # Check if the neighbor from the right side
  # of a pixel has the same color as the right side neighbor
  # of the other pixel
  def same_neighbor?(row_number, neighbor_number)
  
    # This doesn't consider the last pixel, but assumes they are equal
    return true if last_neighbor?(neighbor_number)

    if within_horizontal_limits?(neighbor_number)
      if @ced_pixel.neighbor(row_number, neighbor_number).color_equal?(@cer_pixel.neighbor(row_number, neighbor_number))
        same_neighbor?(row_number, neighbor_number + 1)
      else
        false
      end
    end

  end

  def last_neighbor?(neighbor_pixel)
     neighbor_pixel == total_neighbors
  end

  def within_horizontal_limits?(neighbor_number)
    (@cer_pixel.col + neighbor_number) < @cer_pixel.image.columns
  end

  def same_color?
    @ced_pixel.color == @cer_pixel.color
  end

  def last_row?
    @ced_pixel.image.rows >= @ced_pixel.row
  end

  def match?
    match_row?(0)
  end

  def match_row?(row)
    if @ced_pixel.image.rows == row
      return true
    else
      if same_neighbor?(row, 0)
        match_row?(row + 1)
      else
        false
      end
    end
  end

end


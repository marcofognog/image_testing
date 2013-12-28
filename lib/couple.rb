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
  def same_neighbor?(neighbor_number)
  
    # This doesn't consider the last pixel, but assumes they are equal
    return true if last_neighbor?(neighbor_number)

    if within_horizontal_limits?(neighbor_number)
      if @ced_pixel.neighbor(neighbor_number).color_equal?(@cer_pixel.neighbor(neighbor_number))
        same_neighbor?(neighbor_number + 1)
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
    if !last_row?
      other_ced = Pixel.new(@ced_pixel.row + 1, @ced_pixel.col, @ced_pixel.image)
      other_cer = Pixel.new(@cer_pixel.row + 1, @cer_pixel.col, @cer_pixel.image)
      other_couple = Couple.new(other_cer, other_cer)
      other_couple.match_row?
    end
    match_row?
  end

  def match_row?
    same_neighbor?(0)
  end

end


# Couple of pixels, each from a different image
class Couple
  def initialize(ced_pixel, cer_pixel)
    @ced_pixel = ced_pixel
    @cer_pixel = cer_pixel
  end

  # Check if the neighbor from the right side
  # of a pixel has the same color as the right side neighbor
  # of the other pixel
  def same_neighbor?(neighbor_number)
    @neighbor_count = neighbor_number
    if !last_pixel?
      if @ced_pixel.neighbor(neighbor_number).color_equal?(@cer_pixel.neighbor(neighbor_number))
        same_neighbor?(@neighbor_count += 1)
      end
    else
      true
    end

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

  def last_pixel?
    @neighbor_count == @ced_pixel.image.columns - 1
  end

  def match_row?
    same_neighbor?(0)
  end

end


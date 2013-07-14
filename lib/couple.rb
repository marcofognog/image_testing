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
    @ced_pixel.neighbor(neighbor_number).color_equal?(@cer_pixel.neighbor(neighbor_number))
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
    if same_color?
      conditions = ""
      length = @ced_pixel.image.columns
      (length - 1).times do |i|
       conditions << "if same_neighbor?(#{i})\n"
      end
      conditions << "true\n"
      (length - 1).times do |i|
       conditions << "end\n"
      end

      eval(conditions)
    end
  end
end


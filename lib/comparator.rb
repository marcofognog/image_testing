class Comparator

  def self.compare(container_segment, contained_segment, whole_image = false)
    if whole_image
      tx = container_segment.columns
      ty = container_segment.rows

      dx = contained_segment.image.columns
      dy = contained_segment.image.rows

      ix = contained_segment.columns
      iy = contained_segment.rows

      x_width = tx - dx + ix
      y_width = ty - dy + iy

      sx = contained_segment.x
      sy = contained_segment.y

      optimized_container = Segment.new(sx, sy, x_width, y_width, container_segment.image)
    else
      optimized_container = container_segment
    end

    couples = find_couples(optimized_container, contained_segment)
    couples.map { |c| c.match? }.any?
  end

  def self.find_couples(container, contained)
    couples = []
    ced_c, ced_r = 0,0
    first_pixel = Pixel.new(ced_r, ced_c, contained)
    container.each_pixel do |cer_pixel, cer_c, cer_r|
      tested_pixel = Pixel.new(cer_r, cer_c, container)
      if tested_pixel.color == first_pixel.color
        couples << Couple.new(first_pixel, tested_pixel)
      end
    end
    couples
  end

end


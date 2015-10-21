class Comparator

  def self.compare(container_segment, contained_segment)
    couples = find_couples(container_segment, contained_segment)
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


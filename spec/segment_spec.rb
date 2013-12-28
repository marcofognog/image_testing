$LOAD_PATH << "."

require 'rspec'
require 'lib/image_testing'

describe "Segment" do
  describe "#find_couple" do
    context "Unidimensional" do
      it "should find a couple with the first pixel of the contained image within the whole image" do
        container = Image.read("unidimensional/uni-16.gif").first
        contained = Image.read("unidimensional/uni-4.gif").first
        container_segment = Segment.new(0,0, container.columns, container.rows, container)
        contained_segment = Segment.new(0,0, contained.columns, contained.rows, contained)
        couples = contained_segment.find_couples(container)
        couples.count.should be(1)
      end

      it "should find one couple with the one pixel in the bigger image, even if the smaller is not conteined in the bigger, but have on pixel with the same color" do
        container = Image.read("unidimensional/uni-16.gif").first
        contained = Image.read("unidimensional/diff-uni-4.gif").first
        container_segment = Segment.new(0,0, container.columns, container.rows, container)
        contained_segment = Segment.new(0,0, contained.columns, contained.rows, contained)
        couples = contained_segment.find_couples(container)
        couples.count.should be(1)
      end

      it "should find the two couple, even if the smaller img is in other position" do
        container = Image.read("unidimensional/diff-position-uni-16.gif").first
        contained = Image.read("unidimensional/diff-uni-4.gif").first
        container_segment = Segment.new(0,0, container.columns, container.rows, container)
        contained_segment = Segment.new(0,0, contained.columns, contained.rows, contained)
        couples = contained_segment.find_couples(container)
        couples.count.should be(2)
      end
    end
  end
end


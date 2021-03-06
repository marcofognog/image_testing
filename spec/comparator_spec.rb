$LOAD_PATH << "."

require 'rspec'
require 'spec_helper'
require 'lib/image_testing'

describe "Comparator" do
  describe "#find_couple" do
    context "Unidimensional" do
      it "should find a couple with the first pixel of the contained image within the whole image" do
        container = Image.read("unidimensional/uni-16.gif").first
        contained = Image.read("unidimensional/uni-4.gif").first
        container_segment = Segment.new(0,0, container.columns, container.rows, container)
        contained_segment = Segment.new(0,0, contained.columns, contained.rows, contained)
        couples = Comparator.find_couples(container_segment, contained_segment)
        assert_equal(1, couples.count)
      end

      it "should find one couple with the one pixel in the bigger image, even if the smaller is not conteined in the bigger, but have on pixel with the same color" do
        container = Image.read("unidimensional/uni-16.gif").first
        contained = Image.read("unidimensional/diff-uni-4.gif").first
        container_segment = Segment.new(0,0, container.columns, container.rows, container)
        contained_segment = Segment.new(0,0, contained.columns, contained.rows, contained)
        couples = Comparator.find_couples(container_segment, contained_segment)
        assert_equal(1, couples.count)
      end

      it "should find the two couple, even if the smaller img is in other position" do
        container = Image.read("unidimensional/diff-position-uni-16.gif").first
        contained = Image.read("unidimensional/diff-uni-4.gif").first
        container_segment = Segment.new(0,0, container.columns, container.rows, container)
        contained_segment = Segment.new(0,0, contained.columns, contained.rows, contained)
        couples = Comparator.find_couples(container_segment, contained_segment)
        assert_equal(2, couples.count)
      end
    end
  end

  describe "#compare" do
    it "matches correctly, starting at pixel (2,2)" do
      container = Image.read("bidimensional/tomato.gif").first
      contained = Image.read("bidimensional/tomato6x6.gif").first
      container_segment = Segment.new(0, 0, container.columns, container.rows, container)
      contained_segment = Segment.new(1, 1, contained.columns - 1, contained.rows - 1, contained)
      assert Comparator.compare(container_segment, contained_segment)
    end

    context "matches correclty a bigger image, using just a segment of the contained image" do
      it "#1", :slow do
        container = Image.read("bidimensional/tomato300x161.bmp").first
        contained = Image.read("bidimensional/seg-tomato300x161.bmp").first
        container_segment = Segment.new(0,0, container.columns, container.rows, container)
        contained_segment = Segment.new(60, 60, contained.columns - 60, contained.rows - 60, contained)
        assert Comparator.compare(container_segment, contained_segment)
      end

      it "#2 even bigger image", :slow do
        container = Image.read("bidimensional/tomato1200x1143.bmp").first
        contained = Image.read("bidimensional/seg-tomato1200x1143.bmp").first
        container_segment = Segment.new(0,0, container.columns, container.rows, container)
        contained_segment = Segment.new(700, 600, contained.columns - 700, contained.rows - 600, contained)
        assert Comparator.compare(container_segment, contained_segment)
      end
    end

    context "Segmentation" do
      context "on the contained image: specific segment of the contained image are found in the container"
      it "these proves those two images are different ..." do
        container = Image.read("bidimensional/fluffy-cat.bmp").first
        contained = Image.read("bidimensional/not-seg-fluffy-cat.bmp").first
        container_segment = Segment.new(0,0, container.columns, container.rows, container)
        contained_segment = Segment.new(0, 0, contained.columns, contained.rows, contained)
        assert !Comparator.compare(container_segment, contained_segment)
      end

      it "... but, matches if we look for just the segment both images have in common: the fluffy cat" do
        container = Image.read("bidimensional/fluffy-cat.bmp").first
        contained = Image.read("bidimensional/not-seg-fluffy-cat.bmp").first

        fluffy_cat_seg_params = [190, 160,380, 290, contained]
        container_params = [0,0, container.columns, container.rows, container]

        container_segment = Segment.new(*container_params)
        contained_segment = Segment.new(*fluffy_cat_seg_params)
        assert Comparator.compare(container_segment, contained_segment)
      end
    end

    context "on the container image" do
      it "can find a image pattern on a segment of the container image" do
        container = Image.read("bidimensional/tomato-seg.gif").first
        contained = Image.read("bidimensional/tomato-half.gif").first
        container_segment = Segment.new(0,0, container.columns, 8, container)
        contained_segment = Segment.new(0,0, contained.columns, contained.rows, contained)

        assert Comparator.compare(container_segment, contained_segment)
      end

      it "wont'd find, proving the segmentation on the conteiner: the whole container image
      contains the contained image, but not in the specified segment." do
        container = Image.read("bidimensional/tomato-seg.gif").first
        contained = Image.read("bidimensional/tomato-half.gif").first
        container_segment = Segment.new(0,8, container.columns, 8, container)
        contained_segment = Segment.new(0,0, contained.columns, contained.rows, contained)

        assert !Comparator.compare(container_segment, contained_segment)
      end
    end

    context "use the whole image strategy to search segment" do
      it "for a simple image" do
        container = Image.read("bidimensional/tomato.gif").first
        contained = Image.read("bidimensional/tomato6x6.gif").first
        container_segment = Segment.new(0, 0, container.columns, container.rows, container)
        contained_segment = Segment.new(2, 2, contained.columns - 2, contained.rows - 2, contained)
        assert Comparator.compare(container_segment, contained_segment, true)
      end

      it "for a medium size image", :slow do
        container = Image.read("bidimensional/tomato300x161.bmp").first
        contained = Image.read("bidimensional/seg-tomato300x161.bmp").first
        container_segment = Segment.new(0, 0, container.columns, container.rows, container)
        contained_segment = Segment.new(2, 2, contained.columns - 2, contained.rows - 2, contained)
        assert Comparator.compare(container_segment, contained_segment, true)
      end

      it "for a bigger image", :slow do
        container = Image.read("bidimensional/tomato1200x1143.bmp").first
        contained = Image.read("bidimensional/seg-tomato1200x1143.bmp").first
        container_segment = Segment.new(0, 0, container.columns, container.rows, container)
        contained_segment = Segment.new(700, 600, contained.columns - 700, contained.rows - 600, contained)
        assert Comparator.compare(container_segment, contained_segment, true)
      end
    end
  end

  describe '#found_coordinates' do
    it 'returns the first pixels coordinates' do
      container = Image.read("bidimensional/tomato.gif").first
      contained = Image.read("bidimensional/tomato6x6.gif").first
      container_segment = Segment.new(0, 0, container.columns, container.rows, container)
      contained_segment = Segment.new(2, 2, contained.columns - 2, contained.rows - 2, contained)
      assert_equal [[12,12]], Comparator.found_coordinates(container_segment, contained_segment)
    end
  end
end


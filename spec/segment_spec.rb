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
        couples = contained_segment.find_couples(container_segment)
        couples.count.should be(1)
      end

      it "should find one couple with the one pixel in the bigger image, even if the smaller is not conteined in the bigger, but have on pixel with the same color" do
        container = Image.read("unidimensional/uni-16.gif").first
        contained = Image.read("unidimensional/diff-uni-4.gif").first
        container_segment = Segment.new(0,0, container.columns, container.rows, container)
        contained_segment = Segment.new(0,0, contained.columns, contained.rows, contained)
        couples = contained_segment.find_couples(container_segment)
        couples.count.should be(1)
      end

      it "should find the two couple, even if the smaller img is in other position" do
        container = Image.read("unidimensional/diff-position-uni-16.gif").first
        contained = Image.read("unidimensional/diff-uni-4.gif").first
        container_segment = Segment.new(0,0, container.columns, container.rows, container)
        contained_segment = Segment.new(0,0, contained.columns, contained.rows, contained)
        couples = contained_segment.find_couples(container_segment)
        couples.count.should be(2)
      end
    end
  end
  
  describe "#is_contained_in?" do
    it "matches correctly, starting at pixel (2,2)" do
      container = Image.read("bidimensional/tomato.gif").first
      contained = Image.read("bidimensional/tomato6x6.gif").first
      container_segment = Segment.new(0, 0, container.columns, container.rows, container)
      contained_segment = Segment.new(1, 1, contained.columns - 1, contained.rows - 1, contained)
      contained_segment.is_contained_in?(container_segment).should be_true
    end
    
    it "matches correclty a bigger image, using just a segment of the contained image" do
      container = Image.read("bidimensional/tomato300x161.bmp").first
      contained = Image.read("bidimensional/seg-tomato300x161.bmp").first
      container_segment = Segment.new(0,0, container.columns, container.rows, container)
      contained_segment = Segment.new(60, 60, contained.columns - 60, contained.rows - 60, contained)
      contained_segment.is_contained_in?(container_segment).should be_true
    end

    context "matches correclty a bigger images, using just a segment of the contained image" do
      it "#1" do
        container = Image.read("bidimensional/tomato300x161.bmp").first
        contained = Image.read("bidimensional/seg-tomato300x161.bmp").first
        container_segment = Segment.new(0,0, container.columns, container.rows, container)
        contained_segment = Segment.new(60, 60, contained.columns - 60, contained.rows - 60, contained)
        contained_segment.is_contained_in?(container_segment).should be_true
      end
      
      it "#2" do
        container = Image.read("bidimensional/tomato1200x1143.bmp").first
        contained = Image.read("bidimensional/seg-tomato1200x1143.bmp").first
        container_segment = Segment.new(0,0, container.columns, container.rows, container)
        contained_segment = Segment.new(700, 600, contained.columns - 700, contained.rows - 600, contained)
        contained_segment.is_contained_in?(container_segment).should be_true
      end
    end

    context "Segmentation - the proof that the segmentation is workig" do
      it "doesn't match if we look for the contained (smaller) image whitin the container (bigger) image" do
        container = Image.read("bidimensional/fluffy-cat.bmp").first
        contained = Image.read("bidimensional/not-seg-fluffy-cat.bmp").first
        container_segment = Segment.new(0,0, container.columns, container.rows, container)
        contained_segment = Segment.new(0, 0, contained.columns, contained.rows, contained)
        contained_segment.is_contained_in?(container_segment).should be_false
      end

      it "matchs if we lok for just the segment both images have in comomm: the fluffy cat" do
        container = Image.read("bidimensional/fluffy-cat.bmp").first
        contained = Image.read("bidimensional/not-seg-fluffy-cat.bmp").first

        fluffy_cat = [190, 160,380, 290, contained]
        container_segment = Segment.new(0,0, container.columns, container.rows, container)
        contained_segment = Segment.new(*fluffy_cat)
        contained_segment.is_contained_in?(container_segment).should be_true
      end
    end
  end
end


$LOAD_PATH << "."

require 'rspec'
require 'lib/image_testing'
require 'lib/pixel'

describe "#is_it_contained_in?" do

  context "Unidimensional" do
    context "should NOT find" do
      it "the smaller image in the bigger image, because they are different" do
        is_it_contained_in?("unidimensional/diff-uni-4.gif", "unidimensional/uni-16.gif").should be_false
      end

      it "the smaller image in the bigger, because they'r not the same, but uses the same colors" do
        is_it_contained_in?("unidimensional/uni-4.gif", "unidimensional/same-colors-uni-16.gif").should be_false
      end

      it "the smaller image in the bigger, because only the last pixel match " do
        is_it_contained_in?("unidimensional/uni-4.gif", "unidimensional/last-3-uni-16.gif").should be_false
      end
    end
    
    context "shoul find" do
      it "a segment of the image within the whole image" do
        is_it_contained_in?("unidimensional/uni-4.gif", "unidimensional/uni-16.gif").should be(true)
      end

      it "the smaller image in within the bigger, even if it is in other position" do
        is_it_contained_in?("unidimensional/uni-4.gif", "unidimensional/diff-position-uni-16.gif").should be(true)
      end

      it "the smaller image in within the bigger, even if the bigger image has a set of two pixels similar to the start of the patern" do
        is_it_contained_in?("unidimensional/uni-4.gif", "unidimensional/false-pattern-start-uni-16.gif").should be(true)
      end

      it "even if both images are big" do
        is_it_contained_in?("unidimensional/big-uni-smaller.jpg", "unidimensional/big-uni-bigger.jpg").should be(true)
      end
    end
  end

  context "Bidimensional" do
    it "should find a unidimentional image within the bidimensional image" do
      is_it_contained_in?("bidimensional/uni-4-1.gif", "bidimensional/16x2.gif").should be(true)
    end

    it "should find a unidimentional segment of the bidimensional image in the second row of the bigger image" do
      is_it_contained_in?("bidimensional/uni-4-second-row.gif", "bidimensional/16x2.gif").should be(true)
    end
    
    it "should find a unidimentional image within a bigger bidimensional image" do
      is_it_contained_in?("bidimensional/uni-4-1.gif", "bidimensional/tomato.gif").should be(true)
    end  
  end

  context "performance" do

  end

end

describe "#find_couple" do
  context "Unidimensional" do
    it "should find a couple with the first pixel of the contained image within the whole image" do
      container = Image.read("unidimensional/uni-16.gif").first
      contained = Image.read("unidimensional/uni-4.gif").first
      couples = find_couples(contained, container)
      couples.count.should be(1)
    end

    it "should find one couple with the one pixel in the bigger image, even if the smaller is not conteined in the bigger, but have on pixel with the same color" do
      container = Image.read("unidimensional/uni-16.gif").first
      contained = Image.read("unidimensional/diff-uni-4.gif").first
      couples = find_couples(contained, container)
      couples.count.should be(1)
    end

    it "should find the two couple, even if the smaller img is in other position" do
      container = Image.read("unidimensional/diff-position-uni-16.gif").first
      contained = Image.read("unidimensional/diff-uni-4.gif").first
      couples = find_couples(contained, container)
      couples.count.should be(2)
    end
  end
end


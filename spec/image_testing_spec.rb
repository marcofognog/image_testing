$LOAD_PATH << "."

require 'rspec'
require 'image_testing'

describe "#is_it_contained_in?" do

  context "Unidimensional" do
    it "should find a segment of the image within the whole image" do
      is_it_contained_in?("unidimensional/uni-4.gif", "unidimensional/uni-16.gif").should be(true)
    end

    it "should NOT find the smaller image in the bigger image, because their different" do
      is_it_contained_in?("unidimensional/diff-uni-4.gif", "unidimensional/uni-16.gif").should be_false
    end

    it "should NOT find the smaller image in the bigger, because they'r not the same, but uses the same colors" do
      is_it_contained_in?("unidimensional/uni-4.gif", "unidimensional/same-colors-uni-16.gif").should be_false
    end

    it "should find the smaller image in within the bigger, even if it is in other position" do
      is_it_contained_in?("unidimensional/uni-4.gif", "unidimensional/diff-position-uni-16.gif").should be(true)
    end

    it "should find the smaller image in within the bigger, even if the bigger image has a set of two pixels similar to the start of the patern" do
      is_it_contained_in?("unidimensional/uni-4.gif", "unidimensional/false-pattern-start-uni-16.gif").should be(true)
    end
  end

end

describe "#find_couple" do
  context "Unidimensional" do
    it "should find a couple with the first pixel of the conteined image within the whole image" do
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


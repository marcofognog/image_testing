$LOAD_PATH << "."

require 'rspec'
require 'image_testing'

describe "image_testing" do

  context "Unidimensional" do
    it "should find a segment of the image within the whole image" do
      is_it_contained_in?("unidimensional/uni-4.gif", "unidimensional/uni-16.gif").should be(true)
    end

    it "should NOT find the smaller image in the bigger image, because their different" do
      is_it_contained_in?("unidimensional/diff-uni-4.gif", "unidimensional/uni-16.gif").should be(false)
    end

    it "should NOT find the smaller image in the bigger, because they'r not the same, but uses the same colors" do
      is_it_contained_in?("unidimensional/uni-4.gif", "unidimensional/same-colors-uni-16.gif").should be(false)
    end

    it "should find the smaller image in within the bigger, even if it is in other position" do
      is_it_contained_in?("unidimensional/uni-4.gif", "unidimensional/diff-position-uni-16.gif").should be(true)
    end

    it "should find the smaller image in within the bigger, even if the bigger image has a set of two pixels similar to the start of the patern" do
      is_it_contained_in?("unidimensional/uni-4.gif", "unidimensional/false-pattern-start-uni-16.gif").should be(true)
    end

  end

end

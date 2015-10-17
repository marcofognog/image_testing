$LOAD_PATH << "."

require 'rspec'
require 'spec_helper'
require 'lib/image_testing'

describe "#is_it_contained_in?" do

  context "Unidimensional" do
    context "should NOT find" do
      it "the smaller image in the bigger image, because they are different" do
        assert !is_it_contained_in?("unidimensional/diff-uni-4.gif", "unidimensional/uni-16.gif")
      end

      it "the smaller image in the bigger, because they'r not the same, but use the same colors" do
        assert !is_it_contained_in?("unidimensional/uni-4.gif", "unidimensional/same-colors-uni-16.gif")
      end

      it "the smaller image in the bigger, because only the last pixel match " do
        assert !is_it_contained_in?("unidimensional/uni-4.gif", "unidimensional/last-3-uni-16.gif")
      end
    end

    context "shoul find" do
      it "a segment of the image within the whole image" do
        assert is_it_contained_in?("unidimensional/uni-4.gif", "unidimensional/uni-16.gif")
      end

      it "the smaller image in within the bigger, even if it is in other position" do
        assert is_it_contained_in?("unidimensional/uni-4.gif", "unidimensional/diff-position-uni-16.gif")
      end

      it "the smaller image in within the bigger, even if the bigger image has a set of two pixels similar to the start of the patern" do
        assert is_it_contained_in?("unidimensional/uni-4.gif", "unidimensional/false-pattern-start-uni-16.gif")
      end

      it "even if both images are big" do
        assert is_it_contained_in?("unidimensional/big-uni-smaller.jpg", "unidimensional/big-uni-bigger.jpg")
      end
    end
  end

  context "Bidimensional" do
    it "should find a unidimensional image within the bidimensional image" do
      assert is_it_contained_in?("bidimensional/uni-4-1.gif", "bidimensional/16x2.gif")
    end

    it "should find a unidimensional segment of the bidimensional image in the second row of the bigger image" do
      assert is_it_contained_in?("bidimensional/uni-4-second-row.gif", "bidimensional/16x2.gif")
    end

    it "should find a unidimensional image within a bigger bidimensional image" do
      assert is_it_contained_in?("bidimensional/uni-4-1.gif", "bidimensional/tomato.gif")
    end

    it "should find a unidimensional image within a even bigger bidimensional image" do
      assert is_it_contained_in?("bidimensional/uni-tomato100x54.bmp", "bidimensional/tomato100x54.bmp")
    end

    it "should find a BIidimensional image within a bidimensional image" do
      assert is_it_contained_in?("bidimensional/tomato6x6.gif", "bidimensional/tomato.gif")
    end

    it "should NOT find a BIidimensional image within a bidimensional image" do
      assert !is_it_contained_in?("bidimensional/not-tomato6x6.gif", "bidimensional/tomato.gif")
    end

    it "should find a BIidimensional image within a bigger bidimensional image" do
      assert is_it_contained_in?("bidimensional/seg-tomato100x54.bmp", "bidimensional/tomato100x54.bmp")
    end

    it "should NOT find a BIidimensional image within a bigger bidimensional image" do
      assert !is_it_contained_in?("bidimensional/not-seg-tomato100x54.bmp", "bidimensional/tomato100x54.bmp")
    end
  end

end


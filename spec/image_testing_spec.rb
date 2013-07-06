$LOAD_PATH << "."

require 'rspec'
require 'image_testing'

describe "image_testing" do

  it "should find a segment of the image within the whole image" do
    is_it_contained_in?("tomato2x2.gif", "tomato3x3.gif").should be(true)
  end
  
  it "should NOT find the smaller image in the bigger image, because their different" do
    is_it_contained_in?("tomato2x2.gif", "different_tomato.gif").should be(false)
  end

  it "should NOT find the smaller image in the bigger, because they'r not the same, but uses the same colors" do
    is_it_contained_in?("tomato2x2.gif", "diff_with_same_colors_tomato.gif").should be(false)
  end
  
  it "should find the smaller image in within the bigger, even if it is in other position" do
    is_it_contained_in?("tomato2x2.gif", "2x2contained_in_other_position.gif").should be(true)
  end

end

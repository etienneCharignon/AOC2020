require 'slope'

RSpec.describe Slope, "#count_tree" do
  it "count tree on empty mountain" do
    expect(Slope.count_trees(["....", "...."], 1, 3)).to eql(0)
  end

  it "count tree on one tree mountain" do
    expect(Slope.count_trees(["....", "...#"], 1, 3)).to eql(1)
  end

  it "count tree on larger mountain" do
    expect(Slope.count_trees([".......", "...#...", "......#"], 1, 3)).to eql(2)
  end

  it "count tree on narrow mountain" do
    expect(Slope.count_trees(["....", "...#", "..#."], 1, 3)).to eql(2)
  end
end

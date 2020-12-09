require 'xmas_error_finder'
require 'data_day9'

EXAMPLE_INPUT9 = [35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576]


RSpec.describe XMasErrorFinder do
  context "#part1 : find the weakness" do
    it "compute all combinations of the N first entries" do
      expect(XMasErrorFinder.combinations([1, 2])).to eql([3])
      expect(XMasErrorFinder.combinations([1, 2, 3])).to eql([3, 4, 5])
    end

    it "find weakness in example" do
      expect(XMasErrorFinder.findWeakness(EXAMPLE_INPUT9, 5)).to eql(127)
    end

    it "find weakness" do
      expect(XMasErrorFinder.findWeakness(INPUT9, 25)).to eql(50047984)
    end
  end
  context "#part2 : find more on the weakness" do
    it "find more of weakness in example" do
      expect(XMasErrorFinder.findMoreAboutWeakness(EXAMPLE_INPUT9, 127)).to eql(62)
    end

    it "find more of weakness" do
      expect(XMasErrorFinder.findMoreAboutWeakness(INPUT9, 50047984)).to eql(5407707)
    end
  end
end

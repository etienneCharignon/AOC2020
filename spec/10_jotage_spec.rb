require 'joltage_adapter'
require 'data_day10'

EXAMPLE_INPUT_10 = [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]
EXAMPLE2_INPUT_10 = [28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3]

RSpec.describe JoltageAdapter do
  describe "Part 1" do
    it 'find the differences in the shortest example' do
      expect(JoltageAdapter.find(EXAMPLE_INPUT_10)).to eql(5*7)
    end
    it 'find the differences in the input' do
      expect(JoltageAdapter.find(INPUT10)).to eql(1625)
    end
  end


  describe "Part 2" do
    describe 'find arrangement' do
      it { expect(JoltageAdapter.count2(1, { 0=>1, 1=>[0] })).to eql(1) }
      it { expect(JoltageAdapter.count2(2, { 0=>1, 1=>1, 2=>[1,0] })).to eql(2) }
      it { expect(JoltageAdapter.find_arrangements(EXAMPLE_INPUT_10)).to eql(8) }
      it { expect(JoltageAdapter.find_arrangements(EXAMPLE2_INPUT_10)).to eql(19208) }
      it { expect(JoltageAdapter.find_arrangements(INPUT10)).to eql(3100448333024) }
    end
  end
end

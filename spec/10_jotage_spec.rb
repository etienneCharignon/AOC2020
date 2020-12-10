require 'joltage_adapter'
require 'data_day10'

EXAMPLE_INPUT_10 = [16,
10,
15,
5,
1,
11,
7,
19,
6,
12,
4]

RSpec.describe JoltageAdapter do
  describe "Part 1" do
    it 'find the differences in the shortest example' do
      expect(JoltageAdapter.find(EXAMPLE_INPUT_10)).to eql(5*7)
    end
    it 'find the differences in the input' do
      expect(JoltageAdapter.find(INPUT10)).to eql(5*7)
    end
  end
end

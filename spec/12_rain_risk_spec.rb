require 'rain_risk'
require 'data_day12'

RSpec.describe RainRisk do
  describe 'process instructions part 1' do
    it { expect(RainRisk.process("N1")).to eql({'N' => 1, 'S' => 0, 'E' => 0, 'W' => 0}) }
    it { expect(RainRisk.process("S1")).to eql({'N' => 0, 'S' => 1, 'E' => 0, 'W' => 0}) }
    it { expect(RainRisk.process("F1")).to eql({'N' => 0, 'S' => 0, 'E' => 1, 'W' => 0}) }
    it { expect(RainRisk.process("L90\nF1")).to eql({'N' => 1, 'S' => 0, 'E' => 0, 'W' => 0}) }
    it { expect(RainRisk.process("L180\nF1")).to eql({'N' => 0, 'S' => 0, 'E' => 0, 'W' => 1}) }
    it { expect(RainRisk.process("L360\nF1")).to eql({'N' => 0, 'S' => 0, 'E' => 1, 'W' => 0}) }
    it { expect(RainRisk.process("R90\nF1")).to eql({'N' => 0, 'S' => 1, 'E' => 0, 'W' => 0}) }
    it { expect(RainRisk.process("R360\nF1")).to eql({'N' => 0, 'S' => 0, 'E' => 1, 'W' => 0}) }
    it { expect(RainRisk.process(INPUT12)).to eql({'N' => 3163, 'S' => 3403, 'E' => 2565, 'W' => 2833}) }
  end
  describe 'process instructions part 2' do
    it { expect(RainRisk.process2("F10")).to eql({'N' => 10, 'S' => 0, 'E' => 100, 'W' => 0}) }
    it { expect(RainRisk.process2("N1\nF1")).to eql({'N' => 2, 'S' => 0, 'E' => 10, 'W' => 0}) }
    it { expect(RainRisk.new('E').process2_from("R90").waypoint).to eql({'N' => 0, 'S' => 10, 'E' => 1, 'W' => 0}) }
    it { expect(RainRisk.new('E').process2_from("L90").waypoint).to eql({'N' => 10, 'S' => 0, 'E' => 0, 'W' => 1}) }
    it { expect(RainRisk.process2(INPUT12)).to eql({'N' => 1649161, 'S' => 1666334, 'E' => 1651476, 'W' => 1665064}) }
  end
end

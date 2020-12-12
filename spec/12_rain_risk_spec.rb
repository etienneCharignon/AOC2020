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
end

require 'data_day14'

EXAMPLE_DAY14 = %{mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[7] = 11
mem[8] = 0}

def apply_mask(mask, number)
  mask.reverse.split('').each_with_index do |bit, i|
    number |= 2**i if bit == "1"
    number &= ~(2**i) if bit == "0"
  end
  number
end

def execute(code)
  mem = []
  mask = ""
  code.split("\n").each do |line|
    mask_instruction = /mask = (.*)/.match line
    mask = mask_instruction[1] if mask_instruction

    mem_instruction = /mem\[(\d+)\] = (\d+)/.match line
    mem[mem_instruction[1].to_i] = apply_mask(mask, mem_instruction[2].to_i) if mem_instruction
  end
  mem
end

RSpec.describe "Docking data" do
  describe "Part 1 : initialisation" do
    it { expect(apply_mask("X1", 0)).to eql(1) }
    it { expect(apply_mask("X1", 1)).to eql(1) }
    it { expect(apply_mask("1X", 1)).to eql(3) }
    it { expect(apply_mask("X0", 1)).to eql(0) }
    it { expect(execute(EXAMPLE_DAY14)).to eql([nil, nil, nil, nil, nil, nil, nil, 73, 64]) }
    it { expect(execute(INPUT14).compact.inject(:+)).to eql(11179633149677) }
  end
end

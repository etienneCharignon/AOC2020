require 'data_day14'

EXAMPLE_DAY14 = %{mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[7] = 11
mem[8] = 0}

EXAMPLE_DAY14_2 = %{mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1}

def apply_mask(mask, number)
  mask.reverse.split('').each_with_index do |bit, i|
    number |= 2**i if bit == "1"
    number &= ~(2**i) if bit == "0"
  end
  number
end

def apply_mask2(mask, number)
  floating_bits = []
  mask.reverse.split('').each_with_index do |bit, i|
    number |= 2**i if bit == "1"
    if bit == "X"
      floating_bits << i
      number &= ~(2**i)
    end
  end
  addresses = [number]
  floating_bits.each do |bit|
    addresses.clone.each do |adresse|
      addresses << (adresse | 2**bit)
    end
  end
  addresses
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

def execute2(code)
  mem = {}
  mask = ""
  code.split("\n").each do |line|
    mask_instruction = /mask = (.*)/.match line
    mask = mask_instruction[1] if mask_instruction

    mem_instruction = /mem\[(\d+)\] = (\d+)/.match line
    if mem_instruction
      addresses = apply_mask2(mask, mem_instruction[1].to_i)
      addresses.each { |addresse| mem[addresse] = mem_instruction[2].to_i }
    end
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

  describe "Part 2 : version 2" do
    it { expect(apply_mask2("01", 0)).to eql([1]) }
    it { expect(apply_mask2("10", 1)).to eql([3]) }
    it { expect(apply_mask2("X", 0)).to eql([0, 1]) }
    it { expect(apply_mask2("XX", 0)).to eql([0, 1, 2, 3]) }
    it { expect(execute2(EXAMPLE_DAY14_2).values.inject(:+)).to eql(208) }
    it { expect(execute2(INPUT14).values.inject(:+)).to eql(4822600194774) }
  end
end

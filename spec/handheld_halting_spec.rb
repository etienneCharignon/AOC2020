require 'handheld_halting'
require './lib/data_day8'

RSpec.describe HandheldHalting do
  context "#part 1" do
    it "run a program of one line that do nothing" do
      program = %{nop +0}
      expect(HandheldHalting.new.run(program)).to eql(0)
    end

    it "run a program of one line that increase" do
      program = %{acc +2}
      expect(HandheldHalting.new.run(program)).to eql(2)
    end

    it "run a program of two line" do
      program = %{acc -2
    acc +4}
      expect(HandheldHalting.new.run(program)).to eql(2)
    end

    it "run a program with a jump" do
      program = %{acc -2
    jmp +2
    acc +4
    acc -2}
      expect(HandheldHalting.new.run(program)).to eql(-4)
    end

    it "stop the program when executing two times the same instruction" do
      program = %{nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    jmp -4
    acc +6}
      expect(HandheldHalting.new.run(program)).to eql(5)
    end

    it "run on input" do
      handheld = HandheldHalting.new
      expect(handheld.run(INPUT8)).to eql(1727)
    end
  end

  context "#part 2" do
    it "run on input" do
      handheld = HandheldHalting.new
      handheld.run(INPUT8)
      expect(handheld.infinit_loop).to eql(true)
      expect(handheld.visited_index.count).to eql(201)
    end

    it "can mute au program" do
      program = "nop +0\njmp +2"
      expect(HandheldHalting.mute(program, 0)).to eql("jmp +0\njmp +2")
      expect(HandheldHalting.mute(program, 1)).to eql("nop +0\nnop +2")
    end

    it "search for the mutation" do
      expect(HandheldHalting.answer_when_fixed(INPUT8)).to eql(552)
    end
  end
end


require 'luggage_rull'
require 'data_day7'

EXAMPLE_INPUT = %{light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.}

EXAMPLE_INPUT_PART2 = %{shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.}

RSpec.describe LuggageRull, "#part 1" do
    it "extrait une ligne" do
      expect(LuggageRull.read("light red bags contain 1 bright white bag, 2 muted yellow bags.")).to eq(
        ['light red', { 'bright white' => 1, 'muted yellow' => 2 }])
    end

    it "extrait une ligne avec un sac vide" do
      expect(LuggageRull.read("faded blue bags contain no other bags.")).to eq(
        ['faded blue', { }])
    end

    it "extrait plusieurs lignes" do
      bags = LuggageRull.read_lines(EXAMPLE_INPUT.split("\n"))
      expect(bags.count).to eq(9)
    end

    it "count all direct or 1 distance containing bags" do
      bags = LuggageRull.read_lines(EXAMPLE_INPUT.split("\n"))
      expect(LuggageRull.containing_bags(bags, "shiny gold")).to eql(["bright white", "muted yellow", "light red", "dark orange"])
    end

    it "count the input" do
      bags = LuggageRull.read_lines(INPUT.split("\n"))
      p LuggageRull.containing_bags(bags, 'shiny gold').count
    end

    it "count contained" do
      bags = LuggageRull.read_lines(EXAMPLE_INPUT_PART2.split("\n"))
      expect(LuggageRull.contained(bags, "shiny gold")).to eql(126)
    end

    it "count contained in input" do
      bags = LuggageRull.read_lines(INPUT.split("\n"))
      expect(LuggageRull.contained(bags, "shiny gold")).to eql(54803)
    end
end

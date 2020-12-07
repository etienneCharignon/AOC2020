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
      p bags
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
end

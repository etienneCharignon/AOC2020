PLAYER_1 = [ 12, 48, 26, 22, 44, 16, 31, 19, 30, 10, 40, 47, 21, 27, 2, 46, 9, 15, 23, 6, 50, 28, 5, 42, 34]
PLAYER_2 = [ 14, 45, 4, 24, 1, 7, 36, 29, 38, 33, 3, 13, 11, 17, 39, 43, 8, 41, 32, 37, 35, 49, 20, 18, 25]

DECK1_EXAMPLE = [9, 2, 6, 3, 1]
DECK2_EXAMPLE = [5, 8, 4, 7, 10]

def play_crab_combat(deck1, deck2)
  while !(deck1.empty? or deck2.empty?) do
    c1 = deck1.shift
    c2 = deck2.shift
    if c1 > c2
      deck1 << c1
      deck1 << c2
    else
      deck2 << c2
      deck2 << c1
    end
  end
  [deck1, deck2]
end

def compute_score(game)
  game.flatten.reverse.map.with_index(1) { |c, i| c*i }.inject(:+)
end

RSpec.describe "Crab Combat" do
  describe "play the example" do
    it { expect(play_crab_combat(DECK1_EXAMPLE, DECK2_EXAMPLE)).to eql([[], [3, 2, 10, 6, 8, 5, 9, 4, 7, 1]]) }
    it { expect(compute_score(play_crab_combat(DECK1_EXAMPLE, DECK2_EXAMPLE))).to eql(306) }
  end

  describe "play for real" do
    it { expect(compute_score(play_crab_combat(PLAYER_1, PLAYER_2))).to eql(32448) }
  end
end

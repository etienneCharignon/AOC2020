PLAYER_1 = [ 12, 48, 26, 22, 44, 16, 31, 19, 30, 10, 40, 47, 21, 27, 2, 46, 9, 15, 23, 6, 50, 28, 5, 42, 34]
PLAYER_2 = [ 14, 45, 4, 24, 1, 7, 36, 29, 38, 33, 3, 13, 11, 17, 39, 43, 8, 41, 32, 37, 35, 49, 20, 18, 25]

DECK1_EXAMPLE = [9, 2, 6, 3, 1]
DECK2_EXAMPLE = [5, 8, 4, 7, 10]

DECK1_INFINIT_EXAMPLE = [43,19]
DECK2_INFINIT_EXAMPLE = [2, 29, 14]

def play_crab_combat(d1, d2)
  deck1 = d1.clone
  deck2 = d2.clone
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

def play_recursive_crab_combat(deck1, deck2, game)
  # p "GAME #{game}"
  history = []
  while !(deck1.empty? or deck2.empty?) do
    if history.include?([deck1, deck2])
      deck2 = []
      break
    end
    decks = [deck1.clone, deck2.clone]
    history << decks
    c1 = deck1.shift
    c2 = deck2.shift

    if deck1.size >= c1 and deck2.size >= c2
      result = play_recursive_crab_combat(deck1[0..c1-1], deck2[0..c2-1], game + 1)
      if result[0].empty?
        deck2 << c2
        deck2 << c1
      else
        deck1 << c1
        deck1 << c2
      end
    else
      if c1 > c2
        deck1 << c1
        deck1 << c2
      else
        deck2 << c2
        deck2 << c1
      end
    end
  end
  [deck1, deck2]
end

def compute_score(game)
  game.flatten.reverse.map.with_index(1) { |c, i| c*i }.inject(:+)
end

RSpec.describe "Crab Combat" do
  describe "part 1" do
    describe "play the example" do
      it { expect(play_crab_combat(DECK1_EXAMPLE, DECK2_EXAMPLE)).to eql([[], [3, 2, 10, 6, 8, 5, 9, 4, 7, 1]]) }
      it { expect(compute_score(play_crab_combat(DECK1_EXAMPLE, DECK2_EXAMPLE))).to eql(306) }
    end

    describe "play for real" do
      it { expect(compute_score(play_crab_combat(PLAYER_1, PLAYER_2))).to eql(32448) }
    end
  end

  describe "part 2 : Recursive combat" do
    describe "play inifinit prevention rull" do
      it {expect(play_recursive_crab_combat(DECK1_INFINIT_EXAMPLE, DECK2_INFINIT_EXAMPLE, 1)).to eql([[43, 19], []]) }
    end

    describe "play example" do
      it {expect(play_recursive_crab_combat(DECK1_EXAMPLE, DECK2_EXAMPLE, 1)).to eql([[], [7, 5, 6, 2, 4, 1, 10, 8, 9, 3]]) }
      it { expect(compute_score(play_recursive_crab_combat(DECK1_EXAMPLE, DECK2_EXAMPLE, 1))).to eql(291) }
    end

    describe "play for real" do
      xit { expect(compute_score(play_recursive_crab_combat(PLAYER_1, PLAYER_2, 1))).to eql(32448) }
    end
  end
end

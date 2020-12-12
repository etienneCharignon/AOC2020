require 'seating_system'
require 'data_day11'

EXAMPLE_INPUT11 = %{L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL}

EXAMPLE_SOLUCE11 = %{#.L#.L#.L#
#LLLLLL.LL
L.L.L..#..
##L#.#L.L#
L.L#.LL.L#
#.LLLL#.LL
..#.L.....
LLL###LLL#
#.LLLLL#.L
#.L#LL#.L#}

HEIGH_NEIGHBOUR = %{.......#.
...#.....
.#.......
.........
..#L....#
....#....
.........
#........
...#.....}

RSpec.describe SeatingSystem do
  describe 'parte 2' do
    describe 'look for neighbour in one direction' do
      it { expect(SeatingSystem.look_for_one_direction(0, -10, 43, HEIGH_NEIGHBOUR)).to eql(true) }
      it { expect(SeatingSystem.look_for_one_direction(1, 0, 6, EXAMPLE_SOLUCE11)).to eql(false) }
    end

    describe 'can count the number of neighbour' do
      it { expect(SeatingSystem.countNeighbour(1, "LLL\nL.L")).to eql(0) }
      it { expect(SeatingSystem.countNeighbour(1, "###\n#.#")).to eql(4) }
      it { expect(SeatingSystem.countNeighbour(0, "###\n#.#")).to eql(2) }
      it { expect(SeatingSystem.countNeighbour(1, "###\n###")).to eql(5) }
      it { expect(SeatingSystem.countNeighbour(5, "###\n#.#")).to eql(5) }
      it { expect(SeatingSystem.countNeighbour(0, "###\n#.#")).to eql(2) }
      it { expect(SeatingSystem.countNeighbour(4, "#.#\n###\n#.#")).to eql(3) }
      it { expect(SeatingSystem.countNeighbour(43, HEIGH_NEIGHBOUR)).to eql(8) }
    end

    describe 'can compute the next genetation' do
      it { expect(SeatingSystem.next("LLL\nL.L")).to eql("###\n#.#") }
      it { expect(SeatingSystem.next("###\n###")).to eql("#L#\n#L#") }
      it { expect(SeatingSystem.next("#L#\n#.#")).to eql("#L#\n#.#") }
      it { expect(SeatingSystem.next(EXAMPLE_SOLUCE11)).to eql(EXAMPLE_SOLUCE11) }
    end

    describe 'compute generation until it stabilises' do
      it { expect(SeatingSystem.number_of_seats_occupied_at_the_end(EXAMPLE_INPUT11)).to eql(26) }
      it { expect(SeatingSystem.run_to_the_end(EXAMPLE_INPUT11)).to eql(EXAMPLE_SOLUCE11) }
      xit { expect(SeatingSystem.number_of_seats_occupied_at_the_end(INPUT11)).to eql(2054) }
    end
  end
end

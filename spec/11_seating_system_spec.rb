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

EXAMPLE_SOLUCE11 = %{#.#L.L#.##
#LLL#LL.L#
L.#.L..#..
#L##.##.L#
#.#L.LL.LL
#.#L#L#.##
..L.L.....
#L#L##L#L#
#.LLLLLL.L
#.#L#L#.##}

RSpec.describe SeatingSystem do
  describe 'parte 1' do
    describe 'can count the number of neighbour' do
      it { expect(SeatingSystem.countNeighbour('#', 1, "LLL\nL.L")).to eql(0) }
      it { expect(SeatingSystem.countNeighbour('L', 1, "LLL\nL.L")).to eql(4) }
      it { expect(SeatingSystem.countNeighbour('#', 1, "###\n#.#")).to eql(4) }
      it { expect(SeatingSystem.countNeighbour('#', 0, "###\n#.#")).to eql(2) }
      it { expect(SeatingSystem.countNeighbour('#', 1, "###\n###")).to eql(5) }
      it { expect(SeatingSystem.countNeighbour('#', 5, "###\n#.#")).to eql(5) }
      it { expect(SeatingSystem.countNeighbour('#', 0, "###\n#.#")).to eql(2) }
      it { expect(SeatingSystem.countNeighbour('#', 4, "#.#\n###\n#.#")).to eql(3) }
    end

    describe 'can compute the next genetation' do
      it { expect(SeatingSystem.next("LLL\nL.L")).to eql("###\n#.#") }
      it { expect(SeatingSystem.next("###\n#.#")).to eql("#L#\n#.#") }
      it { expect(SeatingSystem.next("#L#\n#.#")).to eql("#L#\n#.#") }
      it { expect(SeatingSystem.next(EXAMPLE_SOLUCE11)).to eql(EXAMPLE_SOLUCE11) }
      it { expect(SeatingSystem.next(%{#.##.##.##
#######.##
#.#.#..#..
####.##.##
#.##.##.##
#.#####.##
..#.#.....
##########
#.######.#
#.#####.##})).to eql(%{#.LL.L#.##
#LLLLLL.L#
L.L.L..L..
#LLL.LL.L#
#.LL.LL.LL
#.LLLL#.##
..L.L.....
#LLLLLLLL#
#.LLLLLL.L
#.#LLLL.##}) }
    end

    describe 'compute generation until it stabilises' do
      it { expect(SeatingSystem.number_of_seats_occupied_at_the_end("LLL\nL.L")).to eql(4) }
      it { expect(SeatingSystem.number_of_seats_occupied_at_the_end("LLL\nL.L")).to eql(4) }
      it { expect(SeatingSystem.number_of_seats_occupied_at_the_end(EXAMPLE_INPUT11)).to eql(37) }
      it { expect(SeatingSystem.run_to_the_end(EXAMPLE_INPUT11)).to eql(EXAMPLE_SOLUCE11) }
      it { expect(SeatingSystem.number_of_seats_occupied_at_the_end(INPUT11)).to eql(2283) }
    end
  end
end

require './slope'
require './data_day3'

INPUT_TEST=%{..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#}

INPUTS = INPUT.split("\n")
p [
  Slope.count_trees(INPUTS, 1, 1),
  Slope.count_trees(INPUTS, 1, 3),
  Slope.count_trees(INPUTS, 1, 5),
  Slope.count_trees(INPUTS, 1, 7),
  Slope.count_trees(INPUTS, 2, 1),
].inject(:*)

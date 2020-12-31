require 'data_day20'

ONE_TILE= %{Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###}

TWO_TILES = %{Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###

Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..}

# Tile 2473:
# #....####.
# #..#.##...
# #.##..#...
# ######.#.#
# .#...#.#.#
# .#########
# .###.#..#.
# ########.#
# ##...##.#.
# ..###.#.#.

def read_20(input)
  tiles = {}
  input.split("Tile").drop(1).each do |tile_input|
    rows = tile_input.split("\n")
    top = rows[1]
    right = rows[1..-1].map {|r| r[-1]}.join('')
    bottom = rows[-1].reverse
    left = rows[1..-1].map {|r| r[0]}.join('')
    tiles[rows[0][/\d+/].to_i] = { bords: [top, right, bottom, left], tile: rows[1..-1] }
  end
  tiles
end

def flip(tiles, id, axe)
  bords = tiles[id][:bords]
  if axe == :h
    tiles[id][:bords] = [bords[2], bords[1].reverse, bords[0], bords[3].reverse]
    tiles[id][:tile] = tiles[id][:tile].reverse
  else
    tiles[id][:bords] = [bords[0].reverse, bords[3], bords[2].reverse, bords[1]]
    tiles[id][:tile] = tiles[id][:tile].map { |r| r.reverse }
  end
end

def rotate(tiles, id)
  tile = tiles[id][:bords]
  tiles[id][:bords] = [tile[3], tile[0], tile[1], tile[2]]
end

def add_reverse(tiles)
  tiles_with_reverse = {}
  tiles.each do |id, tile|
    tiles_with_reverse[id] = tile[:bords] + tile[:bords].map { |b| b.reverse }
  end
  tiles_with_reverse
end

def has_neighbor(id, border, tiles_with_reverse)
  tiles_with_reverse.each do |tid, borders|
    return tid if tid != id && borders.include?(border)
  end
  return nil
end

def find_corners(tiles)
  tiles_with_reverse = add_reverse(tiles)
  corner = []
  tiles.each do |id, tile|
    #p "NEW TILE #{id}"
    no_neighbour_border_count = 0
    for b in tile[:bords]
      has = has_neighbor(id, b, tiles_with_reverse) != nil
      no_neighbour_border_count += 1 unless has
      if no_neighbour_border_count == 2
        corner << id
        break
      end
    end
  end
  corner
end

def find_neighbour(id, border, tiles_with_reverse)
  tiles_with_reverse.each do |tid, borders|
    return [tid, borders.index(border) ] if tid != id && borders.include?(border)
  end
  return nil
end

def assemble(tiles, first_corner)
  flip(tiles, first_corner, :h)
  tiles_with_reverse = add_reverse(tiles)
  puzzle = []
  current_first_col_tile = first_corner
  1.times do
    puzzle += tiles[current_first_col_tile][:tile]
    puzzle_row = puzzle.size - 10
    current_row_tile = current_first_col_tile
    12.times do
      neighbour = find_neighbour(current_row_tile, tiles[current_row_tile][:bords][1], tiles_with_reverse)
      break if neighbour.nil?
      p neighbour
      flip(tiles, neighbour[0], :h) if neighbour[1] == 7
      tile.each_with_index { |r, i| puzzle[puzzle_row + i] += " #{tiles[neighbour[0]][:tile][i]}" }
      current_row_tile = neighbour[0]
    end
    neighbour = find_neighbour(current_row_tile, tiles[current_row_tile][:bords][2], tiles_with_reverse)

  end
  puzzle.join("\n")
end

RSpec.describe "Jurassic Jigsaw", focus: true do
  describe "Part 1 : reassembled back into a single image" do
    describe "read the input" do
      it { expect(read_20(ONE_TILE)).to eql({
        2311 => {
          :bords => ["..##.#..#.", "...#.##..#", "###..###..", ".#####..#."],
          :tile => ["..##.#..#.", "##..#.....", "#...##..#.", "####.#...#", "##.##.###.", "##...#.###", ".#.#.#..##", "..#....#..", "###...#.#.", "..###..###"]
        }
      }) }
      it { expect(read_20(TWO_TILES).keys).to eql([2311, 1951]) }
      it { expect(read_20(TWO_TILES)[2311][:bords]).to eql(["..##.#..#.", "...#.##..#", "###..###..", ".#####..#."]) }
      it { expect(read_20(TWO_TILES)[1951][:bords]).to eql(["#.##...##.", ".#####..#.", "..#.##...#", "##.#..#..#"]) }
      it { expect(read_20(INPUTS20).count).to eql(144) }
    end

    describe "flip a tile" do
      it { expect(flip({2311 => { bords: ["..##.#..#.", "...#.##..#", "###..###..", ".#####..#."]}}, 2311, :h))
        .to eql(["###..###..", "...#.##..#".reverse, "..##.#..#.", ".#####..#.".reverse]) }
      it { expect(flip({2311 => { bords: ["..##.#..#.", "...#.##..#", "###..###..", ".#####..#."]}}, 2311, :v))
        .to eql(["..##.#..#.".reverse, ".#####..#.", "###..###..".reverse, "...#.##..#"]) }
    end

    describe "rotate a tile" do
      it { expect(rotate({2311 => { bords: ["..##.#..#.", "...#.##..#", "###..###..", ".#####..#."] }}, 2311))
        .to eql([".#####..#.", "..##.#..#.", "...#.##..#", "###..###.."]) }
    end

    describe "look for corners" do
      it { expect(has_neighbor(1214, "..##.#..#.", { 1212 => ["..##.#..#.", "...#.##..#", "###..###..", ".#####..#."] })).to be(1212) }
      it { expect(has_neighbor(1212, "..##.#..#.", { 1212 => ["..##.#..#.", "...#.##..#", "###..###..", ".#####..#."] })).to be(nil) }
      it { expect(has_neighbor(1214, "..##.#....", { 1212 => ["..##.#..#.", "...#.##..#", "###..###..", ".#####..#."] })).to be(nil) }
      it { expect(add_reverse(read_20(EXAMPLE_INPUT20))[1951]).to eql(["#.##...##.", ".#####..#.", "..#.##...#", "##.#..#..#",
                                                                       ".##...##.#", ".#..#####.", "#...##.#..", "#..#..#.##"]) }
      it { expect(find_corners(read_20(EXAMPLE_INPUT20))).to eql([1951, 1171, 2971, 3079]) }
      it { expect(find_corners(read_20(INPUTS20))).to eql([3643, 2647, 1987, 3089]) }
    end

    describe "re-assemble" do
      it do
        expect(assemble(read_20(EXAMPLE_INPUT20), 1951)).to eql(%{
#...##.#.. ..###..### #.#.#####.
..#.#..#.# ###...#.#. .#..######
.###....#. ..#....#.. ..#.......
###.##.##. .#.#.#..## ######....
.###.##### ##...#.### ####.#..#.
.##.#....# ##.##.###. .#...#.##.
#...###### ####.#...# #.#####.##
.....#..## #...##..#. ..#.###...
#.####...# ##..#..... ..#.......
#.##...##. ..##.#..#. ..#.###...

#.##...##. ..##.#..#. ..#.###...
##..#.##.. ..#..###.# ##.##....#
##.####... .#.####.#. ..#.###..#
####.#.#.. ...#.##### ###.#..###
.#.####... ...##..##. .######.##
.##..##.#. ....#...## #.#.#.#...
....#..#.# #.#.#.##.# #.###.###.
..#.#..... .#.##.#..# #.###.##..
####.#.... .#..#.##.. .######...
...#.#.#.# ###.##.#.. .##...####

...#.#.#.# ###.##.#.. .##...####
..#.#.###. ..##.##.## #..#.##..#
..####.### ##.#...##. .#.#..#.##
#..#.#..#. ...#.#.#.. .####.###.
.#..####.# #..#.#.#.# ####.###..
.#####..## #####...#. .##....##.
##.##..#.. ..#...#... .####...#.
#.#.###... .##..##... .####.##.#
#...###... ..##...#.. ...#..####
..#.#....# ##.#.#.... ...##.....
})
      end
    end
  end
end

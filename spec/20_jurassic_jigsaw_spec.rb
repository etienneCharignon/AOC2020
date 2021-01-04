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

class Tile
  attr_reader :id, :bords, :tile, :bords_and_reverse

  def initialize(rows)
    @id = rows[0][/\d+/].to_i
    @tile = rows[1..-1]
    @bords = extract_borders(@tile)
    @bords_and_reverse = @bords + @bords.map { |b| b.reverse }
  end

  def extract_borders(rows)
    top = rows[0]
    right = rows[0..-1].map {|r| r[-1]}.join('')
    bottom = rows[-1]
    left = rows[0..-1].map {|r| r[0]}.join('')
    [top, right, bottom, left]
  end

  def flip(axe)
    if axe == :h
      @bords = [@bords[2], @bords[1].reverse, @bords[0], @bords[3].reverse]
      @tile = @tile.reverse
    else
      @bords = [@bords[0].reverse, @bords[3], @bords[2].reverse, @bords[1]]
      @tile = @tile.map { |r| r.reverse }
    end
    self
  end

  def rotate
    @tile = @tile.map.with_index(0) { |_, i| @tile.reverse.map { |r| r[i] }.join('') }
    @bords = extract_borders(@tile)
    self
  end
end

def read_20(input)
  tiles = {}
  input.split("Tile").drop(1).each do |tile_input|
    rows = tile_input.split("\n")
    tile = Tile.new(rows)
    tiles[tile.id] = tile
  end
  tiles
end

def has_neighbor(id, border, tiles)
  tiles.each do |tid, tile|
    return tid if tid != id && tile.bords_and_reverse.include?(border)
  end
  return nil
end

def find_corners(tiles)
  corner = []
  tiles.each do |id, tile|
    #p "NEW TILE #{id}"
    no_neighbour_border_count = 0
    for b in tile.bords
      has = has_neighbor(id, b, tiles) != nil
      no_neighbour_border_count += 1 unless has
      if no_neighbour_border_count == 2
        corner << id
        break
      end
    end
  end
  corner
end

def find_neighbour(id, border, tiles)
  tiles.each do |tid, tile|
    return tid if tid != id && tile.bords_and_reverse.include?(border)
  end
  return nil
end

def assemble(tiles, first_corner)
  tiles[first_corner].flip(:h)
  puzzle = []
  current_first_col_tile = first_corner
  12.times do
    puzzle << ""
    puzzle += tiles[current_first_col_tile].tile
    puzzle_row = puzzle.size - 10
    current_row_tile = current_first_col_tile
    11.times do
      neighbour = find_neighbour(current_row_tile, tiles[current_row_tile].bords[1], tiles)
      break if neighbour.nil?

      while !(
          tiles[current_row_tile].bords[1] == tiles[neighbour].bords[3] or
          tiles[current_row_tile].bords[1] == tiles[neighbour].bords[3].reverse
      ) do
        tiles[neighbour].rotate
      end
      tiles[neighbour].flip(:h) if tiles[current_row_tile].bords[1] != tiles[neighbour].bords[3]

      current_row_tile = neighbour

      tiles[current_row_tile].tile.each_with_index { |r, i|
        puzzle[puzzle_row + i] += " #{tiles[current_row_tile].tile[i]}"
      }
    end
    neighbour = find_neighbour(current_first_col_tile, tiles[current_first_col_tile].bords[2], tiles)
    break if neighbour.nil?

    while !(
        tiles[current_first_col_tile].bords[2] == tiles[neighbour].bords[0] or
        tiles[current_first_col_tile].bords[2] == tiles[neighbour].bords[0].reverse
    ) do
      tiles[neighbour].rotate
    end
    tiles[neighbour].flip(:v) if tiles[current_first_col_tile].bords[2] != tiles[neighbour].bords[0]

    current_first_col_tile = neighbour
  end
  puzzle.join("\n")
end

RSpec.describe "Jurassic Jigsaw", focus: true do
  describe "Part 1 : reassembled back into a single image" do
    describe "read the input" do
      it { expect(read_20(ONE_TILE)[2311].bords)
        .to eql(["..##.#..#.", "...#.##..#", "..###..###", ".#####..#."]) }
      it { expect(read_20(ONE_TILE)[2311].tile)
        .to eql(["..##.#..#.", "##..#.....", "#...##..#.", "####.#...#", "##.##.###.", "##...#.###", ".#.#.#..##", "..#....#..", "###...#.#.", "..###..###"]) }
      it { expect(read_20(TWO_TILES).keys).to eql([2311, 1951]) }
      it { expect(read_20(TWO_TILES)[2311].bords).to eql(["..##.#..#.", "...#.##..#", "..###..###", ".#####..#."]) }
      it { expect(read_20(TWO_TILES)[1951].bords).to eql(["#.##...##.", ".#####..#.", "#...##.#..", "##.#..#..#"]) }
      it { expect(read_20(INPUTS20).count).to eql(144) }
    end

    describe "flip a tile" do
      it {
        tile = read_20(ONE_TILE)[2311]
        tile.flip(:h)
        expect(tile.bords).to eql(["..###..###", "...#.##..#".reverse, "..##.#..#.", ".#####..#.".reverse])
        expect(tile.tile).to eql([
          "..###..###",
          "###...#.#.",
          "..#....#..",
          ".#.#.#..##",
          "##...#.###",
          "##.##.###.",
          "####.#...#",
          "#...##..#.",
          "##..#.....",
          "..##.#..#."
        ])
      }
      it {
        tile = read_20(ONE_TILE)[2311]
        tile.flip(:v)
        expect(tile.bords).to eql(["..##.#..#.".reverse, ".#####..#.", "..###..###".reverse, "...#.##..#"])
        expect(tile.tile).to eql([
          "..##.#..#.".reverse,
          "##..#.....".reverse,
          "#...##..#.".reverse,
          "####.#...#".reverse,
          "##.##.###.".reverse,
          "##...#.###".reverse,
          ".#.#.#..##".reverse,
          "..#....#..".reverse,
          "###...#.#.".reverse,
          "..###..###".reverse
        ])
      }
    end

    describe "rotate a tile" do
      it {
        tile = read_20(ONE_TILE)[2311]
        tile.rotate
        expect(tile.bords).to eql([".#..#####.", "..##.#..#.", "#..##.#...", "..###..###"])
        expect(tile.tile).to eql([
          ".#..#####.",
          ".#.####.#.",
          "###...#..#",
          "#..#.##..#",
          "#....#.##.",
          "...##.##.#",
          ".#...#....",
          "#.#.##....",
          "##.###.#.#",
          "#..##.#..."
        ])
      }
    end

    describe "look for corners" do
      it { expect(has_neighbor(1214, "..##.#..#.", read_20(ONE_TILE))).to be(2311) }
      it { expect(has_neighbor(1214, "..........", read_20(ONE_TILE))).to be(nil) }
      it { expect(has_neighbor(2311, "..##.#..#.", read_20(ONE_TILE))).to be(nil) }
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
..#.#....# ##.#.#.... ...##.....})
      end
      it do
        expect(assemble(read_20(INPUTS20), 3643)).to eql(PUZZLE20)
      end
    end
  end
end

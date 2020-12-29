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
  else
    tiles[id][:bords] = [bords[0].reverse, bords[3], bords[2].reverse, bords[1]]
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
    return true if tid != id && borders.include?(border)
  end
  return false
end

def find_corners(tiles)
  tiles_with_reverse = add_reverse(tiles)
  corner = []
  tiles.each do |id, tile|
    #p "NEW TILE #{id}"
    no_neighbour_border_count = 0
    for b in tile[:bords]
      has = has_neighbor(id, b, tiles_with_reverse)
      no_neighbour_border_count += 1 unless has
      if no_neighbour_border_count == 2
        corner << id
        break
      end
    end
  end
  corner
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
      it { expect(has_neighbor(1214, "..##.#..#.", { 1212 => ["..##.#..#.", "...#.##..#", "###..###..", ".#####..#."] })).to be(true) }
      it { expect(has_neighbor(1212, "..##.#..#.", { 1212 => ["..##.#..#.", "...#.##..#", "###..###..", ".#####..#."] })).to be(false) }
      it { expect(has_neighbor(1214, "..##.#....", { 1212 => ["..##.#..#.", "...#.##..#", "###..###..", ".#####..#."] })).to be(false) }
      it { expect(add_reverse(read_20(EXAMPLE_INPUT20))[1951]).to eql(["#.##...##.", ".#####..#.", "..#.##...#", "##.#..#..#",
                                                                       ".##...##.#", ".#..#####.", "#...##.#..", "#..#..#.##"]) }
      it { expect(find_corners(read_20(EXAMPLE_INPUT20))).to eql([1951, 1171, 2971, 3079]) }
      it { expect(find_corners(read_20(INPUTS20))).to eql([3643, 2647, 1987, 3089]) }
    end
  end
end

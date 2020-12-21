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
    tiles[rows[0][/\d+/].to_i] = [top, right, bottom, left]
  end
  tiles
end

def flip(tiles, id, axe)
  tile = tiles[id]
  if axe == :h
    tiles[id] = [tile[2], tile[1].reverse, tile[0], tile[3].reverse]
  else
    tiles[id] = [tile[0].reverse, tile[3], tile[2].reverse, tile[1]]
  end
end

def rotate(tiles, id)
  tile = tiles[id]
  tiles[id] = [tile[3], tile[0], tile[1], tile[2]]
end

def find_neighbor(of_borders, tiles, direction)
  tiles.clone.select do |id, borders|
    tile_direction = (direction+2)%4
    found = false
    4.times do
      tile = rotate(tiles, id)
      if tile[tile_direction] == of_borders[direction]
        found = true
        break
      end
      [:v, :h, :v, :h].each do |d|
        tile = flip(tiles, id, d)
        if tile[tile_direction] == of_borders[direction]
          found = true
          break
        end
      end
    end
    found
  end.keys[0]
end

def rearranging(tiles)
  first_tile_id = tiles.keys[0]
  board = { first_tile_id =>  [0,0] }
  placed = { first_tile_id => tiles[first_tile_id]}
  tiles.delete(first_tile_id)
  last_count = 0
  while !tiles.empty? && last_count != tiles.size do
    last_count = tiles.size
    placed.clone.each do |id, borders|
      [-1,1].each do |direction|
        found = find_neighbor(borders, tiles, direction)
        if found
          placed[found] = tiles[found]
          tiles.delete(found)
          board[found] = [board[id][0], board[id][1] + direction]
        end
      end
      [-1,1].each do |direction|
        found = find_neighbor(borders, tiles, direction + 1)
        if found
          placed[found] = tiles[found]
          tiles.delete(found)
          board[found] = [board[id][0] + direction, board[id][1]]
        end
      end
    end
  end
  board
end

def add_reverse(tiles)
  tiles_with_reverse = {}
  tiles.each do |id, borders|
    tiles_with_reverse[id] = borders + borders.map { |b| b.reverse }
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
  tiles.each do |id, borders|
    #p "NEW TILE #{id}"
    no_neighbour_border_count = 0
    for b in borders
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

RSpec.describe "Jurassic Jigsaw" do
  describe "Part 1 : reassembled back into a single image" do
    describe "read the input" do
      it { expect(read_20(ONE_TILE)).to eql({2311 => ["..##.#..#.", "...#.##..#", "###..###..", ".#####..#."]}) }
      it { expect(read_20(TWO_TILES)).to eql( {
        2311 => ["..##.#..#.", "...#.##..#", "###..###..", ".#####..#."],
        1951 => ["#.##...##.", ".#####..#.", "..#.##...#", "##.#..#..#"]
      }) }
      it { expect(read_20(INPUTS20).count).to eql(144) }
    end

    describe "flip a tile" do
      it { expect(flip({2311 => ["..##.#..#.", "...#.##..#", "###..###..", ".#####..#."]}, 2311, :h))
        .to eql(["###..###..", "...#.##..#".reverse, "..##.#..#.", ".#####..#.".reverse]) }
      it { expect(flip({2311 => ["..##.#..#.", "...#.##..#", "###..###..", ".#####..#."]}, 2311, :v))
        .to eql(["..##.#..#.".reverse, ".#####..#.", "###..###..".reverse, "...#.##..#"]) }
    end

    describe "rotate a tile" do
      it { expect(rotate({2311 => ["..##.#..#.", "...#.##..#", "###..###..", ".#####..#."]}, 2311))
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

    describe "rearranging tiles" do
      it { expect(rearranging(read_20(TWO_TILES))).to eql({ 2311 => [0,0],  1951 => [0,-1] }) }
      it { expect(rearranging(read_20(EXAMPLE_INPUT20))).to eql({
        1951 => [0,-1], 2311 => [0,0], 3079 => [0,1],
        2729 => [-1, -1], 1427 => [-1,0], 2473 => [-1,1],
        2971 => [-2, -1], 1489 => [-2,0], 1171 => [-2,1]
      }) }
      xit do
        board = rearranging(read_20(INPUTS20))
        expect(board.count).to eql(144)
        xs = board.values.map {|t| t[0]}
        ys = board.values.map {|t| t[1]}
        expect([xs.min, xs.max, ys.min, ys.max]).to eql([-8, 7, -2, 16])
        expect(board).to eql({})
      end
    end
  end
end

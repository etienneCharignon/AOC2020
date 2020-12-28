require 'data_day24'

EXAMPLE24 = %{sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew}

def flip_tile(path)
  x = 0
  y = 0
  directions = path.split(/(e|se|ne|nw|w|sw)/).delete_if { |d| d == '' }
  directions.each do |direction|
    case direction
    when 'e'
      x -= 1
    when 'se'
      y += 1
    when 'sw'
      x += 1
      y += 1
    when 'w'
      x += 1
    when 'nw'
      y -= 1
    when 'ne'
      x -= 1
      y -= 1
    end
  end
  [x, y]
end

def layout(paths)
  layout = []
  paths.split("\n").each do |path|
    tile = flip_tile(path)
    if layout.include? tile
      layout.delete(tile)
    else
      layout << tile
    end
  end
  layout
end

RSpec.describe "Lobby Layout", focus: true do
  describe "Part 1" do
    describe "flip" do
      it { expect(flip_tile("e")).to eql([-1, 0]) }
      it { expect(flip_tile("esw")).to eql([0, 1]) }
      it { expect(flip_tile("esew")).to eql([0, 1]) }
      it { expect(flip_tile("esenee")).to eql([-3, 0]) }
      it { expect(flip_tile("nwwswee")).to eql([0, 0]) }
    end

    describe "flip multiple tiles" do
      it { expect(layout("e\nw")).to eql([[-1, 0],[1,0]]) }
      it { expect(layout("e\ne")).to eql([]) }
      it { expect(layout(EXAMPLE24).count).to eql(10) }
      it { expect(layout(INPUT24).count).to eql(332) }
    end
  end
end

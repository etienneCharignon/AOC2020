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

def count_neighbours24(cell, world)
  neighbours = [
    [cell[0] - 1, cell[1] - 1],
    [cell[0] - 1, cell[1]],
    [cell[0], cell[1] + 1],
    [cell[0] + 1, cell[1] + 1],
    [cell[0] + 1, cell[1]],
    [cell[0], cell[1] - 1]
  ]

  (neighbours & world).count
end

def inactives_cells24(world)
  inactives_cells = []
  xs = world.map { |cell| cell[0] }
  ys = world.map { |cell| cell[1] }
  (xs.min-1..xs.max+1).each do |x|
    (ys.min-1..ys.max+1).each do |y|
          inactives_cells << [x, y]
    end
  end
  inactives_cells -= world
  inactives_cells
end

def new_black(world)
  new_born = []
  inactives_cells24(world).each do |cell|
    new_born << cell if count_neighbours24(cell, world) == 2
  end
  new_born
end

def nextGen(world)
  next_generation = []
  world.each do |cell|
    next_generation << cell if (1..2).include?(count_neighbours24(cell, world))
  end
  next_generation | new_black(world)
end

def run24(world, n)
  n.times do |g|
    p g
    world = nextGen(world)
  end
  world
end

RSpec.describe "Lobby Layout" do
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

  describe "part 2 : jeu de la vie !" do
    describe "#count_neighbours24" do
      it { expect(count_neighbours24([0,0], [[-1, -1], [-1,0], [0,1], [1,1], [1,0], [0,-1]])).to eql(6) }
      it { expect(count_neighbours24([4,3], [[3, 2], [3,3]])).to eql(2) }
    end

    describe "#new_black" do
      it { expect(new_black([[3, 2], [3,3]])).to eql([[2,2], [4,3]]) }
    end

    describe "run" do
      it { expect(nextGen(layout(EXAMPLE24)).count).to eql(15) }
      xit { expect(run24(layout(EXAMPLE24), 100).count).to eql(2208) }
      xit { expect(run24(layout(INPUT24), 100).count).to eql(2208) }
    end
  end
end

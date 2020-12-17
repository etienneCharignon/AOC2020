EXAMPLE_START=%{.#.
..#
###}

WORLD_17 = %{...#.#.#
..#..#..
#.#.##.#
###.##..
#####.##
#.......
#..#..##
...##.##}

def read(world_string)
  world = []
  world_string.split("\n").each_with_index do |row, r|
    row.split('').each_with_index { |col, c| world << [r, c, 0] if col == '#' }
  end
  world
end

def count_neighbours(cell, world)
  neighbours = []
  (-1..1).each do |x|
    (-1..1).each do |y|
      (-1..1).each do |z|
        neighbours << [cell[0] + x, cell[1] + y, cell[2] +  z] unless (x == 0 && y == 0 && z == 0)
      end
    end
  end

  (neighbours & world).count
end

def inactives_cells(world)
  inactives_cells = []
  xs = world.map { |cell| cell[0] }
  ys = world.map { |cell| cell[1] }
  zs = world.map { |cell| cell[2] }
  (xs.min-1..xs.max+1).each do |x|
    (ys.min-1..ys.max+1).each do |y|
      (zs.min-1..zs.max+1).each do |z|
        inactives_cells << [x, y, z]
      end
    end
  end
  inactives_cells -= world
  inactives_cells
end

def new_born(world)
  new_born = []
  inactives_cells(world).each do |cell|
    new_born << cell if count_neighbours(cell, world) == 3
  end
  new_born
end

def generation(world)
  next_generation = []
  world.each do |cell|
    next_generation << cell if (2..3).include?(count_neighbours(cell, world))
  end
  next_generation | new_born(world)
end

def run(world, n)
  n.times do
    world = generation(world)
  end
  world
end

RSpec.describe "Conway Cubes" do
  describe "part 1" do
    it { expect(read(EXAMPLE_START)).to eql([[0, 1, 0], [1, 2, 0], [2,0,0], [2,1,0], [2,2,0]]) }
    it { expect(generation(read(EXAMPLE_START)).count).to eql(11) }
    it { expect(run(read(EXAMPLE_START), 6).count).to eql(112) }
    it { expect(run(read(WORLD_17), 6).count).to eql(346) }

    describe "count neighbours" do
      it { expect(count_neighbours([0,1,0], [[1,1,0]])).to eql(1) }
    end

    describe "inactives_cells" do
      it { expect(inactives_cells(read(EXAMPLE_START))).to eql([
        [-1, -1, -1], [-1, -1, 0], [-1, -1, 1], [-1, 0, -1], [-1, 0, 0], [-1, 0, 1], [-1, 1, -1], [-1, 1, 0], [-1, 1, 1], [-1, 2, -1], [-1, 2, 0], [-1, 2, 1], [-1, 3, -1], [-1, 3, 0], [-1, 3, 1],
        [0, -1, -1],  [0, -1, 0],  [0, -1, 1],  [0, 0, -1],  [0, 0, 0],  [0, 0, 1],  [0, 1, -1],  [0, 1, 1],  [0, 2, -1], [0, 2, 0],   [0, 2, 1],  [0, 3, -1], [0, 3, 0],   [0, 3, 1],
        [1, -1, -1],  [1, -1, 0],  [1, -1, 1],  [1, 0, -1],  [1, 0, 0],  [1, 0, 1],  [1, 1, -1],  [1, 1, 0],  [1, 1, 1],  [1, 2, -1],  [1, 2, 1],  [1, 3, -1], [1, 3, 0],   [1, 3, 1],
        [2, -1, -1],  [2, -1, 0],  [2, -1, 1],  [2, 0, -1],  [2, 0, 1],  [2, 1, -1], [2, 1, 1],   [2, 2, -1], [2, 2, 1],  [2, 3, -1],  [2, 3, 0],  [2, 3, 1],
        [3, -1, -1],  [3, -1, 0],  [3, -1, 1],  [3, 0, -1],  [3, 0, 0],  [3, 0, 1],  [3, 1, -1],  [3, 1, 0],  [3, 1, 1],  [3, 2, -1],  [3, 2, 0],  [3, 2, 1],  [3, 3, -1],  [3, 3, 0],  [3, 3, 1]
      ]) }
    end
  end
end

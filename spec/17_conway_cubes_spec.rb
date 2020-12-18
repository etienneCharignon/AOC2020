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
    row.split('').each_with_index { |col, c| world << [r, c, 0, 0] if col == '#' }
  end
  world
end

def count_neighbours(cell, world)
  neighbours = []
  (-1..1).each do |x|
    (-1..1).each do |y|
      (-1..1).each do |z|
        (-1..1).each do |w|
          neighbours << [cell[0] + x, cell[1] + y, cell[2] +  z, cell[3] + w] unless (x == 0 && y == 0 && z == 0 && w == 0)
        end
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
  ws = world.map { |cell| cell[3] }
  (xs.min-1..xs.max+1).each do |x|
    (ys.min-1..ys.max+1).each do |y|
      (zs.min-1..zs.max+1).each do |z|
        (ws.min-1..ws.max+1).each do |w|
          inactives_cells << [x, y, z, w]
        end
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
  n.times do |g|
    p g
    world = generation(world)
  end
  world
end

RSpec.describe "Conway Cubes" do
  describe "part 2" do
    it { expect(read(EXAMPLE_START)).to eql([[0, 1, 0, 0], [1, 2, 0, 0], [2,0,0, 0], [2,1,0, 0], [2,2,0, 0]]) }
    it { expect(generation(read(EXAMPLE_START)).count).to eql(29) }
    xit { expect(run(read(EXAMPLE_START), 6).count).to eql(848) }
    xit { expect(run(read(WORLD_17), 6).count).to eql(346) }

    describe "count neighbours" do
      it { expect(count_neighbours([0,1,0,0], [[1,1,0,0]])).to eql(1) }
    end

    describe "inactives_cells" do
      it { expect(inactives_cells(read(EXAMPLE_START)).count).to eql(220) }
    end
  end
end

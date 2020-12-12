class RainRisk

  attr_reader :moves, :waypoint

  def initialize
    @direction = 'E'
    @moves = {
      'E' => 0,
      'S' => 0,
      'W' => 0,
      'N' => 0,
    }
    @waypoint = {
      'E' => 10,
      'S' => 0,
      'W' => 0,
      'N' => 1,
    }
  end

  def new_direction(direction, rotation)
    @moves.keys[(@moves.keys.index(direction) + rotation)%4]
  end

  def rotate(position, rotation)
    position.each_with_object({}) do |(direction, valeur), new_position|
      new_position[new_direction(direction, rotation)] = valeur
    end
  end

  def process_from(instruction)
    steps = instruction[1..-1].to_i
    @moves.each_key do |direction|
      @moves[direction] += steps if instruction.start_with?(direction)
    end
    if instruction.start_with?('L')
      @direction = new_direction(@direction, -steps/90)
    end
    if instruction.start_with?('R')
      @direction = new_direction(@direction, steps/90)
    end
    @moves[@direction] += steps if instruction.start_with?('F')
  end

  def process2_from(instruction)
    steps = instruction[1..-1].to_i
    @waypoint.each_key do |direction|
      @waypoint[direction] += steps if instruction.start_with?(direction)
    end
    if instruction.start_with?('R')
      @waypoint = rotate(@waypoint, steps/90)
    end
    if instruction.start_with?('L')
      @waypoint = rotate(@waypoint, -steps/90)
    end
    if instruction.start_with?('F')
      @waypoint.each_key do |direction|
        @moves[direction] += steps * @waypoint[direction]
      end
    end
    self
  end

  def self.process(instructions, part2 = false)
    boat = RainRisk.new
    instructions.split("\n").each do |instruction|
      if part2
        boat.process2_from(instruction)
      else
        boat.process_from(instruction)
      end
    end
    boat.moves
  end
end

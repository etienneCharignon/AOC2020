class RainRisk

  def initialize(direction)
    @direction = direction
  end

  def process_from(position, instruction)
    steps = instruction[1..-1].to_i
    position.each_key do |direction|
      position[direction] += steps if instruction.start_with?(direction)
    end
    if instruction.start_with?('L')
      rotation = steps/90
      @direction = position.keys[position.keys.index(@direction) - rotation]
    end
    if instruction.start_with?('R')
      rotation = steps/90
      @direction = position.keys[(position.keys.index(@direction) + rotation)%4]
    end
    position[@direction] += steps if instruction.start_with?('F')
    position
  end

  def self.process(instructions)
    waypoint = {
      'E' => 10,
      'S' => 0,
      'W' => 0,
      'N' => 1,
    }
    moves = {
      'E' => 0,
      'S' => 0,
      'W' => 0,
      'N' => 0,
    }
    boat = RainRisk.new('E')
    instructions.split("\n").each do |instruction|
      moves = boat.process_from(moves, instruction)
    end
    moves
  end
end

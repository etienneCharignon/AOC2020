class RainRisk

  attr_reader :moves

  def initialize(direction)
    @direction = direction
    @moves = {
      'E' => 0,
      'S' => 0,
      'W' => 0,
      'N' => 0,
    }
  end

  def process_from(instruction)
    steps = instruction[1..-1].to_i
    @moves.each_key do |direction|
      @moves[direction] += steps if instruction.start_with?(direction)
    end
    if instruction.start_with?('L')
      rotation = steps/90
      @direction = @moves.keys[@moves.keys.index(@direction) - rotation]
    end
    if instruction.start_with?('R')
      rotation = steps/90
      @direction = @moves.keys[(@moves.keys.index(@direction) + rotation)%4]
    end
    @moves[@direction] += steps if instruction.start_with?('F')
  end

  def self.process(instructions)
    waypoint = {
      'E' => 10,
      'S' => 0,
      'W' => 0,
      'N' => 1,
    }
    boat = RainRisk.new('E')
    instructions.split("\n").each do |instruction|
      boat.process_from(instruction)
    end
    boat.moves
  end
end

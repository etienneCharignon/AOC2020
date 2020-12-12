class RainRisk
  def self.process(instructions)
    moves = {
      'E' => 0,
      'S' => 0,
      'W' => 0,
      'N' => 0,
    }
    direction = 'E'
    instructions.split("\n").each do |instruction|
      steps = instruction[1..-1].to_i
      moves.each_key do |direction|
        moves[direction] += steps if instruction.start_with?(direction)
      end
      if instruction.start_with?('L')
        rotation = steps/90
        direction = moves.keys[moves.keys.index(direction) - rotation]
      end
      if instruction.start_with?('R')
        rotation = steps/90
        direction = moves.keys[(moves.keys.index(direction) + rotation)%4]
        p direction
      end
      moves[direction] += steps if instruction.start_with?('F')
    end
    moves
  end
end

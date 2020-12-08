class HandheldHalting
  def self.run(program)
    code = program.split("\n")
    acc = 0
    index = 0
    visited_index = []
    while (index < code.length && ! visited_index.include?(index)) do
      instruction = code[index].split(' ')
      visited_index << index
      case instruction[0]
      when "acc"
        acc += instruction[1].to_i
      when "jmp"
        index += instruction[1].to_i - 1
      end
      index += 1
    end
    acc
  end
end

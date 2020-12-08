class HandheldHalting
  attr_reader :infinit_loop, :visited_index

  def self.mute(program, index)
    code = program.split("\n")
    if code[index].start_with?('nop')
      code[index].gsub!('nop', 'jmp')
    else
      code[index].gsub!('jmp', 'nop')
    end
    code.join("\n")
  end

  def self.answer_when_fixed(program_initial)
      handheld = HandheldHalting.new
      handheld.run(program_initial)

      handheld.visited_index.reverse.each do |index|
        code = mute(program_initial, index)
        acc = handheld.run(code)
        if !handheld.infinit_loop
          return acc
        end
      end
  end

  def run(program)
    code = program.split("\n")
    acc = 0
    index = 0
    @infinit_loop = false
    @visited_index = []
    while index < code.length do
      if visited_index.include?(index)
          @infinit_loop = true
          break
      end
      instruction = code[index].split(' ')
      @visited_index << index
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

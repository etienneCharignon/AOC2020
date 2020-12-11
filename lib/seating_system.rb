class SeatingSystem
  def self.countNeighbour(cell, i, room)
    row_size = room.index("\n") + 1
    [
      i > 0 && room[i - 1] == cell,
      room[i + 1] == cell,
      room[i + row_size - 1] == cell,
      room[i + row_size] == cell,
      room [i + row_size + 1] == cell,
      i >= row_size + 1 && room[i - row_size - 1] == cell,
      i >= row_size && room[i - row_size] == cell,
      i >= row_size && room [i - row_size + 1] == cell
    ].count(true)
  end

  def self.next(room)
    nouvelle_generation = ""
    room.each_char.with_index(0) do |cell, i|
      if cell == '#' && countNeighbour(cell, i, room) >= 4
        nouvelle_generation += 'L'
      elsif cell == 'L' && countNeighbour('#', i, room) == 0
        nouvelle_generation += '#'
      else
        nouvelle_generation += cell
      end
    end
    nouvelle_generation
  end

  def self.run_to_the_end(room)
    next_room = self.next(room)
    while next_room != room do
      room = next_room
      next_room = self.next(room)
    end
    next_room
  end

  def self.number_of_seats_occupied_at_the_end(room)
    run_to_the_end(room).count('#')
  end
end

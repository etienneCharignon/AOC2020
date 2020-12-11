class SeatingSystem
  def self.look_for_one_direction(x, y, i, room)
    i_x_y = i + x + y
    while true
      return false if i_x_y < 0 || room[i_x_y] == "\n" || i_x_y > room.size
      return true if room[i_x_y] == '#'
      return false if room[i_x_y] == 'L'
      i_x_y += x + y
    end
  end
      #i >= row_size && room[i - row_size] == cell,

  def self.countNeighbour(i, room)
    row_size = room.index("\n") + 1
    [
      look_for_one_direction(-1, 0, i, room),
      look_for_one_direction(1, 0, i, room),
      look_for_one_direction(-1, row_size, i, room),
      look_for_one_direction(0, row_size, i, room),
      look_for_one_direction(1, row_size, i, room),
      look_for_one_direction(-1, -row_size, i, room),
      look_for_one_direction(0, -row_size, i, room),
      look_for_one_direction(1, -row_size, i, room),
    ].count(true)
  end

  def self.next(room)
    nouvelle_generation = ""
    room.each_char.with_index(0) do |cell, i|
      if cell == '#' && countNeighbour(i, room) >= 5
        nouvelle_generation += 'L'
      elsif cell == 'L' && countNeighbour(i, room) == 0
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

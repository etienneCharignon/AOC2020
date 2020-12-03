class Slope

  def self.count_trees(montain, x_shift, y_shift)
    count = 0
    col = 0
    (x_shift..montain.length-1).step(x_shift) do |row|
      col += y_shift
      col = col % montain[0].length
      count += 1 if montain[row][col] == '#'
    end
    count
  end
end

class BordingPassCalculator

  def self.seat(pass)
    find(pass[0..6], 0, 127).to_i * 8 + find(pass[7..-1], 0, 7).to_i
  end

  def self.find(letters, low, high)
    return low if letters.empty?
    middle = (high - low)/2
    if letters[0] == "F" || letters[0] == "L"
      find(letters[1..-1], low, low + middle)
    else
      find(letters[1..-1], high - middle, high)
    end
  end
end

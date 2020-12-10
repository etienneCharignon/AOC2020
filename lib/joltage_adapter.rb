class JoltageAdapter
  def self.find(adapters)
    sorted = adapters.sort
    sorted << sorted.max + 3
    sorted.unshift(0)
    (0..sorted.length-1).each_with_object({:one => 0, :three => 0}) do |index, counters|
      difference = sorted[index] - sorted[index-1]
      p difference
      counters[:one] += 1 if difference == 1
      counters[:three] += 1 if difference == 3
    end.values.inject(:*)
  end
end

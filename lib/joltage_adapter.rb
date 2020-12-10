class JoltageAdapter
  def self.find(adapters)
    sorted = adapters.sort
    sorted << sorted.max + 3
    sorted.unshift(0)
    (1..sorted.length-1).each_with_object({:one => 0, :three => 0}) do |index, counters|
      difference = sorted[index] - sorted[index-1]
      counters[:one] += 1 if difference == 1
      counters[:three] += 1 if difference == 3
    end.values.inject(:*)
  end

  def self.count1(adapter, arcs)
    return 1 if adapter == 0
    arcs[adapter].map { |connected| count(connected, arcs) }.inject(:+)
  end

  def self.count2(adapter, arcs)
    return 1 if adapter == 0
    return arcs[adapter] unless arcs[adapter].kind_of?(Array)
    arcs[adapter].map { |connected| count2(connected, arcs) }.inject(:+)
  end

  def self.find_arrangements(adapters)
    sorted = adapters.sort.unshift(0)
    sorted << sorted.max + 3
    arcs = (0..sorted.length-1).each_with_object({}) do |index, arcs|
      arcs[sorted[index]] = [sorted[index-1]]
      arcs[sorted[index]] << sorted[index-2] if index > 1 && sorted[index] - sorted[index-2] < 4
      arcs[sorted[index]] << sorted[index-3] if index > 2 && sorted[index] - sorted[index-3] < 4
    end
    arcs.keys.sort.each do |adapter|
      arcs[adapter] = count2(adapter, arcs)
    end
    arcs[sorted[-1]]
  end
end

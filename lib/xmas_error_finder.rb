class XMasErrorFinder
  def self.combinations(entries)
    combinations = []
    entries.each do |entrie|
      entries.each do |other_entrie|
        combinations << entrie + other_entrie unless entrie == other_entrie
      end
    end
    combinations.uniq
  end

  def self.findWeakness(entries, preamble)
    (preamble..entries.size).each do |i|
      from = i-preamble
      to = i-1
      combinations = combinations(entries[from..to])
      return entries[i] unless combinations.include?(entries[i])
    end
  end

  def self.findMoreAboutWeakness(entries, weakness)
    max = entries.index(weakness) - 1
    (0..max).each do |i|
      from = i + 1
      (from..max).each do |j|
        slice = entries[i..j]
        return slice.min + slice.max if slice.inject(:+) == weakness
      end
    end
    return nil
  end
end

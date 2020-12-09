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
end


def mix1(cups, move)
  dic = {}
  cups.split('').each_with_index do |c, i|
    if cups[i+1].nil?
      dic[c.to_i] = cups[0].to_i
    else
      dic[c.to_i] = cups[i+1].to_i
    end
  end

  start = cups[0].to_i

  move.times do
    slice = dic[start]
    dic[start] = dic[dic[dic[dic[start]]]]
    destination = trouve_destination(slice, start, dic, 9)
    dic[dic[dic[slice]]] = dic[destination]
    dic[destination] = slice
    start = dic[start]
  end
  return print(dic, 1)
end

def print(dic, from)
  result = []
  c = from
  9.times do
    result << c
    c = dic[c]
  end
  result.join(',')
end

def score(dic, from)
  dic[from] * dic[dic[from]]
end

def trouve_destination(slice, start, dic, max)
  destination = start - 1
  destination = max if destination == 0
  slices = [slice, dic[slice], dic[dic[slice]]]
  while slices.include?(destination)
    destination -= 1
    destination = max if destination == 0
  end
  destination
end

def mix(cups, move)
  dic = {}
  (10..1000000).each { |n| dic[n] = n + 1 }
  dic[1000000] = cups[0].to_i
  cups.split('').each_with_index do |c, i|
    if cups[i+1].nil?
      dic[c.to_i] = 10
    else
      dic[c.to_i] = cups[i+1].to_i
    end
  end

  start = cups[0].to_i

  move.times do
    slice = dic[start]
    dic[start] = dic[dic[dic[dic[start]]]]
    destination = trouve_destination(slice, start, dic, 1000000)
    dic[dic[dic[slice]]] = dic[destination]
    dic[destination] = slice
    start = dic[start]
  end
  return score(dic, 1)
end

RSpec.describe "Crab cups" do
  describe "Part 1" do
    it { expect(mix1("389125467", 1)).to eql("1,5,4,6,7,3,2,8,9") }
    it { expect(mix1("389125467", 2)).to eql("1,3,2,5,4,6,7,8,9") }
    it { expect(mix1("389125467", 3)).to eql("1,3,4,6,7,2,5,8,9") }
    it { expect(mix1("389125467", 10)).to eql("1,9,2,6,5,8,3,7,4") }
    it { expect(mix1("974618352", 100)).to eql("1,7,5,8,9,3,2,6,4") }
  end

  describe "Part 2" do
    it { expect(mix("389125467", 2)).to eql(6) }
    xit { expect(mix("389125467", 10000000)).to eql(149245887792) }
    xit { expect(mix("974618352", 10000000 - 1)).to eql(38162588308) }
  end
end

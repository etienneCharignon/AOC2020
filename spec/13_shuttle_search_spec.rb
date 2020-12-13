require 'data_day13'

def compute_one(ts, buses)
  i = 0
  for bus in buses
    return false if bus && (ts + i) % bus != 0
    i += 1
  end
  return true
end

def find_ts(buses, start_at)
  found = false
  highest_bus_id = buses.compact.max
  highest_bus_index = buses.index(highest_bus_id)
  ts = start_at / highest_bus_id * highest_bus_id
  while !found do
    ts += highest_bus_id
    found = compute_one(ts - highest_bus_index, buses)
  end
  ts - highest_bus_index
end

RSpec.describe "X13: Shuttle Search part 2" do

  describe "find from the example" do
    it { expect(EXAMPLE_BUS.index(59)).to eql(4) }
    it { expect(compute_one(1068781, EXAMPLE_BUS)).to eql(true) }
    it { expect(find_ts(EXAMPLE_BUS, 0)).to eql(1068781) }
    it { expect(find_ts([1789,37,47,1889], 0)).to eql(1202161486) }
    it { expect(find_ts([17,nil,13,19], 3000)).to eql(3417) }
    xit { expect(find_ts(INPUT13_BUS, 100000000000000)).to eql(1068781) }
  end
end

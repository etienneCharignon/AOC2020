require 'data_day13'

def gcd(a, b)
  if (b == 0)
    return { x: 1, y: 0, gcd: a }
  end

  gcd = gcd(b, a % b);
  return {
    x: gcd[:y],
    y: gcd[:x] - gcd[:y] * (a / b),
    gcd: gcd[:gcd]
  }
end

def find_any_solution(a, b, c)
  g = gcd(a.abs, b.abs);
  if c % g[:gcd] > 0
    return nil;
  end

  g[:x] *= c / g[:gcd];
  g[:y] *= c / g[:gcd];
  g[:x] = -g[:x] if a < 0
  g[:y] = -g[:y] if b < 0
  return {
    x0:g[:x],
    y0:g[:y],
    g:g[:gcd]
  }
end

def fusion_buses(bus1, bus2)
  d0 = bus1[1]
  d1 = bus2[1]
  i0 = bus1[0]
  i1 = bus2[0]
  sol = gcd(i0, i1)
  t0 = i0 * sol[:x] * (d0 - d1) - d0
  p t0
  p i1 * sol[:y] * (d1-d0) -d1
  periode = i0 * i1
  while t0 < 0 do
    t0 += periode
  end
  [periode, -t0]
end

def find_with_euclide(buses)
  first_bus = buses[0]
  final_bus = buses[1..-1].each_with_object(first_bus) do |bus, fold|
    fusion = fusion_buses(fold, bus)
    fold[0] = fusion[0]
    fold[1] = fusion[1]
  end
  p final_bus
  return -final_bus[1]
end

def collect_buses(buses)
  buses.map.with_index(0) do |bus, i|
    [bus, i] if bus
  end.compact
end

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

  describe "Linear Diophantine Equation" do
    it { expect(gcd(12, 4)[:gcd]).to eql(4) }
    it { expect(gcd(12, 2)[:gcd]).to eql(2) }
    it { expect(gcd(7, 13)).to eql({:gcd=>1, :x=>2, :y=>-1}) }
    it { expect(find_any_solution(7, 13, -2)).to eql({:g=>1, :x0=>-4, :y0=>2}) }
  end

  describe "find from the example" do
    it { expect(EXAMPLE_BUS.index(59)).to eql(4) }
    it { expect(compute_one(1068781, EXAMPLE_BUS)).to eql(true) }
    it { expect(find_ts(EXAMPLE_BUS, 0)).to eql(1068781) }
    it { expect(find_ts([1789,37,47,1889], 0)).to eql(1202161486) }
    it { expect(find_ts([17,nil,13,19], 3000)).to eql(3417) }
    xit { expect(find_ts(INPUT13_BUS, 100000000000000)).to eql(1068781) }
  end

  describe "find with euclide" do
    it { expect(collect_buses(EXAMPLE_BUS)).to eql([[7,0],[13,1],[59,4],[31,6],[19,7]]) }
    it { expect(find_with_euclide(collect_buses([7,13]))).to eql(77) }
    it { expect(find_with_euclide([[7,0],[13, 1]])).to eql(77) }
    it { expect(find_with_euclide(collect_buses([17,nil,13,19]))).to eql(3417) }
    it { expect(find_with_euclide(collect_buses(EXAMPLE_BUS))).to eql(1068781) }
  end
end

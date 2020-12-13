require './data_day13'

def compute(ts, buses)
  departures = buses.map do |bus|
    ts / bus * bus + bus
  end
  p buses
  p departures

  departure = departures.min
  bus_to_take = buses[departures.index(departure)]
  minutes_to_wait =  departure - ts

  p departure
  p bus_to_take
  p minutes_to_wait
  p bus_to_take * (departure - ts)
end

compute(INPUT13_TS, INPUT13_BUS.compact)
puts
compute(EXAMPLE_TS, EXAMPLE_BUS.compact)

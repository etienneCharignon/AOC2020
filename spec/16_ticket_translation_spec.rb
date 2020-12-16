require 'data_day16'

EXAMPLE_TICKETS = %{7,3,47
40,4,50
55,2,20
38,6,12}

EXAMPLE_RULLS = %{class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50}

def read_rulls(rulls)
  rulls.split("\n").each_with_object([]) do |rull, rangs|
    r = /(\d+)-(\d+) or (\d+)-(\d+)/.match(rull)
    rangs << (r[1].to_i..r[2].to_i)
    rangs << (r[3].to_i..r[4].to_i)
  end
end

def find_errors(tickets, rulls)
  errors = []
  tickets.split("\n").each do |ticket|
    ticket.split(',').map {|f| f.to_i}.each do |field_value|
      errors << field_value unless rulls.map { |rull| rull.include?(field_value) }.any?
    end
  end
  errors
end

RSpec.describe "ticket translation" do
  describe "Part 1" do
    describe "read rulls" do
      it { expect(read_rulls("departure location: 32-209 or 234-963")).to eql([(32..209), (234..963)]) }
      it { expect(read_rulls(%{departure location: 32-209 or 234-963
departure station: 47-64 or 83-967})).to eql([(32..209), (234..963), (47..64), (83..967)]) }
    end

    describe "find ticket scanning error rate" do
      it { expect(find_errors(EXAMPLE_TICKETS, read_rulls(EXAMPLE_RULLS)).inject(:+)).to eql(71) }
      it { expect(find_errors(TICKETS, read_rulls(RULLS_16)).inject(:+)).to eql(19060) }
    end
  end
end

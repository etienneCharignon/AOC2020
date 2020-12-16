require 'data_day16'

EXAMPLE_TICKETS = %{7,3,47
40,4,50
55,2,20
38,6,12}

def read_rulls(rulls)
  rulls.split("\n").each_with_object([]) do |rull, rangs|
    r = /(\d+)-(\d+) or (\d+)-(\d+)/.match(rull)
    rangs << (r[1].to_i..r[2].to_i)
    rangs << (r[3].to_i..r[4].to_i)
  end
end

EXAMPLE_RULLS = read_rulls(%{class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50})

EXAMPLE_RULLS2 = read_rulls(%{class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19})

EXAMPLE_TICKETS2 = %{3,9,18
15,1,5
5,14,9}

def find_errors(tickets, rulls)
  errors = []
  tickets.split("\n").each do |ticket|
    ticket.split(',').map {|f| f.to_i}.each do |field_value|
      errors << field_value unless rulls.map { |rull| rull.include?(field_value) }.any?
    end
  end
  errors
end

def filter(tickets, rulls)
  valids_tickets = []
  tickets.split("\n").each do |ticket_string|
    ticket = ticket_string.split(',').map {|f| f.to_i}
    valids_tickets << ticket if ticket.map { |field_value| rulls.map { |rull| rull.include?(field_value) }.any? }.all?
  end
  valids_tickets
end

def find_column_candidate(col, tickets, rulls)
  rulls.each_slice(2).map.with_index(0) do |(range1, range2), i|
    i if tickets.map do |ticket|
      range1.include?(ticket[col]) || range2.include?(ticket[col])
    end.all?
  end.compact
end

def find_all_columns_candidate(tickets, rulls)
  tickets[0].map.with_index(0) do |t, c|
    {
      column: c,
      candidates: find_column_candidate(c, tickets, rulls)
    }
  end.sort_by { |col| col[:candidates].size }
end

RSpec.describe "ticket translation" do
  describe "Part 1" do
    describe "read rulls" do
      it { expect(read_rulls("departure location: 32-209 or 234-963")).to eql([(32..209), (234..963)]) }
      it { expect(read_rulls(%{departure location: 32-209 or 234-963
departure station: 47-64 or 83-967})).to eql([(32..209), (234..963), (47..64), (83..967)]) }
    end

    describe "find ticket scanning error rate" do
      it { expect(find_errors(EXAMPLE_TICKETS, EXAMPLE_RULLS).inject(:+)).to eql(71) }
      it { expect(find_errors(TICKETS, read_rulls(RULLS_16)).inject(:+)).to eql(19060) }
    end
  end

  describe "part 2" do
    describe "filter tickets" do
      it { expect(filter(EXAMPLE_TICKETS, EXAMPLE_RULLS)).to eql([[7, 3, 47]]) }
    end

    describe "find_column_candidate" do
      let(:examples) { filter(EXAMPLE_TICKETS2, EXAMPLE_RULLS2) }

      it { expect(find_column_candidate(0, examples, EXAMPLE_RULLS2)).to eql([1]) }
      it { expect(find_column_candidate(1, examples, EXAMPLE_RULLS2)).to eql([0, 1]) }
      it { expect(find_column_candidate(2, examples, EXAMPLE_RULLS2)).to eql([0, 1, 2]) }
      it do
        #rulls = read_rulls(RULLS_16)
        #input = filter(TICKETS, rulls)
        #p find_all_columns_candidate(input, rulls).each { |col| p col }
        my_ticket = MY_TICKET.split(",").map { |f| f.to_i }
        expect([my_ticket[5], my_ticket[11], my_ticket[17], my_ticket[19], my_ticket[14], my_ticket[13]].inject(:*)).to eql(953713095011)
        #expect(find_all_columns_candidate(input, rulls)).to eql(20)
        # expect(find_column_candidate(0, input, rulls)).to eql([2])
      end

    end
  end
end

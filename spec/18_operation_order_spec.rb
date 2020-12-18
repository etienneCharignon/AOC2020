require 'data_day18'

def count(expression)
  return expression.to_i if /^(\d*)$/.match(expression)

  group = /(.*)\(([^)]*)\)(.*)/.match(expression)
  return count("#{group[1]}#{count(group[2])}#{group[3]}") if group

  r = /(.*) ([+|*]) (\d*)$/.match(expression)
  if r[2] == '+'
    count(r[1]) + count(r[3])
  else
    count(r[1]) * count(r[3])
  end
end

def counts(expressions)
  expressions.split("\n").map { |e| count(e) }.inject(:+)
end

RSpec.describe "Operation Order" do
  describe "part 1 : sum all the result lines" do
    it { expect(count('1')).to eq(1) }
    it { expect(count('1 + 2')).to eq(3) }
    it { expect(count('2 * 2')).to eq(4) }
    it { expect(count('1 + 2 * 2')).to eq(6) }
    it { expect(count('1 + (2 * 2)')).to eq(5) }
    it { expect(count('1 + (2 + (2 * 2))')).to eq(7) }
    it { expect(count('(2 * 2) + 1')).to eq(5) }
    it { expect(count('1 + 2 * 3 + 4 * 5 + 6')).to eq(71) }
    it { expect(count('1 + (2 * 3) + (4 * (5 + 6))')).to eq(51) }
    it { expect(count('2 * 3 + (4 * 5)')).to eq(26) }
    it { expect(count('5 + (8 * 3 + 9 + 3 * 4 * 3)')).to eq(437) }
    it { expect(count('5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))')).to eq(12240) }
    it { expect(count('((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2')).to eq(13632) }
    it { expect(count('(2 * 2)')).to eq(4) }
    it { expect(counts(%{1
(2 * 3) + (4 * (5 + 6))})).to eq(51) }
    it { expect(counts(INPUT18)).to eql(1408133923393) }
  end


end

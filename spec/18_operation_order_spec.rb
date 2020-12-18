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

def count2(expression)
  return expression.to_i if /^(\d*)$/.match(expression)

  group = /(.*)\(([^)]*)\)(.*)/.match(expression)
  return count2("#{group[1]}#{count2(group[2])}#{group[3]}") if group

  r = /(.*) [*] (.*)/.match(expression)
  return count2(r[1]) * count2(r[2]) if r

  r = /(.*) [+] (.*)/.match(expression)
  count2(r[1]) + count2(r[2]) if r
end

def counts(expressions, counter)
  expressions.split("\n").map { |e| counter.call(e) }.inject(:+)
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
(2 * 3) + (4 * (5 + 6))}, Proc.new { |e| count(e) })).to eq(51) }
    it { expect(counts(INPUT18, Proc.new { |e| count(e) })).to eql(1408133923393) }
  end

  describe "Part 2 : when sum and product are in inverse order of precedence" do
    it { expect(count2('1 + (2 * 3) + (4 * (5 + 6))')).to eql(51) }
    it { expect(count2('1 + 2')).to eq(3) }
    it { expect(count2('2 * 2')).to eq(4) }
    it { expect(count2('2 * 3 + (4 * 5)')).to eql(46) }
    it { expect(count2('5 + (8 * 3 + 9 + 3 * 4 * 3)')).to eql(1445) }
    it { expect(count2('5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))')).to eql(669060) }
    it { expect(count2('((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2')).to eql(23340) }
    it { expect(counts(INPUT18, Proc.new { |e| count2(e) })).to eql(314455761823725) }
  end


end

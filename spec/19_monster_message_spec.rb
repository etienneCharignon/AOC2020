require 'data_day19'

EXAMPLES_RULLS19_1= %{0: 1 2
1: "a"
2: 1 3 | 3 1
3: "b"}

EXAMPLES_RULLS19_2= %{0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"}

def build(rulls, rull)
  or_rull = rulls[rull].split(' | ').map do |sub_or_rull|
    rulls_match = /(\d+ ?)+/.match(sub_or_rull)
    if rulls_match
      sub_or_rull.split(' ').map do |subrull|
        build(rulls, subrull)
      end.join('')
    else
      return sub_or_rull[1..-2]
    end
  end
  if or_rull.size > 1
    "(#{or_rull.join('|')})"
  else
    or_rull[0]
  end
end

def parse(rulls)
  map = rulls.split("\n").each_with_object({}) do |rull, map|
    r = rull.split(": ")
    map[r[0]] = r[1]
  end
  build(map, "0")
end

def check_only(rulls)
  "^#{parse(rulls)}$"
end

RSpec.describe "Monster Message" do
  describe "part 1" do
    describe "rull parsing" do
      it { expect(parse('0: "a"')).to eql("a") }
      it { expect(parse("0: 1\n1: \"b\"\n2: \"a\"")).to eql("b") }
      it { expect(parse("0: 1 2\n1: \"b\"\n2: \"a\"")).to eql("ba") }
      it { expect(parse("0: 1 | 2\n1: \"b\"\n2: \"a\"")).to eql("(b|a)") }
      it { expect(parse(EXAMPLES_RULLS19_1)).to eql("a(ab|ba)") }
      it { expect(parse(EXAMPLES_RULLS19_2)).to eql("a((aa|bb)(ab|ba)|(ab|ba)(aa|bb))b") }
    end
    describe "maching" do
      it "match all strings with example 2" do
        regexp = Regexp.new(check_only(EXAMPLES_RULLS19_2))
        str = ["aaaabb", "aaabab", "abbabb", "abbbab", "aabaab", "aabbbb", "abaaab", "ababbb"]
        expect(str.map {|s| regexp.match(s)}.all?).to be(true)
        expect(["aaaabba"].map {|s| regexp.match(s)}.all?).to be(false)
        expect(["aaaabb", "aaaabba"].count {|s| regexp.match(s)}).to eql(1)
      end
    end

    it "count maching" do
        regexp = Regexp.new(check_only(RULLS19))
        str = MESSAGES19.split("\n")
        expect(str.count {|s| regexp.match(s)}).to eql(230)
    end
  end
end

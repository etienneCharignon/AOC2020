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

EXAMPLES_RULLS19_3 = %{42: 9 14 | 10 1
9: 14 27 | 1 26
10: 23 14 | 28 1
1: "a"
11: 42 31
5: 1 14 | 15 1
19: 14 1 | 14 14
12: 24 14 | 19 1
16: 15 1 | 14 14
31: 14 17 | 1 13
6: 14 14 | 1 14
2: 1 24 | 14 4
0: 8 11
13: 14 3 | 1 12
15: 1 | 14
17: 14 2 | 1 7
23: 25 1 | 22 14
28: 16 1
4: 1 1
20: 14 14 | 1 15
3: 5 14 | 16 1
27: 1 6 | 14 18
14: "b"
21: 14 1 | 1 14
25: 1 1 | 1 14
22: 14 14
8: 42
26: 14 22 | 1 20
18: 15 15
7: 14 5 | 1 21
24: 14 1}

EXAMPLE_MESSAGES_3 = %{abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
bbabbbbaabaabba
babbbbaabbbbbabbbbbbaabaaabaaa
aaabbbbbbaaaabaababaabababbabaaabbababababaaa
bbbbbbbaaaabbbbaaabbabaaa
bbbababbbbaaaaaaaabbababaaababaabab
ababaaaaaabaaab
ababaaaaabbbaba
baabbaaaabbaaaababbaababb
abbbbabbbbaaaababbbbbbaaaababb
aaaaabbaabaaaaababaa
aaaabbaaaabbaaa
aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
babaaabbbaaabaababbaabababaaab
aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba}

def build2(rulls, rull)
  if rull == "8"
    "#{build2(rulls, "42")}+"
  elsif rull == "11"
    "(?<paren>#{build2(rulls, "42")}\\g<paren>*#{build2(rulls, "31")})"
  else
    or_rull = rulls[rull].split(' | ').map do |sub_or_rull|
      rulls_match = /(\d+ ?)+/.match(sub_or_rull)
      if rulls_match
        sub_or_rull.split(' ').map do |subrull|
          build2(rulls, subrull)
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
end

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

def reads(rulls)
  rulls.split("\n").each_with_object({}) do |rull, map|
    r = rull.split(": ")
    map[r[0]] = r[1]
  end
end

def parse2(rulls)
  build2(reads(rulls), "0")
end

def parse(rulls)
  build(reads(rulls), "0")
end

def check_only(rulls)
  "^#{parse(rulls)}$"
end

def check_only2(rulls)
  "^#{parse2(rulls)}$"
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

  describe "part 2" do
    it "can parse 3rd example without modification" do
      regexp = Regexp.new(check_only(EXAMPLES_RULLS19_3))
      str = EXAMPLE_MESSAGES_3.split("\n")
      expect(str.count {|s| regexp.match(s)}).to eql(3)
    end

    describe "can parse rull 8 and 11" do
      it { expect(parse2("0: 8\n8: 42 | 42 8\n42: \"b\"")).to eql('b+')  }
      it { expect(parse2("0: 11\n11: 42 31 | 42 11 31\n42: \"b\"\n31: \"a\"")).to eql('(?<paren>b\g<paren>*a)')  }
    end

    it "can parse 3rd example with modification" do
      regexp = Regexp.new(check_only2(EXAMPLES_RULLS19_3))
      str = EXAMPLE_MESSAGES_3.split("\n")
      expect(str.count {|s| regexp.match(s)}).to eql(12)
    end

    it "can parse the solution with modification" do
      regexp = Regexp.new(check_only2(RULLS19))
      str = MESSAGES19.split("\n")
      expect(str.count {|s| regexp.match(s)}).to eql(341)
    end

  end
end

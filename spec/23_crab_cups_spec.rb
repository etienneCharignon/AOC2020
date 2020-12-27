
def mix(cups, move)
  move.times do
    current_value = cups[0].to_i
    pickup = cups[1..3]
    cups.slice!(pickup)
    dest = 0
    loop do
      current_value -= 1
      current_value = 9 if current_value == 0
      dest = cups.index(current_value.to_s)
      break unless dest.nil?
    end
    cups = cups.insert(dest + 1, pickup)
    first = cups[0]
    cups[0] = ''
    cups += first
  end
  return cups
end

RSpec.describe "Crab cups", focus: true do
  describe "Part 1" do
    it { expect(mix("389125467", 1)).to eql("289154673") }
    it { expect(mix("389125467", 2)).to eql("546789132") }
    it { expect(mix("389125467", 3)).to eql("891346725") }
    it { expect(mix("389125467", 10)).to eql("837419265") }
    it { expect(mix("974618352", 100)).to eql("417589326") }
  end
end

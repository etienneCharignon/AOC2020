
def recitation(start, n)
  spoken = {}
  start.each_with_index { |n, i| spoken[n] = [i+1] }
  spoke = start[-1]
    p spoken
  (start.size+1..n).each do |i|
    if spoken.keys.include? spoke
      if spoken[spoke].size == 1
        spoke = 0
      else
        spoke = spoken[spoke][-1] - spoken[spoke][-2]
      end
    else
      spoke = 0
    end
    spoken[spoke] ||= []
    spoken[spoke] << i
  end
  spoke
end

RSpec.describe "Rambunctious Recitation" do
  describe "Part 1" do
    xit { expect(recitation([0,3,6], 1)).to eql(0)}
    it { expect(recitation([0,3,6], 3)).to eql(6)}
    it { expect(recitation([0,3,6], 4)).to eql(0)}
    it { expect(recitation([0,3,6], 5)).to eql(3)}
    it { expect(recitation([0,3,6], 6)).to eql(3)}
    it { expect(recitation([0,3,6], 7)).to eql(1)}
    it { expect(recitation([0,3,6], 2020)).to eql(436)}
    it { expect(recitation([1,20,8,12,0,14], 2020)).to eql(492)}
  end
end

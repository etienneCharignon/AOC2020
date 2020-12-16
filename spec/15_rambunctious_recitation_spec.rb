
def recitation(start, n)
  spoken = {}
  start.each_with_index { |n, i| spoken[n] = [i+1] }
  spoke = start[-1]
  (start.size+1..n).each do |i|
    if spoken.key? spoke
      data_spoken = spoken[spoke]
      if data_spoken.size == 1
        spoke = 0
      else
        spoke = data_spoken[-1] - data_spoken[-2]
      end
    else
      spoke = 0
    end
    spoken[spoke] ||= []
    spoken[spoke] << i
    spoken[spoke].shift if spoken[spoke].size > 2
  end
  spoke
end

def recitation2(start, n)
  spoken = []
  start.each_with_index { |n, i| spoken[n] = [i+1] }
  spoke = start[-1]
  (start.size+1..n).each do |i|
    if spoken[spoke] != nil
      data_spoken = spoken[spoke]
      if data_spoken.size == 1
        spoke = 0
      else
        spoke = data_spoken[-1] - data_spoken[-2]
      end
    else
      spoke = 0
    end
    spoken[spoke] ||= []
    spoken[spoke] << i
    spoken[spoke].shift if spoken[spoke].size > 2
  end
  spoke
end

RSpec.describe "Rambunctious Recitation" do
  describe "Part 1" do
    it { expect(recitation2([0,3,6], 3)).to eql(6)}
    it { expect(recitation2([0,3,6], 4)).to eql(0)}
    it { expect(recitation2([0,3,6], 5)).to eql(3)}
    it { expect(recitation2([0,3,6], 6)).to eql(3)}
    it { expect(recitation2([0,3,6], 7)).to eql(1)}
    it { expect(recitation2([0,3,6], 2020)).to eql(436)}
    it { expect(recitation2([1,20,8,12,0,14], 2020)).to eql(492)}
  end

  describe "Part 2" do
    xit { expect(recitation2([0,3,6], 30000000)).to eql(175594)}
    xit { expect(recitation2([1,20,8,12,0,14], 30000000)).to eql(63644)}
  end
end

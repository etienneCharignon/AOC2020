def find_loop_size(pk, initial_subject_number)
  loop_size = 0
  value = 1
  while pk != value do
    value *= initial_subject_number
    value = value % 20201227
    loop_size += 1
  end
  loop_size
end

def encrypt(subject_number, loop_size)
  value = 1
  loop_size.times do
    value *= subject_number
    value = value % 20201227
  end
  value
end

RSpec.describe "25: Combo Breaker" do
  describe "Part 1" do
    describe "Find loop size" do
      it { expect(find_loop_size(5764801, 7)).to eql(8) }
      it { expect(find_loop_size(17807724, 7)).to eql(11) }
    end

    describe "encrypt" do
      it { expect(encrypt(17807724, 8)).to eql(14897079) }
      it { expect(encrypt(5764801, 11)).to eql(14897079) }
    end

    describe "solve" do
      it { expect(find_loop_size(5099500, 7)).to eql(14665099) }
      it { expect(find_loop_size(7648211, 7)).to eql(10092352) }
      it { expect(encrypt(7648211, 14665099)).to eql(11288669) }
      it { expect(encrypt(5099500, 10092352)).to eql(11288669) }
    end
  end
end

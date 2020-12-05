require 'bording_pass_calculator'

RSpec.describe BordingPassCalculator, "#part 1" do
  context "#seat_id" do
    it { expect(BordingPassCalculator.seat("FBFBBFFRLR")).to eql(357) }
  end

  context "#compute_row_or_colum" do
    it "No more letter to read" do
      expect(BordingPassCalculator.find("", 0, 0)).to eql(0)
    end

    it "read one row letter" do
      expect(BordingPassCalculator.find("F", 0, 1)).to eql(0)
      expect(BordingPassCalculator.find("B", 0, 1)).to eql(1)
    end

    it "read two row letters" do
      expect(BordingPassCalculator.find("FF", 44, 47)).to eql(44)
      expect(BordingPassCalculator.find("BB", 44, 47)).to eql(47)
    end

    it "read all row letters" do
      expect(BordingPassCalculator.find("FBFBBFF", 0, 127)).to eql(44)
    end

    it "read column letters" do
      expect(BordingPassCalculator.find("RLR", 0, 7)).to eql(5)
    end
  end
end

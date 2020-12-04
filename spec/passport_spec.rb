require 'passport_validator'

TWO_VALIDS_INPUT_EXAMPLE=%{ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb hgt:150cm cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929}

ONE_INVALID_INPUT_EXAMPLE=%{ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb hgt:12cm cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929}

RSpec.describe PassportValidator, "#validate" do
  it "Validate empty file" do
    expect(PassportValidator.validate([])).to eql(0)
  end

  it "Validate one valid passport" do
    expect(PassportValidator.validate(["ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm"])).to eql(1)
  end

  it "Validate one valid passport on two lines" do
    expect(PassportValidator.validate(["ecl:gry pid:860033327 eyr:2020\nhcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm"])).to eql(1)
  end

  it "Validate two valids passports" do
    expect(PassportValidator.validate(TWO_VALIDS_INPUT_EXAMPLE.split("\n\n")))
      .to eql(2)
  end

  it "Validate one valid passport and one invalid" do
    expect(PassportValidator.validate(ONE_INVALID_INPUT_EXAMPLE.split("\n\n")))
      .to eql(1)
  end

  it "Validate the byr" do
    expect(PassportValidator::RULLS['byr'].call('1920')).to eql(true)
    expect(PassportValidator::RULLS['byr'].call('1919')).to eql(false)
    expect(PassportValidator::RULLS['byr'].call('2002')).to eql(true)
    expect(PassportValidator::RULLS['byr'].call('2003')).to eql(false)
  end

  it "Validate the iyr" do
    expect(PassportValidator::RULLS['iyr'].call('2010')).to eql(true)
    expect(PassportValidator::RULLS['iyr'].call('2009')).to eql(false)
    expect(PassportValidator::RULLS['iyr'].call('2020')).to eql(true)
    expect(PassportValidator::RULLS['iyr'].call('2021')).to eql(false)
  end

  it "Validate the hgt" do
    expect(PassportValidator::RULLS['hgt'].call('150cm')).to eql(true)
    expect(PassportValidator::RULLS['hgt'].call('149cm')).to eql(false)
    expect(PassportValidator::RULLS['hgt'].call('193cm')).to eql(true)
    expect(PassportValidator::RULLS['hgt'].call('194cm')).to eql(false)
    expect(PassportValidator::RULLS['hgt'].call('59in')).to eql(true)
    expect(PassportValidator::RULLS['hgt'].call('58in')).to eql(false)
    expect(PassportValidator::RULLS['hgt'].call('76in')).to eql(true)
    expect(PassportValidator::RULLS['hgt'].call('77in')).to eql(false)
  end

  it "Validate the hcl" do
    expect(PassportValidator::RULLS['hcl'].call('#123abc')).to eql(true)
    expect(PassportValidator::RULLS['hcl'].call('123abc')).to eql(false)
    expect(PassportValidator::RULLS['hcl'].call('#123-bc')).to eql(false)
    expect(PassportValidator::RULLS['hcl'].call('#123ab')).to eql(false)
  end

  it "Validate the ecl" do
    expect(PassportValidator::RULLS['ecl'].call('amb')).to eql(true)
    expect(PassportValidator::RULLS['ecl'].call('toto')).to eql(false)
  end

  it "Validate the pid" do
    expect(PassportValidator::RULLS['pid'].call('123456789')).to eql(true)
    expect(PassportValidator::RULLS['pid'].call('023456789')).to eql(true)
    expect(PassportValidator::RULLS['pid'].call('0')).to eql(false)
    expect(PassportValidator::RULLS['pid'].call('0123456789')).to eql(false)
  end
end

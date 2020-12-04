class PassportValidator

  RULLS = {
    'byr'=> Proc.new {|value| value.to_i >= 1920 && value.to_i <= 2002},
    'iyr'=> Proc.new {|value| value.to_i >= 2010 && value.to_i <= 2020},
    'eyr'=> Proc.new {|value| value.to_i >= 2020 && value.to_i <= 2030},
    'hgt'=> Proc.new {|value| (value.end_with?('cm') && value.to_i >= 150 && value.to_i <= 193) || (value.end_with?('in') && value.to_i >= 59 && value.to_i <= 76)},
    'hcl'=> Proc.new {|value| (value =~ /#[0-9a-z]{6}/) == 0},
    'ecl'=> Proc.new {|value| ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].include?(value)},
    'pid'=> Proc.new {|value| (value =~ /^[0-9]{9}$/) == 0}
  }

  def self.validate(file_lines)
    file_lines.select do |passport|
      entries = passport.split(' ').map { |entree| entree.split(':') }
      entries.select!{ |entrie| entrie[0] != 'cid' && RULLS[entrie[0]].call(entrie[1])}
      entries.map{|e| e[0]}.sort == RULLS.keys.sort
    end.count
  end
end

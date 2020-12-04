class PassportValidator

  RULLS = {
    'byr'=> Proc.new {|value| (1920..2002).member?(value.to_i)},
    'iyr'=> Proc.new {|value| (2010..2020).member?(value.to_i)},
    'eyr'=> Proc.new {|value| (2020..2030).member?(value.to_i)},
    'hgt'=> Proc.new {|value| (value.end_with?('cm') && (150..193).member?(value.to_i)) || (value.end_with?('in') && (59..76).member?(value.to_i))},
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

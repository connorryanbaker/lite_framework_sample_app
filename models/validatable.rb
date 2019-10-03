require_relative '../controllers/flash'
module Validatable
  ABSENT_VALUES = [nil, '']
  def self.presence(*args)
    args.each do |arg|
      unless absent?(arg)
        flash['errors'] = "#{arg} must be present"
        return false
      end
    end
  end

  def absent?(val)
    ABSENT_VALUES.includes?(val)
  end
end
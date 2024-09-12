module Utils
  def self.split_num(s)
    s.split(/(\d+)|(\D+)/).select {|c| c != ''}.map do |c|
      x = c.to_i
      x > 0 || c[0] == '0' ? x : c
    end
  end

  private_class_method :split_num

  def self.nat_ord(a, b)
    for x in split_num(a).zip(split_num(b))
      case x
      in nil, nil
        return 0
      in nil, _
        return -1
      in _, nil
        return 1
      in Integer, String
        return -1
      in String, Integer
        return 1
      in a, b
        cmp = a <=> b
        return cmp if cmp != 0
      end
    end

    0
  end
end

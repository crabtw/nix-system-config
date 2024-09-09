#!/usr/bin/env ruby

def split(s)
  s.split(/(\d+)|(\D+)/).select {|c| c != ''}.map do |c|
    x = c.to_i
    x > 0 || c[0] == '0' ? x : c
  end
end

def nat_ord(a, b)
  for x in split(a).zip(split(b))
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
      raise "invalid argument type" if a.class != b.class
      cmp = a <=> b
      return cmp if cmp != 0
    end
  end

  0
end

if __FILE__ == $0
  exit if ARGV.length < 1

  dir = File.dirname ARGV.first
  file = File.basename ARGV.first

  Dir.chdir dir
  all = Dir.entries('.').select do |f|
    f =~ /\.(jpe?g|png|bmp|gif)$/i
  end.sort {|a, b| nat_ord(a, b)}

  exec 'imv', '-n', file, '-f', '-s', 'shrink', *all
end

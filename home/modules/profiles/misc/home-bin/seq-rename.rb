#!/usr/bin/env ruby

require 'optparse'

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
  options = {}
  OptionParser.new do |opts|
    opts.on('-s', '--start N', Integer, 'Start number (default 1)') {|v| options[:start] = v}
    opts.on('-l', '--len N', Integer, 'Minimal length (default log10(number of files) + 1)') {|v| options[:len] = v}
    opts.on('-d', '--dryrun', 'Don\'t rename files') {options[:dryrun] = true}
  end.parse!

  i = options[:start] || 1
  len = options[:len] || Math.log10(ARGV.size).floor + 1

  ARGV.sort {|a, b| nat_ord(a, b)}.each do |old|
    ext = File.extname old
    new = i.to_s.rjust(len, '0')

    new << '_' while File.exist?(new + ext)
    new += ext

    puts "#{old} => #{new}"
    File.rename(old, new) unless options[:dryrun]

    i += 1
  end
end

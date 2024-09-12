#!/usr/bin/env ruby

require 'optparse'

$LOAD_PATH.unshift File.dirname(__FILE__)
require 'utils'

if __FILE__ == $0
  options = {}
  OptionParser.new do |opts|
    opts.on('-s', '--start N', Integer, 'Start number (default 1)') {|v| options[:start] = v}
    opts.on('-l', '--len N', Integer, 'Minimal length (default log10(number of files) + 1)') {|v| options[:len] = v}
    opts.on('-d', '--dryrun', 'Don\'t rename files') {options[:dryrun] = true}
  end.parse!

  i = options[:start] || 1
  len = options[:len] || Math.log10(ARGV.size).floor + 1

  ARGV.sort {|a, b| Utils.nat_ord(a, b)}.each do |old|
    ext = File.extname old
    new = i.to_s.rjust(len, '0')

    new << '_' while File.exist?(new + ext)
    new += ext

    puts "#{old} => #{new}"
    File.rename(old, new) unless options[:dryrun]

    i += 1
  end
end

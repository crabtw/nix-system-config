#!/usr/bin/env ruby

$LOAD_PATH.unshift File.dirname(__FILE__)
require 'utils'

if __FILE__ == $0
  exit if ARGV.length < 1

  dir = File.dirname ARGV.first
  file = File.basename ARGV.first

  Dir.chdir dir
  all = Dir.entries('.').select do |f|
    f =~ /\.(jpe?g|png|bmp|gif)$/i
  end.sort {|a, b| Utils.nat_ord(a, b)}

  exec 'imv', '-n', file, '-f', '-s', 'shrink', *all
end

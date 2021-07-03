#!/usr/bin/env ruby

require 'optparse'
require 'fileutils'

DB_PATH = "#{ENV["HOME"]}/db/comic"

TITLE_GROUP = "#{DB_PATH}/title+"
ARTIST_GROUP = "#{DB_PATH}/artist+"
GROUP_GROUP = "#{DB_PATH}/group+"

def mk_tag(group, tag)
  if !Dir.exists? group
    $stderr.puts "Error: #{group} doesn't exist"
    exit 1
  end
  FileUtils.mkdir_p("#{group}/#{tag}")
end

if __FILE__ == $0
  artists = []
  groups = []

  OptionParser.new do |opts|
    opts.on('-aNAME', '--artist=NAME') {|v| artists << v.strip}
    opts.on('-gNAME', '--group=NAME') {|v| groups << v.strip}
  end.parse!

  [
    [ARTIST_GROUP, artists],
    [GROUP_GROUP, groups],
  ].each do |group, tags|
    tags.each {|t| mk_tag(group, t)}
  end

  ARGV.each do |file|
    if !File.exists? file
      $stderr.puts "Error: #{file} doesn't exist"
      next
    end

    title = File.basename(File.realpath(file)).strip
    mk_tag(TITLE_GROUP, title)

    tags = (artists + groups + [title]).uniq.join('/')
    puts "#{file} -> #{tags}"
    system('tag', 'ln', file, tags)
  end
end

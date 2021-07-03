#!/usr/bin/env ruby

require 'optparse'
require 'fileutils'

DB_PATH = "#{ENV["HOME"]}/db/comic"

TITLE_GROUP = "#{DB_PATH}/title+"
AUTHOR_GROUP = "#{DB_PATH}/author+"
CIRCLE_GROUP = "#{DB_PATH}/circle+"

def mk_tag(group, tag)
  if !Dir.exists? group
    $stderr.puts "Error: #{group} doesn't exist"
    exit 1
  end
  FileUtils.mkdir_p("#{group}/#{tag}")
end

if __FILE__ == $0
  authors = []
  circles = []

  OptionParser.new do |opts|
    opts.on('-aNAME', '--author=NAME') {|v| authors << v.strip}
    opts.on('-cNAME', '--circle=NAME') {|v| circles << v.strip}
  end.parse!

  [
    [AUTHOR_GROUP, authors],
    [CIRCLE_GROUP, circles],
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

    tags = (authors + circles + [title]).uniq.join('/')
    puts "#{file} -> #{tags}"
    system('tag', 'ln', file, tags)
  end
end

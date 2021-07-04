#!/usr/bin/env ruby

require 'fileutils'
require 'pathname'

def chperm dir
  stack = []
  stack << dir

  while !stack.empty?
    dir = stack.pop
    if dir.directory?
      FileUtils.chmod 0775, dir
      dir.each_child do |path|
        stack << path
      end
    else
      FileUtils.chmod 0664, dir
    end
  end
end

ARGV.each do |d|
  d = Pathname.new d
  chperm d
  FileUtils.chown_R 'root', 'wheel', d
end

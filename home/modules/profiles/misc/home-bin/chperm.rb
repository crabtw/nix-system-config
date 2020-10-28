#!/usr/bin/env ruby

require 'fileutils'
require 'pathname'

def chperm dir
  if dir.directory?
    dir.each_child do |path|
      if path.directory?
        FileUtils.chmod 0755, path
        chperm path
      else
        FileUtils.chmod 0644, path
      end
    end
  else
    FileUtils.chmod 0644, dir
  end
end

ARGV.each do |d|
  d = Pathname.new d
  chperm d
  FileUtils.chown_R 'root', 'root', d
end

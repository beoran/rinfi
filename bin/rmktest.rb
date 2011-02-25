#!/usr/bin/env ruby

require 'fileutils'

def make_test_for_file(dirname, filename)
  
end 

def make_tests_for_dir(dirname)
  dir = Dir.new(li
end

def main(args)
  libname = 'lib'
  unless File.exist?(libname)
    warn "No #{libname} directory in current work directory. Nothing to do!"
    return 1
  end
  make_tests_for_dir(libname)
end
  
  
main(ARGV)




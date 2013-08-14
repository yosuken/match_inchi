#!/usr/bin/env ruby
require 'rubygems'
require 'match_inchi'
include MatchInChI

f1, f2, f3 = ARGV
unless f3
	puts "usage: match_inchi input1 input2 output"
	raise
end
$stderr.puts "input file1:#{f1}"
$stderr.puts "input file2:#{f2}"
$stderr.puts "output file:#{f3}"
i1, i2 = [f1, f2].map{ |f| InChI_file.new(f) }
fout = open(f3, "w")
mf = Match_files.new(i1, i2)
mf.match
fout.puts mf.make_output

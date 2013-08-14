#!/usr/bin/env ruby
require 'rubygems'
require 'match_inchi'
include MatchInChI

f1, f2, f3 = ARGV
unless f3
	raise "usage: match_inchi input1 input2 output"
end
i1, i2 = [f1, f2].map{ |f| InChI_file.new(f) }
mf = Match_files.new(i1, i2)
mf.make_output

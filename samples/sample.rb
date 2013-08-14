
require 'rubygems'
$:.unshift File.expand_path "../lib", File.dirname(__FILE__)
require 'match_inchi'
include MatchInChI
require 'pp'

option = ARGV.shift

i1 = InChI_file.new("../../HMDB/compound/parse_compound_InChI2.out")
#i1 = InChI_file.new("../../KNApSAcK/compound/parse_compound_InChI.out")
i2 = InChI_file.new("../../HMDB/compound/parse_HMDB_InChI.out")
#i2 = InChI_file.new("../../KNApSAcK/compound/parse_KNApSAcK_InChI.out")

#i1.ids2inchi.keep_if{ |k, r| r.parts["t"] }.keep_if{ |k, r| r.invert_tm }.each{ |k, r| puts [k, r.parts["m"]]*"\t" }
#i1.ids2inchi.keep_if{ |k, r| r.invert_tm }.each{ |k, r| puts [k, r.parts["m"], r.invert_tm["m"]]*"\t" }
#i1.ids2inchi.keep_if{ |k, r| r.invert_tm }.each{ |k, r| puts [k, r.invert_tm["m"]]*"\t" }
#i2.ids2inchi.select{ |k, r| r.parts["t"] }.reject{ |k, r| r.parts["m"] }.each{ |k, r| pp [k, r.inchi]*"\t" }
#i2.ids2inchi.select{ |k, r| r.invert_tm }.each{ |k, r| pp r  }
#i1.ids2inchi.each{ |k, r| pp r.without_qp_from_organic }
#pp i1.ids2inchi
#pp i2.ids2inchi
#pp i1.formulae2ids
#pp i2.formulae2ids

mf = Match_files.new(i1, i2)
mf.match
#pp mf.results
mf.make_output



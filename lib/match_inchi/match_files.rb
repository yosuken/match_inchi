
module MatchInChI
	attr_reader :f1, :f2, :results
	class Match_files
		def initialize(f1, f2)
			@f1 = f1 # InChI_file object of DB1
			@f2 = f2 # InChI_file object of DB2
			@results = Hash.new
		end
		def match
			@f1.formulae2ids.each{ |formula, ids1|
				ids2 = @f2.formulae2ids[formula]
				next unless ids2
				ids1.each{ |id1|
					i1 = @f1.ids2inchi[id1]
					ids2.each{ |id2|
						i2 = @f2.ids2inchi[id2]
						m = Match_InChI.new(i1, i2)
						result = m.do_match
						@results[[id1,id2]*","] = result if result
					}
				}
			}
		end
		def make_output
			outstr = @results.keys.sort.map{ |k|
				next unless @results[k]
				flag, hash = @results[k]
				[k, flag, hash.to_inchi]*"\t"
			}.compact
		end
	end
end

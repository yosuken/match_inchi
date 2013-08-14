
module MatchInChI
	class Match_InChI
		attr_reader :inchi1, :inchi2
		def initialize(inchi1, inchi2)
			@i1 = inchi1 # InChI object1 to compare
			@i2 = inchi2 # InChI object2 to compare
		end
		def do_match(option = "all")
			# [1] full 
			# [2] -pq from organic compound
			# [3] loose-t
			# [4] invert-tm & (loose-t)
			# [5] -ms
			# [6] -tms
			case option
			when "all"
				result = nil
				(1..6).each{ |idx| 
					ret = self.send("do_match#{idx}".to_sym) 
					if ret then (result = ret and break) end
				}
				return result
			end
		end
		def do_match1
			if @i1.parts == @i2.parts
				return [1, @i1.parts]
			else
				return nil
			end
		end
		def do_match2
			[[@i1, @i2], [@i2, @i1]].each{ |i1, i2|
				if i1.without_qp_from_organic == i2.parts 
					return [2, i2.parts]
				end
			}
			return nil
		end
		def do_match6
			[[@i1, @i2], [@i2, @i1]].each{ |i1, i2|
				i1w = i1.without_tms
				next unless i1w
				if i1w == i2.default
					return [6, i2.default]
				end
			}
			return nil
		end
		def do_match5
			[[@i1, @i2], [@i2, @i1]].each{ |i1, i2|
				i1w = i1.without_ms
				next unless i1w
				if i1w == i2.default
					return [5, i2.default]
				end
			}
			return nil
		end
		def do_match3
			i1 = @i1.default.dup
			i2 = @i2.default.dup
			t1 = i1["t"]
			t2 = i2["t"]
			i1.delete("t")
			i2.delete("t")
			return nil if i1 != i2
			return nil unless t1 and t2
			loose_t = match_loose_t(t1, t2)
			if loose_t
				return [3, @i1.default]
			else
				return nil
			end
		end
		def do_match4
			i1 = @i1.default.dup
			i2 = @i2.default.dup
			i1.delete("t"); i1.delete("m")
			i2.delete("t"); i2.delete("m")
			return nil if i1 != i2
			if @i1.invert_tm
				t1 = @i1.invert_tm["t"]; m1 = @i1.invert_tm["m"]
				t2 = @i2.default["t"]; m2 = @i2.default["m"]
			elsif @i2.invert_tm
				t2 = @i2.invert_tm["t"]; m2 = @i2.invert_tm["m"]
				t1 = @i1.default["t"]; m1 = @i1.default["m"]
			else
				return nil
			end
			return nil unless m1 == m2
			return nil unless t1 and t2
			loose_t = match_loose_t(t1, t2)
			if loose_t
				return [4, @i1.default]
			else
				return nil
			end
		end
	end
end

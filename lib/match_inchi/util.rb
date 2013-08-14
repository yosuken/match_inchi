
module MatchInChI
	#class Hash < ::Hash
	class Hash < Hash
		def set(k, v)
			self[k] ? self[k] << v : self[k] = [v]
		end
		def to_inchi
			keys = ["formula"] + "chqpbtms".split(//) + "ifr".split(//)
			sinchi = "InChI=1S/"
			sinchi += keys.map{ |k| self[k] }.compact*"/"
		end
	end

	def invert_binary(str)
		case str
		when "1" then "0"
		when "0" then "1"
		else str
		end
	end

	def match_loose_t(t1, t2)
		# t field can include "."
		a1, a2 = [t1, t2].map{ |t| t.split(/\,/) }
		a1.zip(a2){ |e1, e2| # each element (6?/4+/...)
			return nil if e1.size != e2.size
			e1.split(//).zip(e2.split(//)){ |c1, c2| # each character
				if c1 == "?" or c2 == "?"
					next
				elsif c1 == c2
					next
				else
					return nil
				end
			}
		}
		return 1
	end
end

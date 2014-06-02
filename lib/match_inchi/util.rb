
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
		_t1, _t2 = t1[1..-1], t2[1..-1] # "t12-, 13-" => "12-, 13-"

		h1, h2 = {}, {}
	 	[_t1, _t2].zip([h1, h2]){ |t, h| 
			t.split(/\,/).map{ |i| i =~ /(\d+)([+-?])/; h[$1] = $2 } 
		}
		[h1, h2].each{ |h| raise if h.has_key?(nil) }

		h1.keys.each{ |p|
			next unless h2[p] # pass if h2 don't have this position => e.g.) t1:"t12-,13?,14+", t2:"t12-,13-"
			c1, c2 = h1[p], h2[p]  #=> +=?
			if c1 == "?" or c2 == "?"
				next
			elsif c1 == c2
				next
			else
				return nil
			end
		}
		return 1

=begin
		#a1, a2 = [_t1, _t2].map{ |t| t.split(/\,/).map{ |i| i =~ /(\d+)([+-?])/; [$1, $2] } }
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
=end
	end
end

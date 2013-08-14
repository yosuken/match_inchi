
class InChI < Hash
	def initialize
	end
	def set_parts(inchi)
		# (reference: InChI_TechMan.pdf, Appendix 3)
		# [formula]/(chqpbtms/i(hbtms)/f((hqbtms/i(hbtms)o))/r(....))
		# for this time, the first "chqpbtms" is the target sublayer
		flags = inchi.split(/\//)[1..-1]
		formula = flags.shift
		flags *= "/"
		flags, r = flags.split(%r{/r})
		flags, f = flags.split(%r{/f})
		flags, i = flags.split(%r{/i})
		flags.split(/\//).each{ |elem|
			self[elem[0]] = elem # main
		}
		self["r"] = "r" + r if r # not main
		self["f"] = "f" + f if f # not main
		self["i"] = "i" + i if i # not main
	end
end

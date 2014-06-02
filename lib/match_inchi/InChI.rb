
module MatchInChI
	class InChI
		attr_reader :inchi
		attr_accessor :parts, :without_qp_from_organic, :without_tms, :without_ms, :invert_tm, :default
		def initialize(inchi)
			@inchi = inchi
		end
		def set_parts
			# reference: InChI_TechMan.pdf, Appendix 3
			# http://www.inchi-trust.org/fileadmin/user_upload/software/inchi-v1.04/InChI_TechMan.pdf

			# [formula]/(chqpbtms/i(hbtms)/f((hqbtms/i(hbtms)o))/r(....))
			# This gem checks just the first "chqpbtms".
			@parts = Hash.new
			flags = @inchi.split(/\//)[1..-1]
			formula = flags.shift
			@parts["formula"] = formula
			flags *= "/"
			return if flags == ""
			flags, r = flags.split(%r{/r})
			flags, f = flags.split(%r{/f})
			flags, i = flags.split(%r{/i})
			flags.split(/\//).each{ |elem|
				@parts[elem[0]] = elem # main
			}
			@parts["r"] = "r" + r if r # not main
			@parts["f"] = "f" + f if f # not main
			@parts["i"] = "i" + i if i # not main
		end
		def prepare_options
			self.set_without_qp_from_organic
			self.set_default
			self.set_without_tms
			self.set_without_ms
			self.set_invert_tm
		end
		def set_without_qp_from_organic
			if self.parts["formula"] =~ /C[^a-z]/
				@without_qp_from_organic = self.parts.dup
				@without_qp_from_organic.delete("q")
				@without_qp_from_organic.delete("p")
			end
		end
		def set_default(option = 0)
			case option
			when 0
				@default = self.without_qp_from_organic ? self.without_qp_from_organic : self.parts
			else
				@default = self.parts
			end
		end
		def set_without_tms
			if self.default["t"]
				@without_tms = self.default.dup
				@without_tms.delete("t")
				@without_tms.delete("m")
				@without_tms.delete("s")
			end
		end
		def set_without_ms
			if self.default["m"]
				@without_ms = self.default.dup
				@without_ms.delete("m")
				@without_ms.delete("s")
			end
		end
		def set_invert_tm
			return unless self.default["t"]
			@invert_tm = self.default.dup
			# invert_m
			if @invert_tm["m"]
				@invert_tm["m"] = @invert_tm["m"].split(//).map{ |c| invert_binary(c) }*""
			else
				@invert_tm = nil
				return
			end
			# invert_t
			@invert_tm["t"] = @invert_tm["t"].gsub(/\-/, "/")
			@invert_tm["t"] = @invert_tm["t"].gsub(/\+/, "-")
			@invert_tm["t"] = @invert_tm["t"].gsub(/\//, "+")
		end
	end
end

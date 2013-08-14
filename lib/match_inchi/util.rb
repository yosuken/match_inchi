
class Hash
	module Util
		def set(k, v)
			self[k] ? self[k] << v : self[k] = [v]
		end
	end
end


class InChI_file
	attr_accessor :key2sinchi, :file, :key2sinchi_parts

	def initialize(file)
		@file = file
		@key2sinchi = Hash.new
		@key2sinchi_parts = Hash.new
		set_key2sinchi()
		set_key2sinchi_parts()
	end
	def set_key2sinchi
		IO.foreach(@file){ |l|
			# key must be uniq
			a = l.chomp.split(/\t/)
			case a.size
			when 0..1
				$stderr.puts "skipped line:#{l}"
			else
				key, sinchi = a
				if sinchi =~ %r{^InChI\=1S/}
					@key2sinchi[key] = sinchi
				else
					$stderr.puts "skipped line:#{l}"
				end
			end
		}
	end
	def set_key2sinchi_parts
		@key2sinchi.each{ |k, sinchi|
			inchi = InChI.new(sinchi)
			inchi.set_parts
			@key2sinchi_parts[k] = inchi
		}
	end
end



module MatchInChI
	class InChI_file
		attr_accessor :ids2inchi, :formulae2ids

		def initialize(file)
			@file = file
			@ids2inchi = Hash.new
			@formulae2ids = Hash.new
			set_ids2inchi()
		end
		def set_ids2inchi
			IO.foreach(@file){ |l|
				if l =~ /^\s*\#/
					$stderr.puts "skipped line:#{l}"
				else
					a = l.chomp.split(/\t/)
					case a.size
					when 0..1
						$stderr.puts "skipped line:#{l}"
					else
						key, sinchi = a
						if sinchi =~ %r{^InChI\=1S/}
							inchi = InChI.new(sinchi)
							inchi.set_parts
							inchi.prepare_options

							# key must be uniq
							$stderr.puts "duplication found:#{key}" if @ids2inchi[key]

							@ids2inchi[key] = inchi
							@formulae2ids.set(inchi.parts["formula"], key)
						else
							$stderr.puts "skipped line:#{l}"
						end
					end
				end
			}
		end
	end
end


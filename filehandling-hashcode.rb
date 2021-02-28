FILES = Dir["**/*.txt"].freeze
FILES.each do |file|
	

	File.open("#{file}_output", "w+") do |f|
		f.puts(" ")
	end
end

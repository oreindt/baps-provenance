class String
	def numeric?
		Float(self) != nil rescue false
	end
end


dirs = `ls -d x_*`.split

pars = dirs.map do |dir|
	dir.split('_')[1..-1]
end

index = []
count = []

pars[0].each do |p|
	index << (p.numeric? ? nil : Hash.new)
	count << 0
end

pars.each do |line|
	new_line = []
	line.each_index do |i|
		if ! index[i]
			new_line << line[i]
			next
		end
		
		if index[i].has_key?(line[i])
			new_line << index[i][line[i]]
		else
			STDERR.print i, "\t", line[i], " -> ", count[i], "\n"
			index[i][line[i]] = count[i]
			new_line << count[i]
			count[i] += 1
		end
	end
	puts new_line.join("\t")
end




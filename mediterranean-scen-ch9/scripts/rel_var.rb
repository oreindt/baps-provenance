names = []
first = true

varns = []
varis = []

warn = {}

$stdin.readlines.each do |line|
	if first
		names = line.chomp.split
		first = false

		# collect mean columns, vars are one to the right
		names.each_index do |i|
			if names[i].start_with?("mean")
				vname = names[i][5..-1]
				varns << vname
				varis << i

				print("rstdd_", vname, "\t")
			end
		end

		puts
		next
	end

	vals = line.split

	varns.each_index do |i|
		mean = vals[varis[i]].to_f
		var = vals[varis[i]+1].to_f
		#$stderr.print vals[varis[i]], ": ", mean, " ", var, "; "
		if var < 0
			warn[varns[i]] = true
			print(0, "\t")
		else
			print(Math.sqrt(var)/mean, "\t")
		end
	end

	puts
end

if warn.size > 0
	$stderr.print(warn.keys.join(" "), " have neg. values!\n")
end


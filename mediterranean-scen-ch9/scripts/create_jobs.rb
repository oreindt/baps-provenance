`mkdir -p submit`

lines = File.new("commands", "r").readlines

(0...lines.size).step(2) do |i|
	dir = lines[i].strip
	cmd = lines[i+1].strip
	wd = `pwd`.strip
	sbm_file = "submit/submit_#{dir}"
	`cat header > #{sbm_file}`
	`echo "cd #{wd}/#{dir}" >> #{sbm_file}`
	`echo sh run >> #{sbm_file}`
end

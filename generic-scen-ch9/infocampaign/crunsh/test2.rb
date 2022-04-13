require 'crunsh'

Crunsh.new "testsim", argPrefix: "", argSep: ":", onCreate: "touch " do
	set 'bla', 3

	par ['h1', 'h2'], {"first" => [10, 20], "second" => [0, 0]}
	par 'v1', 1.5, 1.7, 4
	par ['p1', 'p2'], [1, 2], [2, 4], [3, 5]
	end

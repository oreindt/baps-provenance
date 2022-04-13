

function get_result(run_dir)
	map(split.(readlines("$run_dir/summary.txt"))) do line
		parse.(Float64, line)
	end
end

function costs(results)
    arrivals = [0.657941144053786, 0.207848228494849, 0.599476123312513]
    mort = [0.022736973763885, 0.019768432868398, 0.028785488958991, 0.047819332348149]
    interc = [1.43020016842651, 0.884092762025546, 0.525283057533685]

    d1 = sqrt(sum((arrivals .- results[1]) .^ 2))
    d2 = sqrt(sum((mort .- results[2]) .^ 2))
    d3 = sqrt(sum((interc .- results[3]) .^ 2))
    
    d1 + d2 * 10 + d3
end


function best_runs(runs)
	runs_info = [(dir, costs(get_result(dir))) for dir in runs]

	sort!(runs_info, by=x->x[2])

	for (dir, cost) in runs_info
		println(dir, "\t", cost)
	end
end


best_runs(ARGS)

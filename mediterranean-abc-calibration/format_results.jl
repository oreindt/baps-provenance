
function calc_yearly(data, warmup, year)
	yearly = Float64[]
	idx = warmup + year
	while idx <= length(data)
		#println(idx, " ", data[idx])
		push!(yearly, data[idx] - data[idx - year + 1])
		idx += year
	end
	yearly
end


function calc_yearly_delta(data, warmup, year)
	yearly = calc_yearly(data, warmup, year)

	res = Float64[]
	for i in 2:length(yearly)
		push!(res, yearly[i]/yearly[i-1])
	end

	res
end


function run()
	output = split.(readlines("interceptions.txt")[2:end])

	interc_w = parse.(Float64, map(l -> l[1], output))
	int_ratios_w = calc_yearly_delta(interc_w, 100, 100)

	interc_e = parse.(Float64, map(l -> l[2], output))
	int_ratios_e = calc_yearly_delta(interc_e, 100, 100)

	n_dead_w = parse.(Float64, map(l->l[3], output))
	dead_yearly_w = calc_yearly(n_dead_w, 100, 100)
	
	n_dead_e = parse.(Float64, map(l->l[4], output))
	dead_yearly_e = calc_yearly(n_dead_e, 100, 100)
	
	arrivals_w = parse.(Float64, map(l -> l[5], output))
	arr_ratios_w = calc_yearly_delta(arrivals_w, 100, 100)
	arr_yearly_w = calc_yearly(arrivals_w, 100, 100)

	arrivals_e = parse.(Float64, map(l -> l[6], output))
	arr_ratios_e = calc_yearly_delta(arrivals_e, 100, 100)
	arr_yearly_e = calc_yearly(arrivals_e, 100, 100)

	mort_yearly_w = dead_yearly_w ./ arr_yearly_w
	mort_yearly_e = dead_yearly_e ./ arr_yearly_e


	open("summary.txt", "w") do file
			println(file, join(arr_ratios_w, "\t"))
			println(file, join(arr_ratios_e, "\t"))
			println(file, join(mort_yearly_w, "\t"))
			println(file, join(mort_yearly_e, "\t"))
			println(file, join(int_ratios_w, "\t"))
			println(file, join(int_ratios_e, "\t"))
		end
end

run()

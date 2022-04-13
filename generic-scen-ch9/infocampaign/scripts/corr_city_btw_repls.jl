using Statistics

include("script_utils.jl")


function correlate(run1, run2)
	cities1 = readlines(join(run1, '_') * "/cities.txt")
	cities2 = readlines(join(run2, '_') * "/cities.txt")
	c1 = Int[]
	c2 = Int[]
	ex1 = Int[]
	ex2 = Int[]

	names = split(cities1[1])
	count_col = col_number("count", names)
	type_col = col_number("type", names)

	for i in 2:length(cities1)
		spl1 = split(cities1[i])
		spl2 = split(cities2[i])
		count1 = parse(Int, spl1[count_col])
		count2 = parse(Int, spl2[count_col])
		push!(c1, count1)
		push!(c2, count2)
		if spl1[type_col] == "EXIT"
			push!(ex1, count1)
			push!(ex2, count2)
		end
	end

	println(cor(c1, c2)^2, "\t", cor(ex1, ex2)^2)
end


const pars = par_combis()
const n_params = length(pars[1])
current = nothing
first = 0

for i in eachindex(pars)
	global current
	global first
	c = pars[i][1:n_params-1]
	if c != current
		current = c
		if first > 0
			correlate(pars[i-1], pars[first])
		end
		first = i
		continue
	end

	correlate(pars[i-1], pars[i])
end

correlate(pars[end], pars[first])



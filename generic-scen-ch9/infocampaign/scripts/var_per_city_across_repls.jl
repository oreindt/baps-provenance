using Statistics

include("script_utils.jl")


function var_stdd(matrix)
	va = 0.0
	stdd = 0.0

	for city in eachrow(matrix)
		v = var(city)
		va += v
		stdd += sqrt(v)
	end

	m_var = va / size(matrix)[2]
	m_stdd = stdd / size(matrix)[2]

	m_var, m_stdd
end


function variation(pars)
	pref = join(pars, "_")
	files = data_files("cities.txt", "$pref*")
	
	data = Float64[]
	count_col = col_number("count", header(files[1]))

	# read data into matrix
	for f in files
		d = parse_col(grep(f, "EXIT"), count_col, Float64)
		append!(data, d)
	end

	# Mongolian, not Latin
	# => lines are cities, columns are replicates
	count = reshape(data, :, length(files))

	# *** calculate variation based on absolute numbers

	m_var, m_stdd = var_stdd(count)

	m = mean(count)

	rel_m_var = m_var / m
	rel_m_stdd = m_stdd / m

	print(m_var, "\t", rel_m_var, "\t", m_stdd, "\t", rel_m_stdd, "\t")

	# *** calculate variation based on proportions
	# TODO drop last city

	sums = Float64[]

	for repl in eachcol(count)
		push!(sums, sum(repl))
	end

	# normalize to proportions
	r = 1

	for repl in eachcol(count)
		repl ./= sums[r]
		r += 1
	end
	
	m_var, m_stdd = var_stdd(count)

	println(m_var, "\t", m_stdd)
end


const pars = par_combis()
const n_params = length(pars[1])
# all pars except rand seed
current = pars[1][1:n_params-1] 

for i in 2:length(pars)
	global current
	c = pars[i][1:n_params-1]
	if c != current || i == length(pars)
		variation(current)
		current = c
	end
end


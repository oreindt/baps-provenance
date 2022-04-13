using Statistics

include("script_utils.jl")

function correlate(pars)
	pref = join(pars, "_")
	files = data_files("cities.txt", "$pref*")
	
	data = Int[]

	for f in files
		# parse numbers here and put them directly into data
		d = parse_col(grep(f, "EXIT"), 8)
		push!(data, d)
	end

	# Mongolian, not Latin
	# => lines are cities, columns are replicates
	count = reshape(data, :, length(files))

	v = 0.0

	for row in eachrow(count)
		v += var(row)
	end

	println(v/size(count)[2])
end


const pars = par_combis()
const n_params = length(pars[1])
# all pars except rand seed
current = pars[1][1:n_params-1] 

for i in 2:length(pars)
	global current
	c = pars[i][1:n_params-1]
	if c != current || i == length(pars)
		correlate(current)
		current = c
	end
end


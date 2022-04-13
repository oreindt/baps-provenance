#!/usr/bin/env julia

push!(LOAD_PATH, pwd())

include("analysis.jl")
include("base/simulation.jl")
include("base/args.jl")


function run(p, stop, log_file, scenarios)
	sim = Simulation(setup_model(p), p)
	scen_data = []
	# setup scenarios
	for (setup,update) in scenarios
		dat = setup(sim)
		push!(scen_data, (update, dat))
	end

	t = 0.0
	RRGraph.spawn(sim.model, sim)
	while t < stop
		# run scenario update functions
		for (update, dat) in scen_data
			update(dat, sim, t)
		end

		RRGraph.upto!(t + 1.0)
		t += 1.0
		analyse_log(sim.model, log_file)
		println(t, " ", RRGraph.time_now())
		flush(stdout)
	end

	sim
end


using Params2Args
using ArgParse


include(get_parfile())
	

const arg_settings = ArgParseSettings("run simulation", autofix_names=true)

@add_arg_table! arg_settings begin
	"--stop-time", "-t"
		help = "at which time to stop the simulation" 
		arg_type = Float64
		default = 50.0
	"--par-file", "-p"
		help = "file name for parameter output"
		default = "params_used.jl"
#	"--model-file"
#		help = "file name for model data output"
#		default = "data.txt"
	"--city-file"
		help = "file name for city data output"
		default = "cities.txt"
	"--link-file"
		help = "file name for link data output"
		default = "links.txt"
	"--log-file", "-l"
		help = "file name for log"
		default = "log.txt"
	"--scenario", "-s"
		help = "load custom scenario code"
		nargs = '+'
	"--scenario-dir"
		help = "directory to search for scenarios"
		default = ""
end

add_arg_group!(arg_settings, "simulation parameters")
fields_as_args!(arg_settings, Params)

const args = parse_args(arg_settings, as_symbols=true)
const p = @create_from_args(args, Params)


save_params(args[:par_file], p)


const t_stop = args[:stop_time] 

scenarios = Tuple{Function, Function}[]
const scenario_files = args[:scenario]
scendir = args[:scenario_dir]
if scendir != ""
	scendir *= "/"
end
for sfile in scenario_files
	if sfile == "none"
		continue
	end
	functions = include(scendir * sfile * ".jl")
	push!(scenarios, functions)
end

const logf = open(args[:log_file], "w")
#const modelf = open(args[:model_file], "w")
const cityf = open(args[:city_file], "w")
const linkf = open(args[:link_file], "w")

prepare_outfiles(logf, cityf, linkf)
const sim = run(p, t_stop, logf, scenarios)

analyse_world(sim.model, cityf, linkf)

close(logf)
#close(modelf)
close(cityf)
close(linkf)

#!/usr/bin/env julia

include("script_utils.jl")

using Random

src_dir = "rumours_graph_CT"

push!(LOAD_PATH, pwd() * "/$src_dir/")

include("../$src_dir/base/simulation.jl")
include("../$src_dir/base/args.jl")
include("../$src_dir/analysis.jl")


function create(p)
	Random.seed!(p.rand_seed_world)
	create_world(p);
end

function optimal_path(world, par)
	agent = Agent(world.entries[1], 1.0)
	agent.info_loc = fill(Unknown, length(world.cities))
	agent.info_link = fill(UnknownLink, length(world.links))

	# find all cities
	for city in world.cities
		explore_at!(agent, world, city, 1.0, false, par)
	end
	
	# find all links
	for link in world.links
		explore_at!(agent, world, link, link.l1, 1.0, par)
	end

	for entry in world.entries
		agent.loc = entry
		make_plan!(agent, par)

		prev = world.cities[agent.plan[1].id]
		prev.count += 1
		for i in 2:length(agent.plan)
			loc = world.cities[agent.plan[i].id]
			loc.count += 1
			link = find_link(prev, loc)
			link.count += 1
			prev = loc
		end
	end
end


function save_optimal_path(world, dir)
	model = Model(world, [], [], [], [])
	cities_f = open(dir * "/cities_opt.txt", "w")
	links_f = open(dir * "/links_opt.txt", "w")
	print_header_final_city(cities_f)
	print_header_final_link(links_f)
	analyse_world(model, cities_f, links_f)
	close(cities_f)
	close(links_f)
end

include("../params.jl")
	

function optimal_path_for(dir, arg_settings)
	argv = get_cmd_line(dir)
	args = parse_args(argv, arg_settings, as_symbols=true)
	p = create_from_args(args, Params)

	world = create(p)

	optimal_path(world, p)
	save_optimal_path(world, dir)
end

const arg_settings = ArgParseSettings("run simulation", autofix_names=true)

@add_arg_table! arg_settings begin
	"--n-steps", "-t"
		help = "number of simulation steps" 
		arg_type = Float64
		default = 300.0
	"--par-file", "-p"
		help = "file name for parameters"
		default = "params.txt"
	"--out-file", "-o"
		help = "file name for data output"
		default = "output.txt"
	"--city-file"
		help = "file name for city output"
		default = "cities.txt"
	"--link-file"
		help = "file name for link output"
		default = "links.txt"
	"--log-file", "-l"
		help = "file name for log"
		default = "log.txt"
end

add_arg_group!(arg_settings, "simulation parameters")
fields_as_args!(arg_settings, Params)

const runs = data_dirs()

for dir in runs
	print(stderr, ".")
	optimal_path_for(dir, arg_settings)
end
println(stderr)

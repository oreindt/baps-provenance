mutable struct Run
	server :: String
	dir :: String
	id :: String
end

function create_run(remote_dir, args, id)
	tmpdir = "tmp/" * id
	mkpath(tmpdir)
	open(tmpdir * "/run", "w") do file
			script = """
				#!/bin/bash
				JULIA_LOAD_PATH=\$JULIA_LOAD_PATH:../rgct_data julia ../rgct_data/run.jl ../params.jl $args </dev/null >out 2>err

				julia ../format_results.jl 
				"""

			println(file, script)
		end

	open(tmpdir * "/submit", "w") do file
			script = """
				#!/bin/bash

				#PBS -l walltime=5:00:00,nodes=1:ppn=4

				cd $remote_dir/$id
				sh run
				"""
			println(file, script)
		end

	mkpath("incoming")
	run(`mv -n $tmpdir incoming/.`)
	end


	

function run_batch(server, remote_dir, prefix, args; wait_check = 10)
	runs = Run[]
	for (i, arg) in enumerate(args)
		id = prefix * string(i) * "_" * string(hash(arg))
		push!(runs, Run(server, remote_dir, id))
		create_run(remote_dir, arg, id)
		println("created $id")
	end

	running = true
	while running
		running = false
		xdirs = filter(x -> startswith(x, "x"), readdir("done"))
		for r in runs
			if ! (r.id in xdirs)
				running = true
			end
		end
		sleep(wait_check)
	end

	map(runs) do run
		map(split.(readlines("done/$(run.id)/summary.txt"))) do line
			parse.(Float64, line)
		end
	end
end

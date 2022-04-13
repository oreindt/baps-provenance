
function poll(server, remote_dir; batch_size=100, wait_submit=1, wait_poll=10)
	while true
		# *** start runs

		sleep(wait_poll)
		n = -1
		n_prev = 0
		xdirs = String[]
		# check incoming until we reach batch size or nothing new gets added
		while n<batch_size && n!=n_prev
			xdirs = filter(x -> startswith(x, "x"), readdir("incoming"))
			n_prev = n
			n = length(xdirs)
			sleep(1)
		end

		if !isempty(xdirs)
			ids = xdirs[1:min(batch_size, length(xdirs))]
			start_remotely(server, remote_dir, ids)
		end

		# *** finish runs

		xdirs = filter(x -> startswith(x, "x"), readdir("running"))
		if isempty(xdirs)
			continue
		end

		status = split.(readlines(`ssh $server cd $remote_dir '&&' ./check_runs.sh $(join(xdirs, " "))`))
		for s in status
			if s[2] == "done"
				finish_remotely(server, remote_dir, s[1])
				println("$(s[1]) done")
			end
		end
	end
end

function start_remotely(server, remote_dir, ids)
	run_dirs = "incoming/" .* ids
	println("attempting to copy $run_dirs to $(server):$(remote_dir)/submit/")
	run(`rsync -avz $run_dirs $(server):$(remote_dir)/submit/`)
	mkpath("running")
	run(`mv -n $run_dirs running/.`)

	println("starting $(join(ids, ' ')) on $server in directory $remote_dir")
	run(`ssh $server cd $remote_dir '&&' ./submit.sh`)
end


function finish_remotely(server, remote_dir, id)
	mkpath("done")
	run(`rsync -avz $(server):$(remote_dir)/$(id) running`)
	run(`mv -n running/$id done/.`)
end


poll("sotonhpc", "Science/southampon/runs/mediterranean")


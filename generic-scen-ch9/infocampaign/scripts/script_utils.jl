
macro sh_cmd(s_str)
    s_expr = Meta.parse(string('"', escape_string(s_str), '"'))
    return esc(:(Base.cmd_gen(("sh", "-c", $s_expr))))
end

grep(file, pattern) = collect(Iterators.filter(x -> occursin(pattern, x), eachline(file)))


data_dirs(pat="x_*") = readlines(sh`ls -d $pat`)
data_files(name, dirpat="x_*") = readlines(sh`ls -d $dirpat/$name`)
header(file) = split(readline(file))

function col_number(name, names)
	offset = occursin("#", names[1]) ? 1 : 0
	findfirst(isequal(name), names) - offset
end


function parse_params(dirnames)
	map(dirnames) do dir
		split(dir, '_')
	end
end

function par_combis(pat="x_*")
	parse_params(data_dirs(pat))
end


get_col(lines, n) = getindex.(split.(lines), n)
parse_col(lines, n, T = Int) = parse.(T, get_col(lines, n))


# cut away command and redirection, leaving only parameters
function get_cmd_line(dir)
	cmd = grep(dir * "/run", "julia")[1]
	cmd = replace(cmd, r"^.*params.jl " => "")
	cmd = replace(cmd, "\"" => "")
	split(replace(cmd, r" \<.*$" => ""))
end



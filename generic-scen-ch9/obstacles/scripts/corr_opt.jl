using Statistics

include("script_utils.jl")


function norm_dat(fname, col)
	dat = parse_col(readlines(fname)[2:end], col)
	s = sum(dat)

	dat ./ s
end

function corr(fname, col)
	dat = norm_dat(fname * ".txt", col)
	dat2 = norm_dat(fname * "_opt.txt", col)

	cor(dat, dat2)
end

const dirs = data_dirs()

count_col_l = col_number("count", header(dirs[1] * "/links.txt"))
count_col_c = col_number("count", header(dirs[1] * "/cities.txt"))

for dir in dirs
	corr_c = corr(dir * "/cities", count_col_c)
	corr_l = corr(dir * "/links", count_col_l)

	println(corr_c, "\t", corr_l)
end





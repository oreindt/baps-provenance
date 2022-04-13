using Statistics

include("script_utils.jl")

files = data_files("links.txt")
count_col = col_number("count", header(files[1]))

for file in files
	dat = parse_col(grep(file, "FAST"), count_col)

	m = sum(dat) / length(dat)
	stdd = std(dat, mean = m)

	println(m, "\t", stdd, "\t", stdd/m)
end





mkdir -p data

# *** parameters
echo parameters...

ruby scripts/get_pars.rb > data/pars.txt
ruby run.rb parameters | tr - _ | sed 's/0_[a-z]*_//g' > data/pars_title.txt
cat data/pars_title.txt data/pars.txt > data/pars.dat

# *** plain model output
echo model output...

head -n 1 `ls -d x* | head -n 1`/log.txt | tr -d "# " | sed -e 's/tsn_/ts\tn_/' > data/lla_title.txt
for file in x* ; do  tail -n 1 $file/log.txt; done > data/last_log_all.txt
cat data/lla_title.txt data/last_log_all.txt > data/lla.dat

paste data/pars.dat data/lla.dat > data/pars-lla.dat

# *** relative variance
echo relative variance...

ruby scripts/rel_var.rb < data/pars-lla.dat > data/rstdd.dat


# *** correlation of exit counts between replicates
echo corr exit counts...

( echo -e corr_c"\t"corr_c_e"\t"; julia scripts/corr_city_btw_repls.jl ) > data/city_corr_btw_repl.dat


# *** variation of link counts
echo var link counts...

( echo -e mean_link_c"\t"stdd_link_c"\t"rstdd_link_c; julia scripts/var_links.jl ) > data/var_links.dat


# *** max #migrants
echo max no. of migrants...

( echo -e max_n_migr"\t"t_max_n_migr; . scripts/max_n_migrants.sh ) > data/max_nm.dat
  

# *** optimal path
echo optimal path...

julia scripts/optimal_path.jl > /dev/null


# *** corr opt
echo correlation optimal path vs. realized...

( echo -e corr_opt_cities"\t"corr_opt_links; julia scripts/corr_opt.jl ) > data/corr_opt.dat


# *** paste everything into one file
echo collecting...

OUT_FILE=pars-lla-rs-cc-vl-mnm-co.dat

paste data/pars-lla.dat data/rstdd.dat data/city_corr_btw_repl.dat data/var_links.dat data/max_nm.dat data/corr_opt.dat > data/$OUT_FILE


# *** misc files
echo misc files...

# create gnplfile
head -n 1 data/$OUT_FILE| tr -d "# " | tr '\t' '\n' > data/gnplfile
# create plain text file for showall
tail -n +2 data/$OUT_FILE | sed 's/Infinity/1000000/g' > data/${OUT_FILE/.dat/.txt}


# *** sanity check
echo sanity checks..
nl1=$(( `wc -l < data/$OUT_FILE` - 1 ))
nl2=`ls -d x* | wc -l`
if [ x$nl1 != x$nl2 ] ; then
	echo wrong number of lines in data file: $nl1
fi

nl1=`head -n 1 data/$OUT_FILE | wc -w`
nl2=`tail -n 1 data/$OUT_FILE | wc -w`

if [ x$nl1 != x$nl2 ] ; then
	echo header and data inconsistent in $OUT_FILE
fi

for dir in `ls -d x_*` ; do
	cmp <(cut -f 1-5,7 < $dir/cities.txt) <(cut -f 1-5,7 < $dir/cities_opt.txt) || 
		echo $dir: cities and cities_opt differ
	cmp <(cut -f 1-5 < $dir/links.txt) <(cut -f 1-5 < $dir/links_opt.txt) ||
		echo $dir: links and links_opt differ
done


# *** variation of exit counts per city across replicates
echo var exit counts...

# calculate
julia scripts/var_per_city_across_repls.jl > data/var_across.txt
# parameters
awk 'NR % 10 == 0' data/pars.txt | ruby -ane 'puts $F[0...-1].join("\t")' > data/pars_NR.txt
paste data/pars_NR.txt data/var_across.txt > data/pars_NR-var_ax.txt
# header
( cat data/pars_title.txt | ruby -ane 'print $F[0...-1].join("\t")'
	echo -e "\tvar\trel_var\tstdd\trel_stdd\tprop_var\tprop_stdd"
   	cat data/pars_NR-var_ax.txt ) > data/pars_NR-var_ax.dat
# another gnplfile
head -n 1 data/pars_NR-var_ax.dat | tr '\t' '\n' > data/gnplfile_NR

logf=`ls -d x*/log.txt | head -n 1` 
col=`cat $logf | ruby scripts/col_by_name.rb n_migrants`

for file in x* ; do
	tail -n +2 $file/log.txt | 
		awk "BEGIN {mx=0}; \$$col > mx {mx = \$$col; line=NR}; END {print mx\"\\t\"line}"
done

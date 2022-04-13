
for file in x_* ; do
	if [ ! -e $file/out ] ; then
		echo run: $file no output
		continue
	fi
	
	if [ x`tail -n 1 $file/out | cut -d ' ' -f 1 | cut -d '.' -f 1` != x500 ] ; then
		echo run: $file not complete
	fi
done

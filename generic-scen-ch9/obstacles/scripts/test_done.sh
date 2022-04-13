for file in x_* ; do 
	if [ -s $file/out -a `tail -n 1 $file/out` == 500 ] ; then  
		continue
	fi
	echo $file
done

for file in $* ; do
	id=`cat $file/qsub_id`
	status=`qstat $id | tail -n 1 | tr -s " " | cut -d " " -f 5`
	case $status in
		"" | C)
			echo $file done
			;;
		R)
			echo $file running
			;;
		E)
			echo $file error
			;;
		*)
			echo $file waiting
			;;
	esac
	sleep 0.5
done

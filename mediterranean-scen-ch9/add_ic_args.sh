for dir in x*[0-9] ; do
	echo $dir
	cp -a $dir ${dir}_lt
	cp -a $dir ${dir}_ht
	
	cd ${dir}_ht && 
		{ 
		head -n 2 run | sed "s/<\/dev/ -s ..\/info_campaign '--trust 1.0' <\/dev/" > run.ic
		sed "s/mediterranean/risk-rumours_scenarios-ch9_med/;s/$dir/${dir}_ht/" < submit > submit.ic
		mv submit submit.old
		mv run run.old
		mv submit.ic submit
		mv run.ic run
		}

	cd ../${dir}_lt &&
		{
		head -n 2 run | sed "s/<\/dev/ -s ..\/info_campaign '--trust 0.5' <\/dev/" > run.ic
		sed "s/mediterranean/risk-rumours_scenarios-ch9_med/;s/$dir/${dir}_lt/" < submit > submit.ic
		mv submit submit.old
		mv run run.old
		mv submit.ic submit
		mv run.ic run
		} &&
		cd ..
done


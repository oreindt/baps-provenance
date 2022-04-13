first=`ls -d x*| head -n 1`

{ head -n 1 $first/log.txt; tail -n 1 -q x*lt/log.txt; } > last_all_lt.dat
{ head -n 1 $first/log.txt; tail -n 1 -q x*ht/log.txt; } > last_all_ht.dat
{ head -n 1 $first/log.txt; tail -n 1 -q orig/x*/log.txt; } > last_all_orig.dat


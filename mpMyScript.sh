#!/bin/bash

## Parameters legends
# $1 : Directory of which subdirectories are to be profiled.
# $2 : If left blank, all sub-directories of $1 will be run. Otherwise, the specified sub-directory will only be run.

## Define functions
runProfiler ()
{
        #echo "Running ${i} without profiling (${jobCount}/${maxJobs})"
        cmsRun makeMiniAOD.py

        ## Keep the existing root file
        #[ -f miniaod.root ] && mv miniaod.root miniaod.root.bak

        echo "Running ${i} with profiling (${jobCount}/${maxJobs})"
        igprof -mp -z -o "${i}MP.gz" cmsRun makeMiniAOD.py &> outMP.log

        ## Keep the existing sql3 file
        #[ -f "${i}MP.sql3" ] && mv "${i}MP.sql3" "${i}MP.sql3.bak"

        echo "Analysing ${i}"
        igprof-analyse --sqlite --value peak -d -v -g -r MEM_LIVE "${i}MP.gz" | sqlite3 "${i}MP.sql3"

        ## Copy sql3 report to cgi area
	echo "Copying report to cgi area"

	if [ ! -d ~/www/cgi-bin/data/MEM_LIVE ] ; then mkdir ~/www/cgi-bin/data/MEM_LIVE ; fi
        cp "${i}MP.sql3" ~/www/cgi-bin/data/MEM_LIVE

        echo "Finished running ${i} (${jobCount}/${maxJobs})"
}


## Try to go to directory specified by the parameter
if [ -z "$1" ] ; then 
	echo "Error: one parameter is required"; 
	exit;
elif [ -d $1 ] ; then

	## Set path
	ORIGINALDIR=$(pwd)
	MYHOME="/build/peerutb/CMSSW_7_4_6/src/MiniAODPerformanceStudies"
	cd $MYHOME

	cd $1
	echo " === cd to $(basename $(pwd)) === "

	subdirs=*
	jobCount=1
	maxJobs=$(ls -l . | grep -c ^d)
	
	## If $2 is specified, run with $2 only
	if [ -d $2 ] && [ ! -z "$2" ]; then
		subdirs="$2";  maxJobs=1;
	elif [ ! -d $2 ]; then echo "Error: $2 is not a directory"; exit; fi

	## Looping over its sub-directores
	for i in $subdirs ; do

		## Try to go to each sub-directory
		if [ -d $i ]; then

			cd $i
			echo " === now in $(basename $(pwd)) === "
			
			## The fun part. Run the profiler	
			runProfiler
			let jobCount+=1

			cd ..

		fi
		#[ ! -d $i ] && echo "Error: $i is not a directory"
	done

echo " === cd back "
cd ..

cd $ORIGINALDIR

fi

[ ! -d $1 ] && echo "Error: $1 is not a directory"


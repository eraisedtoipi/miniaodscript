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
        igprof -pp -z -o "${i}PP.gz" cmsRun makeMiniAOD.py &> outPP.log

        ## Keep the existing sql3 file
        #[ -f "${i}PP.sql3" ] && mv "${i}PP.sql3" "${i}PP.sql3.bak"

        echo "Analysing ${i}"
        igprof-analyse --sqlite --value peak -d -v -g "${i}PP.gz" | sqlite3 "${i}PP.sql3"

        ## Copy sql3 report to cgi area
	echo "Copying report to cgi area"

	if [ ! -d ~/www/cgi-bin/data ] ; then mkdir ~/www/cgi-bin/data ; fi
        cp "${i}PP.sql3" ~/www/cgi-bin/data

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


#!/bin/bash
## 
# $1 : input file contaning all directory in which makeMiniAOD.py file resides
# $2 : if specified 'mp', run memory profile; otherwise, run performance profile

profilePP()
{
	FILENAME=$(basename $(pwd))	
	#echo "Basename: $FILENAME"	

	echo "Running without profiling"
        #cmsRun makeMiniAOD.py

        echo "Running with profiling"
        #igprof -pp -z -o "${FILENAME}PP.gz" cmsRun makeMiniAOD.py &> PPout.log

        echo "Analysing"
        #igprof-analyse --sqlite -d -v -g "${FILENAME}PP.gz" | sqlite3 "${FILENAME}PP.sql3"

       	## Copy sql3 report to cgi area
        echo "Copying report to cgi area"

        #if [ ! -d ~/www/cgi-bin/data/PP ] ; then mkdir ~/www/cgi-bin/data ; fi
       	#cp "${FILENAME}PP.sql3" ~/www/cgi-bin/data
}

profileMP()
{
	FILENAME=$(basename $(pwd))	
	#echo $FILENAME	

        echo "Running without profiling"
       	#cmsRun makeMiniAOD.py

       	echo "Running with profiling"
        #igprof -mp -z -o "${FILENAME}MP.gz" cmsRun makeMiniAOD.py &> MPout.log

        echo "Analysing"
        #igprof-analyse --sqlite --value peak -d -v -g -r MEM_LIVE "${FILENAME}MP.gz" | sqlite3 "${FILENAME}MP.sql3"

        ## Copy sql3 report to cgi area
        echo "Copying report to cgi area"

        #if [ ! -d ~/www/cgi-bin/data/MEM_LIVE ] ; then mkdir ~/www/cgi-bin/data/MEM_LIVE ; fi
        #cp "${FILENAME}MP.sql3" ~/www/cgi-bin/data/MEM_LIVE
}

profileMP2()
{
	FILENAME=$(basename $(pwd))	
	#echo $FILENAME

	cd "$WORKDIR/checkMem"
	#echo "now profilemp2 at $(pwd)"
	python checkMem.py -n "$FILENAME" cmsRun "$WORKDIR/$line/makeMiniAOD.py"
	cd -
}
#
## Script starts here
#
if [[ ! -f "$1" ]]; then echo "Error: counldn't find file."
else 
	echo "Start time: $(date)"
	
	if [[ "$2" == "mp" ]]; then
		echo "MEMORY PROFILE"
	else
		echo "PERFORMANCE PROFILE"
	fi

	ORIGINALDIR=$(pwd)
	WORKDIR="/build/peerutb/CMSSW_7_4_6/src/MiniAODPerformanceStudies"
	cd "$WORKDIR"
	
	NUMFILES=$(more "$WORKDIR/codes/$1" | wc -l)
	COUNT=1
	while read line
	do
		echo "Now processing ($COUNT/$NUMFILES)"
		if [[ -d "$line" ]]; then
			#echo "Now in directory: $WORKDIR/$line"
			cd "$WORKDIR/$line"
			if [[ "$2" == "mp" ]]; then
				profileMP2
			else
				profilePP
			fi
			cd "$WORKDIR"
		elif [[ "$line" =~ ^#* ]]; then
			echo "Omitting directory \"$line\""
		else
			echo "Error: \"$line\" directory not found."
		fi
		echo "Finished processing ($COUNT/$NUMFILES)"
		COUNT=$[$COUNT+1]
	done < "$WORKDIR/codes/$1"

	echo "End time: $(date)"
fi


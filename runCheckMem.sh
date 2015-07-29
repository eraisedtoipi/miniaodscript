#!/bin/bash

target=("basketSize" "compressionAlgorLevel")

ORIGINALDIR=$(pwd)
WORKDIR="/build/peerutb/CMSSW_7_4_6/src/MiniAODPerformanceStudies"
echo "now at $(pwd)"

cd checkMem

echo "Start time: $(date)"

for i in $WORKDIR/* ; do
	if [[ -d $i ]] && ( [[ "$i" == *"basketSize"* ]] || [[ "$i" == *"compressionAlgorLevel"* ]] ) ; then 
		#echo $i		
		SUBWORKDIR1=$(basename $i)
		echo "$SUBWORKDIR1"
		
		for j in $i/* ; do
			if [[ -d $j ]] ; then
				#echo $j
				SUBWORKDIR2=$(basename $j)
				echo "$SUBWORKDIR2"
				
				python checkMem.py -n "$SUBWORKDIR2" cmsRun $j/makeMiniAOD.py
			fi
		done
		
	fi
done

cd "$ORIGINALDIR"

echo "End time: $(date)"

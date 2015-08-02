#!/bin/bash

runSimulation()
{

NOEVENTS=1000
FILENAME="$PARAM=$VALUE"
if [[ "$1"=~"^[0-9]+$" ]]; then NOEVENTS=$1; fi

# Step1: Measure CPU Ticks
echo "Profiling CPU Ticks of ${FILENAME}"
if [[ "$PARAM" == "compression" ]]; then
	#igprof -pp -z -o "${FILENAME}.gz" cmsRun myMakeMiniAOD.py maxEvents=$1 "compressionAlgorithm=${VALUE:0:4}" "compressionLevel=${VALUE:4}" outputFile="$WORKDIR/outputRootFile/miniaod_${FILENAME}.root" > "$WORKDIR/log/out_${FILENAME}.log"
else
	#igprof -pp -z -o "${FILENAME}.gz" cmsRun myMakeMiniAOD.py maxEvents=$1"${FILENAME}" outputFile="$WORKDIR/outputRootFile/miniaod_${FILENAME}.root" > "$WORKDIR/log/out_${FILENAME}.log"
fi
# Step 2: Measure Job Memory 
echo "Profiling Job Memory of ${FILENAME}"
if [[ "$PARAM" == "compression" ]]; then
	cd "$WORKDIR/checkMem"
	echo "now profilemp2 at $(pwd)"
	#python checkMem.py -n "$FILENAME" cmsRun myMakeMiniAOD.py maxEvents=$1 "compressionAlgorithm=${VALUE:0:4}" "compressionLevel=${VALUE:4}" outputFile="$WORKDIR/outputRootFile/miniaod_${FILENAME}.root"
	cd -
else
	cd "$WORKDIR/checkMem"
	echo "now profilemp2 at $(pwd)"
	#python checkMem.py -n "$FILENAME" cmsRun  myMakeMiniAOD.py maxEvents=$1"${FILENAME}" outputFile="$WORKDIR/outputRootFile/miniaod_${FILENAME}.root"
	cd -
fi

}

WORKDIR="/build/peerutb/CMSSW_7_4_6/src/MiniAODPerformanceStudies"
PARAMS=( "basketSize" "compression" "splitLevel" "eventAutoFlushCompressedSize" "fastCloning" "maxEvents" )

#for i in ${PARAMS[@]}; do
	#echo $i
	#while read line; do
	#	echo $line
	#done < "$WORKDIR/codes/input/${i}.txt"
#done

PARAM=""
VALUE=""
LINECOUNT=1
while IFS='' read -r line || [[ -n "$line" ]]; do
	# "#" marks the omission of the parameter
	if [[ "$line" == "#@"* ]]; then
		PARAM=
	# "#" marks the omission of the value
	elif [[ "$line" == "#"* ]]; then
		VALUE=
	# "@" marks the start of each parameter values
	elif [[ "$line" == "@"* ]]; then
		PARAM=${line##*@}
	# "$" marks the end of each parameter values
	elif [[ "$line" == \$ ]]; then
		PARAM=
	# run simulation with specified parameter and its value
	elif [[ ! -z "$line" && ! -z "$PARAM" ]]; then
		VALUE=$line
		runSimulation $1
	fi
#	echo "line no. $LINECOUNT param=$PARAM"
#	LINECOUNT=$[$LINECOUNT+1]
done < "$WORKDIR/codes/input/parameters.txt"

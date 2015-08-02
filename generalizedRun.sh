#!/bin/bash

runSimulation()
{

FILENAME="$PARAM=$VALUE"
NOEVENTS=1000
IGPROFOPTION="$FILENAME"
if [[ "$1"=~"^[0-9]+$" ]]; then NOEVENTS=$1; fi
if [[ "$PARAM" == "compression" ]]; then IGPROFOPTION="compressionAlgorithm=${VALUE:0:4} compressionLevel=${VALUE:4}"


# Step1: Measure CPU Ticks
echo "Profiling CPU Ticks of ${FILENAME}"
#igprof -pp -z -o "$WORKDIR/reports_raw/${FILENAME}.gz" cmsRun myMakeMiniAOD.py maxEvents=$1 "${IGPROFOPTION}" outputFile="$WORKDIR/outputRootFile/miniaod_${FILENAME}.root" > "$WORKDIR/log/out_${FILENAME}.log"
echo "Analysing"
#igprof-analyse --sqlite -d -v -g "$WORKDIR/reports_raw/${FILENAME}.gz" | sqlite3 "$WORKDIR/reports_web/${FILENAME}.sql3"
echo "Copying report to cgi area"
#cp "$WORKDIR/reports_web/${FILENAME}.sql3" ~/www/cgi-bin/data/results	

# Step 2: Measure Job Memory 
echo "Profiling Job Memory of ${FILENAME}"
cd "$WORKDIR/checkMem"
echo "now profilemp2 at $(pwd)"
python checkMem.py -n "$FILENAME" cmsRun myMakeMiniAOD.py maxEvents=$1 "${IGPROFOPTION}" outputFile="$WORKDIR/outputRootFile/miniaod_${FILENAME}.root"
cd -

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

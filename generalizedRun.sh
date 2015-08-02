#!/bin/bash
########### 
# $1 : number of input events
#
runSimulation()
{

FILENAME="$PARAM=$VALUE"
NOEVENTS=1
IGPROFOPTION="$FILENAME"
if [[ ! -z "$1" ]] && [[ "$1"=~"^[0-9]+$" ]]; then NOEVENTS=$1; fi
if [[ "$PARAM" == "compression" ]]; then IGPROFOPTION="compressionAlgorithm=${VALUE:0:4} compressionLevel=${VALUE:4}"; fi

# Step0: Run without Profiling
#echo "Run ${FILENAME} without profiling ($NOEVENTS events)"
#cmsRun $WORKDIR/codes/myMakeMiniAOD.py maxEvents=$NOEVENTS $IGPROFOPTION outputFile="$WORKDIR/output_step1/miniaod_${FILENAME}.root" > "$WORKDIR/log/out_${FILENAME}.log"

# Step1.1: Measure CPU Ticks
echo "Profiling CPU Ticks of ${FILENAME} ($NOEVENTS events)"
#echo "Option: ${IGPROFOPTION}"
igprof -pp -z -o "$WORKDIR/reports_raw/${FILENAME}.gz" cmsRun $WORKDIR/codes/myMakeMiniAOD.py maxEvents=$NOEVENTS $IGPROFOPTION outputFile="$WORKDIR/output_step1/miniaod_${FILENAME}.root" > "$WORKDIR/log/out_${FILENAME}.log"
echo "Analysing"
igprof-analyse -d -v -g "$WORKDIR/reports_raw/${FILENAME}.gz" >& "$WORKDIR/reports_txt/${FILENAME}.txt"
igprof-analyse --sqlite -d -v -g "$WORKDIR/reports_raw/${FILENAME}.gz" | sqlite3 "$WORKDIR/reports_web/${FILENAME}.sql3"
echo "Copying report to cgi area"
cp "$WORKDIR/reports_web/${FILENAME}.sql3" ~/www/cgi-bin/data/results	

# Step 1.2: Measure Job Memory 
echo "Profiling Job Memory of ${FILENAME} ($NOEVENTS events)"
cd "$WORKDIR/checkMem"
echo "now profilemp2 at $(pwd)"
python checkMem.py -n "$FILENAME_$NOEVENTS" cmsRun $WORKDIR/codes/myMakeMiniAOD.py maxEvents=$NOEVENTS $IGPROFOPTION outputFile="$WORKDIR/output_step2/miniaod_${FILENAME}.root"
cd -

}

##### Here begins the script #####
#
WORKDIR="/build/peerutb/CMSSW_7_4_6/src/MiniAODPerformanceStudies"

echo "Start time: $(date)"

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

echo "End time: $(date)"


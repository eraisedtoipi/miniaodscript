WORKDIR="/build/peerutb/CMSSW_7_4_6/src/MiniAODPerformanceStudies"
cd $WORKDIR

rm reports_*/*
rm output_step*/*
rm checkMem/*.log
rm checkMem/*.out

ls -lh reports_*/ output_step*/ checkMem/

cd -

rm ~/www/cgi-bin/data/results/*
ls -lh ~/www/cgi-bin/data/results

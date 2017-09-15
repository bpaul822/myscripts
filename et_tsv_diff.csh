#!/bin/sh

#readme : to run this file go to atpg run path , ~/et_tsv_diff.csh
#dont use source command in the  run

echo "" 
echo "golden run path is"  
NAME="/proj/muska/bpaul//sos_bpaul/dig_impl/muska/atpg_Cortex_only_with_fullscan_topup_modified/log/et_tsv.log"
echo "$NAME" 

echo "" 
echo "current run path is"  
pwd      

#this is the path of the current run
ls ../log/et_tsv.log | xargs grep TSV | sed -e 's/TSV-900.*$/TSV-900/' > tsv_logs_cr

#this is the path of the golden run
ls  $NAME | xargs grep TSV | sed -e 's/TSV-900.*$/TSV-900/' | sed -e 's/.*\/log\//..\/log\//'> tsv_logs_golden
#ls /proj/muska/bpaul//sos_bpaul/dig_impl/muska/atpg_Cortex_only/log/et_tsv.log | xargs grep TSV | sed -e 's/TSV-900.*$/TSV-900/' | sed -e 's/.*\/log\//..\/log\//'> tsv_logs_golden

#take a diff b/w golden with current run
tkdiff tsv_logs_golden tsv_logs_cr 
#diff tsv_logs_golden tsv_logs_cr 

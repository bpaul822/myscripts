#This script is used to combine all the sta reports across different rc corners from 2 sta runs and find the flops which are not present in one run but present in the other 
#search for todo and edit the path based on the requirements

#this combines all the relevant sta reports where violations are present, in this case for scan shift 
#todo change the path 
cat ../sta_tps_1p32_cgull_fix/rep/*shift*/drv.all_viol.rep > all_tt_viol
cat rep/*shift*/drv.all_viol.rep > all_ull_alone_tt_viol

#based on the below pattern it extract the scan hold violation from the combined report
sed -n '/in_delay\/hold {SCAN_CLK}/,/Check type/p' all_tt_viol >  all_tt_viol_final
sed -n '/in_delay\/hold {SCAN_CLK}/,/Check type/p' all_ull_alone_tt_viol >  all_ull_alone_tt_viol_final

#get all the flop names
awk '{print $1}' all_tt_viol_final | grep muska > all_tt_viol_final_flops
awk '{print $1}' all_ull_alone_tt_viol_final | grep muska >  all_ull_alone_tt_viol_final_flops

#get the uniq list  of flops 
cat all_tt_viol_final_flops | sort | uniq > all_tt_viol_final_flops_uniq 
cat all_ull_alone_tt_viol_final_flops | sort | uniq > all_ull_alone_tt_viol_final_flops_uniq

#find the difference b/w the flops present in one file  but not in other 
fgrep -x -f all_tt_viol_final_flops_uniq -v all_ull_alone_tt_viol_final_flops_uniq 
fgrep -x -f all_ull_alone_tt_viol_final_flops_uniq -v all_tt_viol_final_flops_uniq  

reference of diff from my alias
##grep -f diff_file2file1 file2 > File_3
#alias linediff 'awk '\''FNR==NR{a[$0]++;next}(!($0 in a))'\'''
##the above fails if there are multiple fields seperated by white space, in the case below one works.
##diff -w file1 file2 | grep +
##grep -f File_1 File_2 > File_3
##above grp  command can be use to grep for field in file_1 which are present in file 2
##below are alternatives for line diff
##awk 'FNR==NR{a[$0]++;next}(!($0 in a))' file1 file2
##fgrep -x -f file2 -v file1

#! /bin/tcsh

echo ""  
pwd      

#run this script from atpg/run path
#this assume 50*10-9sec as your scan clock period. For
#other scan period change this after priting from the final awk
#the tester_time reported is in seconds

#echo "" 
#echo -n "Total number of testermodes ,"; ls -1 ../out/*WGL*/cycle* | wc -l 
#echo "" 
#echo "Testtime break up for all testmodes:" 
#ls -art ../out/*WGL*/cycle*  > temp11
#sed -i -- 's/.*cycleMap.//g' temp11
#
#ls -art ../out/*WGL*/cycle* | xargs tail -n -1 | grep end_of_scan | awk '{print $1*50*(10**-9)}' > temp22
#
##here OFS = is the seperator to concatinate temp11 temp22 
#awk 'BEGIN { OFS=" ,= "} FNR==NR { a[(FNR"")] = $0; next } { print a[(FNR"")], $0 }' temp11 temp22 
#
#echo -n "Total tester time equal ,=" 
#ls ../out/*WGL*/cycle* | xargs tail -n -1 | grep end_of_scan | \
#awk '{print $1}' | awk '{s+=$0} END {print s*50*(10**-9) }'  
#
#
#echo "" 
#echo "Coverage break up for all testmodes:" 
#
#
#
##scan chain coverage
#ls -art ../rep/*create*scanchain* |xargs cat | grep "Testmode Statistics:" -A 11 | grep "Global Statistics" -A 4 | awk '{print $9}' | grep -v '^$' > temp55
#ls -art ../rep/*create*scanchain* | xargs cat | grep "Testmode Statistics:" | awk '{print $1" "$2" "$3" "",Static Coverage \n ,Dynamic Coverage"}' > temp77
#awk 'BEGIN { OFS=" ,= "} FNR==NR { a[(FNR"")] = $0; next } { print a[(FNR"")], $0 }' temp77 temp55 > temp_7755 
#grep "Static Coverage" temp_7755 | awk '{print $7}' | awk 'NR-1{print $0-p}{p=$0}' | sed '0~2d' > static_chain
#grep "Dynamic Coverage" temp_7755 | awk '{print $4}' |awk 'NR-1{print $0-p}{p=$0}' | sed '0~2d' > dynamic_chain 
#ls -art ../rep/*create*scanchain* | xargs cat | grep "Testmode Statistics:" | awk '{print$3}' | uniq > chain_mode
#echo "Coverage for create chain"
#echo "Testmode,Static Coverage,Dynamic Coverage"
##join -t, chain_mode static_logic dynamic_logic
#paste chain_mode static_chain dynamic_chain | awk '{print $1,"," $2,"," $3}'




#logic chain coverage
ls -art ../rep/*create*logic* |xargs cat | grep "Testmode Statistics:" -A 11 | grep "Global Statistics" -A 4 | awk '{print $9}' | grep -v '^$' > temp333
ls -art ../rep/*create*logic* | xargs cat | grep "Testmode Statistics:" | awk '{print $1" "$2" "$3" "",Static Coverage \n ,Dynamic Coverage"}' > temp444
awk 'BEGIN { OFS=" ,= "} FNR==NR { a[(FNR"")] = $0; next } { print a[(FNR"")], $0 }' temp444 temp333 > temp_444333
grep "Static Coverage" temp_444333 | awk '{print $7}' | awk 'NR-1{print $0-p}{p=$0}' | sed '0~2d' > static_logic
grep "Dynamic Coverage" temp_444333 | awk '{print $4}' |awk 'NR-1{print $0-p}{p=$0}' | sed '0~2d' > dynamic_logic 
ls -art ../rep/*create*logic* | xargs cat | grep "Testmode Statistics:" | awk '{print$3}' | uniq > logic_mode
#echo "" 
#echo "Coverage for create logic"
#echo "Testmode,Static Coverage,Dynamic Coverage"
##join -t, logic_mode static_logic dynamic_logic
#paste logic_mode static_logic dynamic_logic | awk '{print $1,"," $2,"," $3}'



#total coverage
echo "" 
echo "Total Coverage" 
#reporting coverage, please change the below 
#report(path as well as name) ifnot the right one 
echo "                         Faults    Tested      Redund  TCov  ATCov" 
cat ../rep/muska_static_coverage.rep | grep Total | head -3 | tail -2     
echo "" 
rm logic_mode dynamic_logic static_logic temp_444333 temp444 temp333 dynamic_chain chain_mode static_chain temp_7755 temp77 temp55  temp11 temp22

echo "Note1: Each test modes have 2 sets of static and dynamic coverage 1st being the \n starting coverage of that testmode and the 2nd being the ending coverage" 
echo "Note2: Check if the final dynamic/static coverage is matching with the last mode in static/dynamic mode" 
#*create*logic can be used to extract only from logic 
ls -art ../rep/*create* |xargs cat | grep "Testmode Statistics:" -A 11 | grep "Global Statistics" -A 4 | awk '{print $9}' | grep -v '^$' > temp33
ls -art ../rep/*create* | xargs cat | grep "Testmode Statistics:" | awk '{print $1" "$2" "$3" "",Static Coverage \n ,Dynamic Coverage"}' > temp44
awk 'BEGIN { OFS=" ,= "} FNR==NR { a[(FNR"")] = $0; next } { print a[(FNR"")], $0 }' temp44 temp33 
grep Sequences ../log/dynamic.log -A 2 | grep -v Sequences | grep -v -
rm temp44 temp33

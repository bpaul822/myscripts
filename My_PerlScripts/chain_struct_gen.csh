#! /bin/sh
#author: bpaul

#1.	Copy to your report path
#2.	Command to run: 
#
#tcsh chain_struct_gen.csh  <input file>
#eg: tcsh chain_struct_gen.csh build_ATPG_report_test_structures_FULLSCAN.rep
#3.	In the run directory you will see the line hold file with the name Chainn_holdfile
#where n = number of chains 
#for cortex and tensilica n = 8 , cortex only n=6.
#Let me know if you face any issue.


#extract the chains
sed -n '/Controllable Scan Chain 1/,/Report completed/p' $1  > extract_chains
echo "report test structure input file is : $1"

#split the chains into different files  based on starting "Controllable Scan Chain"
awk '/Controllable Scan Chain/{x="Chain"++i;}{print > x;}' extract_chains

#remove flops which are not true flops based on 5th field
awk '($5 ~ /^[0-9]+$/)' Chain1 > Chain1_true_flops
awk '($5 ~ /^[0-9]+$/)' Chain2 > Chain2_true_flops
awk '($5 ~ /^[0-9]+$/)' Chain3 > Chain3_true_flops
awk '($5 ~ /^[0-9]+$/)' Chain4 > Chain4_true_flops
awk '($5 ~ /^[0-9]+$/)' Chain5 > Chain5_true_flops
awk '($5 ~ /^[0-9]+$/)' Chain6 > Chain6_true_flops
awk '($5 ~ /^[0-9]+$/)' Chain7 > Chain7_true_flops
awk '($5 ~ /^[0-9]+$/)' Chain8 > Chain8_true_flops

#add hold keyword
sed -i -- 's/.*u_muskaDigital_top/report_timing -early -path_type full_clock -to u_muskaDigital_top/g' Chain*true* 

#this line is commented"

#remove last 1 field 
sed -r 's/(.[^.]*){1}$//' Chain1_true_flops > Chain1_holdfile
sed -r 's/(.[^.]*){1}$//' Chain2_true_flops > Chain2_holdfile
sed -r 's/(.[^.]*){1}$//' Chain3_true_flops > Chain3_holdfile
sed -r 's/(.[^.]*){1}$//' Chain4_true_flops > Chain4_holdfile
sed -r 's/(.[^.]*){1}$//' Chain5_true_flops > Chain5_holdfile
sed -r 's/(.[^.]*){1}$//' Chain6_true_flops > Chain6_holdfile
sed -r 's/(.[^.]*){1}$//' Chain7_true_flops > Chain7_holdfile
sed -r 's/(.[^.]*){1}$//' Chain8_true_flops > Chain8_holdfile

#remove __i3 to __i7 primitive
sed -i -- 's/.__i1//g' Chain*hold*
sed -i -- 's/.__i2//g' Chain*hold*
sed -i -- 's/.__i3//g' Chain*hold*
sed -i -- 's/.__i4//g' Chain*hold*
sed -i -- 's/.__i5//g' Chain*hold*
sed -i -- 's/.__i6//g' Chain*hold*
sed -i -- 's/.__i7//g' Chain*hold*

##remove __i3 to __i7 primitive
#sed -i -- 's/.__i1.dff_primitive//g' Chain*hold*
#sed -i -- 's/.__i2.dff_primitive//g' Chain*hold*
#sed -i -- 's/.__i3.dff_primitive//g' Chain*hold*
#sed -i -- 's/.__i4.dff_primitive//g' Chain*hold*
#sed -i -- 's/.__i5.dff_primitive//g' Chain*hold*
#sed -i -- 's/.__i6.dff_primitive//g' Chain*hold*
#sed -i -- 's/.__i7.dff_primitive//g' Chain*hold*

#add assign reg.Q equals the required hold value
sed -i'.bak' 's/$/ >> timing_rep_chain1/' Chain1_holdfile
sed -i'.bak' 's/$/ >> timing_rep_chain2/' Chain2_holdfile
sed -i'.bak' 's/$/ >> timing_rep_chain3/' Chain3_holdfile
sed -i'.bak' 's/$/ >> timing_rep_chain4/' Chain4_holdfile
sed -i'.bak' 's/$/ >> timing_rep_chain5/' Chain5_holdfile
sed -i'.bak' 's/$/ >> timing_rep_chain6/' Chain6_holdfile
sed -i'.bak' 's/$/ >> timing_rep_chain7/' Chain7_holdfile
sed -i'.bak' 's/$/ >> timing_rep_chain8/' Chain8_holdfile


#remove intermediate files
rm Chain6
rm Chain5
rm Chain4
rm Chain3
rm Chain2
rm Chain1
rm Chain1_true_flops
rm Chain2_true_flops
rm Chain3_true_flops
rm Chain4_true_flops
rm Chain5_true_flops
rm Chain6_true_flops
rm Chain7_true_flops
rm Chain8_true_flops
rm Chain1_holdfile.bak
rm Chain2_holdfile.bak
rm Chain3_holdfile.bak
rm Chain4_holdfile.bak
rm Chain5_holdfile.bak
rm Chain6_holdfile.bak
rm Chain7_holdfile.bak
rm Chain8_holdfile.bak
rm extract_chains

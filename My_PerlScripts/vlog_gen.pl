#!/usr/bin/perl
require "/home/bibin/bin/sub_func_def.pl";

#######################################################################################
##  $Source  : /home/bibin/bin/vlog_gen.pl                                     
##  $Date    : 22nd Nov 2013                                                         
##  $Author  : Bibin                                                      
##  $Revision: 1.00                                                                  
#######################################################################################
#                                                                                  
# Revision: 1.00                                                                     
# Currently This file parses test-chip multiplxing xls and generate verliog file                             
#   use>> dos2unix tc_agni_r201_s28hk_bondout_csv.csv
#######################################################################################


use Term::ANSIColor;

$csv_file = "./tc_agni_r201_s28hk_bondout_csv.csv";

$COL_SIG_NAME = 1;
$COL_SIG_DIR = 2;
$COL_SIG_WIDTH = 3;
$COL_HAND_WRITTEN = 9;
$COL_CONN_ASSUMPTION = 10;

$out_port_code_ip  = "\n\t//Ouput Port declaration for CORE\n";
$in_port_code_ip   = "\n\t//Input Port declaration for CORE\n";
$out_port_code_pad = "\n\t//Ouput Port declaration for PAD\n";
$in_port_code_pad  = "\n\t//Input Port declaration for PAD\n";

$reg_address =0;

########## Reading Ports
if(-f "$csv_file")
{
    open (fp,"$csv_file") or die( "Can't open $csv_file for READING\n");
    open (VLOG,">tc_padmux_to_ip.v") or die( "Can't open tc_padmux_to_ip.v for WRITING\n");
    while(<fp>)
    { chomp;
      $line =$_;
        if($line !~ /^\s*Domain/ && $line !~ /^.*\$PORT_END/ && $line !~ /^\s*$/) ##Avoid Commented line
        {
                @words=split(",",$line);
                $sig_name=$words[$COL_SIG_NAME];
                $sig_dir=$words[$COL_SIG_DIR];
                $sig_width=$words[$COL_SIG_WIDTH];
                $hand_written=$words[$COL_HAND_WRITTEN];
                $conn_assumption=$words[$COL_CONN_ASSUMPTION]; $conn_assumption =~ s/\s+$//; 
		
                if($hand_written =~ /connect to/)
		{
                	if($sig_dir =~ /I/)
			{
                                $connect = $hand_written; $connect =~ s/connect to (\S+)/\1/;
                                $assign_code = $assign_code . "\to_${$sig_name}_ip = i_${connect}_ip;\n";
                                if(!present_in_list("o_${$sig_name}_ip",@out_port_code_ip_list))  
                                {
                                        push @out_port_code_ip_list, "o_${$sig_name}_ip";
                                        $out_port_code_ip = $out_port_code_ip . "\toutput reg        o_${$sig_name}_ip,\n";
                                }
                                if(!present_in_list("i_${connect}_ip",@in_port_code_ip_list))  
                                {
                                        push @in_port_code_ip_list, "i_${connect}_ip";
                                        $in_port_code_ip = $in_port_code_ip . "\tinput         i_${connect}_ip,\n";
                                }
			}
                        else
                        {
                        	print "Error!! ${sig_name}: Not supported for \"connect to\" type\n"
                        }
                }
                elsif($hand_written =~ /assign/)
		{
                	if($sig_dir =~ /O/)
			{
                                $assign_code = $assign_code . "\t${conn_assumption}_pad = i_${sig_name}_ip;\n";

				if($sig_width == 1)
                                {  
                                	if(!present_in_list("${conn_assumption}_pad",@out_port_code_pad_list))  
                                        {
                                        	push @out_port_code_pad_list, "${conn_assumption}_pad";
                                        	$out_port_code_pad = $out_port_code_pad . "\toutput reg        ${conn_assumption}_pad,\n";
                                        }
                                        if(!present_in_list("i_${sig_name}_ip",@in_port_code_ip_list))  
                                        {
                                        	push @in_port_code_ip_list, "i_${sig_name}_ip";
                                                $in_port_code_ip = $in_port_code_ip . "\tinput         i_${sig_name}_ip,\n";
                                        }
                                }
				else
                                {
                                	if(!present_in_list("${conn_assumption}_pad",@out_port_code_pad_list))  
                                        {
                                        	push @out_port_code_pad_list, "${conn_assumption}_pad";
                                                $tc_reg_def_code = $tc_reg_def_code  . "\treg  [" . ($sig_width -1) . ":0] ${conn_assumption}_pad;\n";
                                        	for ($i=$sig_width -1; $i >=0 ; $i--)
                                                {
                                                     $out_port_code_pad = $out_port_code_pad . "\toutput reg ${conn_assumption}_${i}_pad,\n";
                                                     $assign_split_code = $assign_split_code . "\t${conn_assumption}_${i}_pad = ${conn_assumption}_pad[${i}];\n";
                                                }
                                                
                                        }
                                        if(!present_in_list("i_${sig_name}_ip",@in_port_code_ip_list))   
                                        {
                                        	push @in_port_code_ip_list, "i_${sig_name}_ip";
                                        	$in_port_code_ip = $in_port_code_ip .  "\tinput  [" . ($sig_width - 1) . ":0] i_${sig_name}_ip,\n";
                                        }
                                }
                                
			}
                	elsif($sig_dir =~ /I/)
			{
                                	$assign_code = $assign_code . "\to_${sig_name}_ip = ${conn_assumption}_pad;\n";
                                
				if($sig_width == 1)
                                {  
                                	if(!present_in_list("o_${sig_name}_ip",@out_port_code_ip_list))  
                                        {
                                        	push @out_port_code_ip_list, "o_${sig_name}_ip";
                                        	$out_port_code_ip = $out_port_code_ip . "\toutput reg        o_${sig_name}_ip,\n";
                                        }
                                        if(!present_in_list("${conn_assumption}_pad",@in_port_code_pad_list))  
                                        {
                                        	push @in_port_code_pad_list, "${conn_assumption}_pad";
                                        	$in_port_code_pad = $in_port_code_pad .  "\tinput          ${conn_assumption}_pad,\n";
                                        }
                                }
				else
                                {
                                	if(!present_in_list("o_${sig_name}_ip",@out_port_code_ip_list))  
                                        {
                                        	push @out_port_code_ip_list, "o_${sig_name}_ip";
                                        	$out_port_code_ip = $out_port_code_ip . "\toutput reg [" . ($sig_width - 1) . ":0] o_${sig_name}_ip,\n";
                                        }
                                        if(!present_in_list("${conn_assumption}_pad",@in_port_code_pad_list))   
                                        {
                                        	push @in_port_code_pad_list, "${conn_assumption}_pad";
                                                $tc_reg_def_code = $tc_reg_def_code  . "\treg  [" . ($sig_width -1) . ":0] ${conn_assumption}_pad;\n";
                                        	for ($i=$sig_width -1; $i >=0 ; $i--)
                                                {
                                                     $in_port_code_pad = $in_port_code_pad . "\tinput      ${conn_assumption}_${i}_pad,\n";
                                                     $assign_split_code = $assign_split_code . "\t${conn_assumption}_pad[${i}] = ${conn_assumption}_${i}_pad;\n";
                                                }
                                        }
                                }
                                
			}
                        else
                        {
                        	print "Error!! $sig_name: This case not considered\n";
                        }
                
                }
                elsif($hand_written =~ /config reg/)
		{
			if($sig_dir =~ /O/)
			{
				print "Error!! $sig_name : for Output pin config reg is recommended\n";
			}
			else
			{
				$assign_code = $assign_code . "\to_${sig_name}_ip = TC_${sig_name}_reg;\n";
                                if(!present_in_list("TC_${sig_name}_reg",@tc_reg_list))
                                {
                                	push @tc_reg_list, "TC_${sig_name}_reg";
                                        if($sig_width == 1){ $tc_reg_def_code = $tc_reg_def_code . "\treg    TC_${sig_name}_reg;\n";}
                                        else{ $tc_reg_def_code = $tc_reg_def_code . "\treg  [" . ($sig_width - 1) . ":0] TC_${sig_name}_reg;\n";}
                                }
				
				$define_code = $define_code . "`define DEF_ADD_$sig_name $reg_address\n";
				$reg_address = $reg_address + (int( ($sig_width + 7) /8 ));
				
				if($sig_width == 1 && !present_in_list($out_port_code_ip,@out_port_code_ip_list))
                                {  
                                	push @out_port_code_ip_list, $out_port_code_ip;
                                        $out_port_code_ip = $out_port_code_ip . "\toutput reg        o_${sig_name}_ip,\n";
                                }
				elsif($sig_width != 1 && !present_in_list($out_port_code_ip,@out_port_code_ip_list))
                                {
                                	push @out_port_code_ip_list, $out_port_code_ip;
                                        $out_port_code_ip = $out_port_code_ip . "\toutput reg [" . ($sig_width - 1) . ":0] o_${sig_name}_ip,\n";
                                }
			}
		}
		elsif($hand_written =~ /status reg/)
		{
			if($sig_dir =~ /I/)
			{
				print "Error!! $sig_name : for Input pin status reg is recommended\n";
			}
			else
			{
				$assign_code = $assign_code . "\tTC_${sig_name}_reg = i_${sig_name}_ip;\n";
                                if(!present_in_list("TC_${sig_name}_reg",@tc_reg_list))
                                {
                                	push @tc_reg_list, "TC_${sig_name}_reg";
                                        if($sig_width == 1){ $tc_reg_def_code = $tc_reg_def_code . "\treg    TC_${sig_name}_reg;\n";}
                                        else{ $tc_reg_def_code = $tc_reg_def_code . "\treg  [" . ($sig_width - 1) . ":0] TC_${sig_name}_reg;\n";}
                                }

				$define_code = $define_code . "`define DEF_ADD_$sig_name $reg_address\n";
				$reg_address = $reg_address + (int( ($sig_width + 7 )/8 ));
				
				if($sig_width == 1 && !present_in_list($in_port_code_ip,@in_port_code_ip_list))
                                {  
                                	push @in_port_code_ip_list, $in_port_code_ip;
                                        $in_port_code_ip = $in_port_code_ip . "\tinput 	    i_${sig_name}_ip,\n";
                                }
				elsif($sig_width != 1 && !present_in_list($in_port_code_ip,@in_port_code_ip_list))
                                {
                                	push @in_port_code_ip_list, $in_port_code_ip;
                                        $in_port_code_ip = $in_port_code_ip . "\tinput  [" . ($sig_width - 1) . ":0] i_${sig_name}_ip,\n";
                                }
			}
		}
		elsif($hand_written =~ /mux based on TC_[\w\[:\]]+=/)
		{
			if($sig_dir =~ /O/)
			{
				##print "debug: $sig_name, $hand_written\n";
				$mux_sel = $hand_written; $mux_sel =~ s/mux based on (TC_\S+)=(\d+)/\1/;
				$mux_in = $2;
				$mux_range = $mux_sel; 
				if($mux_sel !~ /\[/){$mux_range = 2;}
				elsif($mux_sel =~ /\[1:0\]/){$mux_range = 4;}
				elsif($mux_sel =~ /\[2:0\]/){$mux_range = 8;}
				elsif($mux_sel =~ /\[3:0\]/){$mux_range = 16;}
				else{print "Error!! $mux_sel: Mux range nut supported\n";}
				
				if(!present_in_list($mux_sel,@mux_sel_list))  
                                {
                                	push @mux_sel_list, $mux_sel;
                                	$define_code = $define_code . "`define DEF_ADD_$mux_sel $reg_address\n";
					$reg_address = $reg_address + 1;
                                }
				$mux_sel_code = $mux_sel . "_code_" . $mux_in;
                                
                                if(!present_in_list("$mux_sel",@tc_reg_list))
                                {
                                	$tc_reg = $mux_sel; 
                                        push @tc_reg_list, "$mux_sel";
                                        if($tc_reg =~ /(\S+)(\[\S+)/){$tc_reg =~ s/(\S+)(\[\S+)/\1/; $reg_width = $2;}
                                        else{$reg_width = "        ";}
                                        $tc_reg_def_code = $tc_reg_def_code . "\treg   $reg_width $tc_reg;\n";
                                }
				
                                if(!present_in_list("${conn_assumption}_pad",@out_port_code_pad_list))
                                {
                                	push @out_port_code_pad_list, "${conn_assumption}_pad";
                                        $out_port_code_pad = $out_port_code_pad . "\toutput reg         ${conn_assumption}_pad,\n";
                                }
                                if(!present_in_list("i_${sig_name}_ip",@in_port_code_ip_list))
                                {
                                	push @in_port_code_ip_list, "i_${sig_name}_ip";
                                        $in_port_code_ip = $in_port_code_ip . "\tinput          i_${sig_name}_ip,\n";
                                }
                                $$mux_sel_code = $$mux_sel_code . "\t\t${conn_assumption}_pad = i_${sig_name}_ip;\n";
				%mux_sel_range_map = (%mux_sel_range_map, $mux_sel,$mux_range);
			}
			else
			{
				print "Error!! $hand_written with input is not supported\n";
			}
		}
		elsif($hand_written =~ /mux based on TC_[\w\[:\]]+/)
		{
		        
                        ##print "debug: $hand_written\n";
			$mux_sel = $hand_written; $mux_sel =~ s/mux based on (TC_\S+).*/\1/;
			$mux_range = $mux_sel; 
			if($mux_sel !~ /\[/){$mux_range = 2;}
			elsif($mux_sel =~ /\[1:0\]/){$mux_range = 4;}
			elsif($mux_sel =~ /\[2:0\]/){$mux_range = 8;}
			elsif($mux_sel =~ /\[3:0\]/){$mux_range = 16;}
			else{print "Error!! $mux_sel: Mux range nut supported\n";}

			if($mux_range == 16)
			{
			     if($sig_name =~ /_RX0$/){$mux_in = 8;}
			     elsif($sig_name =~ /_RX1$/){$mux_in = 9;}
			     elsif($sig_name =~ /_RX2$/){$mux_in = 10;}
			     elsif($sig_name =~ /_RX3$/){$mux_in = 11;}
			     elsif($sig_name =~ /_TX0$/){$mux_in = 12;}
			     elsif($sig_name =~ /_TX1$/){$mux_in = 13;}
			     elsif($sig_name =~ /_TX2$/){$mux_in = 14;}
			     elsif($sig_name =~ /_TX3$/){$mux_in = 15;}
			     elsif($sig_name =~ /_CRX$/){$mux_in = 7;}
			     elsif($sig_name =~ /_CTX$/){$mux_in = 6;}
			     elsif($sig_name =~ /_CMN$/){$mux_in = 5;}
			     elsif($sig_name =~ /_TC$/){$mux_in = 0;}
			     elsif($sig_name =~ /_TC$/){$mux_in = 1;}
			     elsif($sig_name =~ /_TC$/){$mux_in = 2;}
			     elsif($sig_name =~ /_TC$/){$mux_in = 3;}
			     elsif($sig_name =~ /_TC$/){$mux_in = 4;}
			     else{print "Error!! $sig_name: mux(16:1) for the signal not having proper suffix (_RX*, _TX*, _CRT/CRX/CMN, _TC)\n";}
			}
			elsif($mux_range == 8)
			{
			     if($sig_name =~ /_RX0$/){$mux_in = 0;}
			     elsif($sig_name =~ /_RX1$/){$mux_in = 1;}
			     elsif($sig_name =~ /_RX2$/){$mux_in = 2;}
			     elsif($sig_name =~ /_RX3$/){$mux_in = 3;}
			     elsif($sig_name =~ /_TX0$/){$mux_in = 4;}
			     elsif($sig_name =~ /_TX1$/){$mux_in = 5;}
			     elsif($sig_name =~ /_TX2$/){$mux_in = 6;}
			     elsif($sig_name =~ /_TX3$/){$mux_in = 7;}
			     else{print "Error!! $sig_name: mux(8:1) for the signal not having proper suffix (_RX*, _TX*)\n";}
			}
			elsif($mux_range == 4 && $mux_sel =~ /RX/)
			{
			     if($sig_name =~ /_RX0$/){$mux_in = 0;}
			     elsif($sig_name =~ /_RX1$/){$mux_in = 1;}
			     elsif($sig_name =~ /_RX2$/){$mux_in = 2;}
			     elsif($sig_name =~ /_RX3$/){$mux_in = 3;}
			     else{print "Error!! $sig_name: mux(4:1) for the signal not having proper suffix (_RX*, _TX*)\n";}
			}
			elsif($mux_range == 4 && $mux_sel =~ /TX/)
			{
			     if($sig_name =~ /_TX0$/){$mux_in = 0;}
			     elsif($sig_name =~ /_TX1$/){$mux_in = 1;}
			     elsif($sig_name =~ /_TX2$/){$mux_in = 2;}
			     elsif($sig_name =~ /_TX3$/){$mux_in = 3;}
			     else{print "Error!! $sig_name: mux(4:1) for the signal not having proper suffix (_RX*, _TX*)\n";}
			}
			else
			{
			     print "Error!! $sig_name: unknown mux_range $mux_range\n";
			}

			if(!present_in_list("$mux_sel",@tc_reg_list))
                        {
                                $tc_reg = $mux_sel; 
                                push @tc_reg_list, "$mux_sel";
                                if($tc_reg =~ /(\S+)(\[\S+)/){$tc_reg =~ s/(\S+)(\[\S+)/\1/; $reg_width = $2;}
                                else{$reg_width = "        ";}
                                if($tc_reg eq "TC_TIF_sel_reg"){$tc_reg_def_code = $tc_reg_def_code . "\twire   $reg_width $tc_reg;\n";}
                                else{$tc_reg_def_code = $tc_reg_def_code . "\treg   $reg_width $tc_reg;\n";}
                                
                                if($mux_sel =~ /TC_TIF_sel_reg/)
                                {
                                	$define_code = $define_code . "`define DEF_ADD_TC_TIF_sel 255\n";
                                }
                                else
                                {
                                	$define_code = $define_code . "`define DEF_ADD_$mux_sel $reg_address\n";
					$reg_address = $reg_address + 1;
				}
                        }
			if(!present_in_list($mux_sel,@mux_sel_list))  {push @mux_sel_list, $mux_sel;}
			if($sig_dir =~ /O/)
			{
                                
                                if(!present_in_list("${conn_assumption}_pad",@out_port_code_pad_list))
                                {
                                	push @out_port_code_pad_list, "${conn_assumption}_pad";
                                	if($sig_width > 1)
                                        {
                                                $tc_reg_def_code = $tc_reg_def_code  . "\treg  [" . ($sig_width -1) . ":0] ${conn_assumption}_pad;\n";
                                        	for ($i=$sig_width -1; $i >=0 ; $i--)
                                                {
                                                     $out_port_code_pad = $out_port_code_pad . "\toutput reg     ${conn_assumption}_${i}_pad,\n";
                                                     $assign_split_code = $assign_split_code . "\t${conn_assumption}_${i}_pad = ${conn_assumption}_pad[${i}];\n";
                                                }
                                        }
                                        else{$out_port_code_pad = $out_port_code_pad . "\toutput reg      ${conn_assumption}_pad,\n";}
                                }
                                if(!present_in_list("i_${sig_name}_ip",@in_port_code_ip_list))
                                {
                                	push @in_port_code_ip_list, "i_${sig_name}_ip";
                                	if($sig_width > 1){$in_port_code_ip = $in_port_code_ip . "\tinput  [" . ($sig_width - 1) . ":0] i_${sig_name}_ip,\n";}
                                        else{$in_port_code_ip = $in_port_code_ip . "\tinput         i_${sig_name}_ip,\n";}
                                        
                                }
				$mux_sel_code = $mux_sel . "_code_" . $mux_in;
				$$mux_sel_code = $$mux_sel_code . "\t\t${conn_assumption}_pad = i_${sig_name}_ip;\n";
				
                                if($mux_range == 16 &&  $mux_in == 8)
                                {
                                	$mux_sel_code = $mux_sel . "_code_0";
                                        $$mux_sel_code = $$mux_sel_code . "\t\t${conn_assumption}_pad = w_TIF_RDA_TC;\n";
                                	$mux_sel_code = $mux_sel . "_code_1";
                                        $$mux_sel_code = $$mux_sel_code . "\t\t${conn_assumption}_pad = w_TIF_RDA_TC;\n";
                                	$mux_sel_code = $mux_sel . "_code_2";
                                        $$mux_sel_code = $$mux_sel_code . "\t\t${conn_assumption}_pad = w_TIF_RDA_TC;\n";
                                	$mux_sel_code = $mux_sel . "_code_3";
                                        $$mux_sel_code = $$mux_sel_code . "\t\t${conn_assumption}_pad = w_TIF_RDA_TC;\n";
                                	$mux_sel_code = $mux_sel . "_code_4";
                                        $$mux_sel_code = $$mux_sel_code . "\t\t${conn_assumption}_pad = w_TIF_RDA_TC;\n";
                                }
				%mux_sel_range_map = (%mux_sel_range_map, $mux_sel,$mux_range);

                                if($hand_written =~ /keep 0 and 1 as separate lines/)
                                {
					if($sig_name =~ /_RX0/ || $sig_name =~ /_RX1/)
                                        {
                                        	$assign_code = $assign_code . "\to_${sig_name}_pad = i_${sig_name}_ip;\n";
                                        	if(!present_in_list("o_${sig_name}_pad",@out_port_code_pad_list))
                                                {
                                                	push @out_port_code_pad_list, "o_${sig_name}_pad";
                                                        
                                                        if($sig_width > 1){$out_port_code_pad = $out_port_code_pad . "\toutput reg  [" . ($sig_width - 1) . ":0] o_${sig_name}_pad,\n";}
                                                        else{$out_port_code_pad = $out_port_code_pad . "\toutput reg           o_${sig_name}_pad,\n";}
                                                }
                                        }
                                }
                                elsif ($hand_written !~ /mux based on TC_[\w\[:\]]+$/)
                                {
                        	        print "Error!! ${sig_name}: \"$hand_written\" type is not supported\n";
                                }
			}
			elsif($sig_dir =~ /I/)
			{
                                
                                if(!present_in_list("${conn_assumption}_pad",@in_port_code_pad_list))
                                {
                                	push @in_port_code_pad_list, "${conn_assumption}_pad";
                                	if($sig_width>1)
                                        {
                                                $tc_reg_def_code = $tc_reg_def_code  . "\treg  [" . ($sig_width -1) . ":0] ${conn_assumption}_pad;\n";
                                        	for ($i=$sig_width -1; $i >=0 ; $i--)
                                                {
                                                     $in_port_code_pad = $in_port_code_pad . "\tinput      ${conn_assumption}_${i}_pad,\n";
                                                     $assign_split_code = $assign_split_code . "\t${conn_assumption}_pad[${i}] = ${conn_assumption}_${i}_pad;\n";
                                                }
                                        }
                                        else{$in_port_code_pad = $in_port_code_pad .  "\tinput          ${conn_assumption}_pad,\n";}
                                }
                                if(!present_in_list("o_${sig_name}_ip",@out_port_code_ip_list))
                                {
                                	push @out_port_code_ip_list, "o_${sig_name}_ip";
                                	if($sig_width>1){$out_port_code_ip = $out_port_code_ip . "\toutput reg [" . ($sig_width - 1) . ":0] o_${sig_name}_ip,\n";}
                                        else{$out_port_code_ip = $out_port_code_ip . "\toutput reg        o_${sig_name}_ip,\n";}
                                }
				$assign_code = $assign_code . "\to_${sig_name}_ip = ${conn_assumption}_pad & ($mux_sel == $mux_in);\n";
                                
                                if($mux_range == 16 &&  $mux_in == 8)
                                {
                                	push @tc_reg_list, "TIF_W_RB_TC";
                                        $tc_reg_def_code = $tc_reg_def_code . "\treg    TIF_W_RB_TC;\n";
                                        $assign_code = $assign_code . "\tTIF_W_RB_TC = ${conn_assumption}_pad & ($mux_sel < 5);\n";
                                }
			}
		} 
		elsif($hand_written =~ /^NA$/)
		{
                	##Do nothing
                }
                else
                {
                	print "Error!! ${sig_name}: \"$hand_written\" type is not supported\n";
                }
       }
    }
    
    ## Print verilog file;
    print VLOG "$define_code\n\n";
    print VLOG "module TC_PADMUX_TO_IO \(\n";
    print VLOG "$out_port_code_ip\n";
    print VLOG "$in_port_code_ip\n";
    print VLOG "$out_port_code_pad\n";
    print VLOG "$in_port_code_pad\n";
    print VLOG "\toutput reg debug\n";
    print VLOG "\);\n\n";
    print VLOG "\tparameter   p_nregs_write = $reg_address;\n";  
    print VLOG "\tparameter   p_abits  = 8 ;\n";
    print VLOG "\tparameter   p_addr   = 20;\n";
    print VLOG "\tparameter   p_dbits  = 3'b111;\n";
    print VLOG "\tparameter   p_default = 8'h00;\n";
    print VLOG "\n\twire   [7:0]     w_TBITS [p_nregs_write-1:0];\n";
    print VLOG "\n\twire   [7:0]     w_TIF_RDA_TC;\n";

    print VLOG "$tc_reg_def_code\n";
    print VLOG "\nalways @(*)\n";
    print VLOG "begin\n";
    print VLOG "$assign_code\n";
    print VLOG "$assign_split_code\n";
    print VLOG "\tdebug = 0;\n";
    print VLOG "end\n";

    foreach $mux_sel (@mux_sel_list)
    {
	##print "debug: $mux_sel\n";
	print VLOG "\nalways @(*)\n";
	print VLOG "begin\n";
        print VLOG "case ($mux_sel)\n";
        if($mux_sel_range_map{$mux_sel} == 16){$mux_sel_bit = 4;}
        elsif($mux_sel_range_map{$mux_sel} == 8){$mux_sel_bit = 3;}
        elsif($mux_sel_range_map{$mux_sel} == 4){$mux_sel_bit = 2;}
        elsif($mux_sel_range_map{$mux_sel} == 2){$mux_sel_bit = 1;}
        else {print "Error!! $mux_sel: mux_sel_bit range error\n";}
	for ($mux_in=0;$mux_in<$mux_sel_range_map{$mux_sel};$mux_in++)
	{
		print VLOG "\t${mux_sel_bit}'d$mux_in:\n";
		print VLOG "\tbegin\n";
		$mux_sel_code = $mux_sel . "_code_" . $mux_in;
		print VLOG "$$mux_sel_code";
		print VLOG "\tend\n";
	}
	print VLOG "endcase\n";
	print VLOG "end\n";
    }

    print VLOG "     assign w_TIF_RDA_TC = (i_TIF_Addr_pad == 8'hff) ? {4'h0,TC_TIF_sel_reg} : w_TBITS[i_TIF_Addr_pad];\n";

    print VLOG "     tc_register\n";
    print VLOG "       #(.p_abits (p_abits),\n";
    print VLOG "         .p_addr (8'hff),\n";
    print VLOG "         .p_dbits (4),\n";
    print VLOG "         .p_default (p_default)\n";
    print VLOG "         )\n";
    print VLOG "         BLOCK_SEL\n";
    print VLOG "           (\n";
    print VLOG "            .o_DATA_OUTPUT (TC_TIF_sel_reg),\n";
    print VLOG "            // Inputs\n";
    print VLOG "            .i_ADDR      (i_TIF_Addr_pad),\n";
    print VLOG "            .i_DATA_IN   (i_TIF_WDA_pad),\n";
    print VLOG "            .i_WREN      (i_TIF_W_RB_pad),\n";
    print VLOG "            .i_FORCE_WR  (1'b0),\n";
    print VLOG "            .i_CLK       (i_TIF_Clk_pad),\n";
    print VLOG "            .i_RST       (!i_TIF_RSTB_pad)\n";
    print VLOG "            );\n";

    print VLOG "\n    genvar 	 i;   \n";
    print VLOG "    generate\n";
    print VLOG "       for (i=0;i<=(p_nregs_write-1);i=i+1)\n";
    print VLOG "	 begin: TC_TMREG\n";
    print VLOG "	    tc_register\n";
    print VLOG "	      #(.p_abits (p_abits),\n";
    print VLOG "	        .p_addr (i),\n";
    print VLOG "	        .p_dbits (p_dbits),\n";
    print VLOG "	        .p_default (p_default)\n";
    print VLOG "	        )\n";
    print VLOG "	        REG\n";
    print VLOG "		  (\n";
    print VLOG "		   .o_DATA_OUTPUT (w_TBITS[i]),\n";
    print VLOG "		   // Inputs\n";
    print VLOG "		   .i_ADDR      (i_TIF_Addr_pad),\n";
    print VLOG "		   .i_DATA_IN   (i_TIF_WDA_pad),\n";
    print VLOG "		   .i_WREN      (TIF_W_RB_TC),\n";
    print VLOG "		   .i_FORCE_WR  (1'b0),\n";
    print VLOG "		   .i_CLK       (i_TIF_Clk_pad),\n";
    print VLOG "		   .i_RST       (!i_TIF_RSTB_pad)\n";
    print VLOG "		   );\n";
    print VLOG "   	 end \n";
    print VLOG "    endgenerate\n";

    print VLOG "\nendmodule\n";
      
}

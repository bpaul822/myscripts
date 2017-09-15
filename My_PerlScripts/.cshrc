#!/bin/csh -f
#set verbose
#----------------------------------------------------------------------------
#-------------      Divyeshs C Shell resource file   -----------------
#----------------------------------------------------------------------------
#

set filec
set autolist=ambiguous
set addsuffix 
set rmstar 

setenv CDS_LIC_FILE 5280@noiflex:5281@noiflex
setenv LM_LICENSE_FILE $CDS_LIC_FILE 
setenv PATH /grid/avs/install/incisiv/12.2/latest/tools/bin:$PATH
#setenv PATH /grid/avs/install/incisiv/12.2/previous/tools/bin:$PATH
setenv PATH /grid/sfi/farm/bin:$PATH 
#setenv PATH /ccstools/cdsind2/Software/LEC121ISR5_lnx86/bin:$PATH 
#setenv PATH /ccstools/cdsind1/Software/SOC91CB_lnx86/lnx86/bin:$PATH 
setenv PATH /servers/apps/eda/cadence/SOC/current_EDI/tools.lnx86/bin:$PATH 
setenv PATH /servers/apps/eda/cadence/SOC/current_RC/tools.lnx86/bin:$PATH 

set path = ($HOME/bin /bin /sbin /usr/dt/bin /usr/local/bin /grid/common/pkgs/vim/v6.3/bin /grid/common/pkgs/gcc/v4.1.2/bin /usr/sbin /util/bin  /usr/openwin/bin /grid/common/pkgs/vnc/v4/bin /grid/common/bin /grid/it/tp_tools/svn/subversion-1.6.6/bin $path)
#set path = ($HOME/bin /bin /sbin /usr/dt/bin /usr/local/bin /grid/common/pkgs/vim/v6.3/bin /grid/common/pkgs/gcc/v4.1.2/bin /usr/sbin /util/bin  /usr/openwin/bin /grid/common/pkgs/vnc/v4/bin /grid/common/bin  $path)

setenv LD_LIBRARY_PATH /grid/common/pkgs/gcc/v4.1.2/lib

setenv LSF_USER_CLEARCASE TRUE
setenv EDITOR vi
unsetenv LS_COLORS

## SpyGlass BIN, Scripts and License
setenv SPYGLASS_HOME /grid/scp/hw/tools/atrenta/SpyGlass-5.1.1/SPYGLASS_HOME
setenv ATRENTA_IPKIT_DIR /grid/scp/hw/tools/atrenta/atrenta_ip_kit_5.1.0_v1
#setenv SPYGLASS_HOME /grid/scp/hw/tools/atrenta/SpyGlass-5.1.0.1/SPYGLASS_HOME
#setenv ATRENTA_IPKIT_DIR /grid/scp/hw/tools/atrenta/atrenta_ip_kit_5.0.0_v3
setenv ATRENTA_LICENSE_FILE 2710@sjtplic
setenv PATH $SPYGLASS_HOME/bin:$PATH 
# AIPK scripts
alias aipk_read "$ATRENTA_IPKIT_DIR/scripts/aipk_read"
alias aipk_pack "$ATRENTA_IPKIT_DIR/scripts/aipk_pack"
alias aipk_run "$ATRENTA_IPKIT_DIR/scripts/aipk_run"
#Alias for SpyGlass HTML Help and License query
alias sghelp "firefox $SPYGLASS_HOME/htmlhelp/index.html &"
alias sglic "lmstat -c $ATRENTA_LICENSE_FILE -a"
## End

## Environment setup for Noida VM
setenv apps /servers/apps
setenv pdk /servers/pdk
setenv db /servers/db
setenv share /servers/share
setenv dbarchive /servers/dbarchive
setenv act /servers/act
setenv local_home /servers/scratch03/$USER
setenv CSHRCHOME /home/divyeshp
setenv CDSHOME $apps/eda/cadence/IC/IC615/IC615_ISR14
setenv ASSURAHOME $apps/eda/cadence/assura/stable_oa

#if ((vim --version) <702){echo bibin}
source ~/.alias

## Reread Xresource file
#xrdb ~/.Xresources
## Merge Xresource file
#xrdb -merge ~/.Xresources

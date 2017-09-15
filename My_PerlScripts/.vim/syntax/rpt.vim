" add keyword ERROR to logERROR highlight group
:syn keyword logERROR ERROR
hi link logERROR ERROR
" for matching *E,XYZAB ERRORs thrown by ncverilog
:syn match logERROR /\s*\ERROR,[A-Z]*/
" for highlighting expected value mismatch in simulation
:syn match ModeMsg /DPV:\sSignal\s\w*\sexpected\sto\sbe\s[01XZ]\swas\s[01XZ]/

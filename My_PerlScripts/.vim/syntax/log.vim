" add keyword Error to logError highlight group
:syn keyword logError Error
hi link logError Error
" for matching *E,XYZAB errors thrown by ncverilog
:syn match logError /\s*\*E,[A-Z]*/
" for highlighting expected value mismatch in simulation
:syn match ModeMsg /DPV:\sSignal\s\w*\sexpected\sto\sbe\s[01XZ]\swas\s[01XZ]/

set nocompatible
"256 color enable
set t_Co=256
colorscheme wombat256mod
"set t_AB=^[[48;5;%dm
set mouse=a

set history=200
set pastetoggle=<F2>

"csv plugin
autocmd BufWinEnter *.csv set buftype=nowrite | :%s/, /,/g
set ft=csv

"to comment files
"set filetype for run_sim_cmd
"au BufRead,BufNewFile run_sim_cmd   set filetype=csh
"set filetype for .svh files as SV
au BufRead,BufNewFile *.sv   set filetype=verilog_systemverilog
"au BufRead,BufNewFile *.pl   set filetype=perl

"- to comment and _ to uncomment
function! Poundcomment()
"map - 0i#<ESC><CR>
map - 0i#<ESC>
map _ :s/^\s*# \=//g<ESC>
set comments=:#
endfunction
"- to comment and _ to uncomment
function! Slashcomment()
"map - 0i//<ESC><CR>
map - 0i//<ESC>
map _ :s/^\s*\/\///g<ESC>
set comments=://
endfunction
"define for which filetypes this should work
autocmd Filetype perl call Poundcomment()
autocmd Filetype sdc call Poundcomment()
autocmd Filetype tcl call Poundcomment()
autocmd Filetype make  call Poundcomment()
autocmd Filetype csh call Poundcomment()
autocmd Filetype sh call Poundcomment()
autocmd Filetype verilog call Slashcomment()
autocmd Filetype verilog_systemverilog call Slashcomment()

filetype plugin on
filetype on 
"edit between windows and other apps
set tw=0 wrap linebreak
"  backup
"set backup
"set backupdir=~/.vim_backup
"set viminfo=%100,'100,/100,h,\"500,:100,n~/.viminfo
"set viminfo='100,f1
"set textwidth=80                " we like 80 columns
"power line
set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
" Always show statusline
set laststatus=2

"move cursor to last edited line
" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
  "  "100 :  will save up to 100 lines for each register
  "  :20  :  up to 20 lines of command-line history will be remembered
  "  %    :  saves and restores the buffer list
  "  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END


"add pathogen for plugin
if version >= 703
     execute pathogen#infect()
     set cursorline
    endif
"execute pathogen#infect()

" Reference: Initially based on
" http://dev.gentoo.org/~ciaranm/docs/vim-guide/
" Enable syntax highlighting.
syntax on
" Automatically indent when adding a curly bracket, etc.
" source ~/verilog.vim 
set smartindent
" Tabs should be converted to a group of 4 spaces.
" This is the official Python convention
" (http://www.python.org/dev/peps/pep-0008/)
" I didn't find a good reason to not use it everywhere.
set shiftwidth=2
set tabstop=4
set expandtab
set smarttab
"to highlight the cursor line
"set cursorline
" Minimal number of screen lines to keep above and below the cursor.
set scrolloff=999
" Use UTF-8.
set encoding=utf-8
" Set color scheme that I like.
"if has("gui_running")
"colorscheme default
"else
"colorscheme darkblue
"endif
" Status line
set laststatus=2
set statusline=
set statusline+=%-3.3n\ " buffer number
set statusline+=%f\ " filename
set statusline+=%h%m%r%w " status flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}] " file type
set statusline+=%= " right align remainder
set statusline+=0x%-8B " character value
set statusline+=%-14(%l,%c%V%) " line, character
set statusline+=%<%P " file position
" Show line number, cursor position.
set ruler
" Display incomplete commands.
set showcmd
" To insert timestamp, press F3.
"nmap <F3> a<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>
"imap <F3> <C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR>
" To save, press ctrl-s.
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>a
"remap esc to jj
imap jj <Esc>
" Search as you type.
set incsearch
" Ignore case when searching.
set ignorecase
" Show autocomplete menus.
"highlight errors in vim file
au BufRead,BufNewFile *.log set filetype=log
au BufRead,BufNewFile *.rpt set filetype=rpt

set wildmenu
" Show editing mode
set showmode
" Error bells are displayed visually.
set visualbell
colorscheme wombat256mod

"colorscheme zenburn
au BufNewFile,BufRead *.v,*.vh,*.args,*.f,*.verilog set ft=verilog
set backupdir=~/.vim/backup
set backup 

set visualbell 
"avoid error in xterm
set nomodeline
"highlighting incremental search
set hlsearch       


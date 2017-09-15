let mapleader = ","

set tag=/proj/ada4575/sos_bpaul/tags
"remove ? in backspace
set t_kb=^H

set nocompatible
"256 color enable
set t_Co=256
colorscheme wombat256mod
"set t_AB=^[[48;5;%dm
set mouse=a

set history=200
set pastetoggle=<F2>
"autocmd BufWinEnter *.csv set buftype=nowrite | :%s/, /,/g
"set ft=csv

"to comment files
"set filetype for run_sim_cmd
"au BufRead,BufNewFile run_sim_cmd   set filetype=csh
"set filetype for .svh files as SV
au BufRead,BufNewFile *.sv   set filetype=verilog_systemverilog
"au BufRead,BufNewFile *.pl   set filetype=perl
"adding the following for system verilog
if exists("did_load_filetypes") 
          finish 
        endif 
        augroup filetypedetect 
          au! BufRead,BufNewFile *.sv    setfiletype SV 
          au! BufRead,BufNewFile *.svi   setfiletype SV 
        augroup END 

"swapping cntrl v and v in visual mode not in normal mode
nnoremap v <C-V>
nnoremap <C-V> v
vnoremap v <C-V>
vnoremap <C-V> v

"map <leader>k :wincmd k<CR>
"map <leader>l :wincmd l<CR>
"nnoremap <C-W> <leader>w 
"nnoremap <leader>w <C-W>

nnoremap f <C-F>
nnoremap <C-F> f
vnoremap f <C-F>
vnoremap <C-F> f


nnoremap t <C-B>
nnoremap <C-B> t
vnoremap t <C-B>
vnoremap <C-B> t

"nnoremap <C-b> t
"vnoremap t <C-b>
"vnoremap <C-b> t

"This tip allows you to use the Tab key to switch windows cr
set autochdir
map <Tab> <C-W>W:cd %:p:h<CR>:<CR>
"Use TAB to complete when typing words, else inserts TABs as usual.
"Uses dictionary and source files to find matching words to complete.

"See help completion for source,
"Note: usual completion is on <C-n> but more trouble to press all the time.
"Never type the same word twice and maybe learn a new spellings!
"Use the Linux dictionary when spelling is in doubt.
"Window users can copy the file to their machine.
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction
:inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
:set dictionary="/usr/dict/words"

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
autocmd Filetype tcsh call Poundcomment()
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

set backspace=indent,eol,start
                  " allow backspacing over everything in insert mode
set showmatch     " set show matching parenthesis

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
au BufNewFile,BufRead *.v,*.pl,*.cshrc,*.csh,*.vh,*.sv,*.args,*.f,*.verilog set ft=verilog
set backupdir=~/.vim/backup
set backup 
set mouse=a
set visualbell 
"avoid error in xterm
set nomodeline
"highlighting incremental search
set hlsearch       



" Insert and command-line mode Caps Lock.
" Lock search keymap to be the same as insert mode.
"set imsearch=-1
"" Load the keymap that acts like capslock .
"set keymap=insert-only_capslock
"" Turn it off by default.
"set iminsert=0




"alternative method for the above
" Execute 'lnoremap x X' and 'lnoremap X x' for each letter a-z.
for c in range(char2nr('A'), char2nr('Z'))
  execute 'lnoremap ' . nr2char(c+32) . ' ' . nr2char(c)
  execute 'lnoremap ' . nr2char(c) . ' ' . nr2char(c+32)
endfor
"
"" Kill the capslock when leaving insert mode.
autocmd InsertLeave * set iminsert=0


" so the cursor color changes when "Caps Lock" is on:
:highlight Cursor guifg=NONE guibg=Green
:highlight lCursor guifg=NONE guibg=Cyan

" Set following to show "<CAPS>" in the status line when "Caps Lock" is on.
let b:keymap_name = "CAPS"
" Show b:keymap_name in status line.
:set statusline^=%k


"source the below files as pathogen is not sourcing automatically
set ruler 
set fileformat=unix 

source $HOME/.vim/ftplugin/automatic.vim 
source $HOME/.vim/ftplugin/vlog_inst_gen.vim 
source $HOME/.vim/ftplugin/verilog.vim

"autocmd vimenter * NERDTree
"to open nerd tree when no arg is specified
autocmd vimenter * if !argc() | NERDTree | endif 


"=====[ There can be only one (one Vim session per file) ]=====================
augroup NoSimultaneousEdits
    autocmd!
    autocmd SwapExists *  let v:swapchoice = 'o'
    autocmd SwapExists *  echohl ErrorMsg
    autocmd SwapExists *  echo 'Duplicate edit session (readonly)'
    autocmd SwapExists *  echohl None
    autocmd SwapExists *  call Make_session_finder( expand('<afile>') )
    autocmd SwapExists *  sleep 2
augroup END


function! Make_session_finder (filename)
    exec 'nnoremap ss :!terminal_promote_vim_session ' . a:filename . '<CR>:q!<CR>'
endfunction


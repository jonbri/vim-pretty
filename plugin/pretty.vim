" pretty.vim - Invoke Prettier

if exists("g:loaded_pretty") || &cp || v:version < 700
  finish
endif
let g:loaded_pretty = 1

" paths to potential prettier executables
let s:localPath='./node_modules/.bin/prettier'
let s:globalPath='prettier'


"""""""""""""
" functions
"

function! Chomp(string)
    return substitute(a:string, '\n\+$', '', '')
endfunction

" regex match:
"   start: 1 digit
"   middle: 1 or more digit/periods
"   end: 1 digit
"   matches: 123, 1.23, 1.2.3
"   non-matches: 1j2, .1, 1.
function! IsPrettierExecutablePath(path)
    return Chomp(system(a:path.' --version')) =~ '\v^[0-9][0-9\.]+[0-9]$'
endfunction

" fn: invoke Prettier on current buffer
" maintain cursor position
function! PrettierBuffer()
    echo "running Prettier..."

    " get path to Prettier executable
    if (IsPrettierExecutablePath(s:localPath))
      let l:executable=s:localPath
    elseif (IsPrettierExecutablePath(s:globalPath))
      let l:executable=s:globalPath
    else
      echo 'no executable found'
      return
    endif

    " save cursor position
    let l:cursor_pos=getpos(".")

    " perform Prettier operation
    0,$ delete
    $put=system(l:executable.' '.expand('%:p'))
    0 delete
    redraw

    " restore cursor position
    cal cursor(l:cursor_pos[1], l:cursor_pos[2])

    echom "Prettier done"
endfunction


"""""""""""""
" mappings
"

" leader-p
nnoremap <leader>p :call PrettierBuffer()<CR>


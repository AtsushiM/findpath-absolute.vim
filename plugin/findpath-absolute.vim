"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/findpath-absolute.vim
"VERSION:  0.9
"LICENSE:  MIT

if exists("g:loaded_findpath_absolute")
    finish
endif
let g:loaded_findpath_absolute = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=* -range FPPathAbs <line1>,<line2>call fpabs#PathAbs(<f-args>)

let &cpo = s:save_cpo

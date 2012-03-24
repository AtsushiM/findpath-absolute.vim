"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/findpath-absolute.vim
"VERSION:  0.9
"LICENSE:  MIT

command! -nargs=* -range FPPathAbs <line1>,<line2>call fpabs#PathAbs(<f-args>)

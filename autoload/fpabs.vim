"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/findpath-absolute.vim
"VERSION:  0.9
"LICENSE:  MIT

let s:save_cpo = &cpo
set cpo&vim

function! fpabs#_linetypecheck()
    let line = getline('.')
    let ret = ''
    let ishtml = matchlist(line, '\v\<(.+)\>')

    if ishtml != []
        let ret = 'html'
    else
        let iscss = matchlist(line, '\v.{-}(:).{-}')

        if iscss != []
            let ret = 'css'
        endif
    endif

    return ret
endfunction
function! fpabs#PathAbs(...)
    let now = line('.')
    let col = col('.')
    let start = now
    let end = now
    let prefix = ''

    if a:0 != 0
        for e in a:000
            let eary = split(e,'=')
            if eary[0] == '-all'
                if eary[1] == '0'
                    let start = now
                    let end = now
                else
                    let start = 1
                    let end = line('w$')
                endif
            elseif eary[0] == '-start'
                let start = eary[1]
            elseif eary[0] == '-end'
                let end = eary[1]
            elseif eary[0] == '-prefix'
                exec 'let prefix = '."'".eary[1]."'"
            endif
        endfor
    endif
    exec ''.start.','.end.'call fpabs#_PathAbs("'.prefix.'")'
    call cursor(now, col)
endfunction
function! fpabs#_PathAbs(...)
    let orgdir = expand('%:p:h')
    let root = g:FPRoot()
    let base = getline('.')
    let org = base
    let prefix = ''
    let end = 0
    let ret = ''

    if a:0 != 0
        let prefix = a:000[0]
    endif

    while end == 0
        let type = fpabs#_linetypecheck()
        if type == 'html'
            let line = matchlist(base, '\v(.{-})(src|href)(\=")([^/#][^\":]*)(")(.*)')
            if line != []
                let orgary = split(orgdir, '/')
                let srcary = split (line[4], '/')
                let calary = deepcopy(srcary)
                for e in srcary
                    if e == '..'
                        unlet orgary[-1]
                        unlet calary[0]
                    elseif e == '.'
                        unlet calary[0]
                    else
                        break
                    endif
                endfor
                let ret = ret.line[1].line[2].line[3].prefix.'/'.split('/'.join(orgary, '/').'/'.join(calary, '/'), root)[0].line[5]
                let base = line[6]
            else
                let ret = ret.base
                let end = 1
            endif
        elseif type == 'css'
            let line = matchlist(base, '\v(.{-})(url)(\([''"]?)([^/#][^\":]*)([''"]?\))(.*)')
            if line != []
                let orgary = split(orgdir, '/')
                let srcary = split (line[4], '/')
                let calary = deepcopy(srcary)
                for e in srcary
                    if e == '..'
                        unlet orgary[-1]
                        unlet calary[0]
                    elseif e == '.'
                        unlet calary[0]
                    else
                        break
                    endif
                endfor
                let ret = ret.line[1].line[2].line[3].prefix.split('/'.join(orgary, '/').'/'.join(calary, '/'), root)[0].line[5]
                let base = line[6]
            else
                let ret = ret.base
                let end = 1
            endif
        endif
    endwhile

    if ret != org
        call setline('.', ret)
    endif
endfunction

let &cpo = s:save_cpo

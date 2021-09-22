let g:timing = v:false

function TimingsToggle() abort
    if g:timing
        let g:timing = v:false
        augroup timing | autocmd! | augroup end
        echom 'Timing stopped'
    else
        let g:timing = v:true
        let g:timings = {}
        let g:initial_time = reltime()
        augroup timing
            autocmd!
            autocmd InsertCharPre * let g:last_text_change = reltime()
            autocmd CompleteChanged *
            \ if exists('g:last_text_change')
            \|    let t = reltimestr(reltime(g:initial_time, g:last_text_change))
            \|    let g:timings[t] = add(get(g:timings, t, []), reltimefloat(reltime(g:last_text_change)))
            \|endif
        augroup end
        echom 'Timing started'
    endif
endfunction

function TimingsSave(path, title) abort
    if exists('g:timings')
        call writefile([json_encode({'title': a:title, 'timings': g:timings})], expand(a:path), 'b')
    else
        echom 'Timing never started'
    endif
endfunction

command -nargs=+ -complete=file TimingsSave call TimingsSave(<f-args>)

nnoremap <silent> <leader>T :call TimingsToggle()<cr>

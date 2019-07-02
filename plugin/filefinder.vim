" 搜索所有文件名 FileFinder.vim
" 2014.8.13
" 命令
"   :FileFind 显示目录下所有文件
"   :map ea :FinderFind<CR> 绑定一个快捷键
" 快捷键
"   Enter             当前窗口打开文件
"   t                 新窗口打开文件
"   d                 删除文件
"   q                 退出FileFinder
"   r                 刷新
"   R                 运行命令
" 配置
"   g:FileFinder_Name = 'File_Finder' 标签名称
"   g:FileFinder_RunWithLess = 1 运行命令后是否加less

" Load once
if exists('g:loaded_filefinder')
    "finish
endif

let g:loaded_filefinder = 1

" Maps
map <leader>a :FinderFind<CR>

command! -nargs=? FinderFind call s:FileFinder_Find(<f-args>)

autocmd BufEnter *.filefinder call FileFinder_Refresh()

let g:FileFinder_Name = 'File_Finder'

let g:FileFinder_RunWithLess = 1

let g:FileFinder_Count = 0

let b:FileFinder_Cwd = ''

function! s:FileFinder_Find(...)
    if bufname('%') != '' || byte2line(1) != -1
        tabnew
    endif

    let g:FileFinder_Count += 1
    silent! execute 'file '.g:FileFinder_Name.'_'.g:FileFinder_Count

    let cmd = 'find ./ -type f | grep -i -v "/\." | sort'
    if a:0 == 1
        let cmd = cmd.' | grep '.a:1
    endif

    call s:FileFinder_Execute(cmd)

    call s:FileFinder_SetLocal()
    call s:FileFinder_SetMaps()
endfunction

function! s:FileFinder_Execute(cmd)
    let b:FileFinder_Cwd = getcwd()
    let current = getpos('.')
    0,$ delete
    execute '0 read !'.a:cmd
    $,$ delete
    call setpos('.', current)
endfunction

let s:FileFinder_Count = [[], 0]
function! FileFinder_ShowSearchCount()
    let key = [@/, b:changedtick]
    if s:FileFinder_Count[0] !=# key
        let s:FileFinder_Count = [key, 0]
        let pos = getpos('.')
        let subscount = "0"
        try
            redir => subscount | silent %s///gne | redir END
        catch
        endtry
        call setpos('.', pos)
        let s:FileFinder_Count[1] = str2nr(matchstr(subscount, '\d\+'))
    endif
    return '<'.s:FileFinder_Count[1].'> '.@/
endfunction

function! s:FileFinder_SetLocal()
    setfiletype filefinder
    setlocal nobuflisted
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nomodifiable
    setlocal cursorline

    setlocal statusline=%{b:FileFinder_Cwd}
    setlocal statusline+=\ <%L>\ Files
    setlocal statusline+=\ %{FileFinder_ShowSearchCount()}
endfunction

function! s:FileFinder_SetMaps()
    map <buffer> <CR> :execute 'edit '.simplify(b:FileFinder_Cwd.'/'.getline('.'))<CR>
    map <buffer> t :execute 'tabnew '.simplify(b:FileFinder_Cwd.'/'.getline('.'))<CR>
    map <buffer> q :quit<CR>
    map <buffer> d :call FileFinder_DeleteHere()<CR>
    map <buffer> c :call FileFinder_CopyHere()<CR>
    map <buffer> m :call FileFinder_MoveHere()<CR>
    map <buffer> r :call FileFinder_Refresh()<CR>
    map <buffer> R :call FileFinder_RunHere()<CR>
endfunction

function! FileFinder_Refresh()
    let cmd = 'find ./ -type f | grep -v "/\." | sort'
    setlocal modifiable
    call s:FileFinder_Execute(cmd)
    setlocal nomodifiable
endfunction

function! FileFinder_DeleteHere()
    let filename = simplify(b:FileFinder_Cwd.'/'.getline('.'))
    if confirm('Delete file "'.filename.'"?', "yes\nno", 2) != 1
        return
    endif

    if delete(filename) != 0
        echo 'delete failed'
        return
    endif

    echo 'delete success'
    setlocal modifiable | delete | setlocal nomodifiable
    return
endfunction

function! FileFinder_CopyHere()
    let filename = simplify(b:FileFinder_Cwd.'/'.getline('.'))
    echohl Title
    let target = input('Copy to: ', filename)
    echohl None

    let cmd = 'cp -f '.filename.' '.target
    call system(cmd)
    call FileFinder_Refresh()
endfunction

function! FileFinder_MoveHere()
    let filename = simplify(b:FileFinder_Cwd.'/'.getline('.'))
    echohl Title
    let target = input('Move to: ', filename)
    echohl None

    let cmd = 'mv -f '.filename.' '.target
    call system(cmd)
    call FileFinder_Refresh()
endfunction

function! FileFinder_RunHere()
    let filename = simplify(b:FileFinder_Cwd.'/'.getline('.'))
    execute '!'.filename.(g:FileFinder_RunWithLess ? ' | less' : '')
endfunction

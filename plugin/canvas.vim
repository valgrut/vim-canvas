" vim-canvas: :Canvas to create or edit sketches in attachments/
" Maintainer: Jiri Peska <xpeskajiri@seznam.com>

if exists('g:loaded_canvas_plugin')
  finish
endif
let g:loaded_canvas_plugin = 1

" --- User options (with sensible defaults) ---
if !exists('g:canvas_editor')
  " Default editor command (Linux): pinta
  " On Windows you might set: let g:canvas_editor = 'mspaint.exe'
  let g:canvas_editor = 'pinta'
endif

if !exists('g:canvas_img_prefix')
  let g:canvas_img_prefix = 'sketch'
endif

if !exists('g:canvas_attachments_dir')
  let g:canvas_attachments_dir = 'attachments'
endif

if !exists('g:canvas_img_width') | let g:canvas_img_width = 800 | endif
if !exists('g:canvas_img_height') | let g:canvas_img_height = 600 | endif
if !exists('g:canvas_img_fmt') | let g:canvas_img_fmt = 'png' | endif

command! Canvas call CanvasSketch()

function! CanvasSketch()
  " Absolute path to current file (we assume markdown, but works for any)
  let l:md_abs  = expand('%:p')
  let l:bufdir  = expand('%:p:h')
  let l:line    = getline('.')

  " Try to extract (path) from ![alt](path)
  let l:path_from_md = matchstr(l:line, '!\[[^]]*\](\zs[^)]\+\ze)')

  " Fallback: filename under cursor
  let l:cfile = empty(l:path_from_md) ? expand('<cfile>') : l:path_from_md

  let l:img_ext = '\v\.(png|jpg|jpeg|webp|bmp|gif|tif|tiff)$'
  let l:target = ''

  if !empty(l:cfile) && l:cfile =~? l:img_ext
    if l:cfile =~ '^/'
      let l:cand = l:cfile
    else
      let l:cand = l:bufdir . '/' . l:cfile
    endif
    if filereadable(l:cand)
      let l:target = l:cand
    endif
  endif

  " Resolve path to our Python script inside this plugin
  let s:plugin_dir = expand('<sfile>:p:h')
  let s:script = fnameescape(s:plugin_dir . '/../bin/canvas_sketcher.py')

  " Build args
  let l:cmd = 'python3 ' . s:script
  let l:cmd .= ' --file '        . shellescape(l:md_abs)
  let l:cmd .= ' --editor '      . shellescape(get(g:, 'canvas_editor'))
  let l:cmd .= ' --prefix '      . shellescape(get(g:, 'canvas_img_prefix'))
  let l:cmd .= ' --attachments ' . shellescape(get(g:, 'canvas_attachments_dir'))
  let l:cmd .= ' --width '       . string(get(g:, 'canvas_img_width'))
  let l:cmd .= ' --height '      . string(get(g:, 'canvas_img_height'))
  let l:cmd .= ' --format '      . shellescape(get(g:, 'canvas_img_fmt'))

  if empty(l:target)
    " CREATE mode: expect markdown link on stdout
    let l:output = system(l:cmd)
    if !empty(trim(l:output))
      call append(line('.'), trim(l:output))
    else
      echo "Canvas: no image created."
    endif
  else
    " EDIT mode: pass target; script prints nothing
    let l:cmd2 = l:cmd . ' --edit ' . shellescape(l:target)
    call system(l:cmd2)
    echo "Canvas: opened for editing -> " . l:target
  endif
endfunction


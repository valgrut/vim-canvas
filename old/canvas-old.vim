command! Canvas call CanvasSketch()

function! CanvasSketch()
  " Absolute path to the current markdown file
  let l:md_abs = expand('%:p')
  let l:bufdir = expand('%:p:h')
  let l:line = getline('.')

  " 1) Try to extract path from Markdown image link on this line
  let l:path_from_md = matchstr(l:line, '!\[[^]]*\](\zs[^)]\+\ze)')
  " 2) Fallback: use filename under cursor
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

  " Run Python: 
  " arg1 = current md file, arg2 = existing image (optional)
  if empty(l:target)
    let l:output = system("python3 ~/.local/bin/canvas_sketcher.py " . shellescape(l:md_abs))
    if !empty(trim(l:output))
      call append(line('.'), trim(l:output))
    else
      echo "No image created."
    endif
  else
    call system("python3 ~/.local/bin/canvas_sketcher.py " . shellescape(l:md_abs) . " " . shellescape(l:target))
    echo "Opened for editing: " . l:target
  endif
endfunction

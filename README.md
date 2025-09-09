# vim-canvas

Create or edit sketches directly from the vim.


## Description
`
:Canvas` – quickly create or edit sketches alongside your Markdown files.

- Creates `attachments/` in the same directory as the current file.
- Launches your external editor (default: `pinta`) on a new blank image.
- Inserts `![sketch-YYYYMMDD-HHMMSS](attachments/sketch-*.png)` under the cursor line.
- If cursor is on an existing image link or filename, opens it for editing.


-----------------------------------------------------------------------

## Usage

```
:Canvas (create): inserts a Markdown link to a new image in attachments/.
:Canvas (edit): if cursor is on an image link/filename, opens that image.
```


-----------------------------------------------------------------------

## Install

### vim-plug

```vim
Plug 'valgrut/vim-canvas'
```


### Vundle

```
Plugin 'valgrut/vim-canvas'
```


### Pathogen

```
git clone https://github.com/valgrut/vim-canvas ~/.vim/bundle/vim-canvas
```


### Native package

```
git clone https://github.com/valgrut/vim-canvas ~/.vim/pack/plugins/start/vim-canvas
```


-----------------------------------------------------------------------

## Dependencies

- python3
- Pillow (`pip install pillow`)
- An external editor (pinta, mspaint.exe, pinta.exe, etc.)


-----------------------------------------------------------------------

## Config (Optional)

Redefine default settings.

```
let g:canvas_editor = 'pinta'            " Windows: 'mspaint.exe'
let g:canvas_img_prefix = 'sketch'
let g:canvas_attachments_dir = 'attachments'
let g:canvas_img_width = 800
let g:canvas_img_height = 600
let g:canvas_img_fmt = 'png'
```

**Note**: Functionality on Windows is WIP!

Users on Windows can set ((assuming it’s in PATH) or a full path to the editor exe):

```
let g:canvas_editor = 'mspaint.exe'
```

If someone wants WSL -> Windows editor, they can set:

```
let g:canvas_editor = 'pinta.exe'
```

-----------------------------------------------------------------------

## LICENSE

GPT3, ref LICENSE file.


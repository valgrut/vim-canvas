#! /usr/bin/env python3
import argparse
import subprocess
import sys
from datetime import datetime
from pathlib import Path

# Pillow is used to create a valid blank image.
# Require it to avoid "unrecognized image" issues in editors like Pinta.
try:
    from PIL import Image
except Exception as e:
    print("")  # keep Vim clean on import error; show guidance if needed:
    sys.exit(0)

def run_editor(cmd):
    subprocess.run(
        cmd,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )

def resolve_rel(base_dir: Path, maybe: str) -> Path:
    p = Path(maybe)
    return p if p.is_absolute() else (base_dir / p).resolve()

def main():
    ap = argparse.ArgumentParser(description="vim-canvas helper")
    ap.add_argument("--file", required=True, help="Absolute path to current buffer file")
    ap.add_argument("--editor", required=True, help="Editor command (e.g., pinta, mspaint.exe)")
    ap.add_argument("--prefix", default="sketch", help="Filename prefix")
    ap.add_argument("--attachments", default="attachments", help="Attachments dir name")
    ap.add_argument("--width", type=int, default=800, help="Blank image width")
    ap.add_argument("--height", type=int, default=600, help="Blank image height")
    ap.add_argument("--format", default="png", choices=["png","jpg","jpeg","bmp","gif","webp","tif","tiff"])
    ap.add_argument("--edit", help="Existing image path to edit (optional)")
    args = ap.parse_args()

    md_path = Path(args.file).resolve()
    md_dir = md_path.parent
    attachments_dir = md_dir / args.attachments
    attachments_dir.mkdir(exist_ok=True)

    # EDIT MODE
    if args.edit:
        edit_path = resolve_rel(md_dir, args.edit)
        if edit_path.exists() and edit_path.is_file():
            run_editor([args.editor, str(edit_path)])
        # print nothing in edit mode
        return

    # CREATE MODE
    ts = datetime.now().strftime("%Y%m%d-%H%M%S")
    filename = f"{args.prefix}-{ts}.{args.format}"
    img_path = attachments_dir / filename

    # Create a valid blank image
    mode = "RGB" if args.format.lower() not in ("png","gif") else "RGBA"
    bg = (255,255,255,0) if mode == "RGBA" else (255,255,255)
    Image.new(mode, (args.width, args.height), color=bg).save(img_path)

    # Launch editor on the new file
    run_editor([args.editor, str(img_path)])

    # If saved and non-empty, print Markdown link relative to md_dir
    if img_path.exists() and img_path.stat().st_size > 0:
        # Always insert a relative link like: ![name](attachments/name.png)
        rel = Path(args.attachments) / filename
        print(f"![{filename}]({rel.as_posix()})")
    else:
        print("")

if __name__ == "__main__":
    main()

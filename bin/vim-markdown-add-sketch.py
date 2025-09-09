#!/usr/bin/env python3
import subprocess
import sys
from pathlib import Path
from datetime import datetime
from PIL import Image

def open_in_pinta(path: Path):
    subprocess.run(
        ["pinta", str(path)],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )

def main():
    if len(sys.argv) < 2:
        print("")  # nothing to insert into vim
        return

    md_file_path = Path(sys.argv[1]).resolve()
    md_dir = md_file_path.parent
    attachments = md_dir / "attachments"
    attachments.mkdir(exist_ok=True)

    # --- EDIT MODE ---
    if len(sys.argv) >= 3:
        edit_path = Path(sys.argv[2])
        if not edit_path.is_absolute():
            edit_path = (md_dir / edit_path).resolve()

        if edit_path.exists() and edit_path.is_file():
            open_in_pinta(edit_path)

        print("")  # do not insert anything in edit mode
        return

    # --- CREATE MODE ---
    filename = f"sketch-{datetime.now().strftime('%Y%m%d-%H%M%S')}.png"
    full_path = attachments / filename

    # Create valid white PNG (800x600)
    Image.new("RGB", (800, 600), color="white").save(full_path)

    open_in_pinta(full_path)

    # If file exists and has nonzero size, insert Markdown link
    if full_path.exists() and full_path.stat().st_size > 0:
        print(f"![{filename}](attachments/{filename})")
    else:
        print("")

if __name__ == "__main__":
    main()


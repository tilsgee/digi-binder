# digi-binder
This script converts a folder of images into a single CBZ or CBR file. It is useful for organizing and archiving comic books and manga.

#v0.2 — 7-Zip Edition

- Removed all WinRAR dependencies.

- Added internal 7z.exe support for all archive operations.

- New Option 4: Combine multiple .cbz files into one (sorted, user-named).

- Reintroduced legacy conversions:

- CBR → RAR now converts .cbr → .cbz (RAR creation unsupported).

- RAR → CBR now converts .rar → .cbz (with renamed extension).

- Improved cleanup of temporary extraction folders.

- Preserved classic DIGI-BINDER menu layout and style.

- Fully portable — just place 7z.exe beside DIGI-BINDER.bat.
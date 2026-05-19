# shell-scripts

Shell configuration and utility scripts for zsh.

## Structure

```
shell-scripts/
├── zshrc            # Main zsh config (symlink to ~/.zshrc)
├── shell.d/         # Scripts sourced automatically by zshrc at startup
│   ├── aliases.sh
│   ├── functions.sh
│   ├── ffmpeg_utils.sh
│   ├── git_functions.sh
│   ├── kube.sh
│   ├── docker.sh
│   ├── gcp.sh
│   ├── pdf.sh
│   └── lazyload.sh
└── hp-driver-fix.sh # Standalone script (see below)
```

## shell.d

### aliases.sh

| Alias | Command |
|---|---|
| `gst`, `gch`, `gl`, `gcb`, `gb`, `gtm` | git shortcuts |
| `dcls`, `dils`, `dcrm`, `dirm`, `dprune` | docker container/image management |
| `dku`, `dkd`, `dks`, `dkl`, `dkb` | docker-compose shortcuts |
| `kcat`, `kdiff` | kitty icat / diff (kitty only) |
| `xp` / `xpi` | paste from clipboard (text / image) |
| `play_selection` | play clipboard URL with mpv |
| `slideshow` | slideshow of all images in current dir via mpv |
| `pie` | `python3` |
| `j` | `z` (zoxide) |
| `y` / `yy` | yazi file manager |
| `r` / `rc` | ranger (rc returns to last dir) |
| `bcp` | rsync with progress |
| `ex` | universal archive extractor |
| `o` | `open` / `xdg-open` / `wslview` |
| `vi` | vim |
| `subs` | download English subtitles via subliminal |
| `wtf_scroll` | fix terminal scroll after fullscreen app |
| `remorphans`, `remcache`, `cleanup`, `remove` | Arch/yay package cleanup (Linux only) |

### functions.sh

| Function | Description |
|---|---|
| `activate` | Activate nearest `env/` or `.venv/` walking up the tree |
| `cpp <file> [input]` | Compile and run a C++ file with sanitizers |
| `gio <lang>` | Fetch `.gitignore` template from gitignore.io |
| `rename_media <dir>` | Rename media files by creation date using exiftool |
| `pad <in> <out> <px> [color]` | Add padding around an image using ImageMagick |
| `ffbs <dir> <size>` | Find files by size (e.g. `+1G`, `-500M`) |
| `ex <archive>` | Extract any archive format |
| `random_num <digits>` | Generate a random number with N digits |
| `random_string <len>` | Generate a random alphanumeric string |
| `make_heading <text>` | Print a centered heading across terminal width |
| `xsv-head <file> [n]` | Preview first N rows of a CSV via xsv |
| `dksul <service>` | docker-compose stop → up → logs for a service |
| `fgrpcui <proto_dir>` | Interactive grpcui launcher using gum |
| `fgrpcurl <proto_dir>` | Interactive grpcurl launcher using gum |
| `yy` | yazi with auto `cd` on exit |
| `compressEpub <file>` | Re-compress epub images to webp |
| `yt` | Interactive yt-dlp downloader (video or audio) via gum |
| `pd` | Interactive aria2c downloader via gum |
| `dinr <YYYY-MM-DD>` | USD → INR rate for a given date (FBIL) |

### ffmpeg_utils.sh

| Function/Alias | Description |
|---|---|
| `convto <file> <codec>` | Re-encode video to `libx264` or `libx265` |
| `scale <file> <w> <h>` | Scale video to given resolution |
| `tomp3 <ext>` | Convert all `*.ext` files in cwd to mp3 |
| `tohevc <file>` | Convert to HEVC if not already |
| `clipVideo <file> <start> <end>` | Clip a segment of a video |
| `addsub <video> <srt>` | Mux subtitles into a video |
| `addsub2all` | Mux subtitles for all matching mkv+srt pairs in cwd |
| `videoProcessing` | Interactive re-encode workflow via gum |
| `img2vid` (alias) | Create video from image sequence |

### git_functions.sh

| Function | Description |
|---|---|
| `delete_gone_branches <dir>` | Delete local branches whose remote is gone |
| `remove_branches_from_remote` | Interactively delete old remote branches via gum |

### kube.sh

| Alias/Function | Description |
|---|---|
| `kcuc`, `kccc`, `kcgc` | kubectl context management |
| `kgp`, `kgpa`, `kgpw`, `kdp` | get/describe pods |
| `kgns`, `kdns` | namespaces |
| `kgno`, `kdno`, `kdelno` | nodes |
| `kl`, `klf` | logs / follow |
| `kcp <ns> <pod> <src> <dst>` | Copy files from a pod with progress (via pv) |
| `klogs <service>` | Tail pod logs via stern |

### docker.sh

| Function | Description |
|---|---|
| `dkexec` | Interactively exec into a running container via gum |

### gcp.sh

| Function | Description |
|---|---|
| `airflowui <project-id> [location]` | Open Cloud Composer Airflow UI in browser |

### pdf.sh

| Function | Description |
|---|---|
| `darkenPdf <file>` | Increase contrast of a scanned PDF |
| `shrinkPdf -i <file> [-o output] [-q 0-3]` | Compress a PDF using Ghostscript |
| `combinePdfs -o <out> <file1> <file2> ...` | Merge multiple PDFs |

### lazyload.sh

Lazy-loads `nvm` and `fzf` on first use to keep shell startup fast.

---

## hp-driver-fix.sh

Patches the HP printer driver `.dmg` to bypass the macOS version check (bumps the requirement from 15.0 → 100.0).

```bash
./hp-driver-fix.sh HewlettPackardPrinterDrivers.dmg
```

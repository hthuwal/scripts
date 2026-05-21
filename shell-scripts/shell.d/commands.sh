if command -v pbpaste >/dev/null 2>&1; then
  CLIP_CMD=(pbpaste)
elif command -v xclip >/dev/null 2>&1; then
  CLIP_CMD=(xclip -o -selection clipboard)
elif command -v wl-paste >/dev/null 2>&1; then
  CLIP_CMD=(wl-paste)
else
  CLIP_CMD=()
fi
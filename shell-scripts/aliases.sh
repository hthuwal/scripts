# ---------------------------------------------------------------------------- #
#                            Kitty Specific Aliases                            #
# ---------------------------------------------------------------------------- #

if [[ $TERM == "xterm-kitty" ]]
then
	alias kcat="kitty +kitten icat"
	alias kdiff="kitty +kitten diff"
fi

# ---------------------------------------------------------------------------- #
#                                   Clipboard                                  #
# ---------------------------------------------------------------------------- #

if [[ "$OSTYPE" == "darwin"* ]]; then
	alias xp="pbpaste"
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
	alias xp="xclip -out -selection clipboard"
	alias xpi="xp -t image/png"
fi

# ---------------------------------------------------------------------------- #
#                                      MPV                                     #
# ---------------------------------------------------------------------------- #

alias play_selection='mpv "$(xp)"'
alias slideshow="find . * | mpv -fs --image-display-duration=1 --playlist=-"

# ---------------------------------------------------------------------------- #
#                               Downloading stuff                              #
# ---------------------------------------------------------------------------- #

alias youtube-dl-aria="youtube-dl --external-downloader 'aria2c' --external-downloader-args '--file-allocation=none -c -x 16 -s 16'" 
alias youtube="youtube-dl -c -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mkv"
alias youmusic="youtube-dl -c -f 'bestaudio[ext=m4a]' -x --audio-format mp3"
alias pd='aria2c --file-allocation=none -c -x 16 -s 16' 

# ---------------------------------------------------------------------------- #
#                                    python                                    #
# ---------------------------------------------------------------------------- #

alias pie="python3"
alias ptpy='ptpython'

# ---------------------------------------------------------------------------- #
#                                      git                                     #
# ---------------------------------------------------------------------------- #

# -------------------------------- What I use -------------------------------- #

alias gst="git status"
alias gs="git stash --include-untracked"
alias gsp="git stash pop"
alias gtm='git stash --include-untracked && git checkout master'
alias gb='git checkout - && git stash pop'
alias gch='git checkout'
alias gl='git log --branches --remotes --tags --graph --oneline --decorate'
alias gcb='git rev-parse --abbrev-ref HEAD'

# ------------------------------- What I don't ------------------------------- #

alias ga="git add"
alias gc='git commit'
alias gp='git push origin master'
alias gpl='git pull origin master'

# ---------------------------------------------------------------------------- #
#                                 Arch related                                 #
# ---------------------------------------------------------------------------- #

if [[ "$OSTYPE" == "linux-gnu" ]]; then
	alias remorphans='sudo pacman -Rns $(pacman -Qtdq)'
	alias remcache='sudo paccache -r'
	alias cleanup='yay -Sc'
	alias remove='yay -Rcns'
fi

# ---------------------------------------------------------------------------- #
#                                    Docker                                    #
# ---------------------------------------------------------------------------- #

alias drmi='sudo docker rmi $(sudo docker images -q)'
alias drmc='sudo docker rm $(sudo docker ps -a -q)'
alias dkillall='sudo docker kill $(sudo docker ps -a -q)'
alias vpl_docker='sudo docker run --rm --privileged -p 80:80 -p 443:443 -it --user root hthuwal/vpl_docker bash -c "service vpl-jail-system start; bash"'

# ---------------------------------------------------------------------------- #
#                                 Miscellaneous                                #
# ---------------------------------------------------------------------------- #

alias j='z'
alias r='ranger'
alias rc='ranger --choosedir="$HOME/.rangerdir"; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias subs="subliminal download -l en"
alias bcp="rsync -ah --info=progress2"
alias gapdf='wget -A pdf -m -p -E -k -K -np -nd'
alias vi='vim'

if [[ "$OSTYPE" == "darwin"* ]]; then
	alias tac='tail -r'
	alias o='open'
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
	alias subl="subl3"
	alias o='xdg-open'
	alias net_sucks='systemctl restart NetworkManager.service'
fi

alias wtf_scroll='tput rmcup'

alias youtube="youtube-dl -c -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mkv"
alias youmusic="youtube-dl -c -f bestaudio[ext=m4a]"
alias subs="subliminal download -l en"
#python
alias pie="python3.6"

alias r='ranger'

#Github
alias gst="git status"
alias ga="git add"
alias gc='git commit'
alias gp='git push origin master'
alias gpl='git pull origin master'
alias gl='git log --branches --remotes --tags --graph --oneline --decorate'
alias gcm='git checkout master'

alias gapdf='wget -A pdf -m -p -E -k -K -np -nd'

#Aria parallel download
alias pd='aria2c --file-allocation=none -c -x 16 -s 16' 
alias ptpy='ptpython'

alias subl=subl3

#aliases for arch
alias remorphans='sudo pacman -Rns $(pacman -Qtdq)'
alias remcache='sudo paccache -r'

#aliases for docker
alias drmi='sudo docker rmi $(sudo docker images -q)'
alias drmc='sudo docker rm $(sudo docker ps -a -q)'
alias dkillall='sudo docker kill $(sudo docker ps -a -q)'
alias vpl_docker='sudo docker run --rm --privileged -p 80:80 -p 443:443 -it --user root hthuwal/vpl_docker bash -c "service vpl-jail-system start; bash"'

xsv-head() {
    lines=${2:-100}
    xsv cat -n rows -- $1 | head -n $lines | xsv table | less -S
}

function gio() { 
	curl -L -s https://www.gitignore.io/api/$@ ;
}

function x265tox264() {

	file_name=$(basename "$@")
	root_dir=$(dirname "$@")
	dest_dir="$root_dir""/x264"
	
	if [ ! -d "$dest_dir" ]; then
		mkdir "$dest_dir"
	fi

	dest_file="$dest_dir""/""$file_name"
	
	echo "Trying to convert to x264.."
	ffmpeg -i "$@" -map 0 -c:a copy -c:s copy -c:v libx264 "$dest_file"
}

function tomp3(){
	mkdir mp3_tmp
	for i in *.$1
	do 
		(ffmpeg -i "$i" -acodec libmp3lame "./mp3_tmp/$(basename "${i/.mp3}").mp3") 
		if [ $? -eq 0 ]
		then
			echo "Conversion successful"
			rm "$i"
		fi
	done
	mv -v mp3_tmp/* ./
	rm -rf mp3_tmp
}

alias img2vid='ffmpeg -r 3 -f image2 -s 1024x768 -i %03d.png -vcodec libx264 -crf 25'
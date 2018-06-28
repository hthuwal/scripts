alias youtube="youtube-dl -c -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mkv"
alias youmusic="youtube-dl -c -f bestaudio[ext=m4a] -x --audio-format mp3"
alias subs="subliminal download -l en"
alias bcp="rsync -ah --info=progress2"
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

alias vi='vim'

#aliases for arch
alias remorphans='sudo pacman -Rns $(pacman -Qtdq)'
alias remcache='sudo paccache -r'

#aliases for docker
alias drmi='sudo docker rmi $(sudo docker images -q)'
alias drmc='sudo docker rm $(sudo docker ps -a -q)'
alias dkillall='sudo docker kill $(sudo docker ps -a -q)'
alias vpl_docker='sudo docker run --rm --privileged -p 80:80 -p 443:443 -it --user root hthuwal/vpl_docker bash -c "service vpl-jail-system start; bash"'

alias img2vid='ffmpeg -r 1 -f image2 -s 1920x1080 -i %03d.png -vcodec libx264 -crf 25'


# Functions
function gio() { 
    curl -L -s https://www.gitignore.io/api/$@ ;
}

function rename_media(){
	num_params=$#
	
	if [[ $num_params -eq 1 ]]
    then

    	if [[ -d $1 ]]
    	then
	    	cur=$(pwd)
			cd $1
	        for filename in *
	        do
	          	tmp="$(echo "$filename" | tr '[A-Z]' '[a-z]')"
	          	case "$filename" in
	          	20*)
	        	  echo "Don't need to rename "$filename
	        	;;
	            *.MOV|*.mov) 
	              mv -iv "$filename" "$(exiftool -s -CreationDate -d "%Y_%m_%d_%H_%M_%S" "$filename" | awk -F ': ' '{print $2}')"_$tmp
	              ;;
	            *.JPG|*.jpg)
	              mv -iv "$filename" "$(exiftool -s -CreateDate -d "%Y_%m_%d_%H_%M_%S" "$filename" | awk -F ': ' '{print $2}')"_$tmp
	              ;;
	            *.MP4|*.mp4|*.AVI|*.avi)
	              mv -iv "$filename" "$(exiftool -s -FileModifyDate -d "%Y_%m_%d_%H_%M_%S" "$filename" | awk -F ': ' '{print $2}')"_$tmp
	              ;;
	            *)
	              echo 'Not a *.jpg or a *.mov!'
	              ;;
	          	esac
	        done
        else
        	echo $1 is not a directory
        fi
    else
        echo -e "One argmuent required: The path to the directory containing media files"
        echo -e "\nUsage:\n\n\trename_media pathtofolder\n"
    fi
}

function cpp() {
    # Function to compile and execute a cpp file
    num_params=$#
    if [[ $num_params -eq 2 ]]
    then    
        echo "g++ $1 && time ./a.out < $2"
        g++ $1 && time ./a.out < $2
    elif [[ $num_params -eq 1 ]]
    then
        echo "g++ $1 && time ./a.out"
        g++ $1 && time ./a.out
    else
        echo -e "Atleast one argmuent required"
        echo -e "\nUsage:\n\n\tcpp file.cpp input_file(optional)\n"
    fi
}

.  "/home/hthuwal/dev/Scripts/Shell Scripts/ffmpeg_utils.sh" 

xsv-head() {
    lines=${2:-100}
    xsv cat -n rows -- $1 | head -n $lines | xsv table | less -S
}

function activate()
{
    function isNum(){
        re='^[0-9]+$'
        if [[ $1 =~ $re ]]
        then
            echo 1
        else
            echo 0
        fi
    }

    ask=""
    venvs=()
    iter=0
    while IFS= read line
        do
            arr=($line) #splitting line into elements
            venvs+=(${arr[1]})
            ask="$ask$iter: ${arr[0]}\n"
            iter=$(($iter+1))
        done <"/home/hthuwal/.venvs_list"



    if [ "$#" -eq 1 ]
    then
        input=$1
    else
        echo -e $ask
        read input
    fi

    max=$(($iter - 1))

    if [[ $(isNum $input) -eq 1 ]] && [ $input -le $max ] && [ $input -ge 0 ]
    then
        source ${venvs[$input]}
    else
        echo "Pleae enter a valid number between [0 and $max]"
    fi
}


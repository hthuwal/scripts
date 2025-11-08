function gio() { 
    curl -L -s "https://www.gitignore.io/api/$1" ;
}

# ------------- Rename media files based on their creation date. ------------- #

function rename_media(){
	local num_params=$#
	
	if [[ $num_params -eq 1 ]]
    then

    	if [[ -d $1 ]]
    	then
	    	local cur=$(pwd)
			cd "$1" || exit
	        for filename in *
	        do
	          	local tmp="$(echo "$filename" | tr '[:upper:]' '[:lower:]')"
	          	case "$filename" in
		          	
		          	20??_*) date="fine" ;;
		            
		            *.MOV|*.mov|*.wmv|*.WMV) date="-CreationDate" ;;
		            
		            *.JPG|*.jpg) date="-CreateDate" ;;
		            
		            *.MP4|*.mp4) date="-MediaCreateDate" ;;
		            
		            *.AVI|*.avi) date="-DateTimeOriginal" ;;
		            
		            *) date="" ;;
	          	esac

	          	if [[ $date == "fine" ]]; then
	          		echo "Don't need to rename $filename";

	          	elif [[ -n $date ]]; then	
					mv -iv "$filename" "$(exiftool -s "$date" -d "%Y_%m_%d_%H_%M_%S" "$filename" | awk -F ': ' '{print $2}')"_"$tmp"
	          	
	          	else
	          		echo "$filename" is not of a supported format.
	          	fi
	        done
	        cd "$cur" || exit
        else
        	echo "$1" is not a directory
        fi
    else
        echo -e "One argmuent required: The path to the directory containing media files"
        echo -e "\nUsage:\n\n\trename_media pathtofolder\n"
    fi
}

# ---------------- Function to compile and execute a cpp file ---------------- #

function cpp() {
    local num_params=$#
    if [[ $num_params -eq 2 ]]
    then    
        echo "g++ -Wall -g -O3 -fsanitize=address --std=c++17 ${1} && time ./a.out < ${2}"
        g++ -Wall -g -O3 -fsanitize=address --std=c++17 "${1}" && time ./a.out < "${2}"
        rm a.out
    elif [[ $num_params -eq 1 ]]
    then
        echo "g++ -Wall -g -O3 -fsanitize=address --std=c++17 ${1} && time ./a.out"
        g++ -Wall -g -O3 -fsanitize=address --std=c++17 "${1}" && time ./a.out
        rm a.out
    else
        echo -e "Atleast one argmuent required"
        echo -e "\nUsage:\n\n\tcpp file.cpp input_file(optional)\n"
    fi
}

# ---------------------- Check if argument is a number. ---------------------- #

function isNum(){
    local re='^[0-9]+$'
    if [[ $1 =~ $re ]]
    then
        echo 1
    else
        echo 0
    fi
}

# --------------------- Activate the closest virtual env. -------------------- #

function activate()
{
	local cwd=$(pwd)
	local home=$HOME

	local cond=true
	while "$cond"
	do
		local dir=$(pwd)
		if [[ "$dir" == "$home" ]]; then
			echo "env folder not found."
			local cond=false
		elif [ -d "env" ]; then
			echo "Activating virtual environment located at: $(pwd)/env"
			source	"env/bin/activate"
			local cond=false
		else
			cd ..
		fi
	done
	cd "$cwd" || exit
}



# ------------ Function to pad a black background around an image. ----------- #

function pad()
{
	local input=$1
	local output=$2
	local padding=$3
	local color=$4

	if [ -z "$input" ] || [ -z "$output" ] || [ -z "$padding" ]; then
		echo -e "Usage:\t pad in_file out_file padding_size.\n\n\t E.g pad in.png out.png 200\n"
		return 1
	fi

	if [ -z "$color" ]; then
		local color="black"
	fi

	local width=$(convert "$1" -print "%w" /dev/null)
	local height=$(convert "$1" -print "%h" /dev/null)
	convert -background $color -gravity center -extent "$(echo "$width + $padding" | bc)"x"$(echo "$height + $padding" | bc)" "$input" "$output"
}

# ------------------------- Find Files based on size. ------------------------ #

# +1G files bigger than 1Gigs
# -1G files smaller than 1Gigs
function ffbs()
{
	local dir="$1"
	local thresh="$2"
	find "$dir" -type f -size "$thresh" -print0 | xargs -0 du -sh
}

# -------------------------- ex - archive extractor -------------------------- #

# # usage: ex <file>
function ex ()
{
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# -------- Generates a random number with specified number of digits. -------- #

function random_num {
	local num_digits=$1
	local NUMBER=$(LC_CTYPE=C tr -dc '0-9' < "/dev/urandom" | fold -w 256 | head -n 1 | sed -e 's/^0*//' | head -c "$num_digits")
	if [[ "$NUMBER" == "" ]]; then
	  local NUMBER=0
	fi
	echo $NUMBER
}

# ------- Generates a random alpha-numeric string of specified length. ------- #

function random_string {
	local num_chars=$1
	local LC_CTYPE=C tr -dc 'a-zA-Z0-9' < "/dev/random" | fold -w "$num_chars" | head -n 1
}

# ----------- Function to print stuff at the center of the screen. ----------- #

function make_heading {
  local columns=$(tput cols)
  local title=$1
  printf '%*s\n' "${columns}" '' | tr ' ' =
  printf "%*s\n" $(((${#title}+columns)/2)) "$title"
  printf '%*s\n' "${columns}" '' | tr ' ' =
}

function xsv-head() {
    local lines=${2:-100}
    xsv cat -n rows -- "$1" | head -n "$lines" | xsv table | less -S
}

# ---------------------------- docker stop up logs --------------------------- #
function dksul {
	docker-compose stop $1 &&\
	docker-compose up -d $1 &&\
	docker-compose logs -f $1
}

# ------------------------------- Dollor to INR ------------------------------ #
function dinr() {
  # Date should be provided in YYYY-MM-DD format
  curl "https://www.fbil.org.in/wasdm/refrates/fetchfiltered?fromDate=$1&toDate=$1&authenticated=false" |  jq ".[] | .processRunDate, .subProdName, .rate" | paste - - -
}

# ----------------- Interactive grpcurl and grpcui using gum ----------------- #

function fgrpcui() {
	if [[ ! -d $1 ]]; then
		echo "Path to proto folder is req"
		return
	fi

	local protopath=${1}
	local proto=$(find $protopath -type f | gum filter --placeholder="Select proto file")
	if [[ -z ${proto} ]] {
		echo "No Proto file selected. Exiting"
		return
	}

	local url=$(gum input --placeholder "gRPC server URL")
	if [[ -z $url ]] {
		echo "Empty Url. Exiting"
		return
	}

	grpcui --plaintext --import-path ${protopath} -proto ${proto} ${url}
}

function fgrpcurl() {
	if [[ ! -d $1 ]]; then
		echo "Path to proto folder is req"
		return
	fi
	local protopath=${1}

	local proto=$(find $protopath -type f | gum filter --placeholder="Select proto file")
	if [[ -z $proto ]] {
		echo "No Proto file selected. Exiting"
		return
	}

	local service=$(grpcurl -import-path ${protopath} -proto ${proto} list | gum filter --placeholder="Select Service")
	if [[ -z $service ]] {
		echo "No service selected. Exiting"
		return
	}

	local method=$(grpcurl -import-path ${protopath} -proto ${proto} list ${service} | gum filter --placeholder="Select Service")
	if [[ -z $method ]] {
		echo "No method selected. Exiting"
		return
	}

	local url=$(gum input --placeholder "gRPC server URL")
	if [[ -z $url ]] {
		echo "Empty Url. Exiting"
		return
	}

	local payload=$(gum write --placeholder "Json Payload (CTRL+D to finish)")
	if [[ -z $payload ]] {
		echo "Empty payload. Exiting"
		return
	}

	local cmd="grpcurl -import-path ${protopath} \\
-proto ${proto} \\
--plaintext \\
-d @ \\
${url} \\
${method} <<EOM
${payload}
EOM"

	make_heading "Executing the following command"
	echo "\n${cmd}\n"
	make_heading ""
	echo
	eval $cmd
}

# ----------------------------------- yaazi ---------------------------------- #
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function compressEpub() {
	if ! command -v cwebp &>/dev/null; then
		echo "cwebp not found. Please install cwebp and rerun the script"
		return 1
	fi

	echo Compressing with webp...
	
	rm -rf ./epub
	unzip "$1" -d epub

	cd epub
	for i in **/*.(png|jpg|jpeg); do
		cwebp -short "${i}" -o "${i}"
	done

	# zip epub
	zip -0 -X "../compress.epub" mimetype
	zip -rDX9 "../compress.epub" * -x mimetype
	cd ..

	rm -rf ./epub # remove work directory

	# move the compressed one and rename the other to original
	mv "$1" "${1}.original"
	mv compress.epub "$1"

	echo '-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
	du -h "${1}.original"
	du -h "$1"
	echo '-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
}
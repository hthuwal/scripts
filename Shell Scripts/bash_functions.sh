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
	          	20*) ##name already starts with 2018 or 20** something
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
	        cd $cur
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
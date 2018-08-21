function convto() {
    if [ $# -ne 2 ]; then
        msg="Two arguments expected $# given\n
            \r\tUsage: convert pathtovideo video_format\n
            \rReencode the video using video_format(libx264, libx265)\n\n"
        printf "$msg"
        return 1
    fi
    
    file_name=$(basename "$1")
    root_dir=$(dirname "$1")
    format=$2
    dest_dir="$root_dir""/""$format"
    
    if [ ! -d "$dest_dir" ]; then
        mkdir "$dest_dir"
    fi

    dest_file="$dest_dir""/""$file_name"
    
    echo "Trying to convert to $format.."
    ffmpeg-bar -i "$1" -map 0 -c:a copy -c:s copy -c:v "$format" "$dest_file"
}

function scale() {
    if [ $# -ne 3 ]; then
        msg="Three argument expected $# given\n
            \r\tUsage: scale pattovideo width height\n
            \rScale the video to width x height\n\n"
        printf "$msg"
        return 1
    fi
    
    file_name=$(basename "$1")
    root_dir=$(dirname "$1")
    width="$2"
    height="$3"

    dest_file=$root_dir/"$width"x"$height"_"$file_name"

    echo -e "Scaling...\n"
    ffmpeg-bar -i "$1" -vf scale="$width"x"$height" "$dest_file"  
}

function tomp3(){
    if [ $# -ne 1 ]; then
        msg="One argument expected $# given\n
             \r\tUsage: tomp3 ext\n
             \rAll files with .ext extension in current directory will be converted to .mp3\n\n"
        printf "$msg"
        return 1
    fi

    mkdir mp3_tmp
    for i in *.$1
    do 
        (ffmpeg-bar -i "$i" -acodec libmp3lame "./mp3_tmp/$(basename "${i/.$1}").mp3") 
        if [ $? -eq 0 ]
        then
            echo "Conversion successful"
        fi
    done
    mv -v mp3_tmp/* ./
    rm -rf mp3_tmp
}


function clipVideo(){
    if [ $# -ne 3 ]; then
        msg="Three arguments expected $# given\n
             \r\tUsage: clipVideo pathtovideo start_time end_time\n
             \rVideo is clipped from start_time to end_time\n\n"
        printf "$msg"
        return 1
    fi

    file_name=$(basename "$1")
    root_dir=$(dirname "$1")
    dest_dir="$root_dir""/clipped"
    start=$2
    end=$3

    if [ ! -d "$dest_dir" ]; then
        mkdir "$dest_dir"
    fi

    dest_file="$dest_dir""/""$start""to""$end""of""$file_name"
    dest_file=$(sed "s/:/_/g" <<< $dest_file)
    echo -e "\nClipping $file_name from $start to $end\n"
    ffmpeg-bar -i "$1" -map 0 -ss "$2" -to "$3" -c copy "$dest_file"
}

function addsub(){
    if [ $# -ne 2 ]; then
        msg="Three arguments expected $# given\n
             \r\tUsage: addsub pathtovideo pathtosrt\n\n"
        printf "$msg"
        return 1
    fi

    file_name=$(basename "$1")
    ext="${file_name##*.}"
    root_dir=$(dirname "$1")
    subtitles=$2

    dest_file="$root_dir""/subbed_""$file_name"
    echo -e "\nAdding subs:$subtitles to $file_name\n"

    # (xfce4-terminal --working-directory="$root_dir" --command="watch -n 1 \"du -h '$file_name' '$dest_file'\"")

    srt="mov_text" ## for mp4
    if [ $ext == "mkv" ]; then
        srt="srt"
    fi
    
    ffmpeg-bar -i "$subtitles" -i "$1" -c copy -c:s $srt "$dest_file"

    if [ $? == 0 ]; then
        echo -e "Subtiles added successfullly\n"
        rm "$file_name" "$subtitles"
        mv "$dest_file" "$file_name"
    else
        echo -e "\nFailed to add subtitles\n"
        rm "$dest_file"
    fi
}

function addsub2all(){    
    for file in *
    do
        file_name=$(basename "$file")
        name="${file_name%.*}"
        ext="${file_name##*.}"
        root_dir=$(dirname "$file")
        subtiles="$root_dir""/""$name".srt
        if  [ -f "$subtiles" ] && ([ $ext == "mkv" ] || [ $ext == "mp4" ] || [ $ext == "m4v" ]); then
            addsub "$file" "$subtiles"
        fi
    done
}

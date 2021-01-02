if command -v ffpb &> /dev/null 
then 
    ffmpeg_cmd="ffpb"
else
    ffmpeg_cmd="ffmpeg"
fi

alias img2vid='ffmpeg -r 1 -f image2 -s 1920x1080 -i %03d.png -vcodec libx264 -crf 25'

function convto() {
    if [[ $# -ne 2 ]]; then
        msg="Two arguments expected $# given\n
            \r\tUsage: convert pathtovideo video_format\n
            \rReencode the video using video_format(libx264, libx265)\n\n"
        printf "%s" "$msg"
        return 1
    fi
    
    file_name=$(basename "$1")
    root_dir=$(dirname "$1")
    format=$2
    dest_dir="$root_dir""/""$format"
    
    if [[ ! -d "$dest_dir" ]]; then
        mkdir "$dest_dir"
    fi

    dest_file="$dest_dir""/""$file_name"
    echo "Trying to convert to $format.."
    $ffmpeg_cmd -i "$1" -map 0 -c:a copy -c:s copy -c:v "$format" "$dest_file"   
}

function scale() {
    if [[ $# -ne 3 ]]; then
        msg="Three argument expected $# given\n
            \r\tUsage: scale pattovideo width height\n
            \rScale the video to width x height\n\n"
        printf "%s" "$msg"
        return 1
    fi
    
    file_name=$(basename "$1")
    root_dir=$(dirname "$1")
    width="$2"
    height="$3"

    dest_file=$root_dir/"$width"x"$height"_"$file_name"

    echo -e "Scaling...\n"
    $ffmpeg_cmd -i "$1" -vf scale="$width"x"$height" "$dest_file"  
}

function tomp3(){
    if [[ $# -ne 1 ]]; then
        msg="One argument expected $# given\n
             \r\tUsage: tomp3 ext\n
             \rAll files with .ext extension in current directory will be converted to .mp3\n\n"
        printf "%s" "$msg"
        return 1
    fi

    mkdir mp3_tmp
    for i in *."$1"
    do 
        if $ffmpeg_cmd -i "$i" -acodec libmp3lame "./mp3_tmp/$(basename "${i/.$1}").mp3"; then
            echo "Conversion successful"
        fi
    done
    mv -v mp3_tmp/* ./
    rm -rf mp3_tmp
}

function tohevc() {
    file="$1"
    codec=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$file")
    make_heading "$file: $codec"
    if [[ $codec != "hevc" ]]; then
        convto "$file" libx265
        if convto "$file" libx265; then
            mv "libx265/$file" "$file"
        fi
    else
        echo "Already in hevc format. Skipping file..."
    fi
}

function clipVideo(){
    if [[ $# -ne 3 ]]; then
        msg="Three arguments expected $# given\n
             \r\tUsage: clipVideo pathtovideo start_time end_time\n
             \rVideo is clipped from start_time to end_time\n\n"
        printf "%s" "$msg"
        return 1
    fi

    file_name=$(basename "$1")
    root_dir=$(dirname "$1")
    dest_dir="$root_dir""/clipped"
    start=$2
    end=$3

    if [[ ! -d "$dest_dir" ]]; then
        mkdir "$dest_dir"
    fi

    dest_file="$dest_dir""/""$start""to""$end""of""$file_name"
    dest_file="${dest_file//:/_}"
    echo -e "\nClipping $file_name from $start to $end\n"
    $ffmpeg_cmd -i "$1" -map 0 -ss "$2" -to "$3" -c copy "$dest_file"
}

function addsub(){
    if [[ $# -ne 2 ]]; then
        msg="Three arguments expected $# given\n
             \r\tUsage: addsub pathtovideo pathtosrt\n\n"
        printf "%s" "$msg"
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
    if [[ $ext == "mkv" ]]; then
        srt="srt"
    fi

    if $ffmpeg_cmd -i "$subtitles" -i "$1" -c copy -c:s $srt -disposition:s:0 default "$dest_file"; then
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
        subtitles="$root_dir""/""$name".srt
        if ! [[ -f "$subtitles" ]]; then
            subtitles="$root_dir""/""$name".en.srt
        fi
        if  [[ -f "$subtitles" ]] && { [[ $ext == "mkv" ]] || [[ $ext == "mp4" ]] || [[ $ext == "m4v" ]]; }; then
            addsub "$file" "$subtitles"
        fi
    done
}

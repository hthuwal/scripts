# -------------------------------- Darken Pdf -------------------------------- #
function darkenPdf {
    echo "Converting into png..."
    convert -density 384 "${1}" -quality 100 -alpha remove temp.png
    echo "Increasing contrast..."
    convert temp*.png -level 50%%,100%%,0.3 darker.png
    rm temp*.png
    echo "Combining Into Pdf..."
    convert darker*.png "darker-${1}.pdf"
    rm darker*.png
}

# -------------------------------- Shrink pdf -------------------------------- #
function shrinkPdf() {

    function usage() {
        echo -e "Usage: shrink-pdf <-i|--input INPUT_PDF_FILE> <OPTIONS>\n"
        echo -e "Shrink the INPUT_PDF_FILE\n\n"
        echo -e "OPTIONS\n"
        printf "%-25s\t%s\n" "-o|--output" "Specify name of the output file. Default name of the output file is INPUT_PDF_FILE-shrink.pdf"
        printf "%-25s\t%s\n" "-q|--quality" "Specify output quality [0-3]. Default is 1"
        printf "%-25s\t%s\n" "" "0: lower quality, smaller size."
        printf "%-25s\t%s\n" "" "1: for better quality, but slightly larger pdfs."
        printf "%-25s\t%s\n" "" "2: output similar to Acrobat Distiller 'Prepress Optimized' setting."
        printf "%-25s\t%s\n" "" "3: output similar to the Acrobat Distiller 'Print Optimized' setting."
    }

    # dealing with command line args
    while [[ "$#" -gt 0 ]]; do
        case "$1" in

        -h | --help)
            usage
            return 0
            ;;

        -i | --input)
            local infile="$2"
            if ! [[ -f "$infile" ]]; then
                echo -e "file '$infile' does not exist\n"
                usage
                return 1
            fi
            shift
            ;;

        -o | --output)
            local outfile="$2"
            shift
            ;;

        -q | --quality)
            local quality="$2"
            case "$quality" in
            0)
                quality="/screen"
                ;;
            1)
                quality="/ebook"
                ;;
            2)
                quality="/prepress"
                ;;
            3)
                quality="/printer"
                ;;
            *)
                echo -e "Quality should be between [0-3]. Use -h|--help to see the valid options"
                return 1
                ;;
            esac
            shift
            ;;
        --)
            break
            ;;
        -*)
            echo "Invalid option '$1'. Use -h|--help to see the valid options"
            return 1
            ;;
        esac
        shift
    done

    # checking if variables are set or not
    if [[ -z "$infile" ]]; then
        echo -e "Error: No input file specified. Use -h|--help to see the valid options"
        return 1
    fi

    if [[ -z "$outfile" ]]; then
        if [[ "${infile: -4:4}" == ".pdf" ]]; then ## filename has extension .pdf
            outfile=${infile:0:-4}"-shrink.pdf"
        else
            outfile=$infile"-shrink.pdf"
        fi
    fi

    if [[ -z "$quality" ]]; then
        quality="/ebook"
    fi

    ## attempting to shrink
    gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS="$quality" -sOutputFile="$outfile" "$infile"
    echo "File $infile shrinked to $outfile"
    return 0
}

# -------------------------------- Merge Pdfs -------------------------------- #
function combinePdfs() {
    help_message="Usage: combinePdfs -o outputfile.pdf input_file1.pdf input_file2.pdf .."

    SHORT=o:,h
    LONG=output:,help
    OPTS=$(getopt --alternative --options $SHORT --longoptions $LONG -- "$@")

    VALID_ARGUMENTS=$# # Returns the count of arguments that are in short or long options
    if [ "$VALID_ARGUMENTS" -eq 0 ]; then
        echo "${help_message}"
        return
    fi

    eval set -- "$OPTS"

    while :; do
        case "$1" in
        -o | --output)
            output_file=$2
            shift 2
            ;;
        -h | --help)
            echo "${help_message}"
            return
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Unexpected option: $1"
            return
            ;;
        esac
    done

    if [[ -f "${output_file}" ]]; then
        echo "Output file: ${output_file} already exists. Skipping merge."
        return
    fi

    if [[ $# == 0 ]]; then
        echo "No Input Files Provided"
        echo "${help_message}"
        return
    fi

    gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="${output_file}" $@
}

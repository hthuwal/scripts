echo Compressing with webp...

if ! command -v cwebp &>/dev/null; then
    echo "cwebp not found. Please install cwebp and rerun the script"
    exit 1
fi

rm -rf ./epub
unzip "$1" -d epub

cd epub
shopt -s globstar
for i in **/*.{png,jpg,jpeg}; do
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

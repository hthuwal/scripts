### :small_red_triangle_down: Download/Extract multiple links from a url

The webpage is parsed using BeautifulSoup and all the `<a>` tags with href containing desired extensions are downloaded/extracted.

**Script**: [download-all.py](download-all.py)    
**Dependencies**: [tqdm](https://github.com/tqdm/tqdm), [BeautifulSoup](https://github.com/getanewsletter/BeautifulSoup4)    
	`pip install tqdm, beautifulsoup4`

**Usage**    	
```
get-all [-h] [-e] url destination [extensions [extensions ...]]

Extract/Download Links

positional arguments:
  url          Url of the Webpage from where you intent to download/extract
               links.
  destination  Destination: Should be a directory. Or a FileName if -e is used
  extensions   Space seperated list of file types to be extracted/downloaded.
               For e.g. .mkv .mp4 .pdf

optional arguments:
  -h, --help   show this help message and exit
  -e           Extract all the relevant links to output file. (Default action
               is to download them in the output folder)
```

<br>
---

### :scissors: Trim File Names

To removes a set of substrings from the name of the files and folders in a directory.

Note: Apart from the last dot of extension if the filename contains extra "." (dots) then these dots are also replaced with delimiter(default is space).

**Script**: [trim-file-names.py](trim-file-names.py)

**Usage**
```
trim-file-names [-h] [-d DELIM] [-r] directory substrings [substrings ...]

Trim all file/folder names by removing specific substrings and replacing all
'.' by delim except the last.

positional arguments:
  directory             Path to directory whose content's name needs to be
                        trimmed.
  substrings            The substrings that you want to remove from filenames.

optional arguments:
  -h, --help            show this help message and exit
  -d DELIM, --delim DELIM
                        Delimiter used to replace all '.'. Default is space.
  -r                    Recurse into the subdirectories.

```

<br>
---
### :tv: Play Random Video

Ever wanted to play a random episode of a TV series you have? Well then this is the script for you. 

The scripts looks for videos of the format `".mkv", ".mp4", ".m4v", ".mov", ".wmv"` in a directory and randomly plays one of them.

**Script**: [play-random-video.py](play-random-video.py)

**Usage**
```
play-random-video.py [-h] dir

Randomly play a video from a given directory.

positional arguments:
  dir         path to directory containing videos.

optional arguments:
  -h, --help  show this help message and exit
```

<br>
---
### :pencil2: Auto Rename Videos

Automatically rename videos to their movie titles based on their metadata.

**Script**: [auto-rename-media.py](auto-rename-media.py)

**Usage**
```
auto-rename-media.py [-h] src

Rename a video or video files in a directory to their respective "Movie Name"
from their metadata.

positional arguments:
  src         Path to a video or directory containing video files

optional arguments:
  -h, --help  show this help message and exit

```

<br>
---
### get_subtitles

Try to download the best subtitles for all the videos present in a folder.
The path to the folder needs to be passed as command line argument. If no argument is passed, current working directory is searched.

**Dependency: Subliminal**

``pip install subliminal``
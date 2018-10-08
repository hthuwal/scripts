### :arrow_down_small: Download/Extract multiple links from a url

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
  extensions   Space seperated list of file types to be extracted/downloade.
               For e.g. .mkv .mp4 .pdf

optional arguments:
  -h, --help   show this help message and exit
  -e           Extract all the relevant links to output file. (Default action
               is to download them in the output folder)
```


## remove_from_file_names.py

This python script removes a set of substrings from the name of the files and folderes in a directory.

Note: Apart from the last dot of extension if the filename contains extra "." (dots) then these dots are also replaced with spaces.

**Update**: Script now works recursively on all subdirectories

- **Usage**
	
	`remove_from_file_names <dir> <substrings>`

	- **dir**: Target directory
	- **substings**: Space seperated list of substrings that will be removed if present in the names of files/folders in target directory .

- **Example**

	Suppose a folder "Test" contains the files:

	- tes.t 
	- 123.4
	- (abc).mkv 

	```bash
	python remove_from_file_names.py path-to-Test "es" "12" "(" "c)"
	```

	After running the above command the content of the folder "Test" would be
	
	- tt 
	- 3 
	- ab.mkv

## get_subtitles

Try to download the best subtitles for all the videos present in a folder.
The path to the folder needs to be passed as command line argument. If no argument is passed, current working directory is searched.

**Dependency: Subliminal**

``pip install subliminal``
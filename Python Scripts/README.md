## remove_from_file_names.py

This python script removes a set of substrings from the name of the files and folderes in a directory.

Note: Apart from the last dot of extension if the filename contains extra "." (dots) then these dots are also replaced with spaces.

**Update**: Script now works recursively on all subdirectories

- Arguments
	The script expects a series of arguments. 

	- The first argument is path to the folder containing the files.
	- Rest of the arguments are treated as substrings that should be removed from the file name.

- Example

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


## download_all

This python script tries to download all files of following type from a webpage

- .pdf
- .txt
- .pptx
- .csv

The webpage is parsed using BeautifulSoup and all the < a > tags with href containing desired extensions are downloaded.

- Arguments

	The script expects a series of arguments. 
	
	- The first argument should be the url of the webpage from where you intent to download all pdfs. 
	- The Second argumnet should be the path to the diectory where you want to keep the downloaded files.



## get_subtitles

Try to download the best subtitles for all the videos present in a folder.
The path to the folder needs to be paased as command line argument. If no argument is passed, current working directory is searched.

**Dependency: Subliminal**

``pip install subliminal``
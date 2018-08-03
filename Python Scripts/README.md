## download_all

This python script tries to download all files from a webpage

The webpage is parsed using BeautifulSoup and all the < a > tags with href containing desired extensions are downloaded.

- **Usage:**

	`download_all <url> <dest> <exts>`

	- **url**: Url from where to download files.
	- **dest**: Path to directory where downloaded files will be stored.
	- **exts**: Space seperated list of extensions of filetypes to be downloaded.

	`download_all <url> <dest> .pdf .mp4 .pptx .csv`

- **Dependencies**:
	- tqdm: to display progress bar

		`pip install tqdm`
	
	- BeautifulSoup 
	
		`pip install beautifulsoup4`

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
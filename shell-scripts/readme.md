# ffmpeg_utils.sh

Contains Functions for doing some video related tasks

### Dependency
- ffmpeg
- [ffmpeg-bar](https://github.com/sidneys/ffmpeg-progressbar-cli) (wrapper around ffmpeg to show progress)

### 1. tox264

```bash
tox264 pathtovideo
```

Re-encode video using x264 codec. Re-encoded video is stored in **x264** folder in the root directory of the video

**Arguments**

- pathtovideo: path to the video to be converted.

### 2. tomp3

```bash
tomp3 ext
```

Convert all the files with with *.ext* extension in the current directory are converted to *.mp3*

**Arguments**

- ext: extension of files to be converted. e.g *mp4*, *mkv* etc..

### 3. clipVideo

```bash
clipVideo pathtovideo start_time end_time
```

Video is clipped from start_time to end_time. Clipped file is stored in the **clipped** folder in the root directory of the video.

**Arguments**

- pathtovideo: path to the video to be converted. e.g **movie.mp4**
- start_time: e.g **16:10**
- end_time: e.g **17:20**

### 4. addsub
```bash
addsub pathtovideo pathtosubtitles
```

Mux subtitles into the video. (Replaces all previous subtitles)

### 5. addsub2all

```bash
addsub2all
```

Add subtitles to those files in the current directory for which subtitles are present.

Note: for **movie.mp4** subtitles should be named as **movie.srt**

# Script_numbering_dir_content.sh

### Description

This Shell Script creates copies of the files of the current directory in a new folder named "out" such that the copied files are enumerated.That is the names of the copied files will be like 1.txt 2.png etc...

Note : No affect on the subdirectories in the current folder. Only files are 
	   enumerated.

### Usage
1. copy the script to the directory whose files you want to enumerate.
2. run the script

### Arguments
Script accepts one command line argument : that is the number from which enumeration is to be started. If not provided enumeration starts from 1

### Example
Suppose the current directory contains 3 files and 1 folder 
	
	a.txt 	
	b.png 	
	c.jpg 	
	Folder

1) ./Script_numbering_dir_content.sh 

	after above command current directory would contain
		
		out 	
		a.txt 	
		b.png 	
		c.jpg 	
		Folder

	and "out" would contain 
		
		01.txt 	
		02.png 	
		03.jpg  

2) ./Script_numbering_dir_content.sh 49

	after above command current directory would contain
		
		out 	
		a.txt 	
		b.png 	
		c.jpg 	
		Folder

	and "out" would contain 
	    
	    49.txt 	
	    50.png 	
	    51.jpg

___

# Update

- Removed bug preventing enumeration of files with "space" in their names.
- Removed bug preventing enumeration of files without an extension.


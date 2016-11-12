Description
===========
This Script creates copies of the files of the current directory in a new folder named "out" such that the copied files are enumerated.That is the names of the copied files will be like 1.txt 2.png etc...

Usage
=====
1. copy the script to the directory whose files you want to enumerate.
2. run the script

Arguments
=========
Script accepts one command line argument : that is the number from which enumeration is to be started. If not provided enumeration starts from 1

Example
=======
Suppose the current directory contains 3 files and 1 folder 
	a.txt b.png c.jpg Folder

1) ./Script_numbering_dir_content.sh 

after above command current directory would contain
	out a.txt b.png c.jpg Folder

and "out" would contain 
	01.txt 02.png 03.jpg  

2) ./Script_numbering_dir_content.sh 49

after above command current directory would contain
	out a.txt b.png c.jpg Folder

and "out" would contain 
    49.txt 50.png 51.jpg



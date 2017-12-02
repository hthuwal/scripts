## Description

This python script removes a set of substrings from the name of the files in a directory.

Note: Apart from the last dot of extension if the filename contains extra "." (dots) then these dots are also replaced with spaces.

## Arguments

The script expects a series of arguments. 

- The first argument is path to the folder containing the files.
- Rest of the arguments are treated as substrings that should be removed from the file name.

## Example

Suppose a folder "Test" contains the file:
- tes.t 123 (abc).mkv

`python remove_from_file_names.py path-to-Test "es" "12" "(" "c)"`

After running the above command the content of the folder "Test" would be
- tt 3 ab.mkv



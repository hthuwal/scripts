import os
import sys

if len(sys.argv)>1 and os.path.isdir(sys.argv[1]):
	folder = sys.argv[1]
	to_be_removed = sys.argv[2:]
else:
	folder = os.getcwd()
	to_be_removed = sys.argv[1:]

safe_extensions = [".txt"]

if len(to_be_removed) > 0:
	for path in os.listdir(folder):

		filename, ext =  os.path.splitext(path)
		
		if ext not in safe_extensions:
			for string in to_be_removed:
				filename = filename.replace(string, "").strip()
			
			newpath = filename+ext

			if path != newpath:
				print "renaming: " + path + " to " + newpath
				os.rename(os.path.join(folder, path), os.path.join(folder, newpath))

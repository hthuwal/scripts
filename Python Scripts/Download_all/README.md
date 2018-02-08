## Description

This python script tries to download all files of following type from a webpage
- .pdf
- .txt
- .pptx
- .csv

The webpage is parsed using BeautifulSoup and all the <a> tags with href containing desired extensions are downloaded.

## Arguments

The script expects a series of arguments. 
- The first argument should be the url of the webpage from where you intent to download all pdfs. 
- The Second argumnet should be the path to the diectory where you want to keep the downloaded files.




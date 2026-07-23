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

### 🔑 Is Password Safe?

Wondering whether the password you use have already been leaked or not? Try this script.

The scripts use the API provided by ["have I been pwned"](https://haveibeenpwned.com) to checker whether a password has been leaked or not.

**Note: The entire password is not sent over the network. Only the first 5 characters of the SHA1 of the password are sent over the network.**

**Script**: [is-password-safe.py](is-password-safe.py)

**Usage**
```
is-password-safe.py [OPTIONS] PASSWORD_FILE

  Check if passwords (one on each line) in PASSWORD_FILE are safe or not.

Options:
  --help  Show this message and exit.
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

<br>

---

### 🏷️ Label Jira Epic

Recursively discovers a Jira epic and all of its descendants, shows the issues
for review, and adds one or more labels using Jira's bulk edit API.

**Script**: [label_epic.py](label_epic.py)

**Requirements**

- [uv](https://docs.astral.sh/uv/) and Python 3.11 or newer
- A Jira Cloud API token
- Jira permissions to browse and edit every selected issue
- Jira's global bulk change permission

The script declares `requests`, `rich`, and `ratelimit` using inline PEP 723
metadata. Running it through its executable shebang lets `uv` create and cache
an isolated environment automatically; no manual virtual environment or
dependency installation is required.

**Usage**

```shell
label_epic \
  --url https://yourorg.atlassian.net \
  --email you@example.com \
  --token-file ~/.jira-api-token \
  EPIC-123 label-one [label-two ...]
```

Options:

```text
--url URL            Jira Cloud base URL
--email EMAIL        Atlassian account email
--token-file PATH    File whose first non-empty line is the Jira API token
--preview-file PATH  JSON preview/cache file (default: issues_preview.json)
-h, --help           Show command help
```

**Workflow**

1. Fetches the epic and traverses its descendants using `parent = ISSUE-KEY`.
2. Reuses search results to avoid fetching each child individually and stops
   searching below sub-tasks, because they cannot have children.
3. Writes the epic, requested labels, issue keys, types, and summaries to the
   preview JSON file.
4. Displays the collected issues and asks for confirmation before making
   changes.
5. Adds labels in bulk batches and displays live submission and polling
   progress. Existing labels are preserved, and adding a label already present
   on an issue is safe.

If the preview file already exists, the script displays its contents and asks
whether to apply labels to that saved issue list, recollect the hierarchy, or
abort.

All Jira requests share a limit of 30 calls per minute. The script waits
automatically when that limit is reached. Bulk edit notifications are enabled,
so Jira may notify issue watchers.

**Token file example**

```text
your-jira-api-token
```

Keep this file private:

```shell
chmod 600 ~/.jira-api-token
```

**Run from anywhere**

The script is executable through `uv`. You can expose it on your `PATH` with a
symlink:

```shell
chmod +x /path/to/python-scripts/label_epic.py
ln -s /path/to/python-scripts/label_epic.py ~/bin/label_epic
```
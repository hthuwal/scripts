import walkdir
import click
from tqdm import tqdm
from functools import reduce

UNSUPPORTED_CHARS = {
    "mac": [":"],
    "windows": ["\\", ":", "*", "?", "\"", "<", ">", "|"]
}


def is_safe(fileName, unsuppported_chars):
    return reduce(lambda x, y: x and y, map(lambda char: char not in fileName, unsuppported_chars))


def verify(path, os):
    walk = walkdir.filtered_walk(path)
    paths = walkdir.all_paths(walk)
    for filePath in tqdm(paths):
        if(not str.isalnum(filePath)):
            print(filePath)
        if(not is_safe(filePath, UNSUPPORTED_CHARS[os])):
            print(f"{filePath} not safe for {os}")


@click.command()
@click.argument('path', type=click.Path())
@click.option('--os', type=click.Choice(['mac', 'windows']), default="windows", show_default=True, help="Target OS type: mac or windows")
def main(path, os):
    verify(path, os)


if __name__ == "__main__":
    main()

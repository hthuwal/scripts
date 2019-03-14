import hashlib
import requests
import click

api = "https://api.pwnedpasswords.com/range/{}"


def is_safe(password):
    sha = hashlib.sha1(password.encode()).hexdigest().upper()
    url = api.format(sha[0:5])
    matches = requests.get(url).text.split()
    target = sha[5:]
    for match in matches:
        cand, count = match.split(":")
        if cand == target:
            msg = (
                "No, \"%s\" is not a safe password. Found it in data leaks.\n"
                "Hash:%s, Number of Occurrences: %s\n"
            )
            print(msg % (password, sha, count))
            return

    print("Yes, \"%s\" seems safe. Wasn't found in data leaks.\n" % password)


@click.command()
@click.argument('password_file')
def main(password_file):
    """
    Check if passwords (one on each line) in PASSWORD_FILE are safe or not.
    """
    with open(password_file) as f:
        passwords = f.readlines()
        for password in passwords:
            # print(password.strip("\n"))
            is_safe(password.strip("\n"))


if __name__ == "__main__":
    main()

import subprocess
import sys


class CommitException(Exception):
    def __init__(self, message="Invalid commit"):
        super().__init__(message)


def validate_commit():
    command = "git branch --show-current"
    branch = subprocess.run(command, capture_output=True, text=True).stdout.strip()

    if branch == "production" or branch == "master":
        raise CommitException(
            f"Direct commit or push to {branch} isn't allowed. Please raise PR from {"production" if branch=="master" else "development"}"
        )


if __name__ == "__main__":
    try:
        validate_commit()
        sys.exit(0)
    except Exception as error:
        print(error)
        sys.exit(1)

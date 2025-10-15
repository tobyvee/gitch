# gitch(1)

A helper utility for managing and switching between global git user profiles.

It unloads the all existing ssh keys from `ssh-agent`, loads the key for the specified profile, and sets the global git user name and email.

## Usage

```bash
Usage: gitch <profile>

Options:
  -h, --help      Show this help message and exit
  -v, --version   Show version number and exit
  -c, --create    Create a new git alias
  -l, --load      Load a git user config and add it to the SSH agent. Default action.
      --list      List all available git user profiles

Example: gitch work
```

## Install

### From source

1. Clone the repository
2. Run `make install` to install the binary to `/usr/local/bin/gitch`

### Homebrew

```bash
brew tap tobyvee/tap
brew install gitch
```

## Uninstall

1. Run `make uninstall` to remove the binary from `/usr/local/bin/gitch`

## Creating a new profile

To create a new git user profile, use the `--create, -c` option and follow the prompts:

```bash
gitch -c <name>
Creating new git user profile: test
Enter your name: Test User
Enter your email: test@nomail.com
Enter path to SSH private key: /Users/test/.ssh/pubkey.pub
```

## Switching profiles

Using the above example, to switch to the *test* profile, run:

```bash
gitch test
```

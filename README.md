# sg(1)

A helper utility for managing and switching between global git user profiles.

It unloads the all existing ssh keys from `ssh-agent`, loads the key for the specified profile, and sets the global git user name and email.

*sg is an acronym for 'switch git'.*

## Usage

```bash
Usage: /usr/local/bin/sg <profile>

Options:
  -h, --help      Show this help message and exit
  -v, --version   Show version number and exit
  -c, --create    Create a new git alias
  -l, --load      Load a git user config and add it to the SSH agent. Default action.
      --list      List all available git user profiles

Example: /usr/local/bin/sg work
```

## Install

1. Clone the repository
2. Run `make install` to install the binary to `/usr/local/bin/sg`

## Uninstall

1. Run `make uninstall` to remove the binary from `/usr/local/bin/sg`

## Creating a new profile

To create a new git user profile, use the `--create, -c` option and follow the prompts:

```bash
sg -c <name>
```

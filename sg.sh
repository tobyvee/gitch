#!/usr/bin/env bash

set -euo pipefail

VERSION=1.0.0

function usage {
  echo ""
  echo "Usage: $0 <git-alias>"
  echo ""
  echo "Options:"
  echo "  -h, --help      Show this help message and exit"
  echo "  -v, --version   Show version number and exit"
  echo "  -c, --create    Create a new git alias"
  echo "  -l, --load      Load a git user config and add it to the SSH agent"
  echo "      --list      List all available git user profiles"
  echo ""
  echo "Example: $0 work"
  echo ""
  exit 0
}

function version {
  echo "$VERSION"
  exit 0
}

function check_dependencies {
  for cmd in git ssh-add ssh-agent; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo "Error: $cmd is not installed or not in PATH."
      exit 1
    fi
  done
}

function ensure_ssh_agent {
  if ! pgrep -u "$USER" ssh-agent >/dev/null 2>&1; then
    echo "Starting ssh-agent..."
    eval "$(ssh-agent -s)"
  fi
}

function create {
  local alias="$1"
  local config_dir="$HOME/.config/sg"
  local config_file="$config_dir/$alias.conf"

  mkdir -p "$config_dir"

  echo "Creating new git user profile: $alias"
  read -rp "Enter your name: " name
  read -rp "Enter your email: " email
  read -rp "Enter path to SSH private key: " ssh_key

  # Validate SSH key exists
  if [ ! -f "$ssh_key" ]; then
    echo "Error: SSH key file does not exist: $ssh_key"
    exit 1
  fi

  # Create config file
  cat >"$config_file" <<EOF
NAME=$name
EMAIL=$email
SSH_KEY=$ssh_key
EOF

  echo "Git user profile '$alias' created successfully!"
}

function unload_ssh_agent {
  # Remove all identities, ignore error if none loaded
  ssh-add -D >/dev/null 2>&1 || true
}

function add_ssh_agent {
  local key="$1"
  # Only add if not already loaded
  if ! ssh-add -l | grep -q "$(ssh-keygen -lf "$key" | awk '{print $2}')"; then
    ssh-add "$key"
  fi
}

function load {
  local alias="$1"
  local config_dir="$HOME/.config/sg"
  local config_file="$config_dir/$alias.conf"

  if [ ! -f "$config_file" ]; then
    echo "Error: Git user profile '$alias' not found"
    echo "Use -c or --create to create a new profile"
    exit 1
  fi

  # Parse config file safely
  local NAME EMAIL SSH_KEY
  NAME=$(grep '^NAME=' "$config_file" | cut -d'=' -f2-)
  EMAIL=$(grep '^EMAIL=' "$config_file" | cut -d'=' -f2-)
  SSH_KEY=$(grep '^SSH_KEY=' "$config_file" | cut -d'=' -f2-)

  if [ -z "$NAME" ] || [ -z "$EMAIL" ] || [ -z "$SSH_KEY" ]; then
    echo "Error: Malformed profile config for '$alias'"
    exit 1
  fi

  echo "Switching to git user: $alias"

  # Update git global config
  git config --global user.name "$NAME"
  git config --global user.email "$EMAIL"

  ensure_ssh_agent

  # Clear existing SSH identities
  unload_ssh_agent

  # Add new SSH identity
  add_ssh_agent "$SSH_KEY"

  echo "Successfully switched to $NAME <$EMAIL>"
}

function list_profiles {
  local config_dir="$HOME/.config/switchgit"

  if [ ! -d "$config_dir" ]; then
    echo "No git user profiles found"
    return 0
  fi

  local found=0
  echo "Available git user profiles:"
  for config_file in "$config_dir"/*.conf; do
    [ -e "$config_file" ] || continue
    local alias
    alias=$(basename "$config_file" .conf)
    local NAME EMAIL
    NAME=$(grep '^NAME=' "$config_file" | cut -d'=' -f2-)
    EMAIL=$(grep '^EMAIL=' "$config_file" | cut -d'=' -f2-)
    printf "  %-15s %s <%s>\n" "$alias" "$NAME" "$EMAIL"
    found=1
  done
  if [ "$found" -eq 0 ]; then
    echo "  (none found)"
  fi
}

function check_args {
  if [ $# -eq 0 ]; then
    usage
  fi

  case "$1" in
  -h | --help)
    usage
    ;;
  -v | --version)
    version
    ;;
  -c | --create)
    if [ $# -lt 2 ]; then
      echo "Error: --create requires an alias name"
      echo "Example: $0 --create work"
      exit 1
    fi
    create "$2"
    ;;
  -l | --load)
    if [ $# -lt 2 ]; then
      echo "Error: --load requires an alias name"
      echo "Example: $0 --load work"
      exit 1
    fi
    load "$2"
    ;;
  --list)
    list_profiles
    ;;
  -*)
    echo "Error: Unknown option $1"
    usage
    ;;
  *)
    # Default action is to load the profile
    load "$1"
    ;;
  esac
}

function main {
  check_dependencies
  check_args "$@"
}

main "$@"

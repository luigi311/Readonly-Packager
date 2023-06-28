#!/usr/bin/env bash
set -e

# Check if the script is running with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo or as root."
  exit 1
fi

CHECK_FILE="/readonly_check"
READ_ONLY=0

# On exit or interrupt, remove the check file
trap 'rm -f "$CHECK_FILE"' EXIT INT

list_command_locations() {
  command_name=$(basename "$1")
  locations=$(type -a "$command_name" | awk '{print $3}')
  echo "$locations"
}

check_read_only() {
  if touch "$CHECK_FILE" &>/dev/null; then
    rm -f "$CHECK_FILE" &>/dev/null
  else
    READ_ONLY=1
  fi
}

# Check if the filesystem is read-only
check_read_only

if [ "$READ_ONLY" == "1" ]; then
  # Echo script name is not supported on read-only filesystem
  echo "Running $0 is not supported on read-only filesystem and should not be used"
  exit 1
fi

# Call the second location of the command and pass through all arguments
# The first location should be an alias of this script
# The second location should be the actual package manager
mapfile -t locations < <(list_command_locations "$0")

exec "${locations[1]}" "$@"

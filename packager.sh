#!/usr/bin/env bash
set -e

READ_ONLY=0
PACKAGE_MANAGER=$(basename "$0")

list_command_locations() {
    local LOCATIONS
    LOCATIONS=$(type -a "$PACKAGE_MANAGER" | awk '{print $3}')
    echo "$LOCATIONS"
}

check_read_only() {
    # Touch / and check to see if it returns read only 
    # if it is any other message or error such as permission denied then the system is writable
    TOUCH_OUTPUT=$(touch / 2>&1 || true)
    if [[ $TOUCH_OUTPUT == *"ead-only"* ]]; then
        READ_ONLY=1
    else
        READ_ONLY=0
    fi
}

# Check if the filesystem is read-only
check_read_only

if [ "$READ_ONLY" == "1" ]; then
  # Echo script name is not supported on read-only filesystem
  echo "Running $PACKAGE_MANAGER is not supported on read-only filesystem and should not be used"
  exit 1
fi

# Call the second location of the command and pass through all arguments
# The first location should be an alias of this script
# The second location should be the actual package manager
mapfile -t LIST_LOCATIONS < <(list_command_locations)

exec "${LIST_LOCATIONS[1]}" "$@"

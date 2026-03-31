#!/usr/bin/env bash
get_username() {
    while true; do
        read -e -p "Enter username for new user: " NEW_USER_NAME
        NEW_USER_NAME="${NEW_USER_NAME// /}"   # strip spaces
        NEW_USER_NAME="${NEW_USER_NAME,,}"     # force lowercase

        [[ -z "$NEW_USER_NAME" ]] \
            && { echo "  ✘ Cannot be empty."; continue; }

        [[ ! "$NEW_USER_NAME" =~ ^[a-z_][a-z0-9_-]{2,31}$ ]] \
            && { echo "  ✘ Invalid format."; continue; }

        id "$NEW_USER_NAME" &>/dev/null \
            && { echo "  ✘ User already exists."; continue; }

        break
    done
}

get_username
echo "  ✔ Username accepted: $NEW_USER_NAME"
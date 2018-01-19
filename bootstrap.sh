#!/usr/bin/env bash

# Adapted from Mathias Bynen's dotfiles:
# https://github.com/mathiasbynens/dotfiles

prev=$PWD
cd "$(dirname "${BASH_SOURCE[0]}")"

git pull origin master

function doIt() {
    rsync --exclude ".git/" \
        --exclude ".DS_Store" \
        --exclude "*.swp" \
        --exclude ".osx" \
        --exclude ".gitignore" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" \
        -avh --no-perms . ~
    source ~/.bashrc
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    doIt
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt
    fi
fi
unset doIt

cd "$prev"

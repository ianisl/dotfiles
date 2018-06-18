#!/usr/bin/env bash

# Open a mail in a tmux split
tmpfile=$(mktemp)
cat > $tmpfile
tmux splitw $1 vim -c 'set ft=mail | set nomodifiable | set nospell' $tmpfile

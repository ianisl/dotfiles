# If not running interactively, don't do anything
[ -z "$PS1"  ] && return

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend '$PATH'.
# TODO seems to cause problems with fzf (bindings not working in vi mode) Edit: ?
for file in ~/.{path,bash_prompt,exports,aliases,functions}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# z
. /usr/local/etc/profile.d/z.sh

# fzf
# ---
# No need to set -o vi as .bash_prompt is loaded before
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# Use $$ as the trigger sequence instead of the default **
# NB: when using the trigger sequence, fzf will use find and not the default_command defined below
export FZF_COMPLETION_TRIGGER='$$'
# Default options
export FZF_DEFAULT_OPTS="-e --algo=v1"
# Use ag as default command, respect .gitignore (ag default behavior)
# This is the command that will be used by the vim plugin
export FZF_DEFAULT_COMMAND='ag --hidden --silent --depth 10 --ignore .git --ignore node_modules --ignore **.swp -g ""' # Use --hidden to list hidden files
# Search for all files
export FZF_CTRL_T_COMMAND='ag --hidden --silent --depth 10 --ignore .git --ignore node_modules --ignore **.swp -g ""'
# Search only for folders
export FZF_ALT_C_COMMAND='ag --silent --depth 10 --ignore .git --ignore node_modules --ignore Applications -g "" | sed -e "s:/[^/]*$::" | uniq'

# nvm
# ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pyenv
# -----
# This will take care of adding the necessary shims to the PATH
eval "$(/usr/local/bin/pyenv init -)"

# less
# ----
# Make sure ~/.lessfilter is chmod u+x
export LESS='-R'
export LESSOPEN='|~/.lessfilter %s'

# Special settings when running urxvt
# ------------------------------------
if [[ $TERM = rxvt-unicode-256color ]]; then
    export TERM="xterm-256color";
    # Set locale and notify urxvt about the change. Source: https://sergeemond.ca/en/articles/rxvt-unicode-on-os-x/
    # TODO: still needed?
    export LANG=fr_FR.UTF-8
    printf '\e]701;%s\007' $LANG
    # Check if connected to external screen and set target dimensions accordingly
    external=$(system_profiler SPDisplaysDataType | grep DELL)
    if [ "$external" = "" ]; then
        xsize=720
        ysize=880
        menubarshift=0
    else
        xsize=840
        ysize=1060
        menubarshift=23
    fi
    # Tell ranger where to look for w3mimgdisplay
    export W3MIMGDISPLAY_PATH=/usr/local/Cellar/w3m/0.5.3_1/libexec/w3m/w3mimgdisplay
    # Disable freeze behavior when pressing ctrl-s
    stty -ixon
fi

#!/usr/bin/env bash

# Since we are using a custom xinitrc, we need to read Xresources
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# Set locale before launching URxvt so we don't have encoding problems
export LANG=fr_FR.UTF-8

# According to https://wiki.archlinux.org/index.php/Xinit:
# "At the very least, ensure that the last if block in /etc/X11/xinit/xinitrc is present in your .xinitrc file to ensure that the scripts in /etc/X11/xinit/xinitrc.d are sourced."
# That means we should source the corresponding folder for our XQuartz install, ie /opt/X11/lib/X11/xinit/xinitrc.d
# This folder contains 3 scripts: 10-fontdir.sh 98-user.sh 99-quartz-wm.sh
# Since we don't need 99-quartz-wm.sh, and 98-user.sh sources ~/.xinitrc.d, we can just source .xinitrc.d and add our own fontdir script there
if [ -d "${HOME}/.xinitrc.d" ] ; then
    for f in "${HOME}"/.xinitrc.d/*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Set path with macOS path_helper (needed for Homebrew to work)
eval $(/usr/libexec/path_helper -s)

# Launch programs
# Important: don't forget the trailing &s or the .xinitrc script won't proceed to loading the WM! In this case, the first program would open *outside* any WM.
/usr/local/bin/urxvt -cd "${HOME}" &

# Start the window manager
# Why exec? According to https://wiki.archlinux.org/index.php/Xinit: "prepending exec will replace the script process with the window manager process, so that X does not exit even if this process forks to the background". In practice it seems we need to add this to the last instruction of .xinitrc
exec $HOME/src/objective-c/projets/quartz-vm_ianisl/src/quartz-wm

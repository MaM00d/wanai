# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# PS1='[\u@\h \W]\$ '
# PS1='\[\e[1;35;m\]\u  \[\e[0;36;m\]\h \[\e[0;36;m\]\e[m\]󰣇 \[\e[0;36;m\]\w \e[0;36;m\] \n'
# PS1='\[\e[1;37;42m\] \u \[\e[0;32m\] \[\e[0;37m\]\e[m\]\[\e[0;36;47m\]\h\[\e[0;37m\] \[\e[0;34m\]\e[m\]\[\e[0;37;44m\]\w\[\e[0;36;34m\] \[\e[1;36m\] '
# PS1='\[\e[1;37;46m\] \u \[\e[0;36;47m\]  \[\e[1;36;47m\]\h \[\e[0;37;42m\]  \e[1;37;42m\]\w \[\e[0;32m\]  \[\e[1;36m\]'
#
# PS1='[\e[1;37;46m\] \u \[\e[0;36;47m\]  \[\e[1;36;47m\]\h \[\e[0;37;42m\]  \e[1;37;42m\]\w \[\e[0;32m\]  \[\e[1;36m\]'

PS1="\[\e[1;30;1;44m\] \u \[\e[0;34;40m\]  \[\e[1;37;40m\]\h \[\e[0;30;46m\]  \[\e[1;30;46m\]\w \[\e[0;36m\]  "

#____________________________________________________________
#                                                            |
#                                                            |
#                     Enviroment Variables                   |
#                                                            |
#____________________________________________________________|

export GOPATH=/home/me/Projects/wanas/Server/

# export LIBVA_DRIVER_NAME=vdpau

#opoenssl stuff fixing error rust require install openssl-1.1
export OPENSSL_DIR="/etc/ssl"
export OPENSSL_LIB_DIR=/usr/lib/openssl-1.1
export OPENSSL_INCLUDE_DIR=/usr/include/openssl-1.1/

#Media Directory
export ME_DIA_DIR=$HOME/media/
#Media Directories
export XDG_DESKTOP_DIR="$ME_DIA_DIR/desktop"
export XDG_DOCUMENTS_DIR="$ME_DIA_DIR/documents"
export XDG_DOWNLOAD_DIR="$ME_DIA_DIR/downloads"
export XDG_MUSIC_DIR="$ME_DIA_DIR/music"
export XDG_PICTURES_DIR="$ME_DIA_DIR/pictures"
export XDG_PUBLICSHARE_DIR="$ME_DIA_DIR/public"
export XDG_TEMPLATES_DIR="$ME_DIA_DIR/templates"
export XDG_VIDEOS_DIR="$ME_DIA_DIR/videos"

#editor
export EDITOR=nvim

# export PATH="/home/$USER/bin:$PATH"

export SDL_VIDEORIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_DESKTOP=Hyprland
export XDG_SESSION_TYPTE=wayland
export MANPATH=/usr/share/man
export RUSTUP_HOME=/home/me/.data/rust
# export CARGO_HOME=/home/me/.data/cargo

# export PATH=/home/me/.data/cargo/bin:$PATH
#mozilla wayland
export MOZ_ENABLE_WAYLAND=1
MOZ_CRASHREPORTER_DATA_DIRECTORY="/home/me/.data/.mozilla/firefox/Crash"
MOZ_CRASHREPORTER_PING_DIRECTORY="/home/me/.data/.mozilla/firefox/Pending"

# QT
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=gtk3
export QT_STYLE_OVERRIDE=gtk3

#gtk
export GDK_BACKEND=wayland,x11
export GTK_THEME=Adwaita:dark
#gnupg folder in home
export GNUPGHOME="${XDG_DATA_HOME:-$HOME/.local/share}/gnupg"

#flutter
# export ANDROID_HOME=$HOME/Projects/wanas/App/android-sdk/
# export PATH=$PATH:$ANDROID_HOME/platform-tools
export JAVA_HOME=/usr/lib/jvm/java-22-openjdk/

#python?
export HF_HOME=/home/me/loc/.hfcache/

#____________________________________________________________
#                                                            |
#                                                            |
#                           Aliases                          |
#                                                            |
#____________________________________________________________|

#reboot to uefi
alias uefiboot='systemctl reboot --firmware-setup'

#venv move
alias mvenv='./home/me/scripts/movevenv.sh'

#nvim
alias nv='nvim'

#asmr
alias asmr='mpv ~/media/asmr --shuffle'

#keyboard light
alias keylighton=' /home/me/scripts/legion-kb-rgb set -e Static -c 1,20,40,1,20,40,1,20,40,1,20,40'
alias keylightoff=' /home/me/scripts/legion-kb-rgb set -e Static -c 0,0,0,0,0,0,0,0,0,0,0,0'

alias hotspoton='sudo create_ap wlp4s0 eno1 elpapa pepsipepsi'

#navigating with exa
alias l='exa --icons'
alias ls='exa --icons'
alias ll='exa -l -h --icons'
alias llt='exa -l -h --icons --total-size'
alias la='exa -l -h -a --icons'
alias lat='exa -l -h -a --icons --total-size'
alias .='cd '
alias ..='cd ..'
alias ...='cd ...'
alias cl='clear'

#grep
alias grep='grep --color=auto'

#____________________________________________________________
#                                                            |
#                                                            |
#                             other                          |
#                                                            |
#____________________________________________________________|

#lf navigation
LFCD="/home/me/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
	source "$LFCD"
fi

#vfio
alias nvidia-reboot='sudo bash -c "cat /etc/default/nvidia-reboot > /etc/default/grub" && sudo grub-mkconfig -o /boot/grub/grub.cfg && reboot'
alias vfio-reboot='sudo bash -c "cat /etc/default/vfio-reboot > /etc/default/grub" && sudo grub-mkconfig -o /boot/grub/grub.cfg && reboot'

# tmux auto start
session_name="init"

# 1. First you check if a tmux session exists with a given name.
tmux has-session -t=$session_name 2>/dev/null

# 2. Create the session if it doesn't exists.
if [[ $? -ne 0 ]]; then
	TMUX='' tmux new-session -d -s "$session_name"
fi

# 3. Attach if outside of tmux, switch if you're in tmux.
if [[ -z "$TMUX" ]]; then
	tmux attach -t "$session_name"
fi

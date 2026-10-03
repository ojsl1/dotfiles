echo "Inaction breeds self-doubt." | queercat -b -f 6
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
export PATH=$HOME/bin:$PATH

ZSH_THEME="powerlevel10k/powerlevel10k"

DISABLE_MAGIC_FUNCTIONS="true"
COMPLETION_WAITING_DOTS="true"

# Standard plugins can be found in $HOME/.oh-my-zsh/plugins/*
# Custom plugins may be added to $HOME/.oh-my-zsh/custom/plugins/
plugins=(
  copypath
  copyfile
  copybuffer #CTRL+O
  dirhistory
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting
)

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh
export LANG=en_GB.UTF-8

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

#####  ZLE ACTIONS  #####

# Don’t jump past quotes (delete only the delimiter if on it) e.g. `grep -R "lspconfig" ~/.config/nvim`
smart-backward-kill-word() {
  # If immediately left of cursor is a non-word char, delete just that char.
  # Otherwise, do the normal backward-kill-word.
  local left=${BUFFER[CURSOR-1, CURSOR-1]}
  if [[ -n $left && $left != [[:alnum:]_] ]]; then
    zle backward-delete-char
  else
    zle backward-kill-word
  fi
}
zle -N smart-backward-kill-word
bindkey '^W' smart-backward-kill-word

# Print the active ZLE keymap
show-keymap() { zle -M "keymap=$KEYMAP"; }
zle -N show-keymap
bindkey '^X^K' show-keymap


#####  ALIASES  #####
alias vim="nvim"
alias t="tmux"
alias enw="emacs -nw"

alias findhere="find -type f -iname"
alias ls="ls --color -F"
alias ve="vim $HOME/.config/nvim/vimrc.vim"
alias nve="vim $HOME/.config/nvim/init.lua"
alias lve="vim $HOME/.config/nvim/lua/lazy_setup.lua"
alias ke="vim $HOME/.config/kitty/kitty.conf"
alias te="vim $HOME/.config/tmux/tmux.conf"
alias ze="vim $HOME/.zshrc"
alias zeh="vim $HOME/.zsh_history"
alias zo="source $HOME/.zshrc"
alias bb="exit"
alias b="exit"
alias j="journalctl -ef"
alias update="sudo pacman -Syu && echo \ && yay -Syua && echo \ && flatpak uninstall --unused && echo \ && flatpak update && echo \ && omz update"
alias pkcon="pkcon get-packages | grep installed"
alias u="update"
qo(){ pacman -Qo "$1" }
qi(){ pacman -Qi "$1" | grep -i Description }
qlbin(){ pacman -Ql "$1" | grep '/bin/' }
alias sammu="shutdown now"
alias bat="upower -d && echo -e '\nKatso myös tehtäväpalkin ilmaisinalueella sijaitseva Power Management erit. PS4 ohjain: Wireless Controller Touchpad'"
alias warns="sudo dmesg --level=emerg,alert,crit,err,warn"
alias warns1="sudo dmesg --level=notice"
alias warns2="sudo dmesg --level=info,debug"

alias Songs="func0(){
	sudo mount /dev/wd/lvsongs -t ext4 -o rw,x-mount.mkdir '$HOME/.stepmania-5.1/Songs'
	};func0 && alias Songs"
alias tn="time"
alias tn2="awk 'BEGIN {srand(); print srand()}'"
alias tn3="date +%s"
alias tn4="perl -e 'print time'"
alias upgraded='grep -i upgraded /var/log/pacman.log | tac | less'
alias transfetch='neofetch --color_blocks off --cpu_speed off --gap 1 --ascii "$(fortune -s | cowthink -W 30)" | queercat -b -f 5'
alias tehot="sudo cpupower frequency-set -g performance"
alias säästöt="sudo cpupower frequency-set -g powersave"
alias virrat="func2(){
sudo turbostat -Summary --quiet --show PkgWatt --interval 1 | gawk '{ printf(\"%.2f\n\" , \$1); fflush(); }' | ttyplot -s 100 -t \"Turbostat - CPU Power (watts)\" -u \"watts\"
	};func2"
alias tofix="grep "tofix" $HOME/Dropbox/comms"
alias lsblk1="lsblk -o NAME,SIZE,MOUNTPOINTS,FSAVAIL,FSTYPE"
alias lsblk0="lsblk -o NAME,SIZE,MOUNTPOINTS,FSUSE%,PTTYPE"
alias saffire="sudo modprobe -r snd_bebob && sudo modprobe snd_bebob"
alias ytd="yt-dlp --cookies-from-browser=firefox"
alias y="ytd"

#####  DEV ALIASES  #####
alias rem="make clean && make -j16"
alias cdscripts="cd $HOME/Dropbox/devel/scripts/"
alias ce="vim $HOME/Dropbox/comms"
alias le="vim $HOME/Dropbox/Docs/IT/LinuxPetPeeves"
alias vimoct="cd $HOME/Dropbox/devel/projects/octavius-new/ && vim -p CMakeLists.txt octavius.h octavius.cpp Render.cpp Classes/Render.h SlotMachine.cpp Classes/SlotMachine.h Timer.cpp Classes/Timer.h Wheel.cpp Classes/Wheel.h Sound.cpp Classes/Sound.h"
alias cdsdl="cd $HOME/Dropbox/devel/projects/metadata/"
alias vimsdl="cd $HOME/Dropbox/devel/projects/metadata/ && vim -p src/menu.cpp include/menu.h src/render.cpp include/render.h src/main.cpp include/main.h src/character.cpp include/character.h src/sprite.cpp include/sprite.h src/util.cpp include/util.h"
alias vimsdl1="cd $HOME/Dropbox/devel/projects/metadata/ && vim -p README.md Makefile src/render.cpp include/render.h include/main.h src/main.cpp src/character.cpp include/character.h src/sprite.cpp include/sprite.h src/input.cpp include/input.h src/font.cpp include/font.h include/audio.h compile_commands.json"
alias vimsdl3="cd $HOME/Dropbox/devel/projects/metadata/ && vim -p README.md Makefile src/*.cpp include/*.h"
alias cddocker="cd $HOME/Dropbox/devel/projects/my-dockerized-sd/"
alias reforge="cd $HOME/Dropbox/devel/projects/my-dockerized-sd/ && docker compose up rocm7.1.1-reforge"
alias comfy="cd $HOME/Dropbox/devel/projects/my-dockerized-sd/ && docker compose up rocm7.13-comfy"
alias remake-itgm="cd $HOME/devel/itgmania/Build && setopt extendedglob && rm -rf ^*.md && rm -vf ../itgmania ../itgmania-debug && cmake -G 'Unix Makefiles' -DCMAKE_BUILD_TYPE=Debug .. && cmake .. && make -j16"

lstxt() {
  find . -maxdepth 1 -type f \( -name '*.txt' -o -not -name '*.*' \) -print0 |
    xargs -0 file --mime-type |
    awk -F: '$2 ~ /^[[:space:]]*text\/plain$/ { print $1 }' |
    xargs -d '\n' ls "$@"
}

lstxt1() {
  find . -maxdepth 1 -type f \( -name '*.txt' -o -not -name '*.*' \) -print0 |
    xargs -0 file --mime-type |
    awk -F: '$2 ~ /^[[:space:]]*text\/plain$/ { sub(/^\.\//,"",$1); print $1 }'
}

function md2html() {
  pandoc $1 > /tmp/$1.html
  xdg-open /tmp/$1.html
}
function md2html-styled() {
  pandoc $1 -s -c $HOME/gruvbox.css -o /tmp/$1.html
  xdg-open /tmp/$1.html
}

#####  PARTIAL ALIASES FROM OMZ GIT PLUGIN  #####
#
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git/README.md
alias g="git"
alias ga="git add"
alias gau="git add --update" # stage all modified files
alias gd="git diff"
alias gdca"git diff --cached"
alias gds="git diff --staged"
alias gdup="git diff ${upstream}"
alias gst="git status"
alias gss="git status --short"
alias glo="git log --oneline --decorate"
alias glog="git log --oneline --decorate --graph"
alias glgg="git log --graph"
alias glgm="git log --graph --max-count=10"
alias glg="git log --stat"
alias glgp="git log --patch"
alias glod="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"
alias glods="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'"
alias glola="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all"
alias glols="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat"
alias grs="git restore --staged"
alias grsA="git restore --staged ." # unstage all changes
alias grhs1="git reset --soft HEAD~1" # revert the latest (unpushed) commit into the staging area
alias grmc="git rm --cached" # untrack a file
alias gstl="git stash list"
alias gsts="git stash show --patch"
alias gwch="git whatchanged -p --abbrev-commit --pretty=medium"
alias gwtls="git worktree list"
alias gk="gitk --all --branches &!"

# MAN PAGE COLOURS
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

# if [ -z "$TMUX" ]; then
#   tmux new-session -A -s workspace
# fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

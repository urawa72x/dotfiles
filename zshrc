# prompt
eval "$(starship init zsh)"


# basic
autoload -U compinit
compinit
setopt auto_cd
setopt correct
setopt share_history


# dir color
export LSCOLORS=gxfxxxxxcxxxxxxxxxgxgx
export LS_COLORS='di=01;36:ln=01;35:ex=01;32'
zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'ex=32'

# anyenv
case "${OSTYPE}" in
darwin*)
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init -)"
  ;;
esac
# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
# ruby
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
# node
export NODE_OPTIONS="--max-old-space-size=4096"
export N_PREFIX="$HOME/.n"
export PATH="$PATH:$N_PREFIX/bin"

# alias
case "${OSTYPE}" in
darwin*)
   alias ls="ls -GF"
   ;;
linux*)
  alias ls='ls -F --color'
    ;;
esac
alias ll="ls -lAFG"
alias gg="git grep -H --heading --break"
alias gd="git diff"
alias gb="git branch"
alias gbd="git branch --merged master | grep -vE '^\*|master$|develop$|deliver$' | xargs -I % git branch -d %"
alias gs="git status"
alias gl="git log"
alias gp="git push"
alias d="docker"
alias dc="docker-compose"
alias bs="brew services"
alias agg="ag -g"
alias tt="tmux"
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias ca="cargo"
alias vim="nvim"
alias l="lazygit"

# exa
if [[ $(command -v exa) ]]; then
  alias e='exa --icons'
  alias l=e
  alias ls=e
  alias ea='exa -a --icons'
  alias la=ea
  alias ee='exa -aal --icons'
  alias ll=ee
  alias et='exa -T -L 3 -a -I "node_modules|.git|.cache" --icons'
  alias lt=et
  alias eta='exa -T -a -I "node_modules|.git|.cache" --color=always --icons | less -r'
  alias lta=eta
fi

# for aws
change_role() {
  if [ $# -eq 0 ]; then
    echo 引数を設定してください
    return
  fi
  echo Change Role
  export AWS_PROFILE=$1
  assume-role $1
  eval $(assume-role $1)
}


# for compro
compro_create() {
  mkdir -p "$1/a" "$1/b" "$1/c"
  touch "$1/a/main.cpp"
  touch "$1/b/main.cpp"
  touch "$1/c/main.cpp"
}
compile_test() {
  g++ main.cpp
  oj t
}
alias cc=compro_create
alias ojt=compile_test
alias ojs="oj s main.cpp"
alias ojtp="oj t -c 'python3 main.py'"
alias ojsp="oj s main.py"
alias ojspy="oj s main.py -l 4047"
alias ojtr="cargo atcoder test"
alias ojsr="cargo atcoder submit"


# PATH
export GOPATH="$HOME/go"
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin
export PATH="$HOME/.local/bin/:$PATH"
export PATH=$PATH:$HOME/bin


# fvim for vim
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fvim() {
  files=$(git ls-files) &&
  selected_files=$(echo "$files" | fzf -m --preview 'head -100 {}') &&
  vim $selected_files
}

function ghq-fzf() {
  local target_dir=$(ghq list | fzf-tmux --reverse --query="$LBUFFER")
  local ghq_root=$(ghq root)
  if [ -n "$target_dir" ]; then
    BUFFER="cd ${ghq_root}/${target_dir}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N ghq-fzf
bindkey "^f" ghq-fzf

# select history
function select-history() {
  BUFFER=$(history -n -r 1 | fzf-tmux --reverse --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
}
zle -N select-history
bindkey '^r' select-history


# vcxsrv for wsl
# export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
# export DISPLAY=localhost:0.0

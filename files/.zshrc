# zmodload zsh/zprof && zprof
# source /usr/local/opt/zplug/init.zsh

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
source "$HOME/.rye/env"
# source zinit autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light zsh-users/zsh-autosuggestions
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure
zinit light zsh-users/zsh-syntax-highlighting

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

autoload -U compinit
compinit

export PATH="${PATH}:${HOME}/.krew/bin"
export PATH="${PATH}:/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin/"
export PATH="$HOME/.nodenv/bin:$PATH"
export PATH="$HOME/bins:$PATH"
export PATH="$GOROOT/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export SAVEHIST=1000000
export HISTFILE=~/.zsh_history

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
export GHQ_ROOT=$GOPATH/src

# SSHで接続した先で日本語が使えるようにする
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export SHELL=/bin/zsh
export EDITOR=/usr/local/bin/nvim
export PAGER=cat
export MANPAGER=less

# poetry
export PATH="$PATH:$HOME/.poetry/bin"
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

setopt nobeep
setopt prompt_subst
setopt no_tify
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP
setopt inc_append_history share_history
unsetopt auto_menu
setopt auto_pushd
setopt auto_cd
setopt share_history
setopt hist_save_no_dups
setopt hist_ignore_all_dups

# 重複する要素を自動的に削除
typeset -U path cdpath fpath manpath

path=(
    $HOME/bin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    $path
)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(direnv hook zsh)"
# eval "$(rbenv init -)" # TODO ここはディレクトリごとに`.envrc`で呼び出す

autoload -U promptinit; promptinit
autoload -Uz colors; colors
autoload -Uz is-at-least
autoload -U promptinit; promptinit

zstyle ':prompt:pure:prompt:success' color cyan
zstyle ':prompt:pure:prompt:error' color red
# export PURE_PROMPT_SYMBOL='$'

alias grep="grep --color -I --exclude='*.svn-*' --exclude='entries' --exclude='*/cache/*'"
alias ls="ls -G"
alias l="ls -la"
alias la="ls -la"
alias l1="ls -1"
alias tree="tree -NC"
alias ql='qlmanage -p "$@" >& /dev/null'
alias ag='ag --path-to-ignore ~/.ignore'
alias -g kc='kubectl'
alias -g be="bundle exec"
alias -g vi="nvim"
alias rubymine='open -na "RubyMine.app" --args "$@"'
alias x86='/usr/local/bin/zsh'


bindkey -e

function select-history() {
  BUFFER=$(cat ~/.zsh_history | LC_ALL=C sed 's/.*;//' | fzf +m --no-sort --tac --query "$LBUFFER")
  CURSOR=$#BUFFER
}
zle -N select-history
bindkey '^R' select-history

function cdup() {
   echo
   cd ..
   zle reset-prompt
}
zle -N cdup
bindkey '^K' cdup

fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# cdしたあとで、自動的に ls する
function chpwd() { ls }

stty -ixon

function sedall()  { ag -l $1 $3 | xargs sed -Ei '' s/$1/$2/g }

if (which zprof > /dev/null 2>&1) ;then
  zprof
fi

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# cdr の設定
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
# zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true

alias cdd='fzf-cdd'
function fzf-cdd() {
    target_dir=`cdr -l | sed 's/^[^ ][^ ]*  *//' | fzf`
    target_dir=`echo ${target_dir/\~/$HOME}`
    if [ -n "$target_dir" ]; then
        cd $target_dir
    fi
}
alias cdg="fzf-ghq"
function fzf-ghq() {
    target_dir=`ghq list | fzf`
    target_dir=`echo $(ghq root)/${target_dir}`
    echo $target_dir
    if [ -n "$target_dir" ]; then
        cd $target_dir
    fi
}

alias fbr="fbr"
function fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

alias sst="switch_shell_type"
function switch_shell_type() {
  if [ "$(arch)" = "arm64" ]; then
    arch -x86_64 $SHELL
  else
    arch -arm64e $SHELL
  fi
}

alias fissue="fissue"
function fissue() {
  gh issue list | fzf --preview "gh issue view {+1}" | awk '{print $1}' | xargs gh issue view --web
}

alias fpr="fpr"
function fpr() {
  gh pr list | fzf --preview "gh pr view {+1} --json title,author --template '{{ .author.login }}, {{ .title}}'"| awk '{print $1}' | xargs gh pr view --web
}

alias timezsh="timezsh"
function timezsh() {
  time ( zsh -i -c exit )
}

alias archs="lipo -archs"

# Apple Silicon
export PURE_PROMPT_SYMBOL="(`uname -m`) $ "

if [ "$(arch)" = "arm64" ]; then
  eval $(/opt/homebrew/bin/brew shellenv);
else
  eval $(/usr/local/bin/brew shellenv);
fi


eval "$(jump shell zsh )"

export PATH="$HOME/.poetry/bin:$PATH"
# source $HOME/.cargo/env

# added by travis gem
[ ! -s /Users/hazumiichijo/.travis/travis.sh ] || source /Users/hazumiichijo/.travis/travis.sh
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1) --with-readline-dir=$(brew --prefix readline) --with-libyaml-dir=$(brew --prefix libyaml)"
export LDFLAGS="-L/usr/local/opt/ruby@3.0/lib"
export CPPFLAGS="-I/usr/local/opt/ruby@3.0/include"
export PKG_CONFIG_PATH="/usr/local/opt/ruby@3.0/lib/pkgconfig"
export PATH=/usr/local/opt/ruby@3.0/bin:$PATH

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
### End of Zinit's installer chunk
### End of Zinit's installer chunk

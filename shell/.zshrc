fpath=(/usr/local/share/zsh-completions $fpath)

autoload -Uz compinit
compinit

autoload -Uz promptinit
promptinit

autoload -Uz colors
colors

bindkey -e

setopt print_eight_bit
setopt auto_menu
setopt pushd_ignore_dups
setopt autopushd
setopt autocd
setopt autonamedirs
setopt cdablevars
setopt list_types
setopt auto_param_slash
setopt auto_param_keys
setopt interactive_comments
setopt extended_glob
setopt prompt_subst
setopt correct_all
setopt ignore_eof #^dのログアウト防止
setopt no_clobber #ファイル上書き防止
setopt no_tify # バックグラウンドジョブが終了したらすぐに知らせる。
setopt extended_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt no_beep
setopt ignore_eof
setopt glob_dots
setopt mark_dirs
setopt complete_in_word
setopt always_last_prompt
setopt nonomatch

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

autoload  history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end


zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' verbose yes
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*' # 補完で小文字でも大文字にマッチさせる
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignore-parents parent pwd .. # ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
       /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin # sudo の後ろでコマンド名を補完する
#zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:processes' command 'ps x -o pid,s,args' # ps コマンドのプロセス名補完


export WORDCHARS="|*?_-.[]~=&;!#$%^(){}<>"
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
export LANG="ja_JP.UTF-8"
export LSCOLORS=gxfxcxdxbxegedabagacad
export ALTERNATE_EDITOR=vi EDITOR=emacsclient VISUAL=emacsclient
export TERM="xterm-256color"
export LESS='-g -i -M -R -W -z-4 -x4'
export PAGER=less
export LESS_TERMCAP_mb=$'\E[01;31m'      # Begins blinking.
export LESS_TERMCAP_md=$'\E[01;31m'      # Begins bold.
export LESS_TERMCAP_me=$'\E[0m'          # Ends mode.
export LESS_TERMCAP_se=$'\E[0m'          # Ends standout-mode.
export LESS_TERMCAP_so=$'\E[00;47;30m'   # Begins standout-mode.
export LESS_TERMCAP_ue=$'\E[0m'          # Ends underline.
export LESS_TERMCAP_us=$'\E[01;32m'      # Begins underline.

PROMPT=$'%(?.%{$fg[green]%}.%{${fg[red]}%})~~>`branch-status-check` %{$fg[default]%}'
RPROMPT=$'%{$fg[yellow]%}[%~]%{$fg[default]%}'

alias rm='rm -r'
alias srm='sudo rm -r'
alias cp='cp -r'
alias l='ls -AoFCGB'
alias ls='ls -AoFGB'
alias cvpp='g++ -Wall -O2 `pkg-config opencv --libs --cflags`'
alias gcc='gcc -Wall'
alias cpp='g++ -Wall'
alias t='tmux'
alias ta='tmux attach'
alias ts='tmux source-file ~/.tmux.conf'
alias agb='ag --ignore TAGS --ignore vendor binding\.pry\|debugger\;'
alias agr='ag --ignore TAGS --ignore vendor'

# alias brew="env PATH=${PATH/\/Users\/youdee\/\.pyenv\/shims:/} brew"
alias diff='colordiff'

alias g='open -a Google\ Chrome'
alias gimp='open -a gimp'
alias -s txt='cat'
alias -s html='chrome'
alias -s rb='ruby'
alias -s py='python'
alias -s hs='runhaskell'
alias -s php='php -f'
alias -s {gz,tar,zip,rar,7z}='unarchive' # preztoのarchiveモジュールのコマンド(https://github.com/sorin-ionescu/prezto/tree/master/modules)
alias -s {gif,jpg,jpeg,png,bmp}='display'
alias rn='rails new --skip-turbolinks --skip-bundle'

# if pgrep -f '[Ee]macs' >/dev/null 2>&1; then
#     echo "Emacs server is already running..."
# else
#     `emacs --daemon`
# fi
#alias emacsclient='/usr/local/Cellar/emacs/24.4/bin/emacsclient'
alias e='emacsclient -n'
alias ec='emacsclient -nw'
alias kille="emacsclient -e '(kill-emacs)'"
alias es='emacs -q -l simple-init.el'
alias tage='ctags -e -R --exclude=*.js .'
alias mk='mkdircd'

# -------------------------------------
# パス
# -------------------------------------
# 重複する要素を自動的に削除
# typeset -U path cdpath fpath manpath
# path=(
#     $HOME/bin(N-/)
#     /usr/local/bin(N-/)
#     /usr/local/sbin(N-/)
#     $path
# )

# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi


function chpwd() { l }

function mkdircd () {
    mkdir $1
    cd $1
}

# function runcpp () {
#     g++ -O2 $1
#     shift
#     ./a.out $@
# }
# alias -s {c,cpp}='runcpp'

if [ -z "$TMUX" -a -z "$STY" ]; then
    if type tmux >/dev/null 2>&1; then
        if tmux has-session && tmux list-sessions | grep -qE '.*]$'; then
            tmux attach && echo "tmux attached session "
        else
            tmux new-session && echo "tmux created new session"
        fi
    fi
fi
function title {
    echo -ne "\033]0;"$*"\007"
}

# ----- PROMPT -----
function branch-status-check {
    local prefix branchname suffix
    # .gitの中だから除外
    if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
        return
    fi
    branchname=`get-branch-name`
    # ブランチ名が無いので除外
    if [[ -z $branchname ]]; then
        return
    fi
    prefix=`get-branch-status` #色だけ返ってくる
    suffix='%{'${reset_color}'%}'
    echo "%{$fg[magenta]%}[${prefix}${branchname}${suffix}%{$fg[magenta]%}]"
}
function get-branch-name {
    # gitディレクトリじゃない場合のエラーは捨てます
    echo `git rev-parse --abbrev-ref HEAD 2> /dev/null`
}
function get-branch-status {
    local res color
    output=`git status --short 2> /dev/null`
    if [ -z "$output" ]; then
        res=':' # status Clean
        color='%{'${fg[green]}'%}'
    elif [[ $output =~ "[\n]?\?\? " ]]; then
        res='?:' # Untracked
        color='%{'${fg[yellow]}'%}'
    elif [[ $output =~ "[\n]? M " ]]; then
        res='M:' # Modified
        color='%{'${fg[red]}'%}'
    else
        res='A:' # Added to commit
        color='%{'${fg[cyan]}'%}'
    fi
    # echo ${color}${res}'%{'${reset_color}'%}'
    echo ${color} # 色だけ返す
}

function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
                    eval $tac | \
                    peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}

zle -N peco-select-history
bindkey '^r' peco-select-history

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
# eval "$(plenv init -)"
# eval "$(pyenv init -)"
# eval "$(rbenv init -)"
eval "$(anyenv init -)"

# export PIP_DOWNLOAD_CACHE=$HOME/.pip
# export PIP_SRC=$PIP_DOWNLOAD_CACHE
# export PIP_RESPECT_VIRTUALENV=true
# export GOPATH=$HOME/.go
# export PYTHONPATH=$PYTHONPATH:"/usr/local/lib/python2.7/site-packages/"

export PATH="$HOME/.anyenv/bin:/usr/local/bin:$HOME/bin:$PATH:"
# export PATH="$PATH:/usr/local/opt/mysql@5.6/bin"
export PATH="$PATH:/bin:/usr/bin:/usr/local/sbin"
# export PATH="$PATH:$HOME/.rbenv/versions/2.1.1/lib/ruby/gems/2.1.0/gems/rcodetools-0.8.5.0/bin"
# export PATH="$PATH:/usr/local/opt/ruby/bin"
# export PATH="$PATH:$HOME/.rbenv/bin"
# export PATH="$PATH:/opt/homebrew-cask/Caskroom"
# export PATH="$PATH:$HOME/.cabal/bin"
# export PATH="$PATH:$HOME/.cask/bin"
# export PATH="/Applications/Xcode6.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin:$PATH"
# export PATH="$PATH:/usr/local/opt/go/libexec/bin"
# export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools:$HOME/Library/Android/sdk/tools"

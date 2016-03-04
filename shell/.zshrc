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
export EDITOR=emacsclient

PROMPT=$'%(?.%{$fg[green]%}.%{${fg[red]}%})%n%%`branch-status-check` %{$fg[default]%}'
RPROMPT=$'%{$fg[yellow]%}[%~]%{$fg[default]%}'

alias sudo='sudo '
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
alias agb='ag binding\.pry\|debugger\;'
alias brew="env PATH=${PATH/\/Users\/youdee\/\.pyenv\/shims:/} brew"
alias diff='colordiff'
alias less='less -R'

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

# if pgrep -f '[Ee]macs' >/dev/null 2>&1; then
#     echo "Emacs server is already running..."
# else
#     `emacs --daemon`
# fi
alias e='emacsclient -n'
alias ec='emacsclient -nw'
alias kille="emacsclient -e '(kill-emacs)'"
alias tage='ctags -e -R --exclude=*.js .'

# -------------------------------------
# パス
# -------------------------------------
# 重複する要素を自動的に削除
typeset -U path cdpath fpath manpath
path=(
    $HOME/bin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    $path
)

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


# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

function chpwd() { l }
eval "$(pyenv init -)"
eval "$(plenv init -)"


# function runcpp () {
#     g++ -O2 $1
#     shift
#     ./a.out $@
# }
# alias -s {c,cpp}='runcpp'

function runjava () {
    className=$1
    className=${className%.java}
    javac $1
    shift
    java $className $@
}
alias -s java='runjava'

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

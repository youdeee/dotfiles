fpath=(/usr/local/share/zsh-completions $fpath)

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..
# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

export WORDCHARS="|*?_-.[]~=&;!#$%^(){}<>"
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

autoload -Uz compinit #補完機能追加
compinit -u

export LANG=ja_JP.UTF-8
export LSCOLORS=gxfxcxdxbxegedabagacad

autoload -Uz colors #色選択
colors
setopt print_eight_bit
setopt auto_menu
bindkey -e
setopt pushd_ignore_dups
setopt autopushd
setopt autocd
setopt autonamedirs
setopt cdablevars
setopt list_types
setopt auto_param_slash
setopt auto_param_keys
autoload  history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

export EDITOR=emacsclient
setopt extended_glob
setopt prompt_subst
setopt correct_all
#プロンプトの色変更＆警告時、カラー変化
PROMPT='%(?.%{$fg[green]%}.%{${fg[red]}%})%n%% %{$fg[default]%}'
RPROMPT="%{$fg[yellow]%}[%~]%{$fg[default]%}"
#autoload -U promptinit; promptinit

alias rm='rm -r'
alias cp='cp -r'
#alias emacs='/usr/local/Cellar/emacs/24.3/Emacs.app/Contents/MacOS/Emacs'
alias ls='ls -AoFCGB'
alias cvpp='g++ -Wall -O2 `pkg-config opencv --libs --cflags`'
alias gcc='gcc -Wall'
alias cpp='g++ -Wall'
alias t='tmux'
alias ta='tmux attach'
alias ts='tmux source-file ~/.tmux.conf'
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# if pgrep -f '[Ee]macs' >/dev/null 2>&1; then
#     echo "Emacs server is already running..."
# else
#     `emacs --daemon`
# fi
alias e='emacsclient -n'
alias es='emacsclient -nw'

setopt IGNORE_EOF #^dのログアウト防止
setopt NO_CLOBBER #ファイル上書き防止
setopt no_tify # バックグラウンドジョブが終了したらすぐに知らせる。
setopt EXTENDED_HISTORY
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks

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

autoload -U tetris
zle -N tetris
export PATH=/usr/local/opt/ruby/bin:$PATH
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/opt/homebrew-cask/Caskroom:$PATH
export PIP_DOWNLOAD_CACHE=$HOME/.pip
export PIP_SRC=$PIP_DOWNLOAD_CACHE
export PIP_RESPECT_VIRTUALENV=true
export PATH=~/.cabal/bin:$PATH

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

function chpwd() { ls }
eval "$(pyenv init -)"
eval "$(plenv init -)"

alias chrome='open -a Google\ Chrome'
alias -s txt='cat'
alias -s html='chrome'
alias -s rb='ruby'
alias -s py='python'
alias -s hs='runhaskell'
alias -s php='php -f'
alias -s {gz,tar,zip,rar,7z}='unarchive' # preztoのarchiveモジュールのコマンド(https://github.com/sorin-ionescu/prezto/tree/master/modules)
alias -s {gif,jpg,jpeg,png,bmp}='display'

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

# 既にtmuxを起動してないか
# if [ "$TMUX" = "" ]; then
#     tmux attach;

#     # detachしてない場合
#     if [ $? ]; then
#         tmux;
#     fi
# fi
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
source ~/zaw/zaw.zsh
zstyle ':completion:*:default' menu select=1
setopt glob_dots

#zmodload zsh/zprof #profile start
fpath=(~/.zshfunc $fpath)
export LD_LIBRARY_PATH=/usr/local/lib

export LESS='-i -M -R'
export TMPDIR=/tmp
export LANG=en_US.utf8
export JLESSCHARSET=japanese
export MAIL=~/Maildir
export EDITOR=vi
export PAGER=less
export WORDCHARS='*?_.[]~-=&;!#$%^(){}<>'
export GREP_COLORS='mt=1;31'
export LS_COLORS='di=01;36'
export TMUX_BG=`echo -n mrakn | gzip -1 -c | tail -c8 | hexdump -n4 -e '"%u"'|awk '{$1=$1%128+128;printf "colour%d", $0}'`
alias grep='grep --color'
alias ls='ls -v --color'
alias rm='rm -i'

alias -g G='|&grep'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias cman='LANG=C man'
alias emacs='emacs -nw'
alias tm='tmux attach'
t () {  tmux attach -t $1 2> /dev/null || tmux attach || tmux new -s $1 2> /dev/null || tmux new -s 0 }

alias cp='nocorrect cp -i'
alias mv='nocorrect mv -i'
alias touch='nocorrect touch'
alias ngron="awk 'NR>1'|gron"


alias cdl='cd "$@"; ls -lsAFL'
alias hd='od -Ax -tx1z -v'    # handy hex dump

bindkey -e
bindkey '^P' history-beginning-search-backward # 先頭マッチのヒストリサーチ
bindkey '^N' history-beginning-search-forward  # 先頭マッチのヒストリサーチ
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward
bindkey '^[[1;5C' forward-word  # Ctrl + Right Arrow
bindkey '^[[1;5D' backward-word # Ctrl + Left Arrow

setopt prompt_subst
SHORTHOST=`echo $HOST|sed -e "s/\.corp\..*//"`

PROMPT='%{[34m%}%B`whoami`@$SHORTHOST%{[m%}%b %1(v|%F{green}%1v%f|) %~
$'

HISTFILE=$HOME/.zsh-history           # 履歴をファイルに保存する
HISTSIZE=100000                       # メモリ内の履歴の数
SAVEHIST=100000                       # 保存される履歴の数
fignore=('#' '~' '.svn')

setopt share_history                  # 履歴ファイルを共有
setopt extended_history               # 履歴ファイルに時刻を記録
setopt hist_ignore_dups               # 直前のコマンドと同一ならば登録しない
setopt hist_ignore_all_dups           # 既にヒストリにあるコマンド行は古い方を削除
setopt hist_reduce_blanks             # コマンドラインの余計なスペースを排除
setopt hist_ignore_space              # スペースから始まるコマンドは履歴しない

function history-all { history -E 1 } # 全履歴の一覧を出力する

zstyle ':completion:*' menu select interactive
zstyle ':completion:*' list-colors "ma=43;30"
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/cache
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完の時に大文字小文字を区別しない
#setopt menu_complete

zmodload zsh/complist # enable bindkey -M menuselect
bindkey -M menuselect '^g' .send-breakq
bindkey -M menuselect '^i' forward-char
bindkey -M menuselect '^j' .accept-line
bindkey -M menuselect '^k' accept-and-infer-next-history
bindkey -M menuselect '^p' up-line-or-history
bindkey -M menuselect '^n' down-line-or-history
bindkey -M menuselect '^r' history-incremental-search-forward

autoload -Uz compinit && compinit

stty stop undef         # C-sでストップしない
unsetopt promptcr       # \nで終わらない最終行を表示
setopt auto_pushd
setopt auto_cd          # 第1引数がディレクトリだと自動的に cd を補完
setopt no_hup           # logout時にバックグラウンドジョブを kill しない
setopt no_beep          # コマンド入力エラーでBEEPを鳴らさない
setopt correct          # スペルミス補完
setopt globdots         # ドットファイルも補完
setopt ignore_eof       # C-dでlogoutしない(C-dを補完で使う人用)
setopt extended_glob    # 拡張されたglob展開(~で条件除外など)
setopt list_packed      # 補完候補リストを詰めて表示
setopt print_eight_bit  # 補完候補リストの日本語を適正表示
setopt complete_inword  # 文字列途中で補完

#ファイル名を引数に
function cd () {
    if [ $# = 0 ]; then
        builtin cd
    elif [ -f $1 ]; then
        builtin cd $1:h
    else
        builtin cd $*
    fi
}

clear-screen-rehash() {
	rehash
    clear
	zle reset-prompt
}
zle -N clear-screen-rehash
bindkey '^L' clear-screen-rehash

#for emacs shell-mode
if [[ $EMACS = t ]]; then
    PROMPT='%~ $'
    unsetopt zle
fi

function cdup() {
  cd ..
  zle push-line-or-edit
  zle accept-line
}
zle -N cdup
bindkey '^\^' cdup

alias -g L='|less'
alias -g H='|head'
alias -g T='|tail'
alias -g S='|sort'
alias -g G="|egrep"
alias -g C='2>&1 |perl -pe "s/^(INFO|ERROR|WARNING|DEBUG)(\s+\S+\s\S+)([^\]]+\])/[32m[1m\1[0m[34m\2[31m\3[37m/"'

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

#begin ssh-agent environment
[ -s "$HOME/bin/ssh-add-check.sh" ] && \. "$HOME/bin/ssh-add-check.sh" &|

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

if [ ! -f ~/.zshrc.zwc -o ~/.zshrc -nt ~/.zshrc.zwc ]; then
   zcompile ~/.zshrc
fi

if [ -f ~/.zshrc.local ] && ([ ! -f ~/.zshrc.local.zwc -o ~/.zshrc.local -nt ~/.zshrc.local.zwc ]); then
    zcompile ~/.zshrc.local
fi

[ -s "$HOME/.zshrc.local" ] && source ~/.zshrc.local

if (which zprof > /dev/null 2>&1) ;then
    zprof
fi

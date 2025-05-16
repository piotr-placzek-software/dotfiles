. $HOME/.local/lib/z/z.sh
alias cls="clear"
alias srcaliases=". ~/.bash_aliases"
alias python=python3
alias n="nano"
alias v="nvim ."
alias lsq="lazysql"
alias ld="lazydocker"
alias dc="docker-compose"
alias dcu="docker-compose up"
alias dcd="docker-compose down"
alias lg="lazygit"
alias gf="git fetch"
alias gs="git status"
alias ga="git add"
alias gA="git add ."
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gcam="git commit --amend -m"
alias gd="git diff"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gba="git branch"
alias gbA="git branch -a"
alias gl="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset) - %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'"
alias gls="gl -n 8"
alias gll="gl -n 1"
alias gpl="git pull origin"
alias gps="git push origin"
alias gr="git rebase"
alias gri="git rebase -i"
alias grc="git rebase --continue"
alias gra="git rebase --abort"
alias gulc="ga . && gca"
alias gulcp="gulc && gpsfc"
alias cat="batcat"
alias ls="eza --color=always --long --icons=always --tree --level=1"
alias la="eza --color=always --long --icons=always --tree --level=1 --all"
alias ll="eza --color=always --long --icons=always --tree --level=2"
alias yarnstart="NODE_OPTIONS="--max-old-space-size=4096" yarn start"

gb() {
	git branch |grep \* |cut -c 3-
}

gplc() {
	command git pull origin $(gb)
}
gpsc() {
	command git push origin $(gb)
}
gpsfc() {
	command git push -f origin $(gb)
}

source ~/.bash_completion.d/complete_alias
complete -F _complete_alias dc
complete -F _complete_alias gd
complete -F _complete_alias gco
complete -F _complete_alias gcob
complete -F _complete_alias gpl
complete -F _complete_alias gps
complete -F _complete_alias gr
complete -F _complete_alias gri


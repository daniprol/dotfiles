is_in_git_repo() {
    # git rev-parse HEAD > /dev/null 2>&1
    git rev-parse HEAD > /dev/null
}
# Filter branches.
git-br-fzf() {
    is_in_git_repo || return

    local tags branches target
    tags=$(
	git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
    branches=$(
	git branch --all | grep -v HEAD |
	    sed "s/.* //" | sed "s#remotes/[^/]*/##" |
	    sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
    target=$(
	(echo "$tags"; echo "$branches") |
	    fzf --no-hscroll --no-multi --delimiter="\t" -n 2 \
		--ansi --preview="git log -200 --pretty=format:%s $(echo {+2..} |  sed 's/$/../' )" ) || return
    echo $(echo "$target" | awk -F "\t" '{print $2}')
}
# Filter branches and checkout the selected one with <enter> key,
git-co-fzf() {
    is_in_git_repo || return
    git checkout $(git-br-fzf)
}
# Filter commit logs. The diff is shown on the preview window.
git-log-fzf() { # fshow - git commit browser
    is_in_git_repo || return

    _gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
    _viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always %'"
    git log --graph --color=always \
	--format="%C(auto)%h%d [%an] %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
	--preview="$_viewGitLogLine" \
	--bind "ctrl-m:execute:
		(grep -o '[a-f0-9]\{7\}' | head -1 |
		xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
		{}
FZF-EOF"
}


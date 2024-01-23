# To fastly jump in a remote branch
_get(){
    if [ -d ".git" ]; then
        if [ -n "$1" ]; then
            # An argument passed
            # We try to stash our changes if there where some...
            git stash
            # We fetch/checkout the target branch
            git fetch origin $1
            git checkout $1
        else
            # No argument passed
            echo "Usage: get feat/test-stuff"
        fi
    else
        echo "[x] Oups, not a .git directory !"
    fi
}

# To get back to your stuffs (branch and changes)
_back(){
    if [ -d ".git" ]; then
        # To revert local changes that have been made
        git restore --staged .
        git restore .
        # To get back on previous branch
    	git checkout -
        # We try to get our precedents changes back...
        git stash pop
    else
        echo "[x] Oups, not a .git directory !"
    fi
}

GIT_FZF_DEFAULT_OPTS="
	$FZF_DEFAULT_OPTS
	--ansi
	--reverse
	--height=100%
	--bind shift-down:preview-down
	--bind shift-up:preview-up
	--bind pgdn:preview-page-down
	--bind pgup:preview-page-up
	--bind q:abort
	$GIT_FZF_DEFAULT_OPTS
"

git-fuzzy-diff ()
{
	PREVIEW_PAGER="less --tabs=4 -Rc"
	ENTER_PAGER=${PREVIEW_PAGER}
	if [ -x "$(command -v delta)" ]; then
		PREVIEW_PAGER="delta | ${PREVIEW_PAGER}"
		ENTER_PAGER="delta | sed -e '1,4d' | ${ENTER_PAGER}"
	fi

	# Don't just diff the selected file alone, get related files first using
	# '--name-status -R' in order to include moves and renames in the diff.
	# See for reference: https://stackoverflow.com/q/71268388/3018229
	PREVIEW_COMMAND='git diff --color=always '$@' -- \
		$(echo $(git diff --name-status -R '$@' | grep {}) | cut -d" " -f 2-) \
		| '$PREVIEW_PAGER

	# Show additional context compared to preview
	ENTER_COMMAND='git diff --color=always '$@' -U10000 -- \
		$(echo $(git diff --name-status -R '$@' | grep {}) | cut -d" " -f 2-) \
		| '$ENTER_PAGER

	git diff --name-only $@ | \
		fzf ${GIT_FZF_DEFAULT_OPTS} --exit-0 --preview "${PREVIEW_COMMAND}" \
		--preview-window=top:85% --bind "enter:execute:${ENTER_COMMAND}"
}

git-fuzzy-log ()
{
	PREVIEW_COMMAND='f() {
		set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}")
		[ $# -eq 0 ] || (
			git show --no-patch --color=always $1
			echo
			git show --stat --format="" --color=always $1 |
			while read line; do
				tput dim
				echo " $line" | sed "s/\x1B\[m/\x1B\[2m/g"
				tput sgr0
			done |
			tac | sed "1 a \ " | tac
		)
	}; f {}'

	ENTER_COMMAND='(grep -o "[a-f0-9]\{7\}" | head -1 |
		xargs -I % bash -ic "git-fuzzy-diff %^1 %") <<- "FZF-EOF"
		{}
		FZF-EOF'

	git log --graph --color=always --format="%C(auto)%h %s%d " | \
		fzf ${GIT_FZF_DEFAULT_OPTS} --no-sort --tiebreak=index \
		--preview "${PREVIEW_COMMAND}" --preview-window=top:15 \
		--bind "enter:execute:${ENTER_COMMAND}"
}

git-fuzzy-log-branch ()
{
	PREVIEW_COMMAND='f() {
		set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}")
		[ $# -eq 0 ] || (
			git show --no-patch --color=always $1
			echo
			git show --stat --format="" --color=always $1 |
			while read line; do
				tput dim
				echo " $line" | sed "s/\x1B\[ m/\x1B\[2m/g"
				tput sgr0
			done |
			tac | sed "1 a \ " | tac
		)
	}; f {}'

	ENTER_COMMAND='(grep -o "[a-f0-9]\{7\}" | head -1 |
		xargs -I % bash -ic "git-fuzzy-diff %^1 %") <<- "FZF-EOF"
		{}
		FZF-EOF'

	git log-branch --graph --color=always --format="%C(auto)%h %s%d " | \
		fzf ${GIT_FZF_DEFAULT_OPTS} --no-sort --tiebreak=index \
		--preview "${PREVIEW_COMMAND}" --preview-window=top:15 \
		--bind "enter:execute:${ENTER_COMMAND}"
}

fuzzy_add_search()
{
    DIFF_VIEW='git diff {1} | delta'
    ADD_PATCH='git add -p {1}'

    git diff --shortstat --name-only | \
    fzf ${GIT_FZF_DEFAULT_OPTS} --exit-0 \
    --header "Changes to Add" \
    --preview "${DIFF_VIEW}" \
    --preview-window top:20 --pointer=">" \
    --bind "enter:execute:${ADD_PATCH}"
}

fuzzy_diff_search()
{
    DIFF_VIEW='git diff {1} | delta'

    git diff --shortstat --name-only | \
    fzf ${GIT_FZF_DEFAULT_OPTS} --exit-0 \
    --header "Changes to Add" \
    --preview "${DIFF_VIEW}" \
    --preview-window top:20 --pointer=">"
}

fuzzy_stash_search()
{
    while out=$(git stash list "$@" |
                fzf --ansi --no-sort --reverse --print-query --query="$query"              \
                    --expect=ctrl-a,ctrl-b,ctrl-p,del                                      \
                    --bind="ctrl-u:preview-page-up"                                        \
                    --bind="ctrl-d:preview-page-down"                                      \
                    --bind="ctrl-k:preview-up"                                             \
                    --bind="ctrl-j:preview-down"                                           \
                    --preview="echo {} | cut -d':' -f1 | xargs git stash show -p | delta"  \
                    --preview-window "top:40");
    do
        # Tokenize selection by newline
        IFS=$'\n' read -rd '' -a selection <<< "$out"
        # Keep the query accross fzf calls
        query="${selection[1]}"
        # Represents the stash, e.g. stash{1}
        reflog_selector=$(echo "${selection[3]}" | cut -d ':' -f 1)

        case "${selection[2]}" in
            # ctrl-a applies the stash to the current tree
            ctrl-a)
                git stash apply "$reflog_selector"
                break
                ;;
            # ctrl-b checks out the stash as a branch
            ctrl-b)
                sha=$(echo "${selection[3]}" | grep -o '[a-f0-9]\{7\}')
                git stash branch "stash-$sha" "$reflog_selector"
                break
                ;;
            # ctrl-p is like ctrl-a but it drops the stash. Uses stash pop.
            ctrl-p)
                git stash pop "$reflog_selector"
                break
                ;;
            # del will drop the stash
            del)
                git stash drop "$reflog_selector"
                ;;
        esac
    done
}


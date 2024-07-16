# Source scripts with git+fzf integration
#git_fzf_script=~/Scripts/git_fzf.sh
git_sanix=~/Scripts/git_sanix.sh
if [[ -f $git_sanix && -x $git_sanix ]]; then
	# echo "Sourcing $git_sanix"
	. $git_sanix
fi


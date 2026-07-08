# Git-aware bash prompt: shows the current branch (and dirty state) whenever
# you cd into a git repo. Works in any terminal / font. Sourced from ~/.bashrc.
#
# Uses git's own __git_ps1 helper, which ships with git -- no extra install.

for _gp in /usr/lib/git-core/git-sh-prompt \
           /etc/bash_completion.d/git-prompt \
           /usr/share/git-core/contrib/completion/git-prompt.sh; do
    if [ -f "$_gp" ]; then . "$_gp"; break; fi
done
unset _gp

if declare -f __git_ps1 >/dev/null 2>&1; then
    GIT_PS1_SHOWDIRTYSTATE=1       # * = unstaged, + = staged
    GIT_PS1_SHOWUNTRACKEDFILES=1   # % = untracked files present
    GIT_PS1_SHOWUPSTREAM=auto      # </>/= vs upstream

    # green user@host : blue cwd  yellow (branch*)  $
    PROMPT_COMMAND='__git_ps1 "\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]" "\\\$ " " \[\033[01;33m\](%s)\[\033[00m\]"'
fi

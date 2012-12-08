PROMPT=%{$fg[blue]%}╭$'%{$fg_bold[red]%} s3357678 %{$reset_color%}%{$FG[123]%}[%c] %{$reset_color%}$(git_prompt_short_sha)$(svn_prompt_info) $(git_prompt_info)$(git_prompt_status)%{$FG[147]%}\
%{$fg[blue]%}╰>$(prompt_char) %{'$FG[202]'%}➤%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[147]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="%{]$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{ $fg[red]%}✗ %{$FG[147]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{ $fg[green]%}✓ %{$FG[147]%}"

ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{$FG[200]%}- %{$FG[150]%}"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} [added]"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} [modified]"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} [deleted]"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} [renamed]"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} [unmerged]"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} [untracked]"

#function prompt_char() {
#  git branch >/dev/null 2>/dev/null && echo "%{$fg[green]%}☼%{$reset_color%}" && return
#  hg root >/dev/null 2>/dev/null && echo "%{$fg_bold[red]%}☿%{$reset_color%}" && return
#  echo "%{$fg[cyan]%}☪ %{$reset_color%}"
#}

function prompt_char() {
    if git rev-parse --git-dir > /dev/null 2>&1;then
        echo "%{$fg[green]%}☼%{$reset_color%}"
    else
        if [ -d ".svn" ];then
            echo "%{$fg[yellow]%}☆%{$reset_color%}"
        else
            echo "%{$fg[cyan]%}☪%{$reset_color%}"
        fi 
    fi
}

function svn_prompt_info {
    # Set up defaults
    local svn_branch=""
    local svn_repository=""
    local svn_version=""
    local svn_change=""

    # only if we are in a directory that contains a .svn entry
    if [ -d ".svn" ]; then
        # query svn info and parse the results
        svn_branch=`svn info | grep '^URL:' | egrep -o '((tags|branches)/[^/]+|trunk).*' | sed -e 's/^(branches|tags)\///g'`
        svn_repository=`svn info | grep '^Repository Root:' | egrep -o '(http|https|file|svn|svn+ssh)/[^/]+' | egrep -o '[^/]+$'`
        svn_version=`svnversion -n`
        
        # this is the slowest test of the bunch
        change_count=`svn status | grep "?\|\!\|M\|A" | wc -l`
        if [ "$change_count" != 0 ]; then
            svn_change="%{$reset_color%}%{$fg[red]%}[dirty]"
        else
            svn_change="%{$reset_color%}%{$fg[green]%}[clean]"
        fi
        
        # show the results
        echo "%{$fg[blue]%}$svn_repository/$svn_branch @ $svn_version $svn_change%{$reset_color%}"
        
    fi
}

#%D{[%I:%M:%S]} --> date of time
#%{$fg_bold[green]%}%D{%a %b %d,%Y} %{$fg[yellow]%}◕ %t 

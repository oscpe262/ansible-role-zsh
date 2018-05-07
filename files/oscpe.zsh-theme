# oh-my-zsh oscpe theme

### Git

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%}[%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[white]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%}▴%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%}▾%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[yellow]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"

# Get branch name
oscpe_git_branch () {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

oscpe_git_status() {
  # start blank
  _STATUS=""

  # check file status
  _INDEX=$(command git status --porcelain 2> /dev/null)
  if [[ -n "$_INDEX" ]]; then
    if $(echo "$_INDEX" | command grep -q '^[AMRD]. '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
    fi  
    if $(echo "$_INDEX" | command grep -q '^.[MTD] '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
    fi  
    if $(echo "$_INDEX" | command grep -q -E '^\?\? '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
    fi  
    if $(echo "$_INDEX" | command grep -q '^UU '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
    fi 
  else
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
   
   # check status of local repository
  _INDEX=$(command git status --porcelain -b 2> /dev/null)
  if $(echo "$_INDEX" | command grep -q '^## .*ahead'); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
  if $(echo "$_INDEX" | command grep -q '^## .*behind'); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_BEHIND"
  fi
  if $(echo "$_INDEX" | command grep -q '^## .*diverged'); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_DIVERGED"
  fi

  if $(command git rev-parse --verify refs/stash &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_STASHED"
  fi

  echo $_STATUS
}

oscpe_git_prompt () {
  local _branch=$(oscpe_git_branch)
  local _status=$(oscpe_git_status)
  local _result=""

  if [[ "${_branch}x" != "x" ]]; then
    _result="$ZSH_THEME_GIT_PROMPT_PREFIX${_branch}"
    if [[ "${_status}x" != "x" ]]; then
      _result="$_result $_status"
    fi
    _result="${_result}$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
  echo $_result
}

### Standard

_PATH="%{$fg_bold[white]%}%~%{$reset_color%}"

# user color and prompt sign init
_USERCOLOR="%{$fg_bold[green]%}"
_LIBERTY="$"

# switch if root
if [[ $EUID -eq 0 ]]; then
  _USERCOLOR="%{$fg_bold[red]%}"
  _LIBERTY="#"
fi

# create prompt vars
_LIBERTY="${_USERCOLOR}$_LIBERTY%{$reset_color%}"
_USERNAME="${_USERCOLOR}%n"

# if no HOST_COLOR set, set to default
# TODO: Fix this
if [[ -z $HOST_COLOR ]]; then
  HOST_COLOR=white
fi

# SSH session? Append hostname
if [[ -n $SSH_CLIENT ]]; then
  _USERNAME="${_USERNAME}%{$reset_color%}@$_USERCOLOR%m"
fi

_USERNAME="${_USERNAME}%{$reset_color%}"

PROMPT="$_USERNAME $_PATH $_LIBERTY "
RPROMPT='$(oscpe_git_prompt)'

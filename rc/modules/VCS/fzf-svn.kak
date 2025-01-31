# ╭─────────────╥─────────────────────────╮
# │ Author:     ║ File:                   │
# │ Andrey Orst ║ fzf-svn.kak             │
# ╞═════════════╩═════════════════════════╡
# │ Submodule for Svn support for fzf.kak │
# ╞═══════════════════════════════════════╡
# │ GitHub.com/andreyorst/fzf.kak         │
# ╰───────────────────────────────────────╯

hook global ModuleLoad fzf_vcs %§

declare-option -docstring "command to provide list of files in svn repository to fzf. Arguments are supported
Supported tools:
    <package>:  <value>:
    Subversion: ""svn""

Default arguments:
    ""svn list -R $(svn info | awk -F': ' '/Working Copy Root Path: .*/ {print $2}') | grep -v '$/'""
" \
str fzf_svn_command "svn"

map global fzf-vcs -docstring "edit file from Subversion tree" 's' '<esc>: fzf-svn<ret>'

define-command -hidden fzf-svn %{ evaluate-commands %sh{
    current_path=$(pwd)
    repo_root=$(svn info | awk -F': ' '/Working Copy Root Path: .*/ {print $2}')
    case $kak_opt_fzf_svn_command in
    svn)
        cmd="svn list -R $repo_root | grep -v '$/'" ;;
    svn*)
        cmd=$kak_opt_fzf_svn_command ;;
    esac
    [ ! -z "${kak_client_env_TMUX}" ] && additional_flags="--expect $kak_opt_fzf_vertical_map --expect $kak_opt_fzf_horizontal_map"
    printf "%s\n" "fzf -kak-cmd %{cd $repo_root; edit -existing} -items-cmd %{$cmd} -fzf-args %{-m --expect $kak_opt_fzf_window_map $additional_flags} -post-action %{cd $current_path}"
}}

§

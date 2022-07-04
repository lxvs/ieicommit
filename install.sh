#!/bin/bash
set -o nounset

Logo () {
cat <<EOF

    $name
    $link

EOF
}

Usage () {
cat <<EOF
usage: ./$script_name
   or: ./$script_name uninstall
EOF
}

Install () {
    test -d "$target_dir" || mkdir -p "$target_dir" || return
    install "inspurcommit" "$target_dir" || return
    install --mode=644 "ChangeHistoryTemplate.txt" "$target_dir" || return
    printf "Install complete.\n"
}

Uninstall () {
    if test ! -d "$target_dir"
    then
        >&2 printf "error: not installed\n"
        return 1
    fi
    pushd "$target_dir" 1>/dev/null
    rm -f "inspurcommit" "ChangeHistoryTemplate.txt" || return
    popd 1>/dev/null
    rmdir "$target_dir" 2>/dev/null
    printf "Uninstall complete.\n"
}

ParseArgs () {
    local val
    if test $# -eq 0
    then
        Install
        return
    elif test $# -eq 1
    then
        case $1 in
        -h|--help)
            Logo
            Usage
            exit 0
            ;;
        0|uninstall)
            Uninstall
            return
            ;;
        1|install)
            Install
            return
            ;;
        *)
            >&2 printf "error: invalid argument \`%s'\n" "$1"
            >&2 Usage
            exit 1
            ;;
        esac
    else
        >&2 printf "error: too many arguments\n"
        >&2 Usage
        exit 1
    fi
}

GetTargetDir () {
    local OS=${OS-}
    if grep -Gqi "win" <<<"$OS"
    then
        target_dir="$HOME/bin"
    else
        target_dir="/usr/local/bin"
    fi
}

main () {
    local -r script_name=$(basename "$0")
    local -r script_dir=$(dirname "$0")
    local -r name="inspurcommit installation script"
    local -r link="https://github.com/islzh/inspurcommit"
    local target_dir
    pushd "$script_dir" 1>/dev/null
    GetTargetDir
    ParseArgs "$@" || return
}

main "$@"

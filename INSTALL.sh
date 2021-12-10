#!/bin/bash
set -o nounset

Logo () {
cat <<LOGO

    $name Deployment
    $link

LOGO
}

Usage () {
cat <<USG

Usage:

Install with one of below command:
    ./$script_name 1
    ./$script_name install

Uninstall:
    ./$script_name 0
    ./$script_name uninstall

USG
}

Install () {
    test -d "$target_dir" || mkdir "$target_dir"
    install "inspurcommit" "$target_dir" || return
    cp "ChangeHistoryTemplate.txt" "$target_dir"
    printf "Complete.\n"
}

Uninstall () {
    if test ! -e "$target_dir/inspurcommit"
    then
        >&2 printf "error: not installed\n"
        return 1
    fi
    pushd "$target_dir" 1>/dev/null
    rm -f "inspurcommit" || return
    rm -f "ChangeHistoryTemplate.txt" "jgversion" "jgnumberforthehistory"
    popd 1>/dev/null
    rmdir "$target_dir" 2>/dev/null
    printf "Complete.\n"
}

main () {
    pushd $(dirname "$0") 1>/dev/null
    local -r name="Inspur Commit Kit"
    local -r link="https://github.com/islzh/inspurcommit"
    local -r script_name=$(basename "$0")
    local target_dir
    if printf "%s" "${OS-}" | grep -q "Windows"
    then
        target_dir="$HOME/bin"
    else
        target_dir="/usr/local/bin"
    fi

    if test $# -eq 1
    then
        case "$1" in
        -h|--help)
            Logo
            Usage
            return 0
            ;;
        1|install|deploy)
            Install
            ;;
        0|uninstall|remove)
            Uninstall
            ;;
        *)
            >&2 printf "%s\n" "ERROR: Invalid option: $1"
            >&2 Usage
            return 1
            ;;
        esac
    elif test $# -eq 0
    then
        Logo
        Usage
        return 1
    else
        >&2 printf "%s\n" "ERROR: Too many arguments."
        >&2 Usage
        return 1
    fi
}

main "$@"

#!/bin/bash

Logo(){
    echo "
    $name $rev Deployment
    $link"
}

Usage(){
    echo "
Usage:

Install with one of below command:
    ./$script_name 1
    ./$script_name install
    ./$script_name deploy

Uninstall:
    ./$script_name 0
    ./$script_name uninstall
    ./$script_name remove"
}

pushd $(dirname "$0") 1>/dev/null
declare -r name="Inspur Commit"
declare -r link="https://github.com/islzh/jg"
declare -r LF='
'
declare -r rev=$(cat VERSION 2>/dev/null)
[ "$rev" ] || echo "Warning: failed to get version." >&2
declare -r script_name=$(basename "$0")
if [ "${OS:0:7}" == "Windows" ]
then
    declare -r target_dir=~/bin
else
    declare -r target_dir="/usr/local/bin"
fi

if [ $# -eq 1 ]; then
    case "$1" in
        "-?"|"-h"|"--help")
            Logo
            Usage
            exit
            ;;

        "1"|"install"|"deploy")
            [ -d "$target_dir" ] || mkdir "$target_dir"
            echo "Copying..."
            for jgfile in ./bin/jg*
            do
                cp "$jgfile" "$target_dir" || exit 1
                chmod +x "$target_dir"/$(basename "$jgfile")
            done
            [ "$rev" ] && echo "#!/bin/bash${LF}echo \"$name v$rev\"${LF}echo \"$link\"" > "$target_dir/jgversion"
            chmod +x "$target_dir/jgversion"
            for inspurfile in ./bin/inspur*
            do
                cp $inspurfile $target_dir || exit 1
                chmod +x $target_dir/$(basename $inspurfile)
            done
            echo "Deployment finished"
            exit 0
            ;;

        "0"|"uninstall"|"remove")
            if ! compgen -G "$target_dir/inspur*" >/dev/null
            then
                echo "ERROR: there is no $name deployed." >&2
                exit 1
            fi
            echo "Removing $name..."
            for jgfile in ./bin/jg*
            do
                rm -f "$target_dir"/$(basename "$jgfile")
            done
            for inspurfile in ./bin/inspur*
            do
                rm -f $target_dir/$(basename $inspurfile)
            done
            rm -f "$target_dir/jgversion"
            rmdir "$target_dir" 2>/dev/null
            echo "Complete."
            exit
            ;;

        *)
            >&2 echo "ERROR: Invalid option: $1"
            >&2 Usage
            exit 1
            ;;
    esac

elif [ $# == 0 ]; then
    Logo
    Usage
    exit
else
    >&2 echo "ERROR: Too many arguments."
    >&2 Usage
    exit 1
fi

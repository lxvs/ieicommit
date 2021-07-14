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
    $script_name 1
    $script_name install
    $script_name deploy

Uninstall:
    $script_name 0
    $script_name uninstall
    $script_name remove"
}

declare -r name="Inspur Commit"
declare -r link="https://github.com/islzh/jg"
rev=$(cat VERSION 2>/dev/null)
[ -z $rev ] && echo "Warning: failed to get version" >&2
pushd $(dirname $0) 1>/dev/null
script_name="./$(basename $0)"
if [ "${OS:0:7}" == "Windows" ]
then
    target_dir="/c/Users/$USERNAME/bin"
else
    target_dir="/usr/local/bin"
fi

if [ $# -eq 1 ]; then
    case "$1" in
        "-?"|"-h"|"--help")
            Logo
            Usage
            exit
            ;;

        "1"|"install"|"deploy")
            [ -d $target_dir ] || mkdir $target_dir
            echo "Copying..."
            for jgfile in ./bin/jg*
            do
                cp $jgfile $target_dir || exit 1
                chmod +x $target_dir/$(basename $jgfile)
            done
            for inspurfile in ./bin/inspur*
            do
                cp $inspurfile $target_dir || exit 1
                chmod +x $target_dir/$(basename $inspurfile)
            done
            if [ ! -z $rev ]
            then
                echo "#!/bin/bash
echo '$name $rev'
echo '$link'" > $target_dir/jgversion
            fi
            chmod +x $target_dir/jgversion
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
                rm -f $target_dir/$(basename $jgfile)
            done
            for inspurfile in ./bin/inspur*
            do
                rm -f $target_dir/$(basename $inspurfile)
            done
            rm -f $target_dir/jgversion
            [ $? == 0 ] && echo "Complete."
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
    exit 0
else
    >&2 echo "ERROR: Too many arguments."
    >&2 Usage
    exit 1
fi

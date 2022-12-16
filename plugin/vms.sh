# disable exit
exit(){
    echo -e "\033[34mexit is disabled, please use return statement.\033[0m"
}

info() {
    echo -e "// TODO shows infos of vms, modules, system, etc."
}

help() {
    if [ $# -eq 0 ]; then
        cat man/vms.man
    else
        cat man/${1}.man
    fi
}

history(){
    if [ $# -eq 0 ]; then
        cat -n log/vms.history
        echo -e "\033[34mNote: Navigation key viewing history is currently not supported.\033[0m"
        return 0
    fi

    his_paras=`getopt -o +c -n "#${FUNCNAME[0]}" -- "$@"`
    [ $? != 0 ] && return 1
    eval set -- ${his_paras}
    while true ; do
        case "${1}" in
            -c)
                shift
                echo -n "" > log/vms.history
                return 0
                ;;
            --)
                shift
                ;;
            *)
                vms_main `sed -n "${1},${1}p" log/vms.history`
                return 1
                ;;
        esac
    done
    echo "more..."
}

his(){
    history "$@"
}

vms_main(){
    echo "$@" >> log/vms.history
    cmd=$@
    [ `wc -l < log/vms.history` -eq 1001 ] && sed -i '1d' log/vms.history
    if [ "!" == "${cmd:0:1}" ]; then
        cmd=${cmd:1}
        ${cmd}
    else
        do_vms "${cmd}"
    fi
}

do_vms() {
    eval set -- ${cmd}
    vms_cmd=${1}
    [[ ${vms_cmd} = "do_vms" ]] && echo -e "\033[31mBad Command!\033[0m" && return -1
    [[ ${vms_cmd} = "exit" ]] && unset -f exit && exit
    if [ "$(type -t ${vms_cmd})" = "function" ]; then
        shift
        ${vms_cmd} "$@"
    else
        echo -e "\033[34m${1}: Command Not Found!\033[0m"
    fi
}
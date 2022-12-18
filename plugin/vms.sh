# disable exit
exit(){
    echo -e "\033[34mexit is disabled, please use return statement.\033[0m"
}

info() {
    echo -e "// TODO shows infos of vms, modules, system, etc."
}

help() {
    if [ "$#" -eq 0 ]; then
        cat "${VMS_HOME}"/man/vms.man
    else
        cat "${VMS_HOME}"/man/"${1}".man
    fi
}

his_file="${VMS_HOME}"/log/vms.history

history(){

    if [ "$#" -eq 0 ]; then
        cat -n "${his_file}"
        echo -e "\033[34mNote: Navigation key viewing history is currently not supported.\033[0m"
        return 0
    fi

    his_paras=$(getopt -o +cw -n "${FUNCNAME[0]}" -- "$@")
    [ "$?" != 0 ] && return 1
    eval set -- "${his_paras}"
    while true ; do
        case "${1}" in
            -c)
                shift
                echo -n "" > "${his_file}"
                return 0
                ;;
            -w)
                shift
                history_rows=$(wc -l < log/vms.history)
                of_rows=$[history_rows-HistoryMax]
                [ "${of_rows}" -gt 0 ] && sed -i "1,${of_rows}d" "${his_file}"
                return 0
                ;;
            --)
                shift
                ;;
            *)
                [[ "${1}" = *[!0-9]* ]] && echo -e "\033[34m${1} is not a NUMBER!\033[0m" && return 2
                vms_main $(sed -n "${1},${1}p" "${his_file}")
                return 0
                ;;
        esac
    done
}

his(){
    history "$@"
}

vms_main(){
    echo "$@" >> "${his_file}"
    cmd="$@"
    if [ "#" == "${cmd:0:1}" ]; then
        cmd="${cmd:1}"
        ${cmd}
    elif [ ":" == "${cmd:0:1}" ]; then
        cmd="${cmd:1}"
        : "${cmd}"
    else
        do_vms "${cmd}"
    fi
}

:(){
    cat -n "${his_file}" | grep "$*"
}

!!(){
    history $[$(wc -l < log/vms.history)-1]
}

do_vms() {
    eval set -- "${cmd}"
    vms_cmd="${1}"
    [[ "${vms_cmd}" = "do_vms" ]] && echo -e "\033[31mBad Command!\033[0m" && return -1
    [[ "${vms_cmd}" = "exit" ]] && history -w && unset -f exit && exit
    if [ "$(type -t "${vms_cmd}")" = "function" ]; then
        shift
        ${vms_cmd} "$@"
    else
        echo -e "\033[34m${1}: Command Not Found!\033[0m"
    fi
}
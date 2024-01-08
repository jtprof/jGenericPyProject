#!/bin/bash

export CWHITE="\033[0m"
export CRED="\033[31;6m"
export CGREEN="\033[32;6m"
export CYEL="\033[33;6m"
export CBLUE="\033[34;6m"
export CMAG="\033[35;6m"
export CTURQ="\033[36;6m"

function rpath {
    which realpath 2>&1 >/dev/null
    if [[ ${?} -ne 0 ]] ; then
        OURPWD=$PWD
        cd "$(dirname "$1")"
        LINK=$(readlink "$(basename "$1")")
        while [ "$LINK" ]; do
            cd "$(dirname "$LINK")"
            LINK=$(readlink "$(basename "${LINK}")")
        done
        REALPATH="$PWD/$(basename "$1")"
        cd "$OURPWD"
        echo "$REALPATH"
    else
        echo $(realpath $1)
    fi
}

function echo_red {
   echo -e "${CRED}${1}${CWHITE}"
}
function echo_green {
   echo -e "${CGREEN}${1}${CWHITE}"
}
function echo_yellow {
   echo -e "${CYEL}${1}${CWHITE}"
}
function echo_blue {
   echo -e "${CBLUE}${1}${CWHITE}"
}
function echo_magenta {
   echo -e "${CMAG}${1}${CWHITE}"
}
function echo_turquoise {
   echo -e "${CTURQ}${1}${CWHITE}"
}

function log {
    [[ -n ${verbose} && $1 ]] && echo_magenta "$(date +%H:%M:%S) ${1}"
}

function exit_w_error {
    echo_red "${1}"
    [[ -z ${2} ]] && exit 19 || exit ${2}
}

function just_do_it {
    local CMD=$1
    local msg="eval ${CMD}"
    [[ -n ${2} ]] && err_msg=${2}
    [[ -n ${3} ]] && continue_on_err="y"

    if [[ ${dry_run} == "y" ]] ; then
        echo_yellow "${dry_msg}"
        echo_yellow "${msg}"
    else
        [[ -n ${verbose} ]] && echo_magenta "${msg}"
        eval "${CMD}"
        local rc=${?}
        local err_msg="\"${CMD}\" finished with error ${rc}. ${err_msg}"
        if [[ ${rc} -ne 0 ]] ; then 
          [[ -z ${continue_on_err} ]] && exit_w_error "${err_msg}" || echo_red "${err_msg}"
        fi
    fi
}

function usage {
  [[ -n ${1} ]] && echo_red "${1}"
  echo "Common project initialize and deploy script."
  echo_green "Usage:"
  echo -e "\t$0 -p /tools/common/apps/python/3.9.2/bin/python3 -r repo_FQDN"
  echo_green "\nParameters:"
  echo -e "\t-p\t- path to folder which the project will be located in. Optional. ${CYEL}${PRJ_FLD}${CWHITE} for now."
  echo -e "\t-l\t- programming language which the project will be written on. Awailible options: ${CYEL}${AWAIL_LNGS}${CWHITE} . Optional. ${CYEL}${PRJ_LNG}${CWHITE} for now."
  echo -e "\t-f\t- force init. Optional. ${CYEL}${IS_FORCE}${CWHITE} for now."
  echo -e "\t-d\t- init with devcontainer. Optional. ${CYEL}${IS_DOCKER}${CWHITE} for now."
  echo -e "\t-e\t- init with pyenv. Optional. ${CYEL}${IS_PYENV}${CWHITE} for now."
  echo -e "\t-p\t- path to python3 executeble file. Optional. ${CYEL}${py3_path}${CWHITE} for now."
  echo -e "\t-g\t- path to GO executeble file. Optional. ${CYEL}${go_path}${CWHITE} for now."
  echo -e "\t-r\t- FQDN to new repo. Mutually exclusive with ${CTURQ}-s${CWHITE} key."
  echo -e "\t-s\t- standalone. Don't remove remote git server. Mutually exclusive with ${CTURQ}-r${CWHITE} key. ${CYEL}${standalone}${CWHITE} for now."
  echo -e "\t-t\t- FQDN to Python virtual environment init scripts. Optional."
  echo -e "\t-b\t- Root branch name to init git. \"main\" by default. Optional. Ignored with ${CTURQ}-s${CWHITE} key."
  exit 3
}

AWAIL_LNGS="PYTHON3 GO"
project_template_name="jGenericProject"

FULL_SCRIP_PATH=$(rpath $0)
FULL_EXE_FOLDER=$(dirname $FULL_SCRIP_PATH)

while getopts f:l:p:g:r:st:b:mvhdef flag
do
    case "${flag}" in
        p) PRJ_FLD=${OPTARG};;
        l) PRJ_LNG=${OPTARG};;
        f) IS_FORCE="yes";;
        d) IS_DOCKER="yes";;
        e) IS_PYENV="yes";;
        p) py3_path=${OPTARG};;
        g) go_path=${OPTARG};;
        r) remote_git=${OPTARG};;
        s) standalone="yes";;
        t) VENV_GIT=${OPTARG};;
        b) NEW_BRANCH_NAME=${OPTARG};;
        v) verbose="yes";;
        h) show_help="yes";;
    esac
done

[[ -z ${PRJ_FLD} ]] && PRJ_FLD="$(pwd)"
[[ -z ${PRJ_LNG} ]] && PRJ_LNG="PYTHON3"
[[ ${PRJ_LNG} != "PYTHON3" &&  ${PRJ_LNG} != "GO" ]] && usage "Please set valid programming language"

[[ -z ${py3_path} ]] && py3_path=$(which python3)

# [[ $(git remote -v | grep "${project_template_name}") ]] || DEV_MODE="yes"

[[ -z "${remote_git}" && ${standalone} != "yes" ]] && usage "Please choose remote git mode"
[[ -n "${remote_git}" && ${standalone} == "yes" ]] && usage "Please choose remote git mode"

[[ -z ${VENV_GIT} ]] && VENV_GIT="git@gitlab01.anpa.corp.amazon.com:public-projects/venv-init-script.git"
[[ -z ${VENV_FLD} ]] && VENV_FLD="${PRJ_FLD}/vis"

[[ -z ${NEW_BRANCH_NAME} ]] && NEW_BRANCH_NAME="main"

if [[ -d ${VENV_FLD} ]] ; then
    pushd ${VENV_FLD}
    CMD="git pull"
    just_do_it "${CMD}"
    ${VENV_FLD}/init.sh ${verbose} --py3 ${py3_path} --rebuild
else
    CMD="git clone ${VENV_GIT} ${VENV_FLD}"
    just_do_it "${CMD}"
    ${VENV_FLD}/init.sh ${verbose} --py3 ${py3_path} 
fi

pushd ${PRJ_FLD}
[[ -d ./.git && ${IS_FORCE} == "yes" ]] && rm -fR ./.git || usage "${PRJ_FLD}/.git already exists. Please use -f flag to overiide"

[[ ${standalone} == "y" ]] && exit 0 

log "Reinit repo"

just_do_it "git init"
just_do_it "git remote add origin ${remote_git}"
just_do_it "git add ."

log "Initial commit"
just_do_it "git commit -am \"Initial commit\""

log "Push to repo"
just_do_it  "git remote -v"

just_do_it "git push --set-upstream origin ${NEW_BRANCH_NAME} --force" 

popd

#!/bin/bash

function def_par_undefined {
  echo "Error while getting mandatory param $1 "
  exit 3
}

function def_par_value_error {
  echo "Wrong value of mandatory param $1 "
  exit 19
}

FULL_SCRIP_PATH=$(realpath $0)
FULL_EXE_FOLDER=$(dirname $FULL_SCRIP_PATH)

[[ -z ${T_LOCATION} ]] && def_par_undefined "T_LOCATION"
[[ $(hostname -s) != "${T_INSTANCE}" ]] && def_par_value_error "T_INSTANCE" 

if [ -d ${T_LOCATION} ] ; then
  cd ${T_LOCATION}
  git pull
  git checkout ${CI_COMMIT_BRANCH}
else
   git clone -b ${CI_COMMIT_BRANCH} ${CI_REPOSITORY_URL} ${T_LOCATION} 
fi

[[ -f "${T_LOCATION}/.init.sh" ]] && "${T_LOCATION}/.init.sh" 

if [[ -f "${T_LOCATION}/service/.services" ]] ; then
  s_list=($(cat "${T_LOCATION}/service/.services"))
  for (( I=0; I<"${#s_list[@]}"; I+=1 )); do 
    systemctl stop ${s_list[$I]} ;
  done
  for (( I="${#s_list[@]}"-1; I>=0; I-=1 )); do
    systemctl start ${s_list[$I]} ;
  done
fi
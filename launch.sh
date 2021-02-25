#!/bin/bash

FULL_SCRIP_PATH=$(realpath $0)
FULL_EXE_FOLDER=$(dirname $FULL_SCRIP_PATH)

act_pyenv="${FULL_EXE_FOLDER}/bin/activate"

args=(${@}); a0=${args[0]}; args=("${args[@]/$a0}")

[[ -z ${a0} ]] && l_app="main.py" || l_app="${a0}"

if [[ -f ${act_pyenv} ]] ; then 
    VIRTUAL_ENV_DISABLE_PROMPT=1
    source ${act_pyenv}
else
    echo "PyEnv configuration hasn't been found"
    exit 19
fi

PTHN=$(realpath $(which python3))
LD_LIBRARY_PATH="$(dirname ${PTHN})/../lib":${LD_LIBRARY_PATH}

${PTHN} ${FULL_EXE_FOLDER}/${l_app} ${args[@]}


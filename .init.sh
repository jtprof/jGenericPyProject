#!/bin/bash

[[ -z ${BASH_SOURCE[0]} ]] && FULL_SCRIP_PATH=$(realpath $0) || FULL_SCRIP_PATH=$(realpath ${BASH_SOURCE[0]})
FULL_EXE_FOLDER=$(dirname $FULL_SCRIP_PATH)
export VIRTUAL_ENV_DISABLE_PROMPT=1

[[ -z ${1} ]] && py3='/tools/common/apps/python/3.9.2/bin/python3' || py3=${1}

echo ${py3}

${py3} -m venv ${FULL_EXE_FOLDER}
source "${FULL_EXE_FOLDER}/bin/activate"

python3 -m pip install -r "${FULL_EXE_FOLDER}/requirements.txt"

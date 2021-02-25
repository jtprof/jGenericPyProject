#!/bin/bash

function usage {
  echo "Usage: "
  echo "$0 --service-name='SERVICE_NAME'"
  echo "Example: "
  echo "$0 --version=jMonitor "
  exit 3
}

FULL_SCRIP_PATH=$(realpath $0)
FULL_EXE_FOLDER=$(dirname $FULL_SCRIP_PATH)

SERVICE_FOLDER="/usr/lib/systemd/system/"

for i in "$@"
do
case $i in
    --service-name=*)
    SERVICE_NAME="${i#*=}"
    shift # past argument=value
    ;;
    --source-folder=*)
    SOURCE_FOLDER="${i#*=}"
    shift # past argument=value
    ;;
    -h)
     usage;
    shift # past argument with no value
    ;;
    *)
     echo "Wrong option $i" ; usage     # unknown option
    ;;
esac
done


[[ -z "${SERVICE_NAME}" ]] && usage 
[[ -z "${SOURCE_FOLDER}" ]] && SOURCE_FOLDER=${FULL_EXE_FOLDER}

systemctl status ${SERVICE_NAME}.service
if [[ ${?} -eq 0 ]] ; then
  systemctl stop ${SERVICE_NAME}.service
  systemctl disable ${SERVICE_NAME}.service
fi

[[ -d "${SERVICE_FOLDER}/${SERVICE_NAME}.service" ]] && rm -f "${SERVICE_FOLDER}/${SERVICE_NAME}.service"
cp "${FULL_EXE_FOLDER}/${SERVICE_NAME}.service" "${SERVICE_FOLDER}/${SERVICE_NAME}.service"

systemctl status ${SERVICE_NAME}.timer
if [[ ${?} -eq 0 ]] ; then
  systemctl stop ${SERVICE_NAME}.timer
  systemctl disable ${SERVICE_NAME}.timer
fi

[[ -d "${SERVICE_FOLDER}/${SERVICE_NAME}.timer" ]] && rm -f "${SERVICE_FOLDER}/${SERVICE_NAME}.timer"
cp "${FULL_EXE_FOLDER}/${SERVICE_NAME}.timer" "${SERVICE_FOLDER}/${SERVICE_NAME}.timer"

systemctl daemon-reload

systemctl enable --now ${SERVICE_NAME}.timer

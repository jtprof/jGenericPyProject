#!/bin/bash

function usage {
  echo "Usage: "
  echo "$0 --remote_git=repo_FQDN "
  echo "Example: "
  echo "$0 --remote_git=https://gitlab01.anpa.corp.amazon.com/DevOps/annapurna-python-template.git "
  exit 
}

for i in "$@"
do
case $i in
    --remote_git=*)
    remote_git="${i#*=}"
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

[[ -z "${remote_git}" ]] && usage

FULL_SCRIP_PATH=$(realpath $0)
FULL_EXE_FOLDER=$(dirname $FULL_SCRIP_PATH)

#for remote in $(git remote -v | awk '{print $1}' | uniq); do git remote remove ${remote}; done
pushd ${FULL_EXE_FOLDER}
rm -fR ./.git
git init 
git remote add origin ${remote_git}
git pull origin master
git add .


echo "Initial commit"
git commit -am "Initial commit"

echo "Push to repo"
git remote -v

git push --set-upstream origin master 

popd

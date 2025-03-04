#!/bin/sh

set -e

TAG=$1
DIR=rust
URL=https://github.com/esp-rs/rust.git

if [ ! -d ${DIR}/.git ]; then
    git clone --recursive ${URL} ${DIR}
fi

cd ${DIR}
git checkout --force ${TAG} >/dev/null
git submodule update --init --recursive
MODULE_NAMES=`git config --file .gitmodules --name-only --get-regexp path | sed -e 's|^submodule\.||' -e 's|\.path$||' | sort`
MODULE_TUPLES=""

for MODULE_NAME in ${MODULE_NAMES}; do
    MODULE_PATH=`git config --file .gitmodules --get submodule.${MODULE_NAME}.path`
    MODULE_ORG=`git config --file .gitmodules --get submodule.${MODULE_NAME}.url | sed -e 's|https://github.com/||' -e 's|.git$||' | cut -d '/' -f 1`
    MODULE_PROJECT=`git config --file .gitmodules --get submodule.${MODULE_NAME}.url | sed -e 's|https://github.com/||' -e 's|.git$||' | cut -d '/' -f 2`
    MODULE_SHA=`git submodule status ${MODULE_PATH} | cut -c 2-8`
    MODULE_GROUP=`echo ${MODULE_ORG}_${MODULE_PROJECT} | sed -e 's|-|_|g'`
    MODULE_TUPLE="${MODULE_ORG}:${MODULE_PROJECT}:${MODULE_SHA}:${MODULE_GROUP}/${MODULE_PATH}"
    MODULE_TUPLES="${MODULE_TUPLES} ${MODULE_TUPLE}"
done
cd -

GH_TUPLE_STRING="GH_TUPLE+= "
for MODULE_TUPLE in ${MODULE_TUPLES}; do
    GH_TUPLE_STRING="${GH_TUPLE_STRING} ${MODULE_TUPLE}"
done
echo ${GH_TUPLE_STRING} | sed -e 's| | \\\n\t|g'

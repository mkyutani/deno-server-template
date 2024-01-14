#!/usr/bin/env bash

#
# command line arguments
# if no arguments, target as "production"
#
targets=("production" "dev" "clean")
if [ "$1" == "" -o "$1" == "--help" ]; then
    echo "usage: init.sh [--help] {`echo ${targets[@]}|sed 's/ /|/g'`}" >>/dev/stderr
    exit 1
else
    ARG1_LOWER=`echo $1|tr A-Z a-z`
    if printf "%s\n" "${targets[@]}" | grep -qx "$ARG1_LOWER"; then
        TARGET="$ARG1_LOWER"
    else
        echo "Invalid target $1." >>/dev/stderr
        exit 1
    fi
fi

#
# environment variables
#
USER=$(id -un)
GROUP=$(id -gn)
ENV_FILE=.env
VOLUMES=volumes

#
# clean
#

if [ "$TARGET" == "clean" ]; then
    if [ -e ${ENV_FILE} ]; then
        rm -f ${ENV_FILE}
        echo ${ENV_FILE} removed.
    fi
    if [ -e ${VOLUMES} ]; then
        rm -fr ${VOLUMES}
        echo ${VOLUMES} removed.
    fi
    exit 1
fi

#
# .env
#
echo -n "Preparing ${ENV_FILE} ..."

CREATED=1
if [ -e ${ENV_FILE} ]; then
    rm -f ${ENV_FILE}
    CREATED=2
fi

touch ${ENV_FILE}
echo "LOGS=/logs" >>${ENV_FILE}

echo "SW2_SERVER=localhost" >>${ENV_FILE}
echo "SW2_PORT=18085" >>${ENV_FILE}

echo "AGENT_EX_PORT=18087" >>${ENV_FILE}
echo "AGENT_PORT=8089" >>${ENV_FILE}

echo "TARGET=${TARGET}" >>${ENV_FILE}

cp -f ./${ENV_FILE} agent/${ENV_FILE}

if [ ${CREATED} = 1 ]; then
    echo " created."
else
    echo " overwritten."
fi

#
# volume directories
#

create_directory() {
    local dir=$1
    local mode=$2
    local user=$3
    local group=$4
    if [ ! -e "${dir}" ]; then
        mkdir "${dir}" -m "${mode}"
        chown "${user}:${group}" "${dir}"
        echo -n " ${dir}/"
        CREATED=1
    fi
}

echo -n "Creating site directories ..."
CREATED=0
create_directory "${VOLUMES}" 775 ${USER} ${GROUP}
create_directory "${VOLUMES}/deno-dir.${TARGET}" 775 1993 1993
if [ ${CREATED} = 1 ]; then
    echo " created."
else
    echo " already exist."
fi

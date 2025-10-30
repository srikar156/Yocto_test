#!/usr/bin/env bash

# Exit script on failure
set -x

eval $(ssh-agent -s)

# Set the args
KASFILE="none"
PRIV_KEY_SIGNING="none"
BITBUCKET_REPO_SLUG="none"
BITBUCKET_BUILD_NUMBER="0"

# Allow to build on BitBucket pipeline by setting up a local user and assinging a local directory - change ownership of files already created:
NEW_USER=skrladmin

for i in "$@"; do
    case $i in
        -f=*|--kasfile=*)
            KASFILE="${i#*=}".yaml
            shift # past argument=value
            ;;

        -k=*|--priv-key=*)
            PRIV_KEY_SIGNING="${i#*=}"
            shift # past argument=value
            ;;

        -b=*|--repo-slug=*)
            BITBUCKET_REPO_SLUG="${i#*=}"
            shift # past argument=value
            ;;

        -n=*|--build-number=*)
            BITBUCKET_BUILD_NUMBER="${i#*=}"
            shift # past argument=value
            ;;

        -u=*|--user=*)
            NEW_USER="${i#*=}"
            shift # past argument=value
            ;;

        -*|--*)
            echo "Unknown option $i"
            exit 1
            ;;
        *)
            ;;
    esac
done

# Sanity Checks
if [ ${KASFILE} == "none" ]; then
    echo "No kas file specified."
    exit 1
else
    echo "KAS file: ${KASFILE}"
fi

if [ ${PRIV_KEY_SIGNING} == "none" ]; then
    echo "Private signing key not specified."
    exit 1
else
    echo "Private Key supplied OK"
fi

if [ ${BITBUCKET_REPO_SLUG} == "none" ]; then
    echo "Warning: Bitbucket Repo slug not specified."
fi

if [ ${BITBUCKET_BUILD_NUMBER} == "0" ]; then
    echo "Warning: Bitbucket build number not specified."
fi

if [ ${BUILD_SDK} -eq 1 ]; then
    echo "SDK being built"
else
    echo "SDK Not being built"
fi

export REPO_DIR=$(git rev-parse --show-toplevel 2>/dev/null || realpath -m "${SCRIPT_DIR}/..")
echo ${REPO_DIR}

# Get Kas from repo if it does not exist
if [ ! -d ${REPO_DIR}/../kas ]; then
    git clone https://github.com/siemens/kas.git ${REPO_DIR}/../kas
fi
KAS_CONFIG_FILES="${REPO_DIR}/${KASFILE}"

# Add the user if it does not exist
if [ ! -d /home/${NEW_USER} ]; then
    id -u ${NEW_USER} &>/dev/null || sudo adduser --quiet --disabled-password --shell /bin/bash --home /home/${NEW_USER} --gecos "User" ${NEW_USER}
fi
export KAS_ALLOW_ROOT=yes

sudo chown "${NEW_USER}" "${REPO_DIR}"
sudo chmod +wrx "${REPO_DIR}"

if [ ! -d "$REPO_DIR"/build ]; then
    sudo mkdir -p "$REPO_DIR"/build
    sudo chown "${NEW_USER}" "$REPO_DIR"/build
    sudo chown -R "${NEW_USER}" "$REPO_DIR"/*
    sudo chmod +wrx "$REPO_DIR"/build
fi

# Get the number of CPU cores
NR_CORES=$(nproc)
sudo chmod +x ${REPO_DIR}/../kas/run-kas
sudo -u ${NEW_USER} BB_NUMBER_THREADS=${NR_CORES} ${REPO_DIR}/../kas/run-kas build || exit $?

echo "Now create the file for the downloads directory:"

cd "${REPO_DIR}"

ZIP_FILE_NAME=output.tar.gz
# just tar the pipelines file for now as an example
tar chzf $ZIP_FILE_NAME bitbucket-pipelines.yml

if [ $? -ne 0 ]
then
    echo "Zip of deploy files was unsuccessful"
fi

# Need to split the zip as BitBucket pipeline has a restriction "files: The file must be less than 1000 MB."
split --bytes=500M "${ZIP_FILE_NAME}" "${REPO_DIR}/build/smv_${BITBUCKET_BUILD_NUMBER}"_

# due to file size upload restrictions, split the file into 500MB chunks
if [ $? -ne 0 ]
then
    echo "Couldn't split zip file"
fi

sudo chown -R "${NEW_USER}" "$REPO_DIR"/build/sm*

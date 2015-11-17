#!/bin/bash
set -e

#This script is to be run on any machine that you intend to run The Warrior Wiki MySQL image on.

#Parse command-line arguments
while [[ $# > 1 ]]
do
key="$1"
case $key in
    -b|--backup)
    BACKUP_FILE="$2"
    shift # past argument
    ;;
    -h|--help)
    echo "$0 [(-b|--backup) backup_file.dmp]"
    exit 0
    shift
    ;;
    *)
        # unknown option
    ;;
esac
shift # past argument or value
done

#Make sure the required variables are set.
for env_var in "PRIVATE_DIR" "DATABASE_DIR" "DATABASE_NAME"
do
    name="${env_var}"
    if [ -z "${!name}" ]; then
        echo "${env_var} not set. Will not continue." 1>&2
        exit 1;
    fi
done

#Create the secret key for MySQL
mkdir -p ${PRIVATE_DIR}
chmod 400 ${PRIVATE_DIR}

if [ ! -e "${MYSQL_PASS_FILE}" ]; then
    touch ${MYSQL_PASS_FILE}
    chmod 400 ${MYSQL_PASS_FILE}
    dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64 -w 0 | rev | cut -b 2- | rev > ${MYSQL_PASS_FILE}
else
    echo "${MYSQL_PASS_FILE} already exists. We will not overwrite it."
fi

#Restore a backup of an existing MySQL DB
if [ -n "${BACKUP_FILE}" ]; then
    MYSQL_PREVIOUS_BACKUP=$1
    MYSQL_PREVIOUS_BACKUP_DIR=`dirname $MYSQL_PREVIOUS_BACKUP`
    MYSQL_PREVIOUS_BACKUP_FILE=`basename $MYSQL_PREVIOUS_BACKUP`
    echo "Restoring the backup MySQL DB from '${MYSQL_PREVIOUS_BACKUP}' to '${DATABASE_DIR}'"
    docker run -d --name mysql_restore -v ${DATABASE_DIR}:/var/lib/mysql -v ${MYSQL_PREVIOUS_BACKUP_DIR}:/bak -e MYSQL_ROOT_PASSWORD=`cat ${MYSQL_PASS_FILE}` -e MYSQL_DATABASE=${DATABASE_NAME} -d mysql

    docker exec -i -t mysql_restore bash -c "mysql -u root --password=`cat ${MYSQL_PASS_FILE}` ${DATABASE_NAME} < /bak/${MYSQL_PREVIOUS_BACKUP_FILE}"
    docker stop mysql_restore && docker rm mysql_restore
fi
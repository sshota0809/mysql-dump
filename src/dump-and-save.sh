#!/bin/bash -u

############################################################
# Vars
############################################################
# Set by ENVIRONMENT VARIABLES
## PROJECT_ID
## BUCKET_NAME
## MYSQL_DB_NAME
## MYSQL_DB_IP
## MYSQL_DB_USER
## MYSQL_DB_PASSWORD
# Set by arguments
## OTHER MYSQL Options
### For examples, --dabases

############################################################
# Functions
############################################################
function logger() {
  now=`date '+%Y/%m/%d %H:%M:%S'`
  echo -e "[ ${now} ] ${1}:${2}"
}

function abort() {
  logger $1 $2
  exit 1
}

function do_mysqldump() {
  mysqldump -h ${MYSQL_DB_IP} -u ${MYSQL_DB_USER} -p${MYSQL_DB_PASSWORD} $@ > ${BUCKUP_FILE_NAME} || abort "ERROR" "mysqldump"
}

function do_save_to_gcs() {
  gsutil cp ${BUCKUP_FILE_NAME} gs://${BUCKET_NAME}/mysqldump/${MYSQL_DB_NAME}/${BUCKUP_FILE_NAME} || abort "ERROR" "saveGCS"
}

############################################################
# main
############################################################

echo "========================================="
echo "== [ ${MYSQL_DB_NAME} ] BACKUP START =="
echo "========================================="

BUCKUP_FILE_NAME=mysql-${MYSQL_DB_NAME}-`date '+%Y-%m-%d-%H-%M-%S'`.dump

do_mysqldump $@
do_save_to_gcs

echo "========================================="
echo "== [ ${MYSQL_DB_NAME} ] SHELL FINISH =="
echo "========================================="

exit 0
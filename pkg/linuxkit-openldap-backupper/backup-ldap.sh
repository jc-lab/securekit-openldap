#!/bin/bash

. ~/.profile

PRIV_KEY_FILE=$HOME/.ssh/id_rsa
FILENAME_SUFFIX=`date "+%Y-%m-%d_%H-%M-%S"`.ldif
TEMP_DIR=$(mktemp -d)

function do_backup() {
    set -eu
    
    if [ "x${DISABLE_ENCRYPTED_BACKUP:-no}" = "xyes" ]; then
        slapcat -F /opt/bitnami/openldap/etc/slapd.d -n 0 -l ${TEMP_DIR}/conf-${FILENAME_SUFFIX}
        slapcat -F /opt/bitnami/openldap/etc/slapd.d -n 2 -l ${TEMP_DIR}/data-${FILENAME_SUFFIX}
    else
        slapcat -F /opt/bitnami/openldap/etc/slapd.d -n 0 | gpg2 --recipient-file /backup_protector_key.public.asc --output ${TEMP_DIR}/conf-${FILENAME_SUFFIX}.pgp --encrypt
        slapcat -F /opt/bitnami/openldap/etc/slapd.d -n 2 | gpg2 --recipient-file /backup_protector_key.public.asc --output ${TEMP_DIR}/data-${FILENAME_SUFFIX}.pgp --encrypt
    fi
    
    scp -o StrictHostKeyChecking=accept-new -i "${PRIV_KEY_FILE}" ${SSH_OPTIONS:-} ${TEMP_DIR}/* "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH}"
}

echo "START BACKUP: $(date)"

(do_backup)
rc=$?

rm -rf ${TEMP_DIR}

[ $rc -eq 0 ] && echo "BACKUP SUCCESS" || echo "BACKUP FAILED: $rc"

exit $rc


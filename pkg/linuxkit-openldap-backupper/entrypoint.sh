#!/bin/bash

SSH_PUBLIC_KEY_DIR=${SSH_PUBLIC_KEY_DIR:-$HOME/public_key}

USER_HOME=/home/user

function getBackupSchedule() {
    [ -e "${BACKUP_SCHEDULE_FROM_FILE:-}" ] && cat ${BACKUP_SCHEDULE_FROM_FILE} && return 0
    echo "${BACKUP_SCHEDULE:-0 0 * * *}"
    return 0
}

[ -e /etc/cron.d/ldap-backup ] || echo "$(getBackupSchedule) root su user -c '/opt/backup-ldap.sh' > /proc/1/fd/1 2>&1" >> /etc/cron.d/ldap-backup

if [ ! -e "${USER_HOME}/.ssh/id_rsa" ]; then
    echo "generate key..."
    mkdir -p ${USER_HOME}/.ssh/ ${SSH_PUBLIC_KEY_DIR}
    ssh-keygen -t rsa -f ${USER_HOME}/.ssh/id_rsa -q -N ""
    cp ${USER_HOME}/.ssh/id_rsa.pub ${SSH_PUBLIC_KEY_DIR}
    chown user -R ${USER_HOME}/.ssh
    echo "key generated: $(cat ${USER_HOME}/.ssh/id_rsa.pub)"
fi

cat >> ${USER_HOME}/.profile <<EOF

export REMOTE_USER="${REMOTE_USER}"
export REMOTE_HOST="${REMOTE_HOST}"
export REMOTE_PATH="${REMOTE_PATH}"
export SSH_OPTIONS="${SSH_OPTIONS}"

EOF

exec "$@"


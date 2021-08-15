#!/bin/bash

SSH_PUBLIC_KEY_DIR=${SSH_PUBLIC_KEY_DIR:-$HOME/public_key}

USER_HOME=/home/user

[ -e /etc/cron.d/ldap-backup ] || echo "${BACKUP_SCHEDULE} root su user -c '/opt/backup-ldap.sh' > /proc/1/fd/1 2>&1" >> /etc/cron.d/ldap-backup

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


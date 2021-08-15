#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

# Load libraries
. /opt/bitnami/scripts/liblog.sh

function kinfo() {
     >&2 echo "$*"
}

if [[ "$*" = "/opt/bitnami/scripts/openldap/run.sh" ]]; then
    if [ "x${LDAP_TLS_KEY_GENERATE:-}" = "xyes" ]; then
        CSR_ROOT=/bitnami/openldap/tls-csr
        LDAP_TLS_KEY_GENERATE_ALGORITHM=${LDAP_TLS_KEY_GENERATE_ALGORITHM:-rsa:3072}
        export LDAP_TLS_CERT_FILE="${LDAP_TLS_CERT_FILE:-${CSR_ROOT}/cert.pem}"
        export LDAP_TLS_KEY_FILE="${LDAP_TLS_KEY_FILE:-/bitnami/openldap/certs/openldap.key}"
        mkdir -p "$(dirname ${LDAP_TLS_KEY_FILE})"
        LDAP_TLS_CSR_FILE="${CSR_ROOT}/csr.pem"
        if [ ! -e "${LDAP_TLS_CERT_FILE}" ]; then
            kinfo "could not find certificate file from ${LDAP_TLS_CERT_FILE}"
            if [ ! -e "${LDAP_TLS_KEY_FILE}" ]; then
              kinfo "generate csr into ${LDAP_TLS_CSR_FILE}"
              openssl req -new -newkey "${LDAP_TLS_KEY_GENERATE_ALGORITHM}" -nodes -keyout "${LDAP_TLS_KEY_FILE}" -out "${LDAP_TLS_CSR_FILE}" -config /opt/bitnami/scripts/openldap/tls-csr.cfg
            fi
            until [ -r ${LDAP_TLS_CERT_FILE} ]; do
                kinfo "$(cat /proc/uptime | cut -d' ' -f1): waiting for certificate to be generated: ${LDAP_TLS_CERT_FILE}"
                i=0
                while [[ ! -r ${LDAP_TLS_CERT_FILE} ]] && [[ $i -lt 10 ]]; do
                    sleep 1
                    i=$((i+1))
                done
            done
        fi
    fi
    info "** Starting LDAP setup **"
    /opt/bitnami/scripts/openldap/setup.sh
    info "** LDAP setup finished! **"
fi

echo ""
exec "$@"

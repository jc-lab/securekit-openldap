#!/bin/bash

set -e

linuxkit pkg build -network -org jclab pkg/linuxkit-bitnami-openldap
linuxkit pkg build -network -org jclab pkg/linuxkit-openldap-backupper
sed -e "s|<OPENLDAP_IMAGE>|$(linuxkit pkg show-tag -org jclab pkg/linuxkit-bitnami-openldap)|g;s|<LDAP_BACKUPPER_IMAGE>|$(linuxkit pkg show-tag -org jclab pkg/linuxkit-openldap-backupper)|g" openldap.yml.in > openldap.yml
securekit-build.sh openldap

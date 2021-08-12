#!/bin/bash

linuxkit pkg build -network -org jclab pkg/linuxkit-bitnami-openldap
sed -e "s|<OPENLDAP_IMAGE>|$(linuxkit pkg show-tag -org jclab pkg/linuxkit-bitnami-openldap)|g" openldap.yml.in > openldap.yml
securekit-build.sh openldap

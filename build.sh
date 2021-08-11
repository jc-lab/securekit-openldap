#!/bin/bash

linuxkit pkg build --hash-path . -network -org jclab pkg/linuxkit-bitnami-openldap
securekit-build.sh openldap

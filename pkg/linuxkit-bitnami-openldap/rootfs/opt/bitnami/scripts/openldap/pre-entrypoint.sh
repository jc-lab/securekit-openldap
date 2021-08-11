#!/bin/bash

id

chown 1001:1001 /bitnami/openldap/

su - openldap "$@"

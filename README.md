# securekit-openldap

This is an openldap server based on [bitnami-docker-openldap](https://github.com/bitnami/bitnami-docker-openldap) by [securekit](https://github.com/jc-lab/securekit).

# Quick Start

1. Modify openldap.yml.in according to your environment.
2. Run `./build.sh`
3. Run the generated iso on your machine.
4. If necessary, download the CSR through SFTP, generate a TLS certificate, and upload the certificate to SFTP.
5. After accessing with SSH, create a tunnel and change the initial administrator password.
```bash
# Terminal 1
$ ssh -i your_private_key -L 127.0.0.1:11389:127.0.0.1:1389 manager@192.168.44.200

# Terminal 2
$ ldapmodify -x -H ldap://127.0.0.1:11389/ -D "cn=admin,dc=example,dc=org" -W ...
```

# License

Apache License 2.0


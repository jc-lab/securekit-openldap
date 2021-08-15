FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc1 libltdl7 liblz4-1 libnss3-tools libsasl2-2 libsnappy1v5 libssl1.1 libstdc++6 libwiredtiger0 libwrap0 libzstd1 lsof mdbtools procps tar zlib1g openssh-client gnupg2 cron
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "openldap" "2.5.6-0" --checksum ccc25afb954bea540beca000c8ff8115fd4dd50a2ce8ae3fa91d13012925cde2
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="openldap" \
    BITNAMI_IMAGE_VERSION="2.5.6-debian-10-r17" \
    PATH="/opt/bitnami/openldap/bin:/opt/bitnami/openldap/sbin:/opt/bitnami/common/bin:$PATH"

RUN useradd -m -u 1001 -g 0 -s /bin/bash user && \
    echo 'export PATH=/opt/bitnami/openldap/bin:/opt/bitnami/openldap/sbin:/opt/bitnami/common/bin:$PATH' >> /home/user/.profile

COPY ["backup-ldap.sh", "entrypoint.sh", "/opt/"]
RUN chmod +x /opt/*.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]
CMD [ "/usr/sbin/cron", "-f" ]


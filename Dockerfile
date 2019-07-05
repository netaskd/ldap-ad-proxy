FROM alpine:edge

RUN apk add --no-cache curl vim git bash gettext openssl

# we have to build openldap backend meta with option "SLAPD_META_CLIENT_PR 1" in file back-meta.h
# for enabling client-pr ins slapd.conf. This feature allows to use RFC 2696 Paged Results control for AD
COPY apks /tmp/apks
RUN cd /tmp/apks \
	&& apk add --allow-untrusted \
	./openldap-back-meta-2.4.47-r2.apk \
	./openldap-back-mdb-2.4.47-r2.apk \
	./openldap-back-ldap-2.4.47-r2.apk \
	./openldap-clients-2.4.47-r2.apk \
	./openldap-2.4.47-r2.apk

RUN mkdir /var/run/openldap \
        && chown -R ldap:ldap /var/run/openldap \
        && echo "TLS_REQCERT     allow" >>/etc/openldap/ldap.conf

ADD schema /opt/docker/schema
ADD run.sh /
ADD slapd.conf /tmp/

WORKDIR /etc/openldap
CMD /run.sh
ADD env.example Dockerfile /


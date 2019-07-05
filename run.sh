#!/bin/ash

# Set debug loglevel as default
[[ -z "${LOG_LEVEL}" ]] && export LOG_LEVEL=7

# Set default suffix as basedn
[[ -z "${META_SUFFIX}" ]] && export META_SUFFIX=${AD_BASEDN}

# make config from env
envsubst < /tmp/slapd.conf > slapd.conf

# test config and run openldap
mkdir -p slapd.test \
&& slaptest -d7 -f slapd.conf -F slapd.test -u \
&& rm -rf slapd.d \
&& mv slapd.test slapd.d \
&& chown -R ldap.ldap slapd.d \
&& slapd -h 'ldap:/// ldaps:///' -u ldap -d ${LOG_LEVEL}

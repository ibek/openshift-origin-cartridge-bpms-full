#!/bin/bash
export JAVA_OPTS="-Djboss.management.client_socket_bind_address=$OPENSHIFT_BPMS_IP"

# JA Bride:  use jboss_bpm_soa
#/usr/share/jbossas/bin/jboss-cli.sh "$@"
/opt/jboss_bpm_soa/jboss-eap-6.1/bin/jboss-cli.sh "$@"

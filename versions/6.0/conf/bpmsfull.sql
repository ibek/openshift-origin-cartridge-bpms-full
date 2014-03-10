create database if not exists jbpm;
grant all on jbpm.* to 'jbpm'@'${env.OPENSHIFT_BPMS_IP}' identified by '${env.OPENSHIFT_MYSQL_DB_USERNAME}';

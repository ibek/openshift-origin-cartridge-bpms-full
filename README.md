bpmPaaS Cartridge using BPMS6
==============================

Overview
--------
* Provides an Openshift Enterprise (OSE) cartridge with full suite of Red Hat BPMS6 functionality.  
* A view of the deployment architecture of a gear using this cartridge can be found [here.](https://raw.github.com/jboss-gpe-ose/openshift-origin-cartridge-bpms-full/master/doc/images/bpmPaaS-standalone-deployment-architecture.png)
* NOTE: this cartridge differs from the series of OSE *base* and *add-on* BPMS 6 cartridges.
  Those cartridges allow for more flexible bpmPaaS deployment architectures as per [this diagram.](https://raw.github.com/jbride/openshift-origin-cartridge-bpms-base/master/doc/bpmPaaS_Overview/images/bpms6-deployment-architecture-openshift.png)
* This cartridge is essentially a fork of the OSE jbosseap cartridge.
  Subsequently, most of administration guidelines documented in the jbosseap cartridge apply to this cartridge.
* As of 20 Jan. 2014, the version of BPMS 6 used is :  jboss-bpms-6.0.0.GA-redhat-1-deployable-eap6.


Details
-------
* This cartridge relies on RPMs.  In particular:

1. [an RPM](https://github.com/jboss-gpe-ose/jboss_bpm_soa_rpmbuild) that pre-installs JBoss EAP 6.1.1 on an Openshift Enterprise _node_.  NOTE:  This cartridge does not rely on the JBoss EAP available through the jbappplatform channel of the Red Hat Network.  The release cycle of JBoss EAP from that channel is not in sync with releases of BPMS.  ie:  to-date, the version of EAP available from the jbappplatform channel is 6.2.  BPMS6 has a hard-requirement on EAP 6.1.1 specifically.
2. [an RPM](https://github.com/jboss-gpe-ose/bpms_rpmbuild)  that pre-installs BPMS6 modules and web artifacts on an Openshift Enterprise _node_.


The size of EAP 6.1.1 + BPMS6  makes bundling of all of this within this downloadable cartridge impratical.  Because of the use of custom RPMs, this cartridge will only work on those Openshift Enterprise environments that have installed these custom RPMs.  Subsequently, this cartridge will not currently work on Openshift Online.  The medium term strategy is that these RPMs would eventually be added to a yet to be created BPMS _channel_ on the Red Hat Network.

* MySql
** An embedded H2 database comes default with BPMS6.
** This BPMS6 cartridge will use that default embedded H2 database unless it detects that a MySQL cartridge has been added to the Openshift application.
** In particular, MySQL is used to maintain both JBPM engine and Business Activity Monitoring tables.
** MySQL was selected because in a 'scaled' openshift app, a single mysql database instance could be shared across bpms6 run-time instances.
** Ultimately what's envisioned is a 'BPMS Process Engine' cartridge that would allow for scalable small-gear bpms6 process engine apps that share a single mysql database.
** A "BPMS Process Engine" cartridge has not been completed yet.  

* version
** This cartridge adheres to the OSE 1.2 cartridge specification.

* footprint
** An Openshift app provisioned with this cartridge will have about a 600+MB heap footprint.
** Thus, at a minimum, a medium-sized Openshift Gear is required.
** It has been demonstrated however that a customized BPMS environment that only includes the process engine (ie:  no business-central or dashbuilder) has a runtime heap footprint of about 350MB.  This "BPM Process Engine" app fits comfortably in an Openshift small gear.
** A "BPMS Process Engine" cartridge has not been completed yet.  

  

INITIAL SETUP          
--------------------
1.  Create an OSE 1.2 environment that supports a medium gear size
2.  Install OSE 1.2 rhc tools
3.  Review the jboss_bpm_soa RPM found [here](https://github.com/jboss-gpe-ose/jboss_bpm_soa_rpmbuild)
4.  On your OSE nodes, install the jboss_bpm_soa RPM    
5.  Review the bpms RPM found [here](https://github.com/jboss-gpe-ose/bpms_rpmbuild)
7.  On your OSE nodes, install the bpms RPM    
8.  Delete any previous bpms6 related OSE applications that you may have previously created:
      rhc app delete -a bpms
9.0 understand your districts. options:
    1)  medium
    2)  int_dev_medium (ITOS)
    3)  ext_general_medium (ITOS)
    
9.1 Create the *full* BPMS6 *full* OSE application :
      rhc create-app bpms https://raw.github.com/jboss-gpe-ose/openshift-origin-cartridge-bpms-full/master/metadata/manifest.yml -g medium
10. Add mysql cartridge:
      rhc cartridge add -a bpms -c mysql-5.1
11. execute:   rhc cartridge-restart bpms -a bpms
    - after several minutes, should expect to see the following as the last line in $HOME/bpms/standalone/log/server.log :

            [org.jboss.as.server] (DeploymentScanner-threads - 1) JBAS018559: Deployed "dashbuilder.war" (runtime-name : "dashbuilder.war")


TEST
--------------------
    
    
TODO
----
1)  Upgrade to OSE cartridge specification 2.0
2)  MySQL cartridge should be an automatic child dependency such that steps 10 and 11 are eliminated.

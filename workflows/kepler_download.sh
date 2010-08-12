#!/bin/bash
KEPLER_VERSION=2.0
ANT_VERSION=1.8.1

KEPLER_HOME=$PWD/kepler
ANT_HOME=$PWD

#ANT DOWNLOAD
[ ! -f ${ANT_HOME}/apache-ant-${ANT_VERSION}-bin.zip ] && wget http://mir2.ovh.net/ftp.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.zip

#ANT INSTALL
[ ! -d ${ANT_HOME}/apache-ant-${ANT_VERSION} ] && unzip apache-ant-${ANT_VERSION}-bin.zip

#Kepler DOWNLOAD
mkdir $KEPLER_HOME

cd $KEPLER_HOME
[ ! -d ${KEPLER_HOME}/build-area ] && svn co https://code.kepler-project.org/code/kepler/trunk/modules/build-area
cd build-area

#KEPLER INSTALL

$ANT_HOME/apache-ant-${ANT_VERSION}/bin/ant  change-to -Dsuite=kepler-${KEPLER_VERSION}




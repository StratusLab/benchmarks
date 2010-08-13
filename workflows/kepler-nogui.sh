#!/bin/bash

KEPLER_BUILDXML=${PWD}/kepler

if [ -z $1 ]
then
  echo "Usage ./kepler-nogui.sh $PATH/myWorkflow.xml"
  exit
else
  ant -buildfile ${KEPLER_BUILDXML}/build.xml run-workflow-no-gui -Dworkflow=$1
fi

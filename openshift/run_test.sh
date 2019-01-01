#!/bin/bash

#Script aims to
# 1) create JMeter clusters
# 2) run performance test and copy test results back 
# 3) TODO: remove JMeter clusters 

if [ $# -lt 3 ]; then
    echo "Please input parameters are not enough, please check them"
    exit 1
fi

WORKSPACE=$1
BUILD_NUMBER=$2
TEST_SCRIPT=$3

# create JMeter clusters
cd $WORKSPACE/openshift && sh jmeter_cluster_create.sh

# create workspace
PERFCI_WORKING_DIR="perf-output/builds/$BUILD_NUMBER/rawdata"
mkdir -p "$WORKSPACE/$PERFCI_WORKING_DIR"

cd $WORKSPACE/openshift 
test_script_path="$WORKSPACE/$TEST_SCRIPT"
test_script_dir="$(dirname $test_script_path)"

# run test and copy test results back to Jenkins slave.
sh start_test.sh "$TEST_SCRIPT" "$test_script_dir"
cp /tmp/test_result.jtl $WORKSPACE/$PERFCI_WORKING_DIR/

# TODO: remove JMeter clusters

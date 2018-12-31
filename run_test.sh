#!/bin/bash

if [ $# -lt 3 ]; then
    echo "Please input parameters are not enough, please check them"
    exit 1
fi

WORKSPACE=$1
BUILD_NUMBER=$2
TEST_SCRIPT=$3

#source ~/.bashrc
oc login https://paas.upshift.redhat.com --token=00T3lcRsUq906MUNeRY1nsDuMf4eBxbGXUZtqS5uXLo

cd $WORKSPACE/openshift && sh jmeter_cluster_create.sh

# create workspace
PERFCI_WORKING_DIR="perf-output/builds/$BUILD_NUMBER/rawdata"
mkdir -p "$WORKSPACE/$PERFCI_WORKING_DIR"

cd $WORKSPACE/openshift 
test_script_path="$WORKSPACE/$TEST_SCRIPT"
test_script_dir="$(dirname $test_script_path)"

sh start_test.sh "$TEST_SCRIPT" "$test_script_dir"
cp /tmp/test_result.jtl $WORKSPACE/$PERFCI_WORKING_DIR/

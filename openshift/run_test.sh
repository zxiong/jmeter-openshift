#!/bin/bash

if [ $# -lt 3 ]; then
    echo "Input parameters are not enough, please check them"
    exit 1
fi

WORKSPACE=$1
BUILD_NUMBER=$2
TEST_SCRIPT=$3
EXTRA_PARAM=""
SLAVES_NUM="2"

if [ $# -eq 4 ]; then
    EXTRA_PARAM=$4
fi

if [ $# -eq 5 ]; then
    SLAVES_NUM=$5 
fi

echo $*

#Gnerate a identifier as fileter
filter=`echo $[$(date +%s%N)/1000000]`
cd $WORKSPACE/openshift && sh jmeter_cluster_create.sh "$filter" $SLAVES_NUM 

# create workspace
PERFCI_WORKING_DIR="perf-output/builds/$BUILD_NUMBER/rawdata"
mkdir -p "$WORKSPACE/$PERFCI_WORKING_DIR"

cd $WORKSPACE/openshift 
test_script_path="$WORKSPACE/$TEST_SCRIPT"
test_script_dir="$(dirname $test_script_path)"

sh start_test.sh "$TEST_SCRIPT" "$test_script_dir" "$filter" "$EXTRA_PARAM"
cp /tmp/test_result_$filter.jtl $WORKSPACE/$PERFCI_WORKING_DIR/

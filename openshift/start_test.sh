#!/usr/bin/env bash
#Script created to launch Jmeter tests directly from the current terminal without accessing the jmeter master pod.
#It requires that you supply the path to the jmx file
#After execution, test script jmx file may be deleted from the pod itself but not locally.

if [ $# -lt 3 ]; then
    echo "Input parameters are not enough, please check them"
    exit 1
fi

jmeter_script=$1
jmeter_script_dir=$2
#jmeter_script_dir="$(dirname $jmeter_script)"
filter=$3

echo "$1,$2,$3"

working_dir=`pwd`

master_pod=`oc get pod  | grep "jmeter-master-$filter" | awk '{print $1}'`
slave_pods=`oc get pod  | grep "jmeter-slaves-$filter" | awk '{print $1}'`

echo $master_pod
echo $slave_pods

# Copy performance test scripts with relevant data into JMeter clusters
oc rsync $jmeter_script_dir $master_pod:/jmeter/
for slave_pod in $slave_pods; do
    oc rsync $jmeter_script_dir $slave_pod:/jmeter/
done

## Echo Starting Jmeter load test
oc exec -ti $master_pod -- /bin/bash /jmeter/load_test $jmeter_script

#copy result out
oc rsync $master_pod:/tmp/test_result_$filter.jtl /tmp/

#clean all jmeter pods
oc delete all -l jmeter_mode=slaves-$filter
oc delete all -l jmeter_mode=master-$filter
oc delete configmap jmeter-load-test-$filter

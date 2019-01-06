#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Input parameters are not enough, please check them"
    exit 1
fi

awk -F, -v num="$2" 'r="";{for(i=1;i<=NF;i++){if(i==(NF-3)&&NR!=1)r=r","$(NF-3)*num;else{r=r","$i}};print substr(r,2)}' $1

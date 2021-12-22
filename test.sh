#!/bin/bash

run_stage_command() {
    local stage_prefix=$1
    eval 'local vars=${!'"$stage_prefix"'@}'
    echo "evaluating env variable with prefix ${stage_prefix}, commands:${vars} ..."
    for i in $vars; do
        echo "ececuting command ${!i} ..."
        eval ${!i}
    done
}


aaa_1="date"
aaa_2="whoami"
aaa_3="uname -a"

run_stage_command "aaa"
#!/bin/bash
mergerfs_use_beta=${MERGERFS_USE_BETA:-false}
rclone_use_beta=${RCLONE_USE_BETA:-false}

print_usage() {
    echo "usage: build.sh [--mergerfs_beta] [--rclone_beta] [--beta]"
}



[[ $# == 0 ]] && print_usage

while test $# -gt 0
do
    case "$1" in
        --mergerfs_beta|mergerfs_beta) mergerfs_use_beta=true
            ;;
        --rclone_beta|rclone_beta) rclone_use_beta=true
            ;;
        --beta|beta) 
            mergerfs_use_beta=true
            rclone_use_beta=true
            ;;
        *) 
            echo "unknown argument $1, aborting..."
            print_usage
            exit 1
            ;;
    esac
    shift
done

echo "mergerfs_use_beta:$mergerfs_use_beta, rclone_use_beta:${rclone_use_beta}"


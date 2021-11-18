#!/bin/bash

# MERGERFS_USE_BETA=false
# RCLONE_USE_BETA=false


build_date=${build_date:-$(date +"%Y%m%dT%H%M%S")}
mergerfs_use_beta=${MERGERFS_USE_BETA:-false}
rclone_use_beta=${RCLONE_USE_BETA:-false}
rclone_version=""
mergerfs_version=""

print_usage() {
    echo "usage: update.sh [--mergerfs_beta] [--rclone_beta] [--beta]"
}

get_mergerfs_version() {
    mergerfs_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/trapexit/mergerfs/commits/master" | jq -r .sha)
    [[ -z ${mergerfs_version} ]] && exit 1
    old_mergerfs_version=$(jq -r '.version' < MERGERFS_VERSION.json)
    changelog=$(jq -r '.changelog' < MERGERFS_VERSION.json)
    [[ "${old_mergerfs_version}" != "${mergerfs_version}" ]] && changelog="https://github.com/trapexit/mergerfs/compare/${old_mergerfs_version}...${mergerfs_version}"
    echo '{"version":"'"${mergerfs_version}"'","changelog":"'"${changelog}"'"}' | jq . > MERGERFS_VERSION.json
}

get_rclone_version() {
    if [[ $rclone_use_beta == "true" ]]]; then
        rclone_version=$(curl -fsS https://beta.rclone.org/version.txt)
    else
        rclone_version=$(curl -fsS https://downloads.rclone.org/version.txt)
    fi
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


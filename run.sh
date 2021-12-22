docker build -t rclone_mounter:nightly .
docker run --rm -ti -p 5572:5572/tcp  \
    --privileged --security-opt apparmor:unconfined \
    --device /dev/fuse:/dev/fuse \
    --cap-add SYS_ADMIN --device /dev/fuse \
    --entrypoint bash \
    -e PGID=$GID -e PUID=$UID \
    -v ~/.config/rclone:/config/rclone  \
    rclone_mounter:nightly

docker build -t rclone_mergerfs_mounter:nightly . &&\
    docker image tag rclone_mergerfs_mounter:nightly hereisderek/rclone_mergerfs_mounter:nightly&& \
    docker push hereisderek/rclone_mergerfs_mounter:nightly

# docker run --rm -ti --entrypoint bash rclone/rclone:beta

# exit 0


# docker build -t rclone_mergerfs_mounter:latest . && docker run --rm -ti -p 5572:5572/tcp \
#     --privileged --security-opt apparmor:unconfined --cap-add SYS_ADMIN --device /dev/fuse \
#     --network bridge -e RCLONE_EXTRA_PARAMS="-vv" \
#     -e RCLONE_RC_AUTH="--rc-user=admin --rc-pass=admin" -e RCLONE_REMOTE="share_02" \
#     -v `pwd`/config:/config -v `pwd`/cache:/cache -v mount:/mnt -e PGID=$GID -e PUID=$UID \
#     rclone_mergerfs_mounter:latest


#     --entrypoint sh rclone_mergerfs_mounter:latest

RCLONE_REMOTE=share_01 RCLONE_CONFIG_DIR=`pwd`/.config/rclone  RCLONE_CONFIG_FILE_NAME="rclone.conf" RCLONE_EXCLUDE_FILE_NAME="exclude.txt" \
    RC_WEB_GUI=false RC_SERVE=false RC_ENABLE_METRICS=false RC_ADDR=":5572" RC_EXTRA= OVERRIDE_RC_PARAMS= \
    RC_AUTH="--rc-no-auth" \
    LOCAL_CACHE_TYPE="union" \
    MERGERFS_MOUNT_OPTIONS="rw,use_ino,cache.files=partial,dropcacheonclose=true,allow_other,func.getattr=newest,category.action=all,category.create=ff,cache.files=auto-full,nonempty" \
    _docker_cache="/tmp/rclone" _docker_mount_root="/Volumes/shared/Workspace/Volumes/rclone" \
    root/etc/services.d/rclone_mounter/run



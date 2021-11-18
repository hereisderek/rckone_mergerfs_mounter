docker build -t rclone_mergerfs_mounter:latest .
docker run --rm -ti --expose 5572 -v ./config:/config 
    --privileged --security-opt apparmor:unconfined --cap-add SYS_ADMIN --device /dev/fuse 
    rclone_mergerfs_mounter:latest


exit 0


docker build -t rclone_mergerfs_mounter:latest . && docker run --rm -ti -p 5572:5572/tcp \
    --privileged --security-opt apparmor:unconfined --cap-add SYS_ADMIN --device /dev/fuse \
    --network bridge -e RCLONE_EXTRA_PARAMS="-vv" \
    -e RCLONE_RC_AUTH="--rc-user=admin --rc-pass=admin" -e RCLONE_REMOTE="share_02" \
    -v `pwd`/config:/config -v `pwd`/cache:/cache -v mount:/mnt -e PGID=$GID -e PUID=$UID \
    rclone_mergerfs_mounter:latest


    --entrypoint sh rclone_mergerfs_mounter:latest
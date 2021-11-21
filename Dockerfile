FROM rclone/rclone:beta as rclone
FROM hotio/mergerfs:nightly as mergerfs
FROM alpine

LABEL maintainer="Derek <1and1get2@gmail.com>"

COPY --from=rclone /usr/local/bin/rclone  /usr/local/bin/rclone
COPY --from=mergerfs /usr/local/bin/mergerfs /usr/local/bin/mergerfs
COPY --from=mergerfs /usr/local/bin/mergerfs-fusermount /usr/local/bin/mergerfs-fusermount
COPY --from=mergerfs /sbin/mount.mergerfs /sbin/mount.mergerfs

ADD root /

RUN apk add --no-cache --update ca-certificates fuse fuse-dev libattr libstdc++ unzip curl bash tzdata

ADD https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-amd64-installer /tmp/
RUN chmod a+x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer /

EXPOSE 5572 7879
ENTRYPOINT ["/init"]

ENV PGID=0 PUID=0 UMASK=0 RCLONE_REMOTE= RCLONE_REMOTE_PATH=  \
    RCLONE_CONFIG_DIR="/config/rclone" RCLONE_CONFIG_FILE_NAME="rclone.conf" RCLONE_EXCLUDE_FILE_NAME="exclude.txt" \
    RC_WEB_GUI=false RC_SERVE=false RC_ENABLE_METRICS=false RC_ADDR=":5572" RC_EXTRA= OVERRIDE_RC_PARAMS= \
    RC_USER=admin RC_PASS=admin RC_AUTH= \
    RCLONE_GLOBAL_PARAMS_EXTRA= OVERRIDE_RCLONE_GLOBAL_PARAMS= \
    RCLONE_MOUNT_PARAMS_EXTRA= OVERRIDE_RCLONE_MOUNT_PARAMS= \
    RCLONE_VFS_PARAMS_EXTRA= OVERRIDE_RCLONE_VFS_PARAMS= \
    RCLONE_MOUNT_NAME= MERGERFS_MOUNT_NAME= MERGERFS_MOUNT_OPTIONS="rw,use_ino,cache.files=partial,dropcacheonclose=true,allow_other,func.getattr=newest,category.action=all,category.create=ff,cache.files=auto-full" \
    MERGERFS_MOUNT_RCLONE_PATH= OVERRIDE_MERGERFS_COMMAND_PARAMTERS=

VOLUME [ "/cache", "/storage", "/config/rclone", "/mnt" ]
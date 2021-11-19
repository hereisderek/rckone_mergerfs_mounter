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

EXPOSE 5572
ENTRYPOINT ["/init"]

ENV PGID= PUID= \
    PARAMS_COMMON_EXTRA= \
    XDG_CONFIG_HOME=/config \
    RCLONE_CONFIG_FILE_NAME="rclone.conf" USE_RCD=false \
    RCLONE_REMOTE= RCLONE_REMOTE_PATH=/ \
    RCLONE_MOUNT_NAME=rclone MERGERFS_MOUNT_NAME=merged \
    RC_USER= RC_PASS= RCLONE_IP_PORT=:5572 RC_SERVE=false RC_ENABLE_METRICS=false RC_WEB_GUI=true RC_WEB_GUI_UPDATE=true \
    RCLONE_RC_OPTION_SET_JSON='{"main":{"BufferSize":16777216},"vfs":{"CacheMode":3,"Umask":0,"CacheMaxAge":21600000000000,"ReadAhead":67108864,"NoModTime":true,"NoChecksum":true,"WriteBack":300000000000,"CaseInsensitive":true},"mount":{"AllowNonEmpty":false,"AllowOther":true,"AsyncRead":true,"WritebackCache":true,"MaxReadAhead":524288}}' \
    MERGERFS_MOUNT_RCLONE_PATH= \
    MERGERFS_MOUNT_OPTIONS="rw,use_ino,cache.files=partial,dropcacheonclose=true,allow_other,func.getattr=newest,category.action=all,category.create=ff,cache.files=auto-full"

VOLUME [ "/cache", "/storage", "/config/rclone", "/mnt" ]
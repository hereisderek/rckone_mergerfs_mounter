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
    RCLONE_DEFAULT_PARAMS="--rc-web-gui --rc-addr=:5572 --rc-serve --rc-web-gui-no-open-browser --use-mmap --fast-list --track-renames --tpslimit-burst 3 --track-renames-strategy modtime,leaf --transfers 8 --rc-web-gui-update --cache-dir /cache --cache-db-purge --drive-stop-on-upload-limit " \
    RCLONE_EXTRA_PARAMS= \
    RCLONE_RC_AUTH= \
    XDG_CONFIG_HOME=/config \
    RCLONE_CONFIG_FILE_NAME="rclone.conf" \
    RCLONE_REMOTE= \
    RCLONE_RC_OPTION_SET_JSON='{"main":{"DisableHTTP2":true,"BufferSize":16777216},"vfs":{"CacheMode":3,"Umask":0,"CacheMaxAge":21600000000000,"ReadAhead":67108864,"NoModTime":true,"NoChecksum":true,"WriteBack":300000000000,"CaseInsensitive":true},"mount":{"AllowNonEmpty":false,"AllowOther":true,"AsyncRead":true,"WritebackCache":true,"MaxReadAhead":524288}}'

ENV MERGERFS_MOUNT_OPTIONS="rw,use_ino,allow_other,func.getattr=newest,category.action=all,category.create=ff,cache.files=auto-full"

VOLUME [ "/cache", "/config", "/mnt", "/storage" ]
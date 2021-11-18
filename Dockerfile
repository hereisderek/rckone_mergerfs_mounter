FROM alpine as builder

LABEL build_version="Version:- RClone:${RCLONE_VER} Mergerfs:${MERGERFS_VER} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Derek <1and1get2@gmail.com>"

# MERGERFS_VER=c06db9c3a04effca67f2ed88fdaabc65a4da1d05
# MERGERFS_VER=nightly  

ARG RCLONE_VER=1.57.0 \
    BUILD_DATE=20200617T131603 \
    BASE_OS=linux ARCH=amd64 

ENV MERGERFS_VER=${MERGERFS_VER}

WORKDIR /tmp


RUN apk add --no-cache fuse libattr libstdc++ autoconf automake libtool gettext-dev attr-dev linux-headers make build-base git unzip curl 

RUN if [[ "$RCLONE_VER" = "beta" ]]; then \
        curl "https://beta.rclone.org/rclone-beta-latest-${BASE_OS}-${ARCH}.zip" -o rclone.zip; \
    elif [[ "$RCLONE_VER" = "latest" ]]; then \
        curl "https://downloads.rclone.org/rclone-current-${BASE_OS}-${ARCH}.zip" -o rclone.zip; \
    else \
        curl "https://downloads.rclone.org/v${RCLONE_VER}/rclone-v${RCLONE_VER}-${BASE_OS}-${ARCH}.zip" -o rclone.zip; \
    fi; unzip rclone.zip && cd rclone-*-linux-${ARCH} && cp rclone /usr/bin && chmod a+x /usr/bin/rclone
    

# install mergerfs
# RUN git clone  -–depth=1 -n https://github.com/trapexit/mergerfs.git /mergerfs && cd /mergerfs && \
#     git checkout ${MERGERFS_VER} && \
#     make STATIC=1 LTO=1 && make install

FROM hotio/mergerfs:nightly as mergerfs_builder


FROM alpine

# RUN apk add --no-cache --update ca-certificates fuse fuse-dev unzip curl libattr libstdc++ 
RUN apk add --no-cache --update ca-certificates fuse fuse-dev unzip curl


ADD https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

COPY --from=builder /usr/bin/rclone  /usr/bin/rclone
COPY --from=mergerfs_builder /usr/local/bin/mergerfs /usr/local/bin/mergerfs
COPY --from=mergerfs_builder /usr/local/bin/mergerfs-fusermount /usr/local/bin/mergerfs-fusermount
COPY --from=mergerfs_builder /sbin/mount.mergerfs /sbin/mount.mergerfs

ADD root /
EXPOSE 5572
ENTRYPOINT ["/init"]
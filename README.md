# rclone_mergerfs_mounter
-----
mount your rclone drive and back it with a local cache via mergerfs. 
(and you can periodically upload your changes)

mergerfs paramters used by default is 
```
MERGERFS_MOUNT_OPTIONS="rw,use_ino,cache.files=partial,dropcacheonclose=true,allow_other,func.getattr=newest,category.action=all,category.create=ff,cache.files=auto-full"
``` 
which can be overwriten by the docker env variable: `MERGERFS_MOUNT_OPTIONS`

for rclone mount options check out this [run](root/etc/services.d/rclone_mounter/run) file

checkout the sample [docker-compose.yml](docker-compose.yml) file.

### Note:
In most cases you will need some or all of the following flags added to your command to get the required docker privileges when using a mergerfs mount. 
`--security-opt apparmor:unconfined --cap-add SYS_ADMIN --device /dev/fuse`


### Sidenote

to refresh rclone content:

`rclone rc $RCLONE_RC_AUTH vfs/refresh recursive=true --rc-addr 127.0.0.1:5572 _async=true`



`rclone rc cache/expire remote=relative/path/to/item`
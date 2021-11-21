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

## Environments:
check out the [dockerfile](Dockerfile), the [run](root/etc/services.d/rclone_mounter/run) script and the sample [docker-compose.yml](docker-compose.yml) file.
| variable | default | required | explaination |
| --- | --- | :---: | --- |
| PGID,PUID,UMASK | 0,0,0 |  | mount permission |
| RCLONE_REMOTE | | √ | remote in the config file|
|RCLONE_REMOTE_PATH|||mount path under the remote, which is the path in `remote:path`|
|RCLONE_CONFIG_DIR|`/config/rclone`|||
|RCLONE_CONFIG_FILE_NAME|`rclone.conf`|||
|RCLONE_EXCLUDE_FILE_NAME|`exclude.txt`|||
|RC_WEB_GUI|false||[--rc-web-gui](https://rclone.org/rc/#rc-web-gui)|
|RC_SERVE|false||[--rc-serve](https://rclone.org/rc/#rc-serve)|
|RC_ENABLE_METRICS|false||[--rc-enable-metrics](https://rclone.org/rc/#rc-enable-metrics)|
|RC_ADDR|`:5572`||`--rc_addr`|
|RC_USER|admin||`--rc-user=admin`|
|RC_PASS|admin||`--rc-pass=admin`|
|RC_AUTH|||for custom authentification, this will invalid `RC_USER` and `RC_PASS`|
|RCLONE_GLOBAL_PARAMS_EXTRA|||extra global parameters|
|OVERRIDE_RCLONE_GLOBAL_PARAMS|||replace all default global parameters|
|RCLONE_MOUNT_PARAMS_EXTRA|||similiar to above|
|OVERRIDE_RCLONE_MOUNT_PARAMS|||similiar to above|
|RCLONE_VFS_PARAMS_EXTRA|||similiar to above|
|OVERRIDE_RCLONE_VFS_PARAMS|||similiar to above|
|RCLONE_MOUNT_NAME|||mount point for rclone, if it's relative then will become `/mnt/$RCLONE_MOUNT_NAME`, if empty then will set to `$RCLONE_REMOTE`|
|MERGERFS_MOUNT_NAME|||same as above but for mergerfs,if left empty then will set to `${RCLONE_MOUNT_NAME}_merged`|
|MERGERFS_MOUNT_OPTIONS|see above||mergerfs default mount options|
|MERGERFS_MOUNT_RCLONE_PATH|||relative path of rclone mount that becomes the root of the mergerfs|
|OVERRIDE_MERGERFS_COMMAND_PARAMTERS|||totally override the parameters for mergerfs, allows for custom/multiple mount parents|


## Mount points (--volume bind)
| docker path | required | explaination |
| --- |:---: | --- |
|`/cache`||local rclone cache|
|`/storage`||local mergerfs mount|
|`/config/rclone`||rclone config folder, in which both `rclone.conf` and `exclude.txt` will be searched|
|`/mnt`||default mount parent for rclone and mergerfs|
## Note:
In most cases you will need some or all of the following flags added to your command to get the required docker privileges when using a mergerfs mount. 
`--security-opt apparmor:unconfined --cap-add SYS_ADMIN --device /dev/fuse`


## Sidenote
to refresh rclone content:

`rclone rc $RCLONE_RC_AUTH vfs/refresh recursive=true --rc-addr 127.0.0.1:5572 _async=true`

`rclone rc cache/expire remote=relative/path/to/item`



Extra docker privileges¶
In most cases you will need some or all of the following flags added to your command to get the required docker privileges when using a mergerfs mount.

`--security-opt apparmor:unconfined --cap-add SYS_ADMIN --device /dev/fuse`


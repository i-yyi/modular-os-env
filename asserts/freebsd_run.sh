pkg install sysutils/fusefs-ext2

kldload fuse.ko
fuse-ext2 /dev/ada1 /share
cd /boot/kernel
mv kernel kernel.old
cp /share/kernel.full ./kernel
reboot
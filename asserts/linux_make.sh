#!/bin/bash
mkdir -p /root/linux_env
ARCH=x86
make x86_64_defconfig
make menuconfig
bear -- make -j32
mv ./arch/x86/boot/bzImage /root/linux_env/
# Finish build Linux src

cd /root/tools/busybox-1.36.1
make menuconfig

dd if=/dev/zero of=/root/linux_env/rootfs.img bs=1M count=10
mkfs.ext4 /root/linux_env/rootfs.img

mkdir fs
mount -t ext4 -o loop /root/linux_env/rootfs.img ./fs
make install CONFIG_PREFIX=./fs

cd fs
mkdir proc dev etc home mnt
cp -r ../examples/bootfloppy/etc/* etc/
chmod -R 777 ./
# Finish Prepare img

qemu-system-x86_64 -kernel /root/linux_env/bzImage -hda /root/linux_env/rootfs.img \
-append "root=/dev/sda console=ttyS0" -nographic

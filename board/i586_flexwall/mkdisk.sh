#!/bin/sh

destdir=$1
configfile=$2
disk=$destdir/flexwall.disk

logfile=/tmp/$$.log

log()
{
   echo $1
}

err()
{
   log "ERR: $1"
   cat $logfile
   exit 0
}

# Refs
# https://www.adayinthelifeof.nl/2011/10/11/creating-partitioned-virtual-disk-images/
sudo ls -l $destdir/rootfs.squashfs &> $logfile || err "Unable to list [$destdir/rootfs.squashfs]"

dd if=/dev/zero of=$disk bs=1024 count=70000 &> $logfile || err "dd of empty disk"
echo -e "o\nn\np\n1\n\n+60M\nn\np\n\n\n\nt\n2\nc\nw" | fdisk $disk &> $logfile || err "fdisk"

sudo losetup -d /dev/loop1 &> /dev/null
sudo losetup -o 1048576 --sizelimit 63962624 /dev/loop1 $disk &> $logfile || err "lo mount of rootfs partition"
sudo dd if=$destdir/rootfs.squashfs of=/dev/loop1 &> $logfile || err "dd of rootfs"
sudo losetup -d /dev/loop1 &> $logfile || err "lo detach of rootfs partition"

sudo losetup -o 63963136 --sizelimit 71679488 /dev/loop1 $disk &> $logfile || err "lo mount of fat partition"
sudo mkfs.vfat -F 32 -n flex_cfg /dev/loop1 &> $logfile || err "mkfs.vfat"
if [ ! -z $configfile ]; then
echo "+++++++ Placing Configuration File ++++++++++++"
	sudo mount /dev/loop1 /mnt &> $logfile || err "mount of vfat partition"
	sudo cp $configfile /mnt/flexwall.txt &> $logfile || err "copy over of cfg"
	sudo umount /mnt &> $logfile || err "umount of vfat partition"
fi
sudo losetup -d /dev/loop1 &> $logfile || err "lo detach of fat partition"
echo "+++++++ Partition Configuration +++++++++++++++"
fdisk -l $disk
echo "+++++++ Resulting rootfs blob +++++++++++++++++"
ls -l $disk
rm $logfile -f
echo "+++++++ Finished ++++++++++++++++++++++++++++++"

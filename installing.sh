#!/bin/bash

trap " echo 'if you sure crtl+Z; pkill -9 installing.sh' " SIGINT
source yn.sh


disk=""

while yn "Your want formating your disk?";do
	fdisk -l
	read -p "Select your a disk: " disk
	fdisk $disk

	while yn "You want select some for formating?";do
	#	fdisk -l | less
		whereis mkfs
		read -ep "Select your mkfs[ext4]: " -i "ext4" mk
		fdisk -l
		echo "sda -> sata ; hda -> ata(pata) ; sdb -> flash; sr0 scd0 cdrom-> cd-rom ..."
		read -ep "Select your disk[/dev/sda]: " -i "/dev/sda" dsk
		mkfs.$mk $dsk
	done;
done;

error(){
	exec 1>&2
	echo $1
	if [ $# \> 2 ];then
		exit $2
	fi;
	exit 1
}

read -ep "Write your mount mount of disk[/mnt/gentoo]: " -i "/mnt/gentoo" mountpoint
if ! [ -d $mountpoint ];then
	if [ -e $mountpoint ];then
		echo "Iss busy device, please select other device"
		exit 1
	fi;
	mkdir $mountpoint || error "Cannot create dir"
fi;

LINK_DIST="http://distfiles.gentoo.org/releases/"

read -ep "Disk which need mount to point[/dev/sda1]" -i "/dev/sda1" disk
mount $disk $mountpoint || error "Cannot mount $disk to $mountpoint"

while ! mv stage3-*tar.xz $mountpoint;
do
	echo "please download stage-3(amd64/autobuilds/.../stage3-...tar.xz) archive 5s and links will run"
	sleep 5s
	links $LINK_DIST
done;
lastdir=`pwd`

cd $mountpoint;tar -xpvf stage3-*tar.xz
mkdir $mountpoint/proc || error "Cannot create folder for proc"
mount -t proc none $mountpoint || error "Cannot mount proc"
mount -o bind /dev $mountpoint/dev || error "Cannot mount dev"
mount -o bind /sys $mountpoint/sys || error "Cannot mount sys"
echo "mounted dev, sys, proc"
echo "chrooting"
####
cp $lastdir/"*part.sh" $mountpoint/ || error "Cannot copy Npart.sh"
cp /etc/resolv.conf $mountpoint/etc/
chroot $mountpoint /bin/bash
echo "Run 2part for help with emerge"

###
##


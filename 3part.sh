#!/bin/bash
. yn.sh

if yn "use gentoo install instead vanilla?";then
		emerge --ask gentoo-sources
else
                emerge --ask vanilla-sources
fi;

if yn "install grub";then
	emerge grub
fi;

if yn "Install os-prober?";then
	emerge --ask os-prober
fi

while ! yn "Your boot directory is worked?";
do

done;

if yn "use genkernel instead manual install";then
	zcat /proc/config.gz > /usr/share/genkernel/arch/`uname -m`/kernel-config
	emerge genkernel
	genkernel all
else
	cd /usr/src/linux*
	while yn "run menuconfig";
	do
		make menuconfig
	done;
	make
	make modules_install && make install
fi;

grub_disk=""
while [ 1 == 1 ];
do
	read -p "Write your disk where installed gentoo(for grub)" grub_disk
	grub-install $grub_disk && break
done;
echo "Edit your fstab";sleep 1s
nano /etc/fstab
read -ep "Select grub.cfg dir" -i "/boot/" boot_dir
grub-mkconfig -o $boot_dir/grub.cfg
echo "Config of grub created"
echo "run 4part.sh for install display manager"

#!/bin/bash

MANAGERS="cdm(console dm \
 gdm(gnome dm) lightdm lxdm qingy sddm(simply display manager) slim wdm xdm"

select_manager(){
	echo $MANAGERS
	read -ep "Manager: " -i "slim" manager
	case "$manager" in
	"cdm")
		emerge --ask --deep --newuse x11-misc/cdm;;
	"gdm")
		emerge --ask --deep --newuse gnome-base/gdm;;
	"lightdm")
		emerge --ask --deep --newuse x11-misc/lightdm;;
	"lxdm")
		emerge --ask --deep --newuse lxde-base/lxdm;;
	"slim")
		emerge --ask --deep --newuse slim;;
	"sddm")
		emerge --ask --deep --newuse sddm;;
	"wdm")
		emerge --newuse --deep --ask x11-misc/wdm;;
	"xdm")
		emerge --ask xdm;;
	*)
		return 1
		;;
esac

}

while ! select_manager;
do
	etc-update
	env-update
done;
echo "select your xdm"
nano /etc/conf.d/xdm
rc-update add /etc/init.d/xdm boot
/etc/init.d/xdm restart


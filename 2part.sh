#!/bin/bash
. yn.sh
arch="none"
profiles=/usr/portage/profiles
if yn "select profile?";then
while ! ls $profiles/arch/$arch 2>/dev/null 1>/dev/null;
do
	ls $proiles/arch/
	read -p "Select your architecture " arch
done;
ln -sf $profiles/arch/$arch /etc/portage/make.profile
echo "Profile was selected"
fi;
if yn "copy default make conf?";then
cp /usr/share/portage/config/make.conf.example /etc/portage/make.conf
fi;
if yn "edit your make config?";then
	echo "Edit your make conf; for uses: less /usr/portage/profiles/use.desc ";sleep 2s;
	nano /etc/portage/make.conf
fi;

if yn "sync emerge";then
if yn "use webrsync?";then
	emerge-webrsync
else
	emerge --sync
fi;
fi;

bash /usr/portage/scripts/bootstrap.sh
emerge --deep --update --newuse @world
echo "run 3part.sh for kernel"

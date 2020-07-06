#!/bin/bash
#  File: <name>
#  Author: J. F. Mitre <http://jfmitre.com>
#  Created: seg 06 jul 2020 09:56:22
#  Last Update: seg 06 jul 2020 09:56:22
#  Notes:

OK_TO_REMOVE_TEAMVIEWER=`ps ax|egrep -i dwagent|wc -l`

[ $OK_TO_REMOVE_TEAMVIEWER -lt 3 ] && {
    echo "Instale e acesse pelo DWService para executar esse script"
    exit 0
}

#desabilitar swap
swapoff -a
dphys-swapfile swapoff
unlink /etc/rc5.d/S01dphys-swapfile
update-rc.d dphys-swapfile disable

#fstab
sed -re 's_(PARTUUID=.*ext4)(.*)_/dev/mmcblk0p2 / ext4 defaults,noatime,nodiratime,commit=5,errors=continue,ro 0 1_' /etc/fstab >/tmp/new_fstab
sed -re 's_PARTUUID.*_/dev/mmcblk0p1 /boot vfat defaults 0 2_' /tmp/new_fstab >/etc/fstab

#cmdline.txt
sed -re 's-(dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=)(PARTUUID=.*)(rootfstype.*) -\1/dev/mmcblk0p2 \3-; s/(.*) splashplymouth.ignore-serial-consoles/\1 splash plymouth.ignore-serial-consoles/' /boot/cmdline.txt >/tmp/new_cmdline.txt
mv /tmp/new_cmdline.txt /boot/cmdline.txt

#diretorios para escrita
echo "DIRS=\"/var /etc /tmp /home/pi /opt\"" >/etc/default/dirrw.conf

#servico


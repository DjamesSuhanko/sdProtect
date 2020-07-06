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
echo "DESABILITANDO SWAP"
swapoff -a
dphys-swapfile swapoff
unlink /etc/rc5.d/S01dphys-swapfile
update-rc.d dphys-swapfile disable

#fstab
echo "MODIFICANDO TABELA DE PARTICOES"
sed -re 's_(PARTUUID=.*ext4)(.*)_/dev/mmcblk0p2 / ext4 defaults,noatime,nodiratime,commit=5,errors=continue,ro 0 1_' /etc/fstab >/tmp/new_fstab
sed -re 's_PARTUUID.*_/dev/mmcblk0p1 /boot vfat defaults 0 2_' /tmp/new_fstab >/etc/fstab

#cmdline.txt
echo "MODIFICANDO IDENTIFICADOR DE PARTICAO"
sed -re 's-(dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=)(PARTUUID=.*)(rootfstype.*) -\1/dev/mmcblk0p2 \3-; s/(.*) splashplymouth.ignore-serial-consoles/\1 splash plymouth.ignore-serial-consoles/' /boot/cmdline.txt >/tmp/new_cmdline.txt
mv /tmp/new_cmdline.txt /boot/cmdline.txt

#diretorios para escrita
echo "ESPECIFICANDO DIRETORIOS DE ESCRITA"
echo "DIRS=\"/var /etc /tmp /home/pi /opt\"" >/etc/default/dirrw.conf

#servico
echo "BAIXANDO ARQUIVO DE SERVICO"
#wget -c https://raw.githubusercontent.com/DjamesSuhanko/sdProtect/master/makepartro.service -O /lib/systemd/system/makepartro.service
cp makepartro.service /lib/systemd/system/
systemctl enable makepartro

#rc.local
echo "MODIFICANDO RC.LOCAL PARA CRIAR DIRETORIO DE CACHE EM RAM"
egrep -v 'exit' /etc/rc.local >/tmp/rc.local
echo "mkdir -p /dev/shm/inradio-cache" >>/tmp/rc.local
echo "chmod 0777 /dev/shm/inradio-cache" >>/tmp/rc.local
echo "exit 0" >>/tmp/rc.local
mv /tmp/rc.local /etc/rc.local

#autostart do chromium
echo "MODIFICANDO AUTOSTART DO CHROMIUM PARA FAZER CACHE NA RAM"
egrep -v chromium /home/pi/.config/lxsession/LXDE-pi/autostart >/tmp/autostart
echo "@/usr/bin/chromium-browser --noerordialogs --disable-session-crashed-bubble --disable-infobars --disk-cache-dir=/dev/shm/inradio-cache --disk-cache-size=400000000 --kiosk https://radios.srv.br/" >>/tmp/autostart
mv /tmp/autostart /home/pi/.config/lxsession/LXDE-pi/autostart
chown pi.pi /home/pi/.config/lxsession/LXDE-pi/autostart
chmod 644 /home/pi/.config/lxsession/LXDE-pi/autostart

#memoria da gpu
echo "REDUZINDO MEMORIA DA GPU"
egrep -v "gpu_mem" /boot/config.txt >/tmp/config.txt
echo "gpu_mem=16" >>/tmp/config.txt
mv /tmp/config.txt /boot/config.txt


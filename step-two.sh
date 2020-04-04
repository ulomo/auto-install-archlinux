#!/bin/bash

function autoline(){
    if [[ $? != 0 ]];then
        echo "error occured"
        exit
    fi
    echo ""
    for (( i=0;i<$(tput cols);i++ )) ;do echo -n "=";sleep 0.001;done
}
function say(){
    echo -e "\033[32m$@\033[0m"
}


autoline
read -p "install now? yes/no " answer

if [[ $answer == "yes" ]];then

    autoline
    say installing.......

    # set fast mirror
    autoline
    echo "set faster mirror......."
    grep -A 1 China /etc/pacman.d/mirrorlist | grep Server | while read line ;do sed -i "1i ${line}\n" /etc/pacman.d/mirrorlist;done


    # sync 
    autoline
    echo "sync database........"
    pacman --noconfirm -Sy

    # set time zone
    autoline
    echo "set time zone........"
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

    # generate adjtime
    autoline
    echo "generate adjtime........"
    hwclock --systohc

    # set locale
    autoline
    echo "set locale......."
    sed -i 's/#  en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen

    # set lang
    autoline
    echo "set lang........"
    touch /etc/locale.conf && echo "LANG=en_US.UTF-8" > /etc/locale.conf

    # create hostname
    autoline
    echo "create hostname........"
    touch /etc/hostname && echo "Archlinux" > /etc/hostname

    # create hosts file
    autoline
    echo "create hosts file........"
    touch /etc/hosts 
    echo "127.0.0.1 localhost
::1  localhost
127.0.1.1 Archlinux.localdomain Archlinux" > /etc/hosts

    # install network software
    autoline
    echo "install some network software........"
    pacman --noconfirm -S wpa_supplicant dialog netctl dhcpcd

    # test whether has windows
    autoline
    echo "testing whether to install os-prober......."
    if lsblk -f | grep -i ntfs &>/dev/null;then
        pacman --noconfirm -S os-prober
    fi

    # install grub
    autoline
    echo "install grub......."
    pacman --noconfirm -S grub efibootmgr


    # install grub to device
    autoline
    echo "install grub to device........"
    sleep 4
    if ls /sys/firmware/efi/efivars &>/dev/null;then
        grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
    else
        device=`lsblk | grep  -E '/$' | awk '{print $1}' | tr -d 0-9 | cut -c 3-`
        read -p "grub will be installed in `say /dev/${device}. agree?` yes/no" confirm
        if [[ $confirm == "yes" ]];then
            grub-install --target=i386-pc /dev/${device}
        else
            echo "installed by yourself;and then u should set root passwd before restart"
            exit
        fi
    fi

    # generate config file
    autoline
    echo "generate configurate file........"
    sleep 4
    grub-mkconfig -o /boot/grub/grub.cfg

    # set root passwd
    autoline
    echo "set root passwd"
    passwd

    # exit
    autoline
    say "ok, you can reboot system now"
    say "before reboot run: umount -R /mnt"
    exit

else
    exit
fi

#!/bin/bash

function say(){
    echo -e "\033[32m$@\033[0m"
}

function autoline(){
    if [[ $? != 0 ]];then
        echo "error occured"
        exit
    fi
    echo ""
    for (( i=0;i<$(tput cols);i++ )) ;do echo -n "=";sleep 0.001;done
}

autoline
if [[ ! -f /root/step-two.sh ]];then
    echo "you should copy script to current directory first"
    exit
fi
if [[ ! -x /root/step-two.sh ]];then
    echo "the script cannot be executed with permission denied"
fi    

autoline
echo "testing ur system supports uefi or not......"
if ls /sys/firmware/efi/efivars &>/dev/null;then
    echo "your system `say support uefi` and esp paration must be mounted on `say /boot/efi`"
else
    echo "your system `say do not support uefi`"
fi

autoline
echo "testing whether root paration has been mounted on /mnt......"
if ! lsblk | grep '/mnt' &>/dev/null;then
    echo "before run this script, u should format disk and  mount disk first"
    exit
fi

autoline
if ls /sys/firmware/efi/efivars &>/dev/null;then
    echo "testing whether esp paration has benn mounted on /mnt/boot/efi......"
    if ! lsblk | grep '/mnt/boot/efi';then
        echo "ESP paration must be mounted on /boot/efi"
        exit
    fi
fi

autoline
read -p "testing ok, now install system? yes/no " answer

if [[ $answer == "yes" ]];then

    autoline
    say installing......

    # set fast mirror
    autoline
    echo "setting faster mirror......"
    grep -A 1 China /etc/pacman.d/mirrorlist | grep Server | while read line ;do sed -i "1i ${line}\n" /etc/pacman.d/mirrorlist;done

    # sync
    autoline
    echo "sync database......"
    pacman --noconfirm -Sy

    # install base package
    autoline
    echo "install base package......"
    pacstrap /mnt base base-devel linux linux-firmware

    # update time
    autoline
    echo "update time......."
    timedatectl set-ntp true

    # create fstab
    autoline
    echo "create fstab......"
    genfstab -U /mnt >> /mnt/etc/fstab

    # copy install script to /mnt
    autoline
    echo "copy install script to /mnt......"
    cp ./step-two.sh /mnt
    if [[ $? != 0 ]];then
        echo "u should copy step-two.sh script to /mnt first"
        exit
    fi

    # chroot
    autoline
    echo "chroot......"
    say ok, now run step-two.sh by hand
    arch-chroot /mnt
else
    exit
fi

#!/bin/bash

HOSTNAME=''


if [[ -d /sys/firemware/efi/efivars]];
	then
		FIRMWARE=UEFI
	else
		FIRMWARE=BIOS
fi

wget google.com

if [[ index.html ]];
	then
		NETWORK=true
	else
		NETWORK=false
fi
rm index.html


if [[ NETWORK ]];
	then
		timedatectl set-ntp true
fi

if [[ $FIRMWARE == "UEFI" ]];
	then
	
		echo -e o\nn\n1\n\n+500M\nEF00\nw\n | gdisk /dev/sda
#		gdisk /dev/sda << EOF
#		o
#		n
#		1
#		34
#		+500M
#		EF00
#		w
#		EOF
	else
		echo -e o\nn\n1\n\n+1M\nef02\nw\n | gdisk /dev/sda
#		gdisk /def/sda << EOF
#		o
#		n
#		1
#		34
#		+1M
#		ef02
#		w
#		EOF
fi

echo -e o\nn\n2\n\n+30G\n8300\nw\n | gdisk /dev/sda
#gdisk /dev/sda << EOF
#n
#2
#\n
#+30G
#8300
#w
#EOF
echo -e o\nn\n3\n\n+4G\n8200\nw\n | gdisk /dev/sda
#gdisk /dev/sda << EOF
#n
#3
#\n
#+4G
#8200
#w
#EOF

mkfs.ext4 /dev/sda2

echo -e o\nn\n4\n\n-0\n8300\nw\n | gdisk /dev/sda

#gdisk /dev/sda << EOF
#n
#4
#\n
#-0
#8300
#w
#EOF
mkfs.ext4 /dev/sda4

mount /dev/sda2 /mnt
mount /dev/sda1 /mnt/boot
mount /dev/sda4 /mnt/home

pacstrap /mnt base base-devel
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime
# hwclock --systohc

sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
locale-gen
mkdir /etc/locale.conf && echo LANG=en_US.UTF-8 > /etc/locale.conf

$HOSTNAME > /etc/hostname

echo 127.0.0.1	localhost.localdomain	localhost >> /etc/hosts
echo ::1		localhost.localdomain	localhost >> /etc/hosts
echo 127.0.1.1	$HOSTNAME.localdomain	$HOSTNAME >> /etc/hosts

passwd


if [[ $FIRMWARE == "UEFI" ]];
	then
		pacman -S grub efibootmgr
		grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
	else
		grub-install --target=i386-pc /dev/sda1
fi
pacman -S os-prober
grub-mkconfig -o /boot/grub/grub.cfg

sudo reboot 0

		
---
title: Clone Arch linux
subtitle: A record of a working clone of my arch installation
date: 2020-01-24
tags: ["info", "arch"]
draft: true
---

This is not a tutorial on how to install Arch linux. Arch linux already
has a great wiki and installation notes that will always be up to date,
unlike this post. The main purpose of it is only to rember the software
that I always install for easy reference.

<!--more-->

### Setting up the disks

During the whole process the variable `$x` will contain the letter of the
disk where I install Arch, so go ahead and set it correctly,

    x=a

You can easily create a gpt partition table for booting in UEFI with

    sudo cfdisks /dev/sd$x

I usualy have 3 partitions

| path | mount point | size |
|-----|-------------|------|
| `/dev/sd${x}1` | `/boot` |  300M |
| `/dev/sd${x}2` | `/swap` | Enough to contain the RAM of the system |
| `/dev/sd${x}3` | `/home` |  40G (usualy twice the amount of `/` but between 10 and 100G) |
| `/dev/sd${x}4` | `/` |  20G (it can be only 10G for a usb or 100G is there a lot of space) |

We need to create the filesystems :

    sudo mkfs.vfat /dev/sd${x}1
    sudo mkfs.ext4 /dev/sd${x}3
    sudo mkfs.ext4 /dev/sd${x}4

And the swap

    sudo mkswap /dev/sd${x}2
    sudo swapon /dev/sd${x}2

Finaly we can mount everything

    sudo mount /dev/sd${x}4 /mnt
    sudo mkdir -p /mnt/{boot,home}
    sudo mount /dev/sd${x}1 /mnt/boot
    sudo mount /dev/sd${x}3 /mnt/home

### Bootstraping

Now that the disks are set up, we can clone the old system into the new,
copying all the files I like.

    sudo rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*",\
    "/run/*","/mnt/*","/media/*","/lost+found","/home/diego/.cache/*","/boot/*"} / /mnt

    sudo cp /boot/*linux* /mnt/boot

Notice that we exclude the boot loader as I run into too many problems with it and I think
is easier to install it again.

First we go into the new system and take car of a few things

    sudo arch-chroot /mnt
    echo New-computer-name > /etc/hostname
    vim /etc/hosts
    rm /etc/machine-id
    genfstab / > /etc/fstab

And we configure the bootloader

    mkinitcpio -P
    refind-install

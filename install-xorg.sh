#!/bin/bash

function main(){
	language="en_IN.UTF-8"
	timezone="Asia/Kolkata"
	linuxpkg="base linux linux-firmware"
	develpkg="base-devel nano vim vi wget git go"
	baseutilspkg="sudo man bash-completion fish reflector tmux tlp ffmpeg efibootmgr neofetch"
	microcodepkg="amd-ucode"
	filesystempkg="btrfs-progs"
	networkpkg="netctl dialog wpa_supplicant"
	audiopkg="alsa-utils pulseaudio pulseaudio-alsa"
	bluetoothpkg="bluez bluez-utils"
	xorgpkg="xorg-server xorg-xinit"
	graphicspkg="mesa xf86-video-amdgpu vulkan-radeon libva-mesa-driver mesa-vdpau opencl-mesa lib32-mesa lib32-vulkan-radeon lib32-libva-mesa-driver lib32-mesa-vdpau"
	iopkg="xf86-input-synaptics"
	aurwrapper="yay"
	continuestate=1

	#try
	(
		set -e
		if [[ -z "$@" ]]
		then
			continueinstall
		else
			if [[ -z "$2" && -f "archinstalllog.txt" ]]
			then
				source "archinstalllog.txt"
				continuestate="$crashedstate"
			else
				continuestate="$2"
			fi
			export setupoption="$1"
			setup "$0"
		fi
	)

	# catch
	errorcode="$?"
	if [[ $errorcode -ne 0 ]]
	then
		echo "ERROR!!! Arch Linux Installer Failed at stage $continuestate!!"
		echo crashedstate="$continuestate" > archinstalllog.txt
		exit $continuestate
	fi
}


function setup(){
	case "$setupoption" in
		"-h" | "--help")
			echo ''
			echo 'Usage:'
			echo " $1"
			echo " $1 [options]"
			echo " $1 -c <continuecode>"
			echo ''
			echo 'Arch Linux Installer'
			echo ''
			echo 'Options:'
			echo ' -h, --help            help'
			echo ' -u, --update          update the install script'
			echo ' -c, --continue        continue'
			echo ' -m, --mount           mountall'
			echo ' -um, --umount         unmountall'
			echo ' -cr, --chroot         chroot into installed system'
			echo ' -ft, --fixtime        update system time      (1)'
			echo ' -p, --part            partition disks         (2)'
			echo ' -f, --format          format disks            (3)'
			echo ' -s, --swap            turn on swap            (4)'
			echo ' -r, --root            setup root              (5)'
			echo ' -m, --mirror          refresh mirrors         (6)'
			echo ' -i, --install         install arch            (7)'
			echo ' -et, --ntp            enable ntp              (8)'
			echo ' -l, --locale          generate locale         (9)'
			echo ' -hn, --hostname       configure hostname      (10)'
			echo ' -in, --initramfs      generate initramfs      (11)'
			echo ' -cu, --createuser     create new user         (12)'
			echo ' -eb, --bluetooth      enable bluetooth        (13)'
			echo ' -et, --tlp            enable tlp              (14)'
			echo ' -g, --graphics        configure graphics      (15)'
			echo ' -a, --aur             install aur helpers     (16)'
			echo ' -b, --boot            install bootloader      (17)'
			echo ' -sb, --secureboot     enable secureboot       (18)'
			echo ' -q, --quit            quit installer          (19)'
			echo ''
			echo 'Continue codes are given in brackets. Installer will proceed to execute it and all the instructions below it.'
			;;
		"-u" | "--update") updatescript "$1"
			;;
		"-c" | "--continue") continueinstall
			;;
		"-m" | "--mount") mountall
			;;
		"-um" | "--umount") unmountall
			;;
		"-cr" | "--chroot") archchroot
			;;
		"-ft" | "--fixtime") updatesystime
			;;
		"-p" | "--part") partitiondisks
			;;
		"-f" | "--format") formatdisks
			;;
		"-s" | "--swap") turnonswap
			;;
		"-r" | "--root") setuproot
			;;
		"-m" | "--mirror") refreshmirrors || true
			;;
		"-i" | "--install") installarchlinux
			;;
		"-et" | "--ntp") archsynctime
			;;
		"-l" | "--locale") archlocalegen
			;;
		"-hn" | "--hostname") archsethostname
			;;
		"-in" | "--initramfs") archgeninitramfs
			;;
		"-cu" | "--createuser") archcreateuser
			;;
		"-eb" | "--bluetooth") archenablebluetooth
			;;
		"-et" | "--tlp") archenabletlp
			;;
		"-g" | "--graphics") archgraphics
			;;
		"-a" | "--aur") archinstallaurhelpers
			;;
		"-b" | "--boot") archinstallbootloader
			;;
		"-sb" | "--secureboot") archsecureboot
			;;
		"-q" | "--quit") finishinstall
	esac
}

function continueinstall(){
	case "$continuestate" in
		1)  updatesystime
			continuestate=1
			;&
		2)  partitiondisks
			continuestate=2
			;&
		3)  formatdisks
			continuestate=3
			;&
		4)  turnonswap
			continuestate=4
			;&
		5)  setuproot
			continuestate=5
			;&
		6)  refreshmirrors || true
			continuestate=6
			;&
		7) installarchlinux
			continuestate=7
			;&
		8) archsynctime
			continuestate=8
			;&
		9) archlocalegen
			continuestate=9
			;&
		10) archsethostname
			continuestate=10
			;&
		11) archgeninitramfs
			continuestate=11
			;&
		12) archcreateuser
			continuestate=12
			;&
		13) archenablebluetooth
			continuestate=13
			;&
		14) archenabletlp
			continuestate=14
			;&
		15) archgraphics
			continuestate=15
			;&
		16) archinstallaurhelpers
			continuestate=16
			;&
		17) archinstallbootloader
			continuestate=17
			;&
		18) archsecureboot
			continuestate=18
			;&
		19) finishinstall
	esac
}


function updatescript(){
	curl -L "https://www.tinyurl.com/aim-arch-install-min" -o $1 && exit 0
}


function mountall(){
    swapon /dev/sda2
    mount -o subvol=@,compress=zstd,noatime,nodiratime /dev/sda3 /mnt
    mount -o subvol=@home,compress=zstd,noatime,nodiratime /dev/sda3 /mnt/home
    mount -o subvol=@var,compress=zstd,noatime,nodiratime /dev/sda3 /mnt/var
    mount -o subvol=@snapshots,compress=zstd,noatime,nodiratime /dev/sda3 /mnt/.snapshots
    mount /dev/sda1 /mnt/boot
}


function unmountall(){
	swapoff /dev/sda2 || true
	umount /mnt/home || true
	umount /mnt/var || true
	umount /mnt/.snapshots || true
	umount /mnt || true
	umount /dev/sda3 || true
}


function archchroot(){
    arch-chroot /mnt /bin/bash
}


function updatesystime() {
	systemctl enable --now systemd-timesyncd
	timedatectl set-ntp true
}


function partitiondisks(){
	parted --script /dev/sda \
	rm 1 \
	rm 2 \
	rm 3 \
	mkpart primary fat32 1MiB 513MiB \
	mkpart primary linux-swap 513MiB 4609MiB \
	mkpart primary btrfs 4609MiB 500001MiB \
	set 1 esp on \
	set 2 swap on \
	unit MiB print \
	quit
}


function formatdisks(){
	mkfs.fat -F32 /dev/sda1
	mkswap /dev/sda2
	mkfs.btrfs -L "Computer" -f /dev/sda3
}


function turnonswap(){
	swapon /dev/sda2
}


function setuproot(){
	mount /dev/sda3 /mnt
	btrfs su cr /mnt/@
	btrfs su cr /mnt/@home
	btrfs su cr /mnt/@var
	btrfs su cr /mnt/@snapshots
	umount /mnt
	mount -o subvol=@,compress=zstd,noatime,nodiratime /dev/sda3 /mnt
	mkdir /mnt/{boot,home,var,.snapshots}
	mount -o subvol=@home,compress=zstd,noatime,nodiratime /dev/sda3 /mnt/home
	mount -o subvol=@var,compress=zstd,noatime,nodiratime /dev/sda3 /mnt/var
	mount -o subvol=@snapshots,compress=zstd,noatime,nodiratime /dev/sda3 /mnt/.snapshots
	mount /dev/sda1 /mnt/boot
}


function refreshmirrors(){
	sed -i '/\[multilib\]/,/mirrorlist/ s/#//' /etc/pacman.conf
	pacman -Syy --noconfirm reflector
	reflector --verbose --sort rate --save /etc/pacman.d/mirrorlist
}


function installarchlinux(){
	pacstrap /mnt $linuxpkg $microcodepkg $develpkg $baseutilspkg $filesystempkg $networkpkg $audiopkg $bluetoothpkg $xorgpkg $graphicspkg $iopkg
	genfstab -U /mnt >> /mnt/etc/fstab
}


function runinchroot(){
	arch-chroot /mnt /bin/bash -c "$@"
}

function runasuser(){
	runinchroot "su aim -c -- '$@'"
}


function archsynctime(){
	runinchroot "ln -sf /usr/share/zoneinfo/$timezone /etc/localtime && \
	hwclock --systohc && \
	systemctl enable systemd-timesyncd && \
	timedatectl set-ntp true"
}


function archlocalegen(){
	sed -i "/$language/s/^#//g" /mnt/etc/locale.gen
	runinchroot "locale-gen"
	echo "LANG=$language" >> /mnt/etc/locale.conf
}


function archsethostname(){
	echo pandora >> /mnt/etc/hostname
}


function archgeninitramfs(){
	sed -i 's/block filesystems/block btrfs filesystems/' /mnt/etc/mkinitcpio.conf
	sed -i '/MODULES=()/s/()/(amdgpu radeon)/' /mnt/etc/mkinitcpio.conf
	runinchroot "mkinitcpio -P"
}


function archcreateuser(){
	runinchroot "passwd -l root && \
	useradd -mg users -G wheel,storage,power -s /bin/bash aim && \
	echo aim:aim | chpasswd"
	sed -i '/%wheel ALL=(ALL) ALL/s/# //' /mnt/etc/sudoers
	runasuser "mkdir Documents Downloads Music Pictures Videos" || true
}


function archenablebluetooth(){
	runinchroot "systemctl enable bluetooth"
}


function archenabletlp(){
	runinchroot "tlp start || true"
}


function archgraphics(){
	(
        echo 'Section "Device"'
        echo '    Identifier "AMD"'
        echo '    Driver "amdgpu"'
        echo '    Option "TearFree" "true"'
        echo '    Option "DRI" "3"'
        echo 'EndSection'
    ) > /mnt/etc/X11/xorg.conf.d/20-amdgpu.conf
}


function aurinstall(){
	sed -i '/%wheel ALL=(ALL) ALL/s/%/# %/g' /mnt/etc/sudoers
	sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/# //g' /mnt/etc/sudoers
	runasuser "export LANG=$language && $aurwrapper -Syy --noconfirm $@ ||true"
	sed -i '/%wheel ALL=(ALL) ALL/s/# //g' /mnt/etc/sudoers
	sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/%/# %/g' /mnt/etc/sudoers
}


function archinstallaurhelpers(){
	if [[ -d /mnt/home/aim/.cache/aurinstaller ]]
	then
		rm -r /mnt/home/aim/.cache/aurinstaller
	fi
	runasuser "mkdir /home/aim/.cache || true"
	runasuser "mkdir /home/aim/.cache/aurinstaller"
	runasuser "git clone https://aur.archlinux.org/$aurwrapper.git /home/aim/.cache/aurinstaller/$aurwrapper"
	sed -i '/%wheel ALL=(ALL) ALL/s/%/# %/g' /mnt/etc/sudoers
	sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/# //g' /mnt/etc/sudoers
	runasuser "export LANG=$language && cd /home/aim/.cache/aurinstaller/$aurwrapper && makepkg --syncdeps -si --noconfirm || true"
	sed -i '/%wheel ALL=(ALL) ALL/s/# //g' /mnt/etc/sudoers
	sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/%/# %/g' /mnt/etc/sudoers
	rm -rf /mnt/home/aim/.cache/aurinstaller || true
}


function archinstallbootloader(){
	runinchroot "bootctl --path=/boot install"

	(
        echo 'default  arch'
        echo 'timeout  0'
        echo 'console-mode   max'
        echo 'editor   0'
    ) > /mnt/boot/loader/loader.conf

    (
        echo 'title Arch Linux'
        echo 'linux /vmlinuz-linux'
        echo 'initrd /amd-ucode.img'
        echo 'initrd /initramfs-linux.img'
        echo 'options root=LABEL=Computer rw rootflags=subvol=@ processor.max_cstate=1'
    ) > /mnt/boot/loader/entries/arch.conf
}


function archsecureboot(){
	aurinstall preloader-signed
	yes | cp -f /mnt/usr/share/preloader-signed/HashTool.efi /mnt/boot/EFI/Boot
	yes | cp -f /mnt/boot/EFI/systemd/systemd-bootx64.efi /mnt/boot/EFI/Boot/loader.efi
	yes | cp -f /mnt/usr/share/preloader-signed/PreLoader.efi /mnt/boot/EFI/Boot/bootx64.efi
}


function finishinstall(){
	umount -a || true
	telinit 6
}


main "$@"

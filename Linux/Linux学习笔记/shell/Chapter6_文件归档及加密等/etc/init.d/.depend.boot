TARGETS = console-setup mountkernfs.sh alsa-utils ufw hostname.sh apparmor dns-clean x11-common pppd-dns plymouth-log udev keyboard-setup mountdevsubfs.sh resolvconf procps brltty hwclock.sh networking urandom checkroot.sh bootmisc.sh mountnfs.sh mountall.sh checkfs.sh checkroot-bootclean.sh mountnfs-bootclean.sh mountall-bootclean.sh kmod
INTERACTIVE = console-setup udev keyboard-setup checkroot.sh checkfs.sh
udev: mountkernfs.sh
keyboard-setup: mountkernfs.sh udev
mountdevsubfs.sh: mountkernfs.sh udev
resolvconf: dns-clean
procps: mountkernfs.sh udev
brltty: mountkernfs.sh udev
hwclock.sh: mountdevsubfs.sh
networking: mountkernfs.sh urandom resolvconf procps dns-clean
urandom: hwclock.sh
checkroot.sh: hwclock.sh mountdevsubfs.sh hostname.sh keyboard-setup
bootmisc.sh: udev mountnfs-bootclean.sh checkroot-bootclean.sh mountall-bootclean.sh
mountnfs.sh: networking
mountall.sh: checkfs.sh checkroot-bootclean.sh
checkfs.sh: checkroot.sh
checkroot-bootclean.sh: checkroot.sh
mountnfs-bootclean.sh: mountnfs.sh
mountall-bootclean.sh: mountall.sh
kmod: checkroot.sh

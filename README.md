# flexwall
Buildroot based hardened firewall
(Utilizes the Buildroot br2_external concept to define a target configuration/customization out of tree)

Features
+ Utilizing the latest Linux Kernel NF tables filewall capability
+ Bleeding edge package revisions for minimal CVE exposure
+ SELinux policy hardened
+ Snort IDS monitoring
+ Squid web acceleration
+ Caching DNS server / DHCP server
+ NTP server
+ DDNS client (initially just dnsexit)
+ No authenticated user access or interactive shell
+ Multi-OS setup approach with diskimager loading image binaries to media, then FAT32 media partition mounted to place configuration file.
+ Configurable through a text file placed in a FAT32 partition at USB stick/harddrive images time.  Otherwise not runtime configurable or modifyable

Build Setup
------------------------------------------------------
 cd ~/
 # Retrieve tip of Buildroot
 git clone http://git.buildroot.net/git/buildroot.git
 # Retreive target custom files
 git clone https://github.com/matthew-l-weber/flexwall.git
 # Setup configuration for build
 cd ~/buildroot
 make BR2_EXTERNAL=~/flexwall O=~/t_flexwall x86_flexwall_defconfig
 # Do initial build
 cd ~/t_flexwall
 make

Install
+ Output images located in ~/t_flexwall/images/
+ Use ??? as the binary to load to a media (USB/Harddisk)
  +  Linux - dd if=images/???.bin of=/dev/<disk> conv=fdatasync
  +  Windows - http://sourceforge.net/projects/win32diskimager/

Testing with QEMU (assuming within target build folder)
qemu-system-i386 -M pc -kernel images/bzImage -drive file=images/rootfs.ext2,if=ide -append "console=ttyS0 root=/dev/sda" -net nic,model=rtl8139 -net nic,model=rtl8139 -net user -nographic

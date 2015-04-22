# flexwall
Buildroot based hardened firewall - (Utilizes the Buildroot br2_external concept to define a target configuration/customization out of tree)

Features
------------------------------------------------------
+ (Complete) Utilizing the latest Linux Kernel NF tables filewall capability
+ (Complete) Bleeding edge package revisions for minimal CVE exposure
+ (Maybe, depends on filesystem type and possibly different approach with IMA arch) SELinux policy hardened
+ (Future) Snort IDS monitoring
+ (Future) Squid web acceleration
+ (Complete) Caching DNS server / DHCP server
+ (Pending) NTP server
+ (Future) DDNS client (initially just dnsexit)
+ (Pending) No authenticated user access or interactive shell
+ (Pending) Multi-OS setup approach with diskimager loading image binaries to media, then FAT32 media partition mounted to place configuration file.
+ (Future) Configurable through a text file placed in a FAT32 partition at USB stick/harddrive images time.  Otherwise not runtime configurable or modifyable

Build Setup
------------------------------------------------------
cd ~/<br>
git clone http://git.buildroot.net/git/buildroot.git              # Retrieve tip of Buildroot<br>
git clone https://github.com/matthew-l-weber/flexwall.git         # Retreive target custom files<br>
cd ~/buildroot                                                    # Setup configuration for build<br>
make BR2_EXTERNAL=~/flexwall O=~/t_flexwall x86_flexwall_defconfig<br>
cd ~/t_flexwall                                                   # Do initial build<br>
make<br>

Install
------------------------------------------------------
+ Output images located in ~/t_flexwall/images/
+ Use ??? as the binary to load to a media (USB/Harddisk)
  +  Linux - dd if=images/???.bin of=/dev/<disk> conv=fdatasync
  +  Windows - http://sourceforge.net/projects/win32diskimager/

Testing with QEMU 
------------------------------------------------------
(assuming within target build folder)<br><br>
+ cp images/rootfs.ext2 images/rootfs_fw.ext2
+ qemu-system-i386 -M pc -kernel images/bzImage -drive file=images/rootfs_fw.ext2,if=ide -append "console=ttyS0 root=/dev/sda ip=10.10.10.1:::255.255.255.0:flexwall:eth1:::" -net nic,model=rtl8139,vlan=1,macaddr=52:55:01:4e:79:18 -net user,vlan=1 -net nic,model=rtl8139,vlan=2,macaddr=52:55:01:4e:79:19 -net socket,vlan=2,listen=:1234  -nographic

Second qemu instance to act as a LAN device
+ Start second instance (using qemu socket networking to connect to firewall, https://people.gnome.org/~markmc/qemu-networking.html)
  + cp images/rootfs.ext2 images/rootfs_lan.ext2
  + qemu-system-i386 -M pc -kernel images/bzImage -drive file=images/rootfs_lan.ext2,if=ide -append "console=ttyS0 root=/dev/sda ip=:::::fwclient:eth0:dhcp::" -net nic,model=rtl8139,vlan=2,macaddr=52:55:01:4e:79:28 -net socket,vlan=2,connect=127.0.0.1:1234   -nographic

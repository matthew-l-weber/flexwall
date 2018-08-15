

# audio streamer

A beagleboard encoder/src that takes in an audio stream and a raspberrypi as the destination that outputs the stream to an audio amp/headphones.  At power on the devices work independently and consume/output streams.  Both sync to ntp time and require custom wpa_supplicant config that's checked in as a placeholder home.conf which requires customization.

Buildsystem version used against this br2_external
- Used buildroot commit d2c8d0efbfea1fc5d482a89b8108217de4105d61 plus 112b22d7062ed8d971418cc5ef5544744d30615e which adds support for MediaTek wifi.



# flexwall
Buildroot based hardened firewall - (Utilizes the Buildroot br2_external concept to define a target configuration/customization out of tree)

Features
------------------------------------------------------
+ (Complete) Utilizing the latest Linux Kernel NF tables filewall capability
+ (Complete) Bleeding edge package revisions for minimal CVE exposure
+ (Complete) Caching DNS server / DHCP server
+ (Complete) NTP server
+ (Pending) Guide for updating cfg files to customize the different services/cfg files
+ (Pending) Update for new multi  BR2_EXTERNAL

Build Setup
------------------------------------------------------
cd ~/<br>
git clone http://git.buildroot.net/git/buildroot.git              # Retrieve tip of Buildroot<br>
git clone https://github.com/matthew-l-weber/flexwall.git         # Retreive target custom files<br>
cd ~/buildroot                                                    # Setup configuration for build<br>
make BR2_EXTERNAL_FLEXWALL_PATH=~/flexwall O=~/t_flexwall x86_flexwall_defconfig<br>
cd ~/t_flexwall                                                   # Do initial build<br>
make<br>

Install
------------------------------------------------------
+ Output images located in ~/t_flexwall/images/
+ Use ~/t_flexwall/images/rootfs.iso9660 as the binary to load to a media (USB/Harddisk)
  +  Linux - dd if=~/t_flexwall/images/rootfs.iso9660 of=/dev/<disk> conv=fdatasync
  +  Windows - http://sourceforge.net/projects/win32diskimager/

Testing with QEMU
------------------------------------------------------
(assuming within target build folder)<br><br>
+ qemu-system-i386 -M pc -kernel images/bzImage -drive file=images/rootfs.iso9660,if=ide -append "console=ttyS0 root=/dev/sda1 quiet" -net nic,model=rtl8139,vlan=1,macaddr=52:55:01:4e:79:18 -net user,vlan=1 -net nic,model=rtl8139,vlan=2,macaddr=52:55:01:4e:79:19 -net socket,vlan=2,listen=:1234  -nographic

Second qemu instance to act as a LAN device
+ Start second instance (using qemu socket networking to connect to firewall, https://people.gnome.org/~markmc/qemu-networking.html)
  + qemu-system-i386 -M pc -kernel images/bzImage -drive file=images/rootfs.iso9660,if=ide -append "console=ttyS0 root=/dev/sda1 quiet fwclient" -net nic,model=rtl8139,vlan=2,macaddr=52:55:01:4e:79:28 -net socket,vlan=2,connect=127.0.0.1:1234   -nographic

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
+ DDNS client (initially just dnsexit)
+ No authenticated user access or interactive shell
+ Multi-OS setup approach with diskimager loading image binaries to media, then FAT32 media partition mounted to place configuration file.
+ Configurable through a text file placed in a FAT32 partition at USB stick/harddrive images time.  Otherwise not runtime configurable or modifyable


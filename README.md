# eid-images
Prebuilt Docker and VM Images

## How to Produce the eid-packer-focal-base qcow2 Image File

To produce the eid-packer-ubuntu-focal-base.qcow2 image, use the following method:
### Use eid-ansible -> packer to create the base qcow2 image.

git clone https://eideticcom.visualstudio.com/DefaultCollection/Tools/_git/eid-ansible

Go through the README.md on the packer page called *Eideticom Packer Project* for the prerequisites of your host machine as well as how-to use packer

https://eideticcom.visualstudio.com/Tools/_git/eid-ansible?path=%2Fpacker&anchor=eideticom-packer-project

The packer sub-project that you require here is called *eid-packer-ubuntu-focal-base*.

#to build the VM image
- cd ~/eid-ansible/packer/
- packer build eid-packer-ubuntu-focal-base.json

This will produce a directory called *eid-packer-ubuntu-focal-base*. Inside of that directory will be the eid-packer-ubuntu-focal-base.qcow2 file.
This is the final uncompressed state of this qcow2 image. To reduce the size of the qcow2 file down, see the section *Reduce the qcow2 image size* below.

## How to Produce the eid-packer-focal-nlfs-kern qcow2 Image File

Same steps as above for producing the base image, with the following additions:

### Download the sample kernel onto the VM image.
SSH into the VM which should have a default hostname of *kickseed* and a user name and password can be found in the file
~/eid-ansible/packer/kickstart/eid-packer-ubuntu-focal.ks

- ssh eideticom@kickseed
- sudo su
- cd
- git clone --bare --depth 1 -b v5.7 https://github.com/torvalds/linux.git

## Reduce the qcow2 image size. 

### Create a VM from the qcow2 file, using virt-manager (or preferred means). For example:
- sudo cp ~/eid-ansible/packer/eid-packer-ubuntu-focal-base/eid-packer-ubuntu-focal-base.qcow2 /var/lib/libvirt/images/
- sudo virt-manager
- Use the virt-manager GUI to create a new VM from this qcow2 file and boot into it. 
- **Note** You should set the memory allocation to 2048.

Run the following commands on the VM:

SSH into the VM which should have a default hostname of *kickseed* and a user name and password can be found in the file
~/eid-ansible/packer/kickstart/eid-packer-ubuntu-focal-base.ks

- SUDO_FORCE_REMOVE=yes apt autoremove --purge linux-firmware libgl1-mesa-dri linux-modules-extra-5.4.0-26-generic texlive-bibtex-extra texlive-lang-greek \
texlive-base linux-headers-5.4.0-26 texlive-latex-extra texlive-extra-utils texlive-plain-generic texlive-binaries texlive-latex-recommended texlive-xetex \
texlive-pictures fonts-texgyre tex-gyre iso-codes libruby2.7 mesa-vulkan-drivers texlive-fonts-recommended docbook-xsl texlive-science linux-headers-5.4.0-26-generic \
texlive-formats-extra poppler-data fonts-lato fonts-urw-base35 fonts-lmodern texlive-latex-base fonts-droid-fallback libpdfbox-java tipa dblatex openssh-client \
dvisvgm xkb-data manpages-dev language-pack-gnome-en-base language-pack-en-base gettext groff-base lynx-common intel-microcode fonts-dejavu-core man-db \
shared-mime-info docbook-dsssl xterm docbook-xml apparmor lynx language-selector-common kernel-package manpages strace libx11-data openssh-server \
ntfs-3g sgml-data tcpdump openjade wamerican wbritish gpg-agent plymouth lshw apt-utils keyboard-configuration ufw debconf-i18n perl x11-utils python3-gi \
opensp rsync gpgsm accountsservice ruby-test-unit python3-dbus xfonts-utils gnupg-l10n python3-nacl python3-yaml ubuntu-release-upgrader-core \
python3-certifi x11-common publicsuffix iw rake ruby-xmlrpc gpg-wks-client dmsetup crda dmidecode uuid-runtime netcat-openbsd ruby-xmlrpc pinentry-curses \
iucode-tool fonts-gfs-porson python3-pymacaroons plymouth-theme-ubuntu-text python3-netifaces libcommons-parent-java xauth amd64-microcode  texlive \
sgml-base python3-six ruby-net-telnet python3-gdbm ssh-import-id ruby-power-assert tcl8.6 tk8.6 friendly-recovery ruby command-not-found laptop-detect \
tk tcl language-pack-gnome-en language-pack-en linux-headers-generic python3-update-manager ttf-bitstream-vera fonts-liberation
- apt clean
- swapoff /swapfile
- rm /swapfile
- fallocate -l 512M /swapfile
- mkswap /swapfile
- chmod 0600 /swapfile
- rm /root/post_install-step2.log
    - **NOTE** you can remove sudo if you do not want it
    - SUDO_FORCE_REMOVE=yes apt autoremove --purge sudo
- Shutdown the VM domain

### Run the shrink_qcow2.sh script
- On the host machine:
    - https://github.com/Eideticom/eid-images.git
- cd ~/eid-images/scripts/
- ./shrink_qcow2.sh <path_to_qcow2>

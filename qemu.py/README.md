# eid-images
Prebuilt Docker and VM Images

Ideally, these docker and VM images should be built using eid-ansible and packer:

https://eideticcom.visualstudio.com/DefaultCollection/Tools/_git/eid-ansible

There are several sub-types of images which are explained below with sub-headers. Each section should describe the purpose of the image as well
as how to build it.

## How to Produce the eid-packer-focal-base qcow2 Image File

The eid-packer-ubuntu-focal-base.qcow2 image is created from the Ubuntu 20.04 focal fossa live server iso. The intention of this image is to create the smallest
qcow2 file (approx. 350 MB) which can be used to download quickly and run using qemu.

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

## How to Produce the eid-packer-focal-integ qcow2 Image File

The eid-packer-ubuntu-focal-integ.qcow2 is intended for use with buildbot integration testing. The file is essentially the eid-packer-ubuntu-focal-base image with the following exceptions:

1. There are several packages installed by default to support kernel compilation and xfs, ext4, and NLFS filesystem testing.
2. There is a default torvalds linux kernel pre-installed on the qcow2 which can be used to test kernel compilation on the different filesystems.

Pre-installed:
git clone --bare --depth 1 https://github.com/torvalds/linux.git -b v5.7 /root/linux.git

Same steps as above for producing the base image, with the following additions:

#to build the VM image
- cd ~/eid-ansible/packer/
- packer build eid-packer-ubuntu-focal-integ.json

This will produce a directory called *eid-packer-ubuntu-focal-integ*. Inside of that directory will be the eid-packer-ubuntu-focal-integ.qcow2 file.
This is the final uncompressed state of this qcow2 image. To reduce the size of the qcow2 file down, see the section *Reduce the qcow2 image size* below.

## Reduce the qcow2 image size. 

Prerequisistes:
1. The host machine used to shrink the qcow2 should have the package *libguestfs-tools* installed in order for the script to run the virt-sparsify command.

### Run the shrink_qcow2.sh script
- On the host machine:
    - https://github.com/Eideticom/eid-images.git
- cd ~/eid-images/scripts/
- ./shrink_qcow2.sh <path_to_qcow2>

This will produce a minimal (compressed) qcow2 VM image which will now be much quicker to download and use for testing.

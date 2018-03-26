#!/bin/sh

[ $# -eq 0 ] && echo "uusage: $0 <image name>" && exit

vm_name=$1
iso=/home/jeff/vm-test/result-WH-20180305-B19.iso
eth=enahisic2i1
br=br1

if ! grep ${eth} /proc/net/dev > /dev/null 2>&1; then
       echo "${eth} device not exist"
       exit
fi

grep ${br} /proc/net/dev > /dev/null 2>&1 || virsh iface-bridge ${eth} ${br}

[ -f ${vm_name}.qcow2 ] || qemu-img create -f qcow2 -o size=20G ${vm_name}.qcow2

virt-install \
	--name ${vm_name} \
	--virt-type kvm \
	--memory 4096 \
	--vcpus 4 \
	--accelerate \
	--hvm \
	--os-type linux \
	--os-variant debian9 \
	--disk path=${vm_name}.qcow2,format=qcow2,size=20,bus=scsi \
	--cdrom  ${iso}\
	--network bridge=${br},model=virtio \
	--boot cdrom

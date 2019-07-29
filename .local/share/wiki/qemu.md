# QEMU

## How to mount a qcow2 disk image

1. Enable NBD kernel module
    `modprobe nbd max_part=2`

2. Connect the QCOW2 file as network block device
    `qemu-nbd --connect=/dev/nbd0 "$QCOW2_PATH"`

3. Mount the partition
    `mount /dev/nbd0p1 /mnt`

4. Umount
    `umount -R /mnt`
    `qemu-nbd --disconnect /dev/nbd0`

5. Remove kernel module
    `rmmod nbd`

## Mount host shared volume inside guest

1. Expose host directory
    `-virtfs local,path=/path/to/file,mount_tag=host0,security_model=passthrough,id=host0`

2. Mount in guest
    `sudo mount -t 9p -o trans=virtio host0 /mnt`

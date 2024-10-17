#!/bin/sh

# this assumes the EC2 is using Nitro instance, ext4 file system.
sudo growpart /dev/nvme0n1 1
sudo resize2fs /dev/nvme0n1p1
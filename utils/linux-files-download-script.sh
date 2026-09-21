#!/bin/bash
set -e

cd ~/Projects/TASK-03.-CodeStyle-Automation

mkdir -p dummy/{src,include} utils/tmp

wget -O utils/tmp/linux-7.2.tar.xz \
    https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.2.tar.xz

tar -xJf utils/tmp/linux-7.2.tar.xz -C utils/tmp \
    linux-7.2/drivers/net/ethernet/intel/e1000e/ethtool.c \
    linux-7.2/drivers/net/ethernet/intel/e1000e/manage.c \
    linux-7.2/fs/ext4/file.c \
    linux-7.2/fs/ext4/ext4_jbd2.c \
    linux-7.2/drivers/net/ethernet/intel/e1000e/e1000.h \
    linux-7.2/drivers/net/ethernet/intel/e1000e/phy.h \
    linux-7.2/fs/ext4/ext4_extents.h \
    linux-7.2/fs/ext4/mballoc.h \
    linux-7.2/.clang-format

cp utils/tmp/linux-7.2/drivers/net/ethernet/intel/e1000e/{ethtool.c,manage.c} dummy/src/
cp utils/tmp/linux-7.2/fs/ext4/{file.c,ext4_jbd2.c} dummy/src/

cp utils/tmp/linux-7.2/drivers/net/ethernet/intel/e1000e/{e1000.h,phy.h} dummy/include/
cp utils/tmp/linux-7.2/fs/ext4/{ext4_extents.h,mballoc.h} dummy/include/

cp utils/tmp/linux-7.2/.clang-format dummy/.clang-format

echo "Copied 8 source files and .clang-format to dummy."
wc -c dummy/src/*.c dummy/include/*.h

rm -rf utils/tmp/
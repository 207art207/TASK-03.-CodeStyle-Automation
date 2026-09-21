#!/bin/bash
set -e

mkdir -p ~/Projects/TASK-03.-CodeStyle-Automation/dummy/{src,include}

wget -O ~/Projects/TASK-03.-CodeStyle-Automation/dummy/src/ethtool.c \
https://raw.githubusercontent.com/torvalds/linux/v7.2/drivers/net/ethernet/intel/e1000e/ethtool.c

wget -O ~/Projects/TASK-03.-CodeStyle-Automation/dummy/src/manage.c \
https://raw.githubusercontent.com/torvalds/linux/v7.2/drivers/net/ethernet/intel/e1000e/manage.c

wget -O ~/Projects/TASK-03.-CodeStyle-Automation/dummy/src/file.c \
https://raw.githubusercontent.com/torvalds/linux/v7.2/fs/ext4/file.c

wget -O ~/Projects/TASK-03.-CodeStyle-Automation/dummy/src/ext4_jbd2.c \
https://raw.githubusercontent.com/torvalds/linux/v7.2/fs/ext4/ext4_jbd2.c

wget -O ~/Projects/TASK-03.-CodeStyle-Automation/dummy/include/e1000.h \
https://raw.githubusercontent.com/torvalds/linux/v7.2/drivers/net/ethernet/intel/e1000e/e1000.h

wget -O ~/Projects/TASK-03.-CodeStyle-Automation/dummy/include/phy.h \
https://raw.githubusercontent.com/torvalds/linux/v7.2/drivers/net/ethernet/intel/e1000e/phy.h

wget -O ~/Projects/TASK-03.-CodeStyle-Automation/dummy/include/ext4_extents.h \
https://raw.githubusercontent.com/torvalds/linux/v7.2/fs/ext4/ext4_extents.h

wget -O ~/Projects/TASK-03.-CodeStyle-Automation/dummy/include/mballoc.h \
https://raw.githubusercontent.com/torvalds/linux/v7.2/fs/ext4/mballoc.h

wget -O ~/Projects/TASK-03.-CodeStyle-Automation/dummy/.clang-format \
https://raw.githubusercontent.com/torvalds/linux/v7.2/.clang-format
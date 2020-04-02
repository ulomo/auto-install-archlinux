# auto-install-archlinux
## 使用脚本自动安装archlinux

1. 两个脚本：`step-one.sh / step-two.sh`
2. 由于格式化磁盘的操作危险系数比较高，同时也过于灵活，格式化磁盘和挂载这两步不包含在脚本中
3. 特别重要的一点是：如果使用esp分区，那么需要将esp分区挂在到`/mnt/boot/efi`下

## 步骤

1. 将脚本复制到live system中
2. 格式化以及挂载磁盘
3. 运行`step-one.sh`，在运行结束后继续运行`step-two.sh`，然后系统就安装好了。



## 最小化

安装系统采用了最小化安装方式，唯一多安装的软件则是为了可以使用`wifi-menu`来设置无线网络的相关软件。

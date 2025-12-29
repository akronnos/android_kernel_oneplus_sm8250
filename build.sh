#!/bin/bash

export PATH=~/oneplus/prebuilts/clang-r536225/bin:~/oneplus/prebuilts/arm-gnu-toolchain-15.2.rel1-x86_64-aarch64-none-linux-gnu/bin:$PATH
export ARCH=arm64
export SUBARCH=arm64
export LLVM=1
export CROSS_COMPILE=aarch64-none-linux-gnu-
export CLANG_TRIPLE=aarch64-linux-gnu-
export KBUILD_BUILD_USER=akronnos
export KBUILD_BUILD_HOST=archlinux
rm -rf out
make O=out lemonades_defconfig
make O=out -j$(nproc --all)

mkbootimg/unpack_bootimg.py --boot_img \
mkbootimg/boot.img --format mkbootimg \
--out mkbootimg/out

cp out/arch/arm64/boot/Image \
mkbootimg/out/kernel

mkbootimg/mkbootimg.py \
--header_version 2 --os_version 15.0.0 \
--os_patch_level 2025-10 \
--kernel mkbootimg/out/kernel \
--ramdisk mkbootimg/out/ramdisk \
--dtb mkbootimg/out/dtb --pagesize 0x00001000 \
--base 0x00000000 --kernel_offset 0x00008000 \
--ramdisk_offset 0x01000000 \
--second_offset 0x00000000 \
--tags_offset 0x00000100 \
--dtb_offset 0x0000000001f00000 --board '' \
--cmdline 'androidboot.hardware=qcom androidboot.memcg=1 androidboot.usbcontroller=a600000.dwc3 cgroup.memory=nokmem,nosocket loop.max_part=7 lpm_levels.sleep_disabled=1 msm_rtb.filter=0x237 reboot=panic_warm service_locator.enable=1 swiotlb=2048' \
--output mkbootimg/out/boot.img

# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() {
kernel.string=NeOcOrE Kernel by thirdzcee @ xda
do.devicecheck=1
do.modules=1
do.cleanup=1
do.cleanuponabort=0
device.name1=h990
device.name2=elsa
device.name3=
device.name4=
device.name5=
} # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;

## AnyKernel install
dump_boot;

# init.lge.rc
# Disable LGE Root Checker Tool
replace_file init.lge.rc "0750" "init.lge.rc";
replace_file init.elsa.power.rc "0750" "init.elsa.power.rc";

write_boot;

#/tmp/anykernel/tools/fix-h990-cmdline /dev/block/bootdevice/by-name/boot;

## end install


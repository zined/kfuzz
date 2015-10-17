# kfuzz

linux kernel fuzzing toolchain based on docker/qemu/kvm/trinity. don't use it. it will break.

## requirements

 * docker
 * qemu / kvm
 
## usage

### provision debian sid docker build box

    zined@foo:~/src/kfuzz$ make docker
    #-----------------------------------
    #- setup docker
    #-----------------------------------
    docker build -t kernel .
    Sending build context to Docker daemon 79.87 kB
    [... blablabla ...]
    Successfully built 0xABADIDEA
    zined@foo:~/src/kfuzz$
    
### build a KASAN'ed kernel from current torvalds master

    zined@foo:~src/kfuzz$ make kernel
    [... blablabla ...]
    BUILD   arch/x86/boot/bzImage
    Setup is 15708 bytes (padded to 15872 bytes).
    System is 13997 kB
    CRC 9f288140
    Kernel: arch/x86/boot/bzImage is ready  (#1)
    'arch/x86/boot/bzImage' -> '/kernel/bzImage'

### build your desired init binary

#### c

    zined@foo:~/src/kfuzz$ make init_c
    [... blablabla ...]
    gcc -o initrd/init -static src/init.c
    zined@foo:~/src/kfuzz$

#### golang

    zined@foo:~/src/kfuzz$ make init_go
    [... blablabla ...]
    ( cd initrd && go build ../src/init.go )
    zined@foo:~/src/kfuzz$

#### trinity (the real fun!)

    zined@foo:~/src/kfuzz$ make init_trinity
    [... blablabla ...]
      CC    syscalls/write.o
      CC    trinity
    zined@foo:~/src/kfuzz$

### build initial ramdisk from whatever init binary you chose

    zined@foo:~/src/kfuzz$ make initrd
    [... blablabla ...]
    ( cd initrd/ && find . | cpio -o -H newc ) | gzip > initrd.gz
    6756 blocks
    zined@foo:~/src/kfuzz$

### spin up your kvm

## braindump

 * keep kernel builds, incremental, minor config changes
 * implement mechanism to pipe and evaluate KASAN through kmsg
 * random kernel configs?
 * kvm hardware configs
 

#!/bin/bash

CDIR=$(pwd)
BDIR=$CDIR/cross # build dir

######################################################################################
tput setaf 2
echo "First, make sure your system is updated and install the required prerequisites:"
#apt update
#apt upgrade
#apt install build-essential gawk git texinfo bison


#######################################################################################
tput setaf 2
echo "Step 1"
echo "create a working folder in your home:"
tput setaf 7
mkdir -p $BDIR


####################################################################################
tput setaf 2
echo "Let’s download the software that we’ll use for building the cross compiler:"
echo "Step 2"
tput setaf 7
cd $BDIR
git clone https://github.com/Sven-Moennich/binutils-2.28.git
git clone https://github.com/Sven-Moennich/gcc-6.3.0.git
git clone https://github.com/Sven-Moennich/glibc-2.24.git
git clone https://github.com/Sven-Moennich/gcc-8.1.0.git
git clone --depth=1 https://github.com/Sven-Moennich/linux.git



######################
tput setaf 2
echo "GCC also needs some prerequisites which we can download inside the source folder:"
echo "Step 4"
tput setaf 7
cd $BDIR/gcc-6.3.0
contrib/download_prerequisites
rm *.tar.*

cd $BDIR/gcc-8.1.0
contrib/download_prerequisites
rm *.tar.*



######################
tput setaf 2
echo "Step 5"
echo "Next, create a folder in which we’ll put the cross compiler and add it to the path:"
tput setaf 7
cd $BDIR
mkdir -p /opt/cross-pi-gcc
chown $USER /opt/cross-pi-gcc
export PATH=/opt/cross-pi-gcc/bin:$PATH

#######################
tput setaf 2
echo "Step 5"
echo "Copy the kernel headers in the above folder, see Raspbian documentation for more info about the kernel:"
tput setaf 7
cd $BDIR/linux
KERNEL=kernel7
make ARCH=arm INSTALL_HDR_PATH=/opt/cross-pi-gcc/arm-linux-gnueabihf headers_install


######################
tput setaf 2
echo "Next, let’s build Binutils:"
tput setaf 3
mkdir -p $BDIR/build-binutils 
cd $BDIR/build-binutils
../binutils-2.28/configure --prefix=/opt/cross-pi-gcc --target=arm-linux-gnueabihf --with-arch=armv6 --with-fpu=vfp --with-float=hard --disable-multilib
make -j 8
make install



#######################
tput setaf 2
echo "GCC and Glibc are interdependent, you can’t fully build one without the other, so we are going to do a partial build of GCC, a partial build of Glibc and finally build GCC and Glibc."
tput setaf 5
mkdir -p $BDIR/build-gcc 
cd $BDIR/build-gcc
../gcc-6.3.0/configure --prefix=/opt/cross-pi-gcc --target=arm-linux-gnueabihf --enable-languages=c,c++,fortran --with-arch=armv6 --with-fpu=vfp --with-float=hard --disable-multilib
make -j8 all-gcc
make install-gcc



##############################
tput setaf 2
echo "Now, let’s partially build Glibc:"
tput setaf 6
mkdir -p cd $BDIR/build-glibc 
cd $BDIR/build-glibc
../glibc-2.24/configure --prefix=/opt/cross-pi-gcc/arm-linux-gnueabihf --build=$MACHTYPE --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --with-arch=armv6 --with-fpu=vfp --with-float=hard --with-headers=/opt/cross-pi-gcc/arm-linux-gnueabihf/include --disable-multilib libc_cv_forced_unwind=yes
make install-bootstrap-headers=yes install-headers
make -j8 csu/subdir_lib
install csu/crt1.o csu/crti.o csu/crtn.o /opt/cross-pi-gcc/arm-linux-gnueabihf/lib
arm-linux-gnueabihf-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o /opt/cross-pi-gcc/arm-linux-gnueabihf/lib/libc.so
touch /opt/cross-pi-gcc/arm-linux-gnueabihf/include/gnu/stubs.h



############################
tput setaf 2
echo "Back to GCC:"
tput setaf 5
cd $BDIR/build-gcc
make -j8 all-target-libgcc
make install-target-libgcc


##############################
tput setaf 2
echo "Finish building Glibc:"
tput setaf 6
cd $BDIR/build-glibc
make -j8
make install



#############################
tput setaf 2
echo "Finish building GCC 6.3.0:"
tput setaf 5
cd $BDIR/build-gcc
make -j8
make install


#############
tput setaf 2
echo "At this point, you have a full cross compiler toolchain with GCC 6.3.0. Make a backup before proceeding with the next step:"
tput setaf 7
cp -r /opt/cross-pi-gcc /opt/cross-pi-gcc-6.3.0


####################################
tput setaf 2
echo "Next, we are going to use the above built Glibc to build a more modern cross compiler that will overwrite 6.3:"
tput setaf 3
mkdir -p $BDIR/build-gcc8 
cd $BDIR/build-gcc8
#../gcc-8.1.0/configure --prefix=/opt/cross-pi-gcc --target=arm-linux-gnueabihf --enable-languages=c,c++,fortran --with-arch=armv6 --with-fpu=vfp --with-float=hard --disable-multilib
#../gcc-8.1.0/configure --prefix=/opt/cross-pi-gcc --target=arm-linux-gnueabihf --enable-languages=c,c++ --with-arch=armv6 --with-fpu=vfp --with-float=hard --disable-multilib
#make -j8
#make install


################################3
tput setaf 2
echo "At this point, you can use GCC 8.1 to cross compile any C, C++ or Fortran code for your Raspberry Pi."
echo "In order to stress test our cross compiler, let’s use it to cross compile itself for the Pi:"
tput setaf 4
mkdir -p /opt/gcc-8.1.0
chown $USER /opt/gcc-8.1.0
cd ..

mkdir -p $BDIR/build-native-gcc8 
cd $BDIR/build-native-gcc8
#../gcc-8.1.0/configure --prefix=/opt/gcc-8.1.0 --build=$MACHTYPE --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --enable-languages=c,c++,fortran --with-arch=armv6 --with-fpu=vfp --with-float=hard --disable-multilib --program-suffix=-8.1.0
#make -j 8
#make install-strip


###############################
tput setaf 2
echo "If you want to permanently add the cross compiler to your path, use something like:"
tput setaf 7
cd $BDIR
#echo "export PATH=/opt/cross-pi-gcc/bin:$PATH" >> .bashrc
export PATH=/opt/cross-pi-gcc/bin:$PATH

#########################
tput setaf 2
echo "You can now, optionally, safely erase the build folder."
cd $BDIR
#rm -rf $BDIR
cd /opt
#tar -cjvf $BDIR/gcc-8.1.0.tar.bz2 gcc-8.1.0
cd $BDIR

tput setaf 7


#!/bin/bash

CDIR=$(pwd)

######################################################################################
echo "First, make sure your system is updated and install the required prerequisites:"
#apt update
#apt upgrade
#apt install build-essential gawk git texinfo bison


#######################################################################################
echo "Step 1"
echo "create a working folder in your home:"
cd $CDIR
mkdir -p gcc_all 
cd gcc_all

####################################################################################
echo "Let’s download the software that we’ll use for building the cross compiler:"
echo "Step 2"
git clone https://github.com/Sven-Moennich/binutils-2.28.git
git clone https://github.com/Sven-Moennich/gcc-6.3.0.git
git clone https://github.com/Sven-Moennich/glibc-2.24.git
git clone https://github.com/Sven-Moennich/gcc-8.1.0.git
git clone --depth=1 https://github.com/Sven-Moennich/linux.git
cd ..


######################
echo "GCC also needs some prerequisites which we can download inside the source folder:"
echo "Step 4"
cd gcc_all
cd gcc-6.3.0
contrib/download_prerequisites
rm *.tar.*
cd ..
cd gcc-8.1.0
contrib/download_prerequisites
rm *.tar.*




######################
echo "Step 5"
echo "Next, create a folder in which we’ll put the cross compiler and add it to the path:"
mkdir -p /opt/cross-pi-gcc
chown $USER /opt/cross-pi-gcc
export PATH=/opt/cross-pi-gcc/bin:$PATH

#######################
echo "Step 5"
echo "Copy the kernel headers in the above folder, see Raspbian documentation for more info about the kernel:"
cd ..
cd linux
KERNEL=kernel7
make ARCH=arm INSTALL_HDR_PATH=/opt/cross-pi-gcc/arm-linux-gnueabihf headers_install


######################
echo "Next, let’s build Binutils:"
cd .. 
mkdir -p build-binutils 
cd build-binutils
../binutils-2.28/configure --prefix=/opt/cross-pi-gcc --target=arm-linux-gnueabihf --with-arch=armv6 --with-fpu=vfp --with-float=hard --disable-multilib
make -j 8
make install



#######################
echo "GCC and Glibc are interdependent, you can’t fully build one without the other, so we are going to do a partial build of GCC, a partial build of Glibc and finally build GCC and Glibc."
cd ..
mkdir -p build-gcc 
cd build-gcc
../gcc-6.3.0/configure --prefix=/opt/cross-pi-gcc --target=arm-linux-gnueabihf --enable-languages=c,c++,fortran --with-arch=armv6 --with-fpu=vfp --with-float=hard --disable-multilib
make -j8 all-gcc
make install-gcc



##############################
echo "Now, let’s partially build Glibc:"
cd ..
mkdir -p build-glibc 
cd build-glibc
../glibc-2.24/configure --prefix=/opt/cross-pi-gcc/arm-linux-gnueabihf --build=$MACHTYPE --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --with-arch=armv6 --with-fpu=vfp --with-float=hard --with-headers=/opt/cross-pi-gcc/arm-linux-gnueabihf/include --disable-multilib libc_cv_forced_unwind=yes
make install-bootstrap-headers=yes install-headers
make -j8 csu/subdir_lib
install csu/crt1.o csu/crti.o csu/crtn.o /opt/cross-pi-gcc/arm-linux-gnueabihf/lib
arm-linux-gnueabihf-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o /opt/cross-pi-gcc/arm-linux-gnueabihf/lib/libc.so
touch /opt/cross-pi-gcc/arm-linux-gnueabihf/include/gnu/stubs.h



############################
echo "Back to GCC:"
cd ..
cd build-gcc
make -j8 all-target-libgcc
make install-target-libgcc


##############################
echo "Finish building Glibc:"
cd ..
cd build-glibc
make -j8
make install



#############################
echo "Finish building GCC 6.3.0:"
cd ..
cd build-gcc
make -j8
make install
cd ..


#############
echo "At this point, you have a full cross compiler toolchain with GCC 6.3.0. Make a backup before proceeding with the next step:"
cp -r /opt/cross-pi-gcc /opt/cross-pi-gcc-6.3.0


####################################
echo "Next, we are going to use the above built Glibc to build a more modern cross compiler that will overwrite 6.3:"
mkdir build-gcc8 
cd build-gcc8
#../gcc-8.1.0/configure --prefix=/opt/cross-pi-gcc --target=arm-linux-gnueabihf --enable-languages=c,c++,fortran --with-arch=armv6 --with-fpu=vfp --with-float=hard --disable-multilib
#../gcc-8.1.0/configure --prefix=/opt/cross-pi-gcc --target=arm-linux-gnueabihf --enable-languages=c,c++ --with-arch=armv6 --with-fpu=vfp --with-float=hard --disable-multilib
#make -j8
#make install


################################3
echo "At this point, you can use GCC 8.1 to cross compile any C, C++ or Fortran code for your Raspberry Pi."
echo "In order to stress test our cross compiler, let’s use it to cross compile itself for the Pi:"
#mkdir -p /opt/gcc-8.1.0
#chown $USER /opt/gcc-8.1.0
cd ..

#mkdir build-native-gcc8 
#cd build-native-gcc8
#../gcc-8.1.0/configure --prefix=/opt/gcc-8.1.0 --build=$MACHTYPE --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --enable-languages=c,c++,fortran --with-arch=armv6 --with-fpu=vfp --with-float=hard --disable-multilib --program-suffix=-8.1.0
#make -j 8
#make install-strip


###############################
echo "If you want to permanently add the cross compiler to your path, use something like:"
cd $CDIR
echo "export PATH=/opt/cross-pi-gcc/bin:$PATH" >> .bashrc
export PATH=/opt/cross-pi-gcc/bin:$PATH

#########################
echo "You can now, optionally, safely erase the build folder."
cd $CDIR
#rm -rf gcc_all
cd /opt
#tar -cjvf $CDIR/gcc-8.1.0.tar.bz2 gcc-8.1.0
cd $CDIR

###################################
#echo "build libupnp"
#make libupnp
#cd libupnp
#./configure -prefix=/opt/libupnp  --host=arm-linux-gnueabihf  CC=arm-linux-gnueabihf-gcc CPPFLAGS="-I/opt/cross-pi-gcc/arm-linux-gnueabihf/include/" LDFLAGS="-Wl,-rpath-link=/opt/cross-pi-gcc/arm-linux-gnueabihf/lib/ -L/opt/cross-pi-gcc/arm-linux-gnueabihf/lib/" LIBS="-lc" 
#make
#make install

#mkdir -p w48-image-builder/src/usr/local/include/
#mkdir -p w48-image-builder/src/usr/local/lib/

#cp -r /opt/libupnp/include w48-image-builder/src/usr/local/include/
#cp -r /opt/libupnp/lib/* w48-image-builder/src/usr/local/lib/




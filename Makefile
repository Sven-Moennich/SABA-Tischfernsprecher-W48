all:
	echo "run make build-all || make download-all"

build-all: mkversion_bin w48-image-builder w48-WebGUI_deb libupnp_bin_rpi wiringpi w48phpcmd_bin_rpi libalsa_bin_rpi w48conf_bin_rpi w48play_bin_rpi w48upnpd_bin_rpi w48rebootd_bin_rpi w48d_bin_rpi
	echo "Fertig"


download-all: w48conf w48play w48upnpd w48rebootd w48phpcmd libupnp wiringpi w48d w48-image-builder w48-WebGUI mkversion mkpasswd lib-alsa

clean:
	rm -rf  w48rebootd
	rm -rf  w48-WebGUI
	rm -rf  w48phpcmd
	rm -rf  w48-image-builder
	rm -rf  w48d
	rm -rf  libupnp
	rm -rf  w48upnpd
	rm -rf  mkversion
	rm -rf  w48play
	rm -rf  mkpasswd
	rm -rf  wiringpi
	rm -rf  gcc_all
	rm -rf  w48conf
	rm -f *.deb
	rm -rf  lib-alsa


##################################### cross
cross:
	./make.sh
	touch cross


#######################################################################
##################################### w48conf
w48conf: 
	git clone https://github.com/Sven-Moennich/w48conf.git

##################################### w48conf_bin
w48conf_bin: w48conf
	cd w48conf && make

##################################### w48conf_bin
w48conf_bin_rpi: w48conf
	cd w48conf && make

##################################### w48conf_deb
w48conf_deb: w48conf_bin
	cd w48conf && ./mkdeb.sh 4



#######################################################################
##################################### lib-alsa
lib-alsa: 
	git clone https://github.com/Sven-Moennich/lib-alsa.git

##################################### lib-alsa_bin
lib-alsa_bin_rpi: lib-alsa cross
	cd lib-alsa && \
./configure -prefix=/opt/libalsa  \
--host=arm-linux-gnueabihf  \
CC=arm-linux-gnueabihf-gcc \
CPPFLAGS="-I/opt/cross-pi-gcc/arm-linux-gnueabihf/include/" \
LDFLAGS="-Wl,-rpath-link=/opt/cross-pi-gcc/arm-linux-gnueabihf/lib/ \
-L/opt/cross-pi-gcc/arm-linux-gnueabihf/lib/" \
LIBS="-lc" && make && make install

##################################### lib-alsa_deb
lib-alsa_deb: lib-alsa_bin_rpi
	cd lib-alsa && ./mkdeb.sh 4



#####################################################################
##################################### w48play
w48play: 
	git clone https://github.com/Sven-Moennich/w48play.git

##################################### w48play_bin
w48play_bin: w48play
	cd w48play && make

##################################### w48play_bin
w48play_bin_rpi: w48play libalsa_bin_rpi
	cd w48play && make build-rpi

##################################### w48play_deb
w48play_deb: w48play_bin
	cd w48play && ./mkdeb.sh 4



########################################################################
##################################### w48upnpd
w48upnpd:
	git clone https://github.com/Sven-Moennich/w48upnpd.git

##################################### w48upnpd_bin
w48upnpd_bin: w48upnpd libupnp_bin 
	cd w48upnpd && make

##################################### w48upnpd_bin
w48upnpd_bin_rpi: w48upnpd libupnp_bin_rpi
	cd w48upnpd && make build-rpi

##################################### w48upnpd_deb
w48upnpd_deb: w48upnpd_bin
	cd w48upnpd && ./mkdeb.sh 4


###########################################################################
##################################### w48rebootd
w48rebootd:
	git clone https://github.com/Sven-Moennich/w48rebootd.git

##################################### w48rebootd_bin
w48rebootd_bin: w48rebootd
	cd w48rebootd && make

##################################### w48rebootd_bin
w48rebootd_bin_rpi: w48rebootd
	cd w48rebootd && make build-rpi

##################################### w48rebootd_deb
w48rebootd_deb: w48rebootd_bin
	cd w48rebootd && ./mkdeb.sh 4


###########################################################################
##################################### w48phpcmd
w48phpcmd:
	git clone https://github.com/Sven-Moennich/w48phpcmd.git

##################################### w48phpcmd_bin
w48phpcmd_bin: w48phpcmd
	cd w48phpcmd && make

##################################### w48phpcmd_bin
w48phpcmd_bin_rpi: w48phpcmd cross
	cd w48phpcmd && make build-rpi

##################################### w48phpcmd_deb
w48phpcmd_deb: w48phpcmd_bin
	cd w48phpcmd && ./mkdeb.sh 4


############################################################################
##################################### libupnp
libupnp:
	git clone https://github.com/Sven-Moennich/libupnp.git

##################################### libupnp_bin
libupnp_bin: libupnp
	cd libupnp && ./configure && make && make install

##################################### libupnp_bin_rpi
libupnp_bin_rpi: libupnp cross
	cd libupnp && \
./configure -prefix=/opt/libupnp  \
--host=arm-linux-gnueabihf  \
CC=arm-linux-gnueabihf-gcc \
CPPFLAGS="-I/opt/cross-pi-gcc/arm-linux-gnueabihf/include/" \
LDFLAGS="-Wl,-rpath-link=/opt/cross-pi-gcc/arm-linux-gnueabihf/lib/ \
-L/opt/cross-pi-gcc/arm-linux-gnueabihf/lib/" \
LIBS="-lc"  && make && make install


############################################################################
##################################### wiringpi
wiringpi:
	git clone https://github.com/Sven-Moennich/wiringpi.git


############################################################################
##################################### w48d
w48d:
	git clone https://github.com/Sven-Moennich/w48d.git

##################################### w48d_bin
w48d_bin: w48d
	cd w48d && make

##################################### w48d_bin
w48d_bin_rpi: w48d cross
	cd w48d && make build-rpi

##################################### w48d_deb
w48d_deb: w48d_bin
	cd w48d && ./mkdeb.sh 4


#############################################################################
###################################### w48-image-builder
w48-image-builder:
	git clone https://github.com/Sven-Moennich/w48-image-builder.git


############################################################################
####################################### w48-WebGUI
w48-WebGUI: 
	git clone https://github.com/Sven-Moennich/w48-WebGUI.git

w48-WebGUI_deb: w48-WebGUI
	cd w48-WebGUI && ./mkdeb.sh 4 && cp *.deb ../w48-image-builder/src/usr/src/


###########################################################################
######################################## mkversion
mkversion:
	git clone https://github.com/Sven-Moennich/mkversion.git

mkversion_bin: mkversion
	cd mkversion && make && make install

mkversion_bin_rpi: mkversion cross
	cd mkversion && make build-rpi && make install-rpi

mkversion_deb: mkversion_bin
	cd mkversion && ./mkdeb.sh 4

##########################################################################
######################################### mkpasswd

mkpasswd:
	git clone https://github.com/Sven-Moennich/mkpasswd.git

mkpasswd_bin: mkpasswd
	cd mkpasswd && make && make install

mkpasswd_bin_rpi: cross mkpasswd
	cd mkpasswd && make build-rpi

mkpasswd_deb: mkpasswd_bin
	cd mkpasswd && ./mkdeb.sh 4


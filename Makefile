.PHONY : all
all:
	@echo "run make build-all         || make build-all_rpi  || make download-all"
	@echo "run make changemac         || make changemac_bin  || make changemac_bin_rpi  || make changemac_deb   || make changemac_deb_rpi"
	@echo "run make mkversion         || make mkversion_bin  || make mkversion_bin_rpi"
	@echo "run make w48-image-builder "
	@echo "run make w48-WebGUI        || make w48-WebGUI_deb"
	@echo "run make libupnp           || make libupnp_bin    || make libupnp_bin_rpi"
	@echo "run make lib-alsa          || make lib-alsa_bin   || make lib-alsa_bin_rpi"
	@echo "run make wiringpi          || make wiringpi_bin   || make wiringpi_bin_rpi"
	@echo "run make w48phpcmd         || make w48phpcmd_bin  || make w48phpcmd_bin_rpi  || make w48phpcmd_deb  || make w48phpcmd_deb_rpi"
	@echo "run make w48conf           || make w48conf_bin    || make w48conf_bin_rpi    || make w48conf_deb    || make w48conf_deb_rpi"
	@echo "run make w48play           || make w48play_bin    || make w48play_bin_rpi    || make w48play_deb    || make w48play_deb_rpi"
	@echo "run make w48upnpd          || make w48upnpd_bin   || make w48upnpd_bin_rpi   || make w48upnpd_deb   || make w48upnpd_deb_rpi"
	@echo "run make w48rebootd        || make w48rebootd_bin || make w48rebootd_bin_rpi || make w48rebootd_deb || make w48rebootd_deb_rpi"
	@echo "run make w48d              || make w48d_bin       || make w48d_bin_rpi       || make w48d_deb       || make w48d_deb_rpi"
	@echo "run make cross             || make cross_tar"
	@echo "run make clean"

.PHONY : build-all
build-all : w48-image-builder changemac mkversion_bin w48-WebGUI_deb mkversion_deb_rpi w48rebootd_deb_rpi w48phpcmd_deb_rpi w48conf_deb_rpi lib-alsa_bin_rpi libupnp_bin_rpi wiringpi_bin_rpi w48play_deb_rpi w48upnpd_deb_rpi w48d_deb_rpi w48-image-builder_bin
	echo "Fertig"

.PHONY : download-all
download-all : w48conf w48play w48upnpd w48rebootd w48phpcmd libupnp wiringpi w48d w48-image-builder w48-WebGUI mkversion mkpasswd lib-alsa


.PHONY : clean
clean :
	rm -rf  w48rebootd
	rm -rf  changemac
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
	rm -rf  cross
	rm -rf /opt/cross-pi-gcc
	rm -rf /opt/cross-pi-gcc-6.3.0
	rm -rf /opt/cross-pi-libs
#	rm -rf /opt/gcc-8.1.0
	rm -f *.ok

##################################### cross
.PHONY : cross
cross : cross.ok

cross.ok :
	./make.sh
	touch cross.ok

#############################################################################
###################################### w48-image-builder
.PHONY : w48-image-builder
w48-image-builder : w48-image-builder.ok

w48-image-builder.ok :
	git clone https://github.com/Sven-Moennich/w48-image-builder.git
	touch w48-image-builder.ok

.PHONY : w48-image-builder_bin
w48-image-builder_bin : w48-image-builder_bin.ok

w48-image-builder_bin.ok : mkversion_bin w48-WebGUI_deb mkversion_deb_rpi w48rebootd_deb_rpi w48phpcmd_deb_rpi w48conf_deb_rpi lib-alsa_bin_rpi libupnp_bin_rpi wiringpi_bin_rpi w48play_deb_rpi w48upnpd_deb_rpi w48d_deb_rpi
	cd w48-image-builder && make image
	touch w48-image-builder_bin.ok

############################################################################
####################################### w48-WebGUI
.PHONY : w48-WebGUI
w48-WebGUI : w48-WebGUI.ok

w48-WebGUI.ok : 
	git clone https://github.com/Sven-Moennich/w48-WebGUI.git
	touch w48-WebGUI.ok

.PHONY : w48-WebGUI_deb
w48-WebGUI_deb : w48-WebGUI_deb.ok

w48-WebGUI_deb.ok : w48-WebGUI.ok
	cd w48-WebGUI && ./mkdeb.sh 4
	touch w48-WebGUI_deb.ok

#######################################################################
##################################### w48conf
.PHONY : changemac
changemac : changemac.ok

changemac.ok :
	git clone https://github.com/Sven-Moennich/changemac.git
	touch changemac.ok

.PHONY : changemac_bin
changemac_bin : changemac_bin.ok

changemac_bin.ok : changemac.ok
	cd changemac && make
	touch changemac_bin.ok

.PHONY : changemac_bin_rpi
changemac_bin_rpi : changemac_bin_rpi.ok

changemac_bin_rpi.ok : changemac.ok
	cd changemac && make
	touch changemac_bin_rpi.ok

.PHONY : changemac_deb
changemac_deb : changemac_deb.ok

changemac_deb.ok : changemac_bin.ok
	cd changemac && ./mkdeb.sh 4
	touch changemac_deb.ok

.PHONY : changemac_deb_rpi
changemac_deb_rpi : changemac_deb_rpi.ok

changemac_deb_rpi.ok : changemac_bin_rpi.ok
	cd changemac && ./mkdeb.sh 4
	touch changemac_deb_rpi.ok


#######################################################################
##################################### w48conf
.PHONY : w48conf
w48conf : w48conf.ok

w48conf.ok :
	git clone https://github.com/Sven-Moennich/w48conf.git
	touch w48conf.ok

.PHONY : w48conf_bin
w48conf_bin : w48conf_bin.ok

w48conf_bin.ok : w48conf.ok
	cd w48conf && make
	touch w48conf_bin.ok

.PHONY : w48conf_bin_rpi
w48conf_bin_rpi : w48conf-bin_rpi.ok

w48conf_bin_rpi.ok : w48conf.ok
	cd w48conf && make
	touch w48conf_bin_rpi.ok

.PHONY : w48conf_deb
w48conf_deb : w48conf_deb.ok

w48conf_deb.ok : w48conf_bin.ok
	cd w48conf && ./mkdeb.sh 4
	touch w48conf_deb.ok

.PHONY : w48conf_deb_rpi
w48conf_deb_rpi : w48conf_deb_rpi.ok

w48conf_deb_rpi.ok : w48conf_bin_rpi.ok
	cd w48conf && ./mkdeb.sh 4
	touch w48conf_deb_rpi.ok


#######################################################################
##################################### lib-alsa ToDo
.PHONY : lib-alsa
lib-alsa : lib-alsa.ok

lib-alsa.ok :
	git clone https://github.com/Sven-Moennich/lib-alsa.git
	touch lib-alsa.ok

##################################### lib-alsa_bin
.PHONY : lib-alsa_bin_rpi
lib-alsa_bin_rpi : lib-alsa.ok

lib-alsa_bin_rpi.ok : w48-image-builder.ok lib-alsa.ok cross.ok
	cd lib-alsa && ./configure -prefix=/opt/cross-pi-libs  --host=arm-linux-gnueabihf  CC=arm-linux-gnueabihf-gcc CPPFLAGS="-I/opt/cross-pi-gcc/arm-linux-gnueabihf/include/" LDFLAGS="-Wl,-rpath-link=/opt/cross-pi-gcc/arm-linux-gnueabihf/lib/ -L/opt/cross-pi-gcc/arm-linux-gnueabihf/lib/" LIBS="-lc"
	cd lib-alsa && make 
	cd lib-alsa && make install
#mkdir -p w48-image-builder/src/usr/local/include/
#mkdir -p w48-image-builder/src/usr/local/lib/
#cp -r /opt/cross-pi-libs/include/* w48-image-builder/src/usr/local/include/
#cp -r /opt/cross-pi-libs/lib/* w48-image-builder/src/usr/local/lib/
	touch lib-alsa_bin_rpi.ok

.PHONY : lib-alsa_deb_rpi
lib-alsa_deb_rpi : lib-alsa_deb_rpi.ok

lib-alsa_deb_rpi.ok : lib-alsa_bin_rpi.ok
	cd lib-alsa && ./mkdeb.sh 4
	touch lib-alsa_deb_rpi.ok


#####################################################################
##################################### w48play
.PHONY : w48play
w48play : w48play.ok

w48play.ok :
	git clone https://github.com/Sven-Moennich/w48play.git
	touch w48play.ok

.PHONY : w48play_bin
w48play_bin : w48play_bin.ok

w48play_bin.ok : w48play.ok
	cd w48play && make
	touch w48play_bin.ok

.PHONY : w48play_bin_rpi
w48play_bin_rpi : w48play_bin_rpi.ok

w48play_bin_rpi.ok : w48play.ok lib-alsa_bin_rpi.ok
	cd w48play && make build-rpi
	touch w48play_bin_rpi.ok

.PHONY : w48play_deb
w48play_deb : w48play_deb.ok

w48play_deb.ok : w48play_bin.ok
	cd w48play && ./mkdeb.sh 4
	touch w48play_deb.ok

.PHONY : w48play_deb_rpi
w48play_deb_rpi : w48play_deb_rpi.ok

w48play_deb_rpi.ok : w48play_bin_rpi.ok
	cd w48play && ./mkdeb.sh 4
	touch w48play_deb_rpi.ok


########################################################################
##################################### w48upnpd
.PHONY : w48upnpd
w48upnpd : w48upnpd.ok

w48upnpd.ok :
	git clone https://github.com/Sven-Moennich/w48upnpd.git
	touch w48upnpd.ok

.PHONY : w48upnpd_bin
w48upnpd_bin : w48upnpd_bin.ok

w48upnpd_bin.ok : w48upnpd.ok libupnp_bin.ok
	cd w48upnpd && make
	touch w48upnpd_bin.ok

.PHONY : w48upnpd_bin_rpi
w48upnpd_bin_rpi : w48upnpd_bin_rpi.ok

w48upnpd_bin_rpi.ok : w48upnpd.ok libupnp_bin_rpi.ok
	cd w48upnpd && make build-rpi
	touch w48upnpd_bin_rpi.ok

.PHONY : w48upnpd_deb
w48upnpd_deb : w48upnpd_deb.ok

w48upnpd_deb.ok : w48upnpd_bin.ok
	cd w48upnpd && ./mkdeb.sh 4
	touch w48upnpd_deb.ok

.PHONY : w48upnpd_deb_rpi
w48upnpd_deb_rpi : w48upnpd_deb_rpi.ok

w48upnpd_deb_rpi.ok : w48upnpd_bin_rpi.ok
	cd w48upnpd && ./mkdeb.sh 4
	touch w48upnpd_deb_rpi.ok


###########################################################################
##################################### w48rebootd
.PHONY : w48rebootd
w48rebootd : w48rebootd.ok

w48rebootd.ok :
	git clone https://github.com/Sven-Moennich/w48rebootd.git
	touch w48rebootd.ok

.PHONY : w48rebootd_bin
w48rebootd_bin : w48rebootd_bin.ok

w48rebootd_bin.ok : w48rebootd.ok
	cd w48rebootd && make
	touch w48rebootd_bin.ok

.PHONY : w48rebootd_bin_rpi
w48rebootd_bin_rpi : w48rebootd_bin_rpi.ok

w48rebootd_bin_rpi.ok : w48rebootd.ok
	cd w48rebootd && make build-rpi
	touch w48rebootd_bin_rpi.ok

.PHONY : w48rebootd_deb
w48rebootd_deb : w48rebootd_deb.ok

w48rebootd_deb.ok : w48rebootd_bin.ok
	cd w48rebootd && ./mkdeb.sh 4
	touch w48rebootd_deb.ok

.PHONY : w48rebootd_deb_rpi
w48rebootd_deb_rpi : w48rebootd_deb_rpi.ok

w48rebootd_deb_rpi.ok : w48rebootd_bin_rpi.ok
	cd w48rebootd && ./mkdeb.sh 4
	touch w48rebootd_deb_rpi.ok

###########################################################################
##################################### w48phpcmd
.PHONY : w48phpcmd
w48phpcmd : w48phpcmd.ok

w48phpcmd.ok :
	git clone https://github.com/Sven-Moennich/w48phpcmd.git
	touch w48phpcmd.ok

.PHONY : w48phpcmd
w48phpcmd : w48phpcmd.ok

w48phpcmd_bin.ok : w48phpcmd.ok
	cd w48phpcmd && make
	touch w48phpcmd_bin.ok

.PHONY : w48phpcmd_bin_rpi
w48phpcmd_bin_rpi : w48phpcmd_bin_rpi.ok

w48phpcmd_bin_rpi.ok : w48phpcmd.ok cross.ok
	cd w48phpcmd && make build-rpi
	touch w48phpcmd_bin_rpi.ok

.PHONY : w48phpcmd_deb
w48phpcmd_deb : w48phpcmd_deb.ok

w48phpcmd_deb.ok : w48phpcmd_bin.ok
	cd w48phpcmd && ./mkdeb.sh 4
	touch w48phpcmd_deb.ok

.PHONY : w48phpcmd_deb_rpi
w48phpcmd_deb_rpi : w48phpcmd_deb_rpi.ok

w48phpcmd_deb_rpi.ok : w48phpcmd_bin_rpi.ok
	cd w48phpcmd && ./mkdeb.sh 4
	touch w48phpcmd_deb_rpi.ok


############################################################################
##################################### libupnp
.PHONY : libupnp
libupnp : libupnp.ok

libupnp.ok :
	git clone https://github.com/Sven-Moennich/libupnp.git
	touch libupnp.ok

.PHONY : libupnp_bin
libupnp_bin : libupnp_bin.ok

libupnp_bin.ok : libupnp.ok
	cd libupnp && ./configure && make && make install
	touch libupnp_bin.ok

.PHONY : libupnp_bin_rpi
libupnp_bin_rpi : libupnp_bin_rpi.ok

libupnp_bin_rpi.ok : libupnp.ok w48-image-builder.ok cross.ok
	cd libupnp && ./configure -prefix=/opt/cross-pi-libs --host=arm-linux-gnueabihf  CC=arm-linux-gnueabihf-gcc CPPFLAGS="-I/opt/cross-pi-gcc/arm-linux-gnueabihf/include/" LDFLAGS="-Wl,-rpath-link=/opt/cross-pi-gcc/arm-linux-gnueabihf/lib/ -L/opt/cross-pi-gcc/arm-linux-gnueabihf/lib/" LIBS="-lc"
	cd libupnp && make
	cd libupnp && make install
#	mkdir -p w48-image-builder/src/usr/local/include/
#	mkdir -p w48-image-builder/src/usr/local/lib/
#	cp -r /opt/cross-pi-libs/include/* w48-image-builder/src/usr/local/include/
#	cp -r /opt/cross-pi-libs/lib/* w48-image-builder/src/usr/local/lib/
	touch libupnp_bin_rpi.ok

############################################################################
##################################### wiringpi
.PHONY : wiringpi
wiringpi : wiringpi.ok

wiringpi.ok :
	git clone https://github.com/Sven-Moennich/wiringpi.git
	touch wiringpi.ok

.PHONY : wiringpi_bin
wiringpi_bin : wiringpi_bin.ok

wiringpi_bin.ok : wiringpi.ok
	cd wiringpi && ./build
	touch wiringpi_bin.ok

.PHONY : wiringpi_bin_rpi
wiringpi_bin_rpi : wiringpi_bin_rpi.ok

wiringpi_bin_rpi.ok : wiringpi.ok
	cd wiringpi && ./build
	touch wiringpi_bin_rpi.ok


############################################################################
##################################### w48d
.PHONY : w48d
w48d : w48d.ok

w48d.ok :
	git clone https://github.com/Sven-Moennich/w48d.git
	touch w48d.ok

.PHONY : w48d_bin
w48d_bin : w48d_bin.ok

w48d_bin.ok : w48d.ok wiringpi_bin.ok
	cd w48d && make
	touch w48d_bin.ok

.PHONY : w48d_bin_rpi
w48d_bin_rpi : w48d_bin_rpi.ok

w48d_bin_rpi.ok : w48d.ok wiringpi_bin.ok cross.ok
	cd w48d && make build-rpi
	touch w48d_bin_rpi.ok

.PHONY : w48d_deb
w48d_deb : w48d_deb.ok

w48d_deb.ok : w48d_bin.ok
	cd w48d && ./mkdeb.sh 4
	touch w48d_deb.ok

.PHONY : w48d_deb_rpi
w48d_deb_rpi : w48d_deb_rpi.ok

w48d_deb_rpi.ok : w48d_bin_rpi.ok
	cd w48d && ./mkdeb.sh 4
	touch w48d_deb_rpi.ok



###########################################################################
######################################## mkversion
.PHONY : mkversion
mkversion : mkversion.ok

mkversion.ok :
	git clone https://github.com/Sven-Moennich/mkversion.git
	touch mkversion.ok

.PHONY : mkversion_bin
mkversion_bin : mkversion_bin.ok

mkversion_bin.ok : mkversion.ok
	cd mkversion && make && make install
	touch mkversion_bin.ok

.PHONY : mkversion_bin_rpi
mkversion_bin_rpi : mkversion_bin_rpi.ok

mkversion_bin_rpi.ok : mkversion.ok cross.ok
	cd mkversion && make build-rpi && make install-rpi
	touch mkversion_bin_rpi.ok

.PHONY : mkversion_deb
mkversion_deb : mkversion_deb.ok

mkversion_deb.ok : mkversion_bin.ok
	cd mkversion && ./mkdeb.sh 4
	touch mkversion_deb.ok

.PHONY : mkversion_deb_rpi
mkversion_deb_rpi : mkversion_deb_rpi.ok

mkversion_deb_rpi.ok : mkversion_bin_rpi.ok
	cd mkversion && ./mkdeb.sh 4
	touch mkversion_deb_rpi.ok


##########################################################################
######################################### mkpasswd
.PHONY : mkpasswd
mkpasswd : mkpasswd.ok

mkpasswd.ok :
	git clone https://github.com/Sven-Moennich/mkpasswd.git
	touch mkpasswd.ok

.PHONY : mkpasswd_bin
mkpasswd_bin : mkpasswd_bin.ok

mkpasswd_bin.ok : mkpasswd.ok
	cd mkpasswd && make && make install
	touch mkpasswd_bin.ok

.PHONY : mkpasswd_bin_rpi
mkpasswd_bin_rpi : mkpasswd_bin_rpi.ok

mkpasswd_bin_rpi.ok : cross.ok mkpasswd.ok
	cd mkpasswd && make build-rpi
	touch mkpasswd_bin_rpi.ok

.PHONY : mkpasswd_deb
mkpasswd_deb : mkpasswd_deb.ok

mkpasswd_deb.ok : mkpasswd_bin.ok
	cd mkpasswd && ./mkdeb.sh 4
	touch mkpasswd_deb.ok

.PHONY : mkpasswd_deb_rpi
mkpasswd_deb_rpi : mkpasswd_deb_rpi.ok

mkpasswd_deb_rpi.ok : mkpasswd_bin_rpi.ok
	cd mkpasswd && ./mkdeb.sh 4
	touch mkpasswd_deb_rpi.ok


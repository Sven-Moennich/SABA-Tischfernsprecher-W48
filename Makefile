all:
	echo "run make build-all || make all-rpi"

build-all: w48-image-builder w48-WebGUI mkversion_bin mkpasswd_bin w48d wiringpi libupnp w48phpcmd w48rebootd w48upnpd w48play w48conf_deb
	echo "Fertig"

all-rpi: w48-image-builder mkpasswd_deb w48d_deb w48phpcmd_deb w48rebootd_deb w48upnpd_deb w48play_deb w48conf_deb
	echo "Fertig"


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


##################################### cross
cross:
	./make.sh



#######################################################################
##################################### w48conf
w48conf: 
	git clone https://github.com/Sven-Moennich/w48conf.git

##################################### w48conf_bin
w48conf_bin: w48conf
	cd w48conf && make

##################################### w48conf_deb
w48conf_deb: w48conf_bin
	cd w48conf && ./mkdeb.sh 4




#####################################################################
##################################### w48play
w48play: 
	git clone https://github.com/Sven-Moennich/w48play.git

##################################### w48play_bin
w48play_bin: w48play
	cd w48play && make

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

mkversion_deb: mkversion_bin
	cd mkversion && ./mkdeb.sh 4

##########################################################################
######################################### mkpasswd

mkpasswd:
	git clone https://github.com/Sven-Moennich/mkpasswd.git

mkpasswd_bin: mkpasswd
	cd mkpasswd && make && make install

mkpasswd_bin_cross: cross mkpasswd
	cd mkpasswd && make cross

mkpasswd_deb: mkpasswd_bin
	cd mkpasswd && ./mkdeb.sh 4

mkpasswd_deb_cross: mkpasswd_bin_cross
	cd mkpasswd && ./mkdeb.sh 4

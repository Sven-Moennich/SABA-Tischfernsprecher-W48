all:
	echo "Nichts zu tun"

build-all: w48-image-builder w48-WebGUI_deb mkversion_bin mkpasswd_bin w48d wiringpi libupnp w48phpcmd w48rebootd w48upnpd w48play w48conf_deb
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


##################################### cross
cross:
	./make.sh

##################################### w48conf
w48conf: 
	git clone https://github.com/Sven-Moennich/w48conf.git

##################################### w48conf_deb
w48conf_deb: w48conf
	cd w48conf && ./mkdeb.sh


##################################### w48play
w48play: 
	git clone https://github.com/Sven-Moennich/w48play.git

##################################### w48upnpd
w48upnpd:
	git clone https://github.com/Sven-Moennich/w48upnpd.git


##################################### w48rebootd
w48rebootd:
	git clone https://github.com/Sven-Moennich/w48rebootd.git

##################################### w48phpcmd
w48phpcmd:
	git clone https://github.com/Sven-Moennich/w48phpcmd.git

##################################### libupnp
libupnp:
	git clone https://github.com/Sven-Moennich/libupnp.git

##################################### wiringpi
wiringpi:
	git clone https://github.com/Sven-Moennich/wiringpi.git


##################################### w48d
w48d:
	git clone https://github.com/Sven-Moennich/w48d.git


###################################### w48-image-builder
w48-image-builder:
	git clone https://github.com/Sven-Moennich/w48-image-builder.git


####################################### w48-WebGUI
w48-WebGUI: 
	git clone https://github.com/Sven-Moennich/w48-WebGUI.git

w48-WebGUI_deb: w48-WebGUI
	cd w48-WebGUI && ./mkdeb.sh && cp *.deb ../w48-image-builder/src/usr/src/

######################################## mkversion
mkversion:
	git clone https://github.com/Sven-Moennich/mkversion.git

mkversion_bin: mkversion
	cd mkversion && make && make install

mkversion_deb: mkversion_bin
	cd mkversion && ./mkdeb.sh

######################################### mkpasswd

mkpasswd:
	git clone https://github.com/Sven-Moennich/mkpasswd.git

mkpasswd_bin: mkpasswd
	cd mkpasswd && make && make install

mkpasswd_bin_cross: cross mkpasswd
	cd mkpasswd && make cross

mkpasswd_deb: mkpasswd_bin
	cd mkpasswd && ./mkdeb.sh

mkpasswd_deb_cross: mkpasswd_bin_cross
	cd mkpasswd && ./mkdeb.sh

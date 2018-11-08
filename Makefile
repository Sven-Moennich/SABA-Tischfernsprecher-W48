init:
	git clone https://github.com/Sven-Moennich/w48rebootd.git
	git clone https://github.com/Sven-Moennich/w48-WebGUI.git
	git clone https://github.com/Sven-Moennich/w48phpcmd.git
	git clone https://github.com/Sven-Moennich/w48-image-builder.git
	git clone https://github.com/Sven-Moennich/w48d.git
	git clone https://github.com/Sven-Moennich/libupnp.git
	git clone https://github.com/Sven-Moennich/upnpd.git
	git clone https://github.com/Sven-Moennich/mkversion.git
	git clone https://github.com/Sven-Moennich/w48play.git

clean:
	rm -rf  w48rebootd
	rm -rf  w48-WebGUI
	rm -rf  w48phpcmd
	rm -rf  w48-image-builder
	rm -rf  w48d
	rm -rf  libupnp
	rm -rf  upnpd
	rm -rf  mkversion
	rm -rf  w48play

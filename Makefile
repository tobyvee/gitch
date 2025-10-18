.PHONY: install uninstall

install:
	cp -v gitch.sh /usr/local/bin/gitch
	chmod +x /usr/local/bin/gitch

uninstall:
	rm /usr/local/bin/gitch
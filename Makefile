.PHONY: install uninstall

install:
	cp -v sg.sh /usr/local/bin/sg
	chmod +x /usr/local/bin/sg

uninstall:
	rm /usr/local/bin/sg
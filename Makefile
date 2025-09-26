.PHONY: install uninstall

install:
	sudo cp sg.sh /usr/local/bin/sg
	chmod +x /usr/local/bin/sg

uninstall:
	sudo rm /usr/local/bin/sg
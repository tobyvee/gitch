.PHONY: install uninstall release

install:
	cp -v gitch.sh /usr/local/bin/gitch
	chmod +x /usr/local/bin/gitch

uninstall:
	rm /usr/local/bin/gitch

release:
	@if [ -z "$(TAG)" ]; then \
		echo "Usage: make release TAG=v1.0.0"; exit 1; \
	fi
	@if ! echo "$(TAG)" | grep -Eq '^v[0-9]+\.[0-9]+\.[0-9]+$$'; then \
		echo "Error: TAG must match vX.Y.Z (got: $(TAG))"; exit 1; \
	fi
	git tag -a "$(TAG)" -m "Release $(TAG)"
	git push origin "$(TAG)"
.PHONY: bluecmd-work
bluecmd-work:
	podman build -t cmd.nu/bluecmd-work .
	# Kill any existing instances
	podman rm -f bluecmd-work

bluecmd-debian:
	podman build -t cmd.nu/bluecmd-debian -f debian.dockerfile .
	podman rm -f bluecmd-debian


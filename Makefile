.PHONY: bluecmd-work
bluecmd-work:
	podman build -t cmd.nu/bluecmd-work .
	# Kill any existing instances
	podman rm -f bluecmd-work

.PHONY: bluecmd-work
bluecmd-work:
	docker build -t cmd.nu/bluecmd-work .
	# Kill any existing instances
	docker rm -f bluecmd-work


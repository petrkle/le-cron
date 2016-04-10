help:
	@echo "help     - this help"
	@echo "setup    - first run"
	@echo "cert     - certificate refresh"

setup:
	./setup.sh

cert:
	./le-cron.sh

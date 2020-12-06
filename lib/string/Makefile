SHELL=/bin/bash

.PHONY: build

all: build


build:
	@for folder in $$(ls); do \
		if [ -f $$folder/Makefile ]; then \
			echo "processing folder $$folder"; \
            $(MAKE) -C $$folder; \
        fi; \
    done;
	@echo "Done!"


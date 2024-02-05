SHELL=/bin/sh

DISTFILE=libstd.a
SRCDIR=./src
OBJDIR=./obj

.PHONY: std

all: build run

pre:
	mkdir -p $(OBJDIR)

build: pre libstd.a

std:
	@for folder in $$(ls); do \
		if [ -f $$folder/Makefile ]; then \
			echo "processing folder $$folder"; \
            $(MAKE) -C $$folder; \
        fi; \
    done;
	@echo "Done!"

libstd.a: std
	#ar rcu $@ $+
	ar rcs $@ $(OBJDIR)/*.o
	ranlib $@


clean:
	@rm -rf $(DISTFILE) $(OBJDIR)

run:
	@echo "--------------------------------------------"
	@#readelf -h $(DISTFILE)
	@#echo "---"
	@#objdump -d $(DISTFILE)
	@#echo "--------------------------------------------"
	nm -go $(DISTFILE)
	@echo "--------------------------------------------"

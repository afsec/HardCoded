PROGRAM=main

LIBNAME=std

OBJDIR=./obj
SRCDIR=./src
LIBDIR=./lib

.PHONY: libstd clean

all: build run

build: pre libstd main link

pre:
	@mkdir -p $(OBJDIR)

libstd:
	$(MAKE) -C lib

main:
	riscv64-linux-gnu-as --gstabs+ -march=rv64gc -o $(OBJDIR)/$(PROGRAM).o $(SRCDIR)/$(PROGRAM).s

link:
	riscv64-linux-gnu-ld -o $(PROGRAM).exe $(OBJDIR)/$(PROGRAM).o -L./lib -l$(LIBNAME)

dist: build
	@ls -l $(PROGRAM).exe
	@strip $(PROGRAM).exe
	@mv $(PROGRAM).exe $(PROGRAM)
	@ls -l $(PROGRAM)

examples: pre libstd
	$(MAKE) -C examples

clean:
	@rm -rf $(OBJDIR) $(PROGRAM) $(PROGRAM).exe echo.exe echo_draft.exe
	$(MAKE) -C lib clean

run:
	@#echo "--------------------------------------------"
	@#objdump -D -s $(PROGRAM).exe
	@#readelf -h main.exe | grep "Entry point address:"
	@#echo "---"
	@#objdump -s -j .data $(PROGRAM).exe
	@#objdump -d $(PROGRAM).exe
	@echo "--------------------------------------------"
	./$(PROGRAM).exe ; echo $$?
	./$(PROGRAM).exe -a > /dev/null ; echo $$?
	./$(PROGRAM).exe -a -b 2> /dev/null ; echo $$?

test:
	./tests/test_echo.sh


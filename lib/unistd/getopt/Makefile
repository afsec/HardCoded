PROGRAM=getopt
SRCDIR=./src
OBJDIR=../../obj

all: build

build:
	riscv64-linux-gnu-as --gstabs+ -march=rv64gc -o $(OBJDIR)/$(PROGRAM).o $(SRCDIR)/lib.s

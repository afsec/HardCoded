PROGRAM=print_messages
SRCDIR=./src
OBJDIR=../../obj

all: build

build:
	riscv64-linux-gnu-as --gstabs+ -march=rv64gc -o $(OBJDIR)/$(PROGRAM).o $(SRCDIR)/main.s


link:
	riscv64-linux-gnu-ld -o $(PROGRAM).exe $(OBJDIR)/$(PROGRAM).o -L./lib -lstd
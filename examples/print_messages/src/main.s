# Main program

.include "../../lib/unistd/constants/exit_code.s"
.include "../../lib/unistd/constants/file_descriptor.s"

# .include "./src/print_argv0.s"
# .include "./src/get_argv.s"

.include "./src/parse_args.s"
.include "./src/print_msg.s"
.include "./src/print_error.s"
.include "./src/trigger_error.s"

.align 1

.global _start

.section .text

_start:
    # mv      s1, sp # Store (int argc) address into s1

    # Procedure call
    # addi    a0, sp, 8 # Get argv base address as argument for print_argv0
    # call    print_argv0

    ld      t1, (sp) # Get argc from Stack

    # Conditional Branch: if (argc < 2) goto main_noargs
    li      t2, 2 # valid arguments
    blt     t1, t2, main_noargs

    # Procedure call
    ld      a0, (sp) # Set `int argc` as parameter
    addi    a1, sp, 16 # Set `char *argv[]` as parameter
    call parse_args

    # Procedure call
    mv      a0, a0 # Forward parse_args return value as param for next function
    call    putchar

    # Procedure call
    li      a0, 10 # '\n'
    call    putchar

    # Procedure call
    # mv      a0, a0 # Forward strcmp return value as param for next function
    ld      a0, (sp)
    call    exit

main_noargs:
    # Procedure call
    call    print_msg

    # Procedure call
    call    print_error

    # Procedure call
    call    trigger_error

    # Last procedure call
    ld      a0, (sp) # Dereference s1 address to get argc from memory (Stack)
    # mv      a0, s1 # Get length from strcmp
    call    exit

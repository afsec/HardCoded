# Main program: echo.exe

.include "../../lib/unistd/constants/exit_code.s"
.include "../../lib/unistd/constants/file_descriptor.s"


.include "./src/parse_args.s"
.include "./src/program.s"

.align 1

.global _start

.section .text

_start:
    ld      t1, (sp) # Get argc from Stack

    # Conditional Branch: if (argc == 1) goto main_noargs
    li      t2, 1
    beq     t1, t2, main_noargs

    # Procedure call
    ld      a0, (sp) # Set `int argc` as parameter
    addi    a1, sp, 8 # Set `char *argv[0]` as parameter
    j       parse_args

main_noargs:

    # Procedure call
    li      a0, 10 # '\n'
    call    putchar

    # Last procedure call
    li      a0, EXIT_SUCCESS
    call    exit

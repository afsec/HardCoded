# echo program (Draft)

# TODO: Implement printf


.include "../../lib/unistd/constants/exit_code.s"
.include "../../lib/unistd/constants/file_descriptor.s"

.include "./src/get_argv.s"

.align 1

.global _start

.section .text

_start:
    lb      t2, (sp) # Get argc from Stack

    # Conditional Branch: if (argc == 1)
    li      t1, 1 # valid arguments
    beq     t1, t2, echo_print_newline

    # Conditional Branch: if (argc > 1)
    bgt     t2, t1, echo_parseflags


echo_print_string:
    li      s2, 0

    beqz    t4, echo_print_string_loop
    addi    s2, s2, 1 # Increment counter to check argc

echo_print_string_loop:
    addi    s2, s2, 1 # Increment counter to check argc
    ld      t1, (sp) # Get argc
    beq     s2, t1, echo_print_string_loop_last

    # Procedure call
    addi    a0, sp, 8 # Get argv base address
    mv      a1, s2
    call    get_argv
    mv      a0, a0 # Forward get_argv result (a0) as parameter to next function
    call    printf
    beqz    t4, echo_print_space



echo_print_string_loop_last:
    ld      t1, (sp) # Get argc
    blt     s2, t1, echo_print_string_loop

    bnez    t4, echo_exit_success
    li      a0, 10 # '\n'
    call    putchar
    j       echo_exit_success


echo_parseflags:
    mv      t4, zero # t4 = FALSE

    # Procedure call
    addi    a0, sp, 8
    li      a1, 1
    call    get_argv
    mv      s1, a0 # Save argv[1] base address

    # Procedure call
    mv      a0, a0 # Forward get_argv result (a0) as parameter to next function
    call    strlen


    # Conditional branch
    li      t1, 45 # '-'
    lb      t2, (s1) # Load first char from argv[1]
    bne     t1, t2, echo_print_string # if (argv[1][0] != '-') goto echo_usage

    # Conditional branch
    li      t1, 104 # 'h'
    lb      t2, 1(s1) # Load second char from argv[1]
    beq      t1, t2, echo_usage # if (argv[1][1] == 'h') goto echo_usage

    # Conditional branch
    li      t1, 110 # 'n'
    lb      t2, 1(s1) # Load second char from argv[1]
    bne     t1, t2, echo_usage # if (argv[1][1] != 'n') goto echo_usage
    li      t4, 1 # t4 = TRUE

    # Conditional branch
    li      t1, 2 # Set a valid length for argv[1] to block some arg like '-nn'
    bne     a0, t1, echo_usage # if (strlen(argv[1]) != 2) goto echo_usage


    lb      t2, (sp) # Get argc from Stack
    beq     t1, t2, echo_usage # if (strlen(argv[1]) != 2) goto echo_usage
    # Conditional branch
    # bnez     t3, echo_print_string # if (argv[1][0] != '-') goto echo_usage
    # # Conditional Branch: if (argc == 2)
    # li      t1, 2
    # beq     t2, t1, echo_print_newline
    j       echo_print_string


echo_print_space:
    li      a0, 32 # ' '
    call    putchar
    j       echo_print_string_loop_last


echo_print_newline:
    li      a0, 10 # '\n'
    call    putchar

echo_exit_success:
    li      a0, EXIT_SUCCESS
    call    exit

echo_exit_failure:
    li      a0, EXIT_FAILURE
    call    exit


echo_usage:
    la      a0, echo_msg_usage
    li      a1, FD_STDERR
    call    fputs
    j       echo_exit_failure



.section .rodata

echo_msg_usage: .string "Usage: echo [ [-h | -n] ] [\"STRING\"]"

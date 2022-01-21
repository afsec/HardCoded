# echo program (Draft)


.align 1

.section .text
# a0: OPT_FLAGS
# a1: STRING
program:
    # Prologue
    addi    sp, sp, -24 # Allocate space from stack (3 x 8 Bytes)
    sd      ra, 16(sp) # Store ra into stack
    sd      fp, 8(sp) # Store fp into stack
    addi    fp, sp, 24 # Set stack frame for current function
    sd      s1, -24(fp) # Store s1 into stack

    # Function - BEGIN
    mv      s1, a1
    beqz    a0, program_noargs
    j       program_arg_n



program_noargs:
    mv      a0, s1
    call    puts
    j       program_exit



program_arg_n:
    mv      a0, s1
    call    printf
    j       program_exit



program_exit:
    # Function - END
    # Epilogue
    ld      s1, -24(fp) # Store s1 into stack
    ld      ra, 16(sp) # Store ra into stack
    ld      fp, 8(sp) # Store fp into stack
    addi    sp, sp, 24 # Deallocate space from stack

    # Procedure call
    li      a0, EXIT_SUCCESS
    call    exit

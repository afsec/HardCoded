# Function void print_msg(void)

.align 1

.section .text
print_msg:
    # Prologue
    addi    sp, sp, -16 # Allocate space from stack
    sd      ra, 8(sp) # Store ra into stack
    sd      fp, 0(sp) # Store fp into Stack

    # Procedure call
    la      a0, print_msg_string_01
    call    puts

    # Epilogue
    ld      ra, 8(sp) # Load ra from stack
    ld      fp, 0(sp) # Load fp from stack
    addi    sp, sp, 16 # Deallocate space from stack
    ret

.section .rodata
    print_msg_string_01: .string "INFO: Lorem ipsum info."

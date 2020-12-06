# Function void print_argv0(char *argv[])

.align 1

.section .text

# a0 - 1st Param: argv base address
print_argv0:
    # Prologue
    addi    sp, sp, -16 # Allocate space from stack (4 x 8 Bytes)
    sd      ra, 8(sp) # Store ra into stack
    sd      fp, 0(sp) # Store fp into stack
    addi    fp, sp, 16 # Set current function fp

    # Procedure call
    mv      a0, a0 # Forward a0 to next function
    li      a1, 0 # Set argument to be printed (argv[0])
    call    get_argv
    mv      t1, a0 # Forward a0 to next function (String address)
    
    
    mv      a0, t1  # Set string address from t1
    call    puts

    # Epilogue
    ld      ra, 8(sp) # Load ra from stack
    ld      fp, 0(sp) # Load fp from stack

    addi    sp, sp, 16 # Deallocate space from stack          
    ret

#    Function: int strcmp(const char *s1, const char *s2);
#
# Description: The strcmp function compares the string pointed to by s1 to the
#              string pointed to by s2.
#
#     Returns: The strcmp function returns an integer greater than, equal to,
#              or less than zero, accordingly as the string pointed to by s1 is
#              greater than, equal to, or less than the string pointed to by
#              s2.


.align 1

.global strcmp
.type strcmp, @function

.section .text

# a0 - 1st param: str1 base address
# a1 - 2nd param: str2 base address
strcmp:
    # PROLOGUE
    addi    sp, sp, -32 # Allocate space from stack (4 x 8 Bytes)
    sd      ra, 24(sp) # Store ra into stack
    sd      fp, 16(sp) # Store fp into stack
    addi    fp, sp, 32 # Set current function fp
    sd      s1, -16(fp) # Store s1 into stack
    sd      s2, -24(fp) # Store s2 into stack
    sd      s3, -32(fp) # Store s3 into stack

    # FUNCTION - BEGIN
    # Local variables (s1, s2, s3)
    mv      s1, a0 # Get str1 base address
    mv      s2, a1 # Get str2 base address

    # Procedure call
    mv      a0, s1 # Set strlen 1st param: str1 base address
    call    strlen # a0 <- strlen(str1)
    mv      s3, a0 # s3 <- a0

    # Procedure call
    mv      a0, s2 # Set strlen 1st param: str2 base address
    call    strlen # a0 <- strlen(str2)
    mv      t1, a0 # t1 <- a0

    # Return value (a0)
    subw    a0, s3, t1 # a0 <- (s3 - t1) subtraction
    # FUNCTION - END

    # EPILOGUE
    ld      s1, -16(fp) # Load s1 from stack
    ld      s2, -24(fp) # Load s2 into stack
    ld      s3, -32(fp) # Load s3 into stack
    ld      ra, 24(sp) # Load ra from stack
    ld      fp, 16(sp) # Load fp from stack

    addi    sp, sp, 32 # Deallocate space from stack
    ret

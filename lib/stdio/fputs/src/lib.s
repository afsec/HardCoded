#    Function: int fputs(const char * restrict s, FILE * restrict stream);
#
# Description: The fputs function writes the string pointed to by s to the
#              stream pointed to by stream. The terminating null character is
#              not written.
#
#     Returns: The fputs function returns EOF if a write error occurs;
#              otherwise it returns a nonnegative value.

# TODO: Create "./unistd/constants/global_constants.s" with EOF(possible -1) and
#      NULL(null pointer)

.include "../../unistd/constants/linux_syscall.s"


.align 1

.global fputs
.type fputs, @function

.section .text

# a0 - 1st param: String address
# a1 - 2nd param: FILE DESCRIPTOR
fputs:
    # PROLOGUE
    addi    sp, sp, -32 # Allocate space from stack (4 x 8 Bytes)
    sd      ra, 24(sp) # Store ra into stack
    sd      fp, 16(sp) # Store fp into stack
    addi    fp, sp, 32 # Set stack frame for current function
    sd      s1, -24(fp) # Store s1 into stack
    sd      s2, -32(fp) # Store s2 into stack

    # FUNCTION - BEGIN
    # Local variables (s1, s2)
    mv      s1, a1 # Save FILE DESCRIPTOR
    mv      s2, a0 # Save String address

    # Procedure call
    mv      a0, s2 # Set String address as paramater
    call    strlen

    # Environment call
    mv      a2, a0 # String length a2 <- strlen(a0)
    mv      a0, s1 # Set FILE DESCRIPTOR from s1
    mv      a1, s2 # String address
    li      a7, SYS_WRITE
    ecall

    # Environment call
    li      a0, 10 # '\n'
    mv      a1, s1 # Set FILE DESCRIPTOR from s1
    call putc
    # FUNCTION - END

    # EPILOGUE
    ld      s1, -24(fp) # Load s1 into stack
    ld      s2, -32(fp) # Load s2 into stack
    ld      ra, 24(sp) # Load ra from stack
    ld      fp, 16(sp) # Load fp from stack

    addi    sp, sp, 32 # Deallocate space from stack
    ret

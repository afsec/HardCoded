#    Function: int putchar(int c);
#
# Description: The putchar function is equivalent to putc with the second
#              argument stdout.
#
#     Returns: The putchar function returns the character written. If a write
#              error occurs, the error indicator for the stream is set and
#              putchar returns EOF.

# TODO: Create "./unistd/constants/global_constants.s" with EOF(possible -1) and
#      NULL(null pointer)

.include "../../unistd/constants/file_descriptor.s"
.include "../../unistd/constants/linux_syscall.s"

.align 1

.global putchar
.type putchar, @function

.section .text

# a0 - 1st param: c (1 Byte)
putchar:
    # PROLOGUE
    addi    sp, sp, -8 # Allocate space from stack (1 x 8 Bytes)
    sd      ra, 0(sp) # Store ra into stack

    # FUNCTION - BEGIN
    # Local variables (t1)
    mv      t1, a0 # Get 1st param (c)
    # Procedure call
    mv      a0, t1 # Set char
    li      a1, FD_STDOUT # Set FILE DESCRIPTOR

    # TODO: Rename fputchar to fputc / putc
    call putc


    # TODO: Add fputs return value scenario
    # TODO: Add EOF scenario
    # FUNCTION - END

    # EPILOGUE
    ld      ra, 0(sp) # Load ra into stack
    addi    sp, sp, 8 # Allocate space from stack (1 x 8 Bytes)

    ret

#    Function: int putc(int c, FILE *stream);
#
# Description: The putc function is equivalent to fputc, except that if it is
#              implemented as a macro, it may evaluate stream more than once,
#              so that argument should never be an expression with side
#              effects.
#
#     Returns: The putc function returns the character written. If a write
#              error occurs, the error indicator for the stream is set and putc
#              returns EOF.
#

.include "../../unistd/constants/linux_syscall.s"

.align 1

.global putc
.type putc, @function

.section .text

# a0 - 1st Param: char (1 Byte)
# a1 - 2nd param: FILE DESCRIPTOR
putc:
    # Prologue
    addi    sp, sp, -32 # Allocate space from stack (4 x 8 Bytes)
    sd      ra, 24(sp) # Store ra into stack
    sd      fp, 16(sp) # Store fp into stack
    addi    fp, sp, 32 # Set stack frame for current function
    sd      s1, -24(fp) # Store s1 into stack

    # Local variables
    mv      s1, a1 # Save FILE DESCRIPTOR
    sd      a0, -32(fp) # Store 1st param into stack: char (1 Byte)

    # Environment call
    addi    a1, fp, -32 # Set char address from stack
    mv      a0, s1 # Set FILE DESCRIPTOR
    li      a2, 1 # Size of buffer: 1 Byte
    li      a7, SYS_WRITE  # Linux Syscall
    ecall

    # Epilogue
    ld      s1, -24(fp) # Load s1 into stack
    ld      ra, 24(sp) # Load ra from stack
    ld      fp, 16(sp) # Load fp from stack

    addi    sp, sp, 32 # Deallocate space from stack
    ret

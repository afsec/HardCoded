#    Function:
#
# Description:
#
#     Returns:
#
# TODO: Create "./unistd/constants/global_constants.s" with EOF(possible -1) and
#      NULL(null pointer)

.include "../../unistd/constants/linux_syscall.s"
.include "../../unistd/constants/file_descriptor.s"

.align 1

.global printf
.type printf, @function

.section .text

# a0 - 1st param: String address
# a1 ~ a7 param: Optionals
printf:
    # PROLOGUE
    addi    sp, sp, -40 # Allocate space from stack (3 x 8 Bytes)
    sd      ra, 32(sp) # Store ra into stack
    sd      fp, 24(sp) # Store fp into stack
    addi    fp, sp, 40 # Set stack frame for current function
    sd      s1, -24(fp) # Store s1 into stack
    sd      s2, -32(fp) # Store s2 into stack
    sd      s3, -40(fp) # Store s3 into stack

    # FUNCTION - BEGIN

    # Local variables (s1, s2, s3, t1)
    mv      s1, a0 # Save string base address
    mv      a0, s1 # Set strlen argument
    call    strlen
    mv      s2, zero # Counter
    mv      s3, a0 # Save strlen return value

printf_while:
    lb      t1, (s1) # Load char (1 Byte)
    beqz    t1, printf_while_break #if (t1 == '\0') goto strlen_return
    mv      a0, t1
    call    putchar
    addi    s2, s2, 1 # Increment counter
    addi    s1, s1, 1 # Increment char address into string chunk
    blt     s2, s3, printf_while #if (s2 < s3) goto printf_while

printf_while_break:
    # FUNCTION - END
    li      a0, 0 # Return success

    # EPILOGUE
    ld      s1, -24(fp) # Load s1 into stack
    ld      s2, -32(fp) # Load s2 into stack
    ld      s3, -40(fp) # Load s3 into stack
    ld      ra, 32(sp) # Load ra from stack
    ld      fp, 24(sp) # Load fp from stack

    addi    sp, sp, 40 # Deallocate space from stack
    ret

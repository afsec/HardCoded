#    Function: size_t strlen(const char *s);
#
# Description: The strlen function computes the length of the string pointed to
#              by s.
#
#     Returns: The strlen function returns the number of characters that
#              precede the terminating null character.

.include "../../unistd/constants/file_descriptor.s"

.align 1

.global strlen
.type strlen, @function

#.equ MAX_LENGTH, 1073741824 # 1 GByte
.equ MAX_LENGTH, 255 # 255 Bytes # To test: 'tests/test_echo.sh'

.section .text

# a0 - 1st param: String base address (const char *s)
strlen:
    # PROLOGUE
    addi    sp, sp, -24 # Allocate space from stack (3 x 8 Bytes)
    sd      ra, 16(sp) # Store ra into stack
    sd      fp, 8(sp) # Store fp into stack
    addi    fp, sp, 24 # Set stack frame for current function
    sd      s1, -24(fp) # Store s1 into stack

    # BEGIN
    # Local variables (s1, t1, t2)
    mv      s1, zero # Counter
    li      t1, MAX_LENGTH # Max String length to count


strlen_while:
    lb      t2, (a0) # Load char (1 Byte)
    beqz    t2, strlen_return #if (t2 == '\0') goto strlen_return
    addi    s1, s1, 1 # Increment counter
    addi    a0, a0, 1 # Increment char address into string chunk
    bgt     s1, t1, strlen_error #if (s1 > MAX_LENGTH) goto strlen_error
    j       strlen_while


strlen_error:
    # Procedure call
    la      a0, strlen_msg_error_01
    li      a1, FD_STDERR
    call    fputs
    j       strlen_return


strlen_return:
    mv      a0, s1 # Return string length
    # END

    # EPILOGUE
    ld      s1, -24(fp) # Load s1 from stack
    ld      ra, 16(sp) # Load ra from stack
    ld      fp, 8(sp) # Load fp from stack
    addi    sp, sp, 24 # Deallocate space from stack
    ret


.section .rodata
    strlen_msg_error_01: .string "ERROR: strlen() MAX_LENGTH overflow."

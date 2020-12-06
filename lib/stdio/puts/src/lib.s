#    Function: int puts(const char *str);
#
# Description: The puts function writes the string pointed to by str to the
#              stream pointed to by stdout, and appends a new-line character
#              to the output. The terminating null character is not written.
#
#     Returns: The puts function returns EOF if a write error occurs; otherwise
#              it returns a nonnegative value.

# TODO: Create "./unistd/constants/global_constants.s" with EOF(possible -1) and
#      NULL(null pointer)

.include "../../unistd/constants/file_descriptor.s"

.align 1

.global puts
.type puts, @function

.section .text

# a0 - 1st param: str base address
puts:
    # PROLOGUE
    addi    sp, sp, -16 # Allocate space from stack
    sd      ra, 8(sp) # Store ra into stack
    sd      fp, 0(sp) # Store fp into stack

    # FUNCTION - BEGIN
    # Procedure call
    mv      a0, a0 # Forward get_argv result (a0) as parameter to next function
    li      a1, FD_STDOUT # Set FILE DESCRIPTOR
    call    fputs

    # TODO: Add fputs return value scenario
    # TODO: Add EOF scenario
    # FUNCTION - END

    # EPILOGUE
    ld      ra, 8(sp) # Load ra from stack
    ld      fp, 0(sp) # Load fp from stack

    addi    sp, sp, 16 # Deallocate space from stack

    ret

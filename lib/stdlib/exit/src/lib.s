#    Function: void exit(int status);
#
# Description: The exit function causes normal program termination to occur. If
#              more than one call to the exit function is executed by a
#              program, the behavior is undefined.
#              First, all functions registered by the atexit function are
#              called, in the reverse order of their registration,256) except
#              that a function is called after any previously registered
#              functions that had already been called at the time it was
#              registered. If, during the call to any such function, a call to
#              the longjmp function is made that would terminate the call to
#              the registered function, the behavior is undefined. Next, all
#              open streams with unwritten buffered data are flushed, all open
#              streams are closed, and all files created by the tmpfile
#              function are removed. (TODO)
#              Finally, control is returned to the host environment. If the
#              value of status is zero or EXIT_SUCCESS, an
#              implementation-defined form of the status successful termination
#              is returned. If the value of status is EXIT_FAILURE, an
#              implementation-defined form of the status unsuccessful
#              termination is returned. Otherwise the status returned is
#              implementation-defined.
#
#     Returns: The exit function cannot return to its caller.

# Default EXIT_CODES: "../../unistd/constants/exit_code.s"

.include "../../unistd/constants/linux_syscall.s"

.align 1

.global exit
.type exit, @function

.section .text

# a0 - 1st param: Exit code (1 Byte)
exit:
    # Environment call
    mv      a0, a0 # Forward a0 as parameter to next function
    li      a7, SYS_EXIT # Set Linux syscall
    ecall
    ret

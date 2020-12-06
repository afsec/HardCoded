#    Function: int, char * const argv[]) getopt(
#                                                int argc, char * const argv[],
#                                                const char *optstring
#                                               );
#               extern int optind;
#
# Description: The getopt() function is a command-line parser. The argument
#              optstring is a string of recognized option characters.
#
#          int optind - is the index of the next element of the argv[] vector
#                       to be processed. It shall be initialized to 1 by the
#                       system, and getopt() shall update it when it finishes
#                       with each element of argv[].
#
#     Returns: The getopt() function shall return the next option character
#              specified on the command line. Otherwise, getopt() shall return
#              -1 when all command line options are parsed.
#
#    Features: Only short arguments: "-a", "-a -b", etc.
#

.include "../../unistd/constants/file_descriptor.s"
.include "../../unistd/constants/linux_syscall.s"

.align 1

.global getopt
.type getopt, @function

.section .text

# a0: int argc
# a1: char * const argv[]
# a2: const char *optstring
# a3: int optind
getopt:
    # Prologue
    addi    sp, sp, -48 # Allocate space from stack (6 x 8 Bytes)
    sd      ra, 40(sp) # Store ra into stack
    sd      fp, 32(sp) # Store fp into stack
    addi    fp, sp, 48 # Set stack frame for current function
    sd      s1, -24(fp) # Store s1 into stack
    sd      s2, -32(fp) # Store s2 into stack
    sd      s3, -40(fp) # Store s3 into stack
    sd      s4, -48(fp) # Store s4 into stack

    # Function - BEGIN

    # Local variables (s1 - s7, t1, t2, t3)

    # Set s1, s3, s4
    mv      s1, a0 # Save: int argc
    mv      s3, a2 # Save: const char *optstring
    mv      s4, a3 # Save: optind

    # Conditional branch: if (argc == optind) goto getopt_argv_end
    ld      t2, (s4) # t2 <- int *optind
    beq     s1, t2, getopt_argv_end

    # Set s2
    li      t1, 8 # t1: baseOffset (8 Bytes -> 64 bit)
    ld      t2, (s4) # t2 <- int *optind
    mul     t3, t2, t1 # (t2 * baseOffset)
    add     t4, a1, t3 # t3: argv[t2] base address
    ld      s2, (t4) # Load argv[n] from stack

    # Conditional branch: Check if (strlen(argv[n]) == 2)
    mv      a0, s2
    call    strlen
    li      t1, 2 # number of valid length for arguments
    bne     t1, a0, getopt_error_reading_arg # if (strlen(argv[n]) != 2)
                                             #   goto getopt_error_reading_arg

    # Conditional branch: Check if (argv[n][0] == '-')
    li      t1, 45 # '-'
    lb      t2, 0(s2) # Load char from argv[n][0]
    bne     t1, t2, getopt_error_reading_arg # if (argv[n][0] != '-')
                                             #   goto getopt_error_reading_arg

    # Procedure call
    mv      a0, s3 # Set *optstring as argument
    call    strlen # strlen(*optstring)

    mv      t1, a0 # t1 = strlen(*optstring)
    mv      t2, zero # optstring index: (t2 = 0)
    j       getopt_optstring_loop

getopt_optstring_loop_iter:
    li      t2, 1 # Increment value for optstring index
getopt_optstring_loop:
    add     s3, s3, t2 # optstring index increment (loop = 0 | loop_iter = 1)
    lb      t3, (s3) # Get optstring char (t3) using t2 as index
    mv      t4, zero # t4 <- '\0'
    beq     t3, t4, getopt_error_notfound # if (t3 == '\0')
                                          #    goto getopt_error_notfound

    lb      t5, 1(s2) # Get argv[n][1] char (t5)

    beq     t3, t5, getopt_arg_found # if (t3 == t5)
                                    #    goto getopt_arg_found
    j       getopt_optstring_loop_iter

getopt_arg_found:
    mv      a0, t3 # Set found char(t3) as return value
    # Increment optind
    ld      t1, (s4) # Load optind from Stack
    addi    t1, t1, 1 # Increment optind
    sd      t1, (s4) # Save optind into Stack
    j       getopt_return

getopt_error_reading_arg:
getopt_error_notfound:
    li      a0, 63 # '?'
    j       getopt_return

getopt_argv_end:
    li      a0, -1

getopt_return:
    # Function - END
    # Epilogue
    ld      s1, -24(fp) # Store s1 into stack
    ld      s2, -32(fp) # Store s2 into stack
    ld      s3, -40(fp) # Store s3 into stack
    ld      s4, -48(fp) # Store s4 into stack
    ld      ra, 40(sp) # Store ra into stack
    ld      fp, 32(sp) # Store fp into stack

    addi    sp, sp, 48 # Deallocate space from stack
    ret

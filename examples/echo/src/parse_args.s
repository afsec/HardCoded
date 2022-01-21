#    Function: size_t parse_args(int argc, char * const argv[])
#
# Description: Enumerate all developer-defined flags, set their
#              respective flags, and call the software main function
#
# Usage:
#
#    ld      a0, (sp) # Set `int argc` as parameter
#    addi    a1, sp, 16 # Set `char *argv[]` as parameter
#    call parse_args
#

.align 1

.section .text

# a0: int argc
# a1: char * const argv[]
parse_args:
    # Prologue
    addi    sp, sp, -64 # Allocate space from stack (8 x 8 Bytes)
    sd      ra, 40(sp) # Store ra into stack
    sd      fp, 32(sp) # Store fp into stack
    addi    fp, sp, 64 # Set stack frame for current function
    sd      s1, -24(fp) # Store s1 into stack
    sd      s2, -32(fp) # Store s2 into stack
    sd      s3, -40(fp) # Store s3 into stack
    sd      s4, -48(fp) # Store s4 into stack

    # Function - BEGIN
    mv      s1, a0 # Set a0: int argc
    mv      s2, a1 # Set a1: char * const argv[]

    # Local variables

    # -56(fp): bool flag_n (Must store into stack)
    mv      t1, zero # flag_n = FALSE (0)
    addi    t2, fp, -56
    sd      t1, (t2)

    # -64(fp): int optind (Must store into stack)
    li      t1, 1 # optind = 1
    addi    t2, fp, -64
    sd      t1, (t2)
    mv      a3, t2 # Set a3 = &optind



parse_args_loop:
    # Procedure call
    mv      a0, s1 # Set a0: int argc
    mv      a1, s2 # Set a1: char * const argv[]
    la      a2, parse_args_rodata_optstring
    call    getopt

    # Conditional branch
    li      t1, -1 # End of arguments
    beq     a0, t1, parse_args_end # if ((getopt() == -1)
                                          #     goto parse_args_end

    li      t1, 63 # '?'
    beq     a0, t1, parse_args_error_reading_arg # if (getopt() == '?')
                                              #   goto getopt_error_reading_arg

# Set Flag - BEGIN

    li      t1, 104 # 'h'
    beq     a0, t1, parse_args_usage

    li      t1, 110 # 'n'
    beq     a0, t1, parse_args_setflag_n

    j       parse_args_loop


parse_args_setflag_n:
    li      t1, 0x01
    sd      t1, -56(fp) # flag_n = TRUE (1)
    j       parse_args_loop

# Set Flag - END

parse_args_error_reading_arg:
    # Check if the invalid option is the last argument.
    # Check if argc == optind
    ld      t1, -64(fp)
    addi    t2, s1, -1
    beq     t1, t2, parse_args_lastarg # if (is_lastarg())
                                       #     goto parse_args_lastarg
    j       parse_args_usage

parse_args_end:
parse_args_lastarg:
    # s1: argc
    # s2: argv

    # Getting address of last argument: argv[-1]
    addi    t1, s1, -1 # t1: (argc - 1)
    li      t2, 8 # t2: baseOffset (8 Bytes -> 64 bit)
    mul     t3, t2, t1 # t3 <- (t1 * t2)
    add     t4, s2, t3 # t3: argv[t2] base address
    ld      t5, (t4) # Load argv[-1] from stack

    # Getting the 1st char of last argument: argv[-1][0]
    lb      t1, 0(t5) # Load argv[-1][0] from stack

    # Check if the last argument is NOT an option.
    # Conditional branch: Check if (argv[-1][0] == '-') goto parse_args_usage
    li      t2, 45 # '-'
    beq     t1, t2, parse_args_usage

    ld      t1, -56(fp) # Get OPT_FLAGS: flag_n
    mv      a0, t1 # OPT_FLAGS
    mv      a1, t5 # STRING
    # Function - END
    # The last argument is NOT an option, so we'll use it as user input.
    # Epilogue
    ld      s1, -24(fp) # Store s1 into stack
    ld      s2, -32(fp) # Store s2 into stack
    ld      s3, -40(fp) # Store s3 into stack
    ld      s4, -48(fp) # Store s4 into stack
    ld      ra, 40(sp) # Load ra from stack
    ld      fp, 32(sp) # Load fp from stack

    addi    sp, sp, 64 # Deallocate space from stack

    call    program

parse_args_usage:
    la      a0, parse_args_rodata_usage
    call    puts
    li      a0, EXIT_FAILURE
    call    exit

.section .rodata
    parse_args_rodata_optstring: .string "hn"

.section .rodata
    parse_args_rodata_usage: .string "Usage: echo [-h | -n] \"STRING\""

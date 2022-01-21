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
# .include "../../unistd/constants/file_descriptor.s"
# .include "../../unistd/constants/linux_syscall.s"

.align 1

.section .text

# a0: int argc
# a1: char * const argv[]
parse_args:
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

    # TODO: Alloc
    # s1: char *optarg (Must allocate into stack)
    # s2: int *opterr (Must allocate into stack)
    # s3: int *optind (Must allocate into stack)
    # s4: int *optopt (Must allocate into stack)

    # Local variables (t1)
    
    # Must iterate over (a1) based on argc (a0)

    # 1. Iterate over a1: char * const argv[]
    
    # 2.    For each param do getopt workflow (TODO)
    # Procedure call
    mv      a0, a0 # Set a0: int argc
    mv      a1, a1 # Set a1: char * const argv[]
    la      a2, parse_args_rodata_optstring
    li      a3, 0x00 # Set a4: char *optarg; TODO
    li      a4, 0x00 # Set a4: int opterr; TODO
    li      a5, 1 # Set a5: int optind = 1;
    li      a6, 0x00 # Set a6: int optopt; TODO
    call    getopt
     


    # Conditional branch
    li      t1, 63 # '?'
    beq     a0, t1, parse_args_error_reading_arg # if (getopt() == '?')
                                             #   goto getopt_error_reading_arg
    j       parse_args_return

parse_args_error_reading_arg:
    li      a0, 63

parse_args_return:
    # Function - END
    # Epilogue
    ld      s1, -24(fp) # Store s1 into stack
    ld      s2, -32(fp) # Store s2 into stack
    ld      s3, -40(fp) # Store s3 into stack
    ld      s4, -48(fp) # Store s4 into stack
    ld      ra, 40(sp) # Load ra from stack
    ld      fp, 32(sp) # Load fp from stack

    addi    sp, sp, 48 # Deallocate space from stack          
    ret


.section .rodata
    parse_args_rodata_optstring: .string "ab"

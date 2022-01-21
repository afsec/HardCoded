#    Function: char* argv[argv_idx] get_argv(const char *argv[], size_t argv_idx)

.align 1

.section .text

# a0 - 1st param: argv base address
# a1 - 2nd param: argv_idx
get_argv:
    li      t1, 8 # Set Address length (64 bits/8 Bytes)
    mulw    t2, a1, t1 # Get Argument and multiply by t1
    add     t3, a0, t2 # Get address by add the sp plus the multiplication result
    ld      a0, (t3) # Load Argument base address from stack
    ret

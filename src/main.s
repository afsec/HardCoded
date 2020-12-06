# Hello World

.include "./lib/unistd/constants/exit_code.s"
.include "./lib/unistd/constants/file_descriptor.s"
.include "./lib/unistd/constants/linux_syscall.s"

.align 1

.global _start

.section .text

_start:

    # Environment call
    la      s1, main_msg_01 # Load String base address
    mv      a0, s1
    call    strlen
    mv      a2, a0 # Set string length (Byte length)
    mv      a1, s1 # Set string base address
    li      a0, FD_STDOUT # Set file descript (STDOUT)

    li      a7, SYS_WRITE # Linux syscall: 64 -> write
    ecall

    # Environment call
    li      a0, EXIT_SUCCESS # Exit code (0)
    li      a7, SYS_EXIT # Set Linux syscall: SYS_EXIT (93)
    ecall

.section .rodata
    main_msg_01: .string "Hello World!\n"

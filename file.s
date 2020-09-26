.section __DATA, __data

message: .ascii "Hello world\n"
messageLength = . - message
filename: .asciz "some_file.txt"
fileMode: .asciz "w+"
errorClosingFileMsg: .asciz "Error closing file\n"
streamAddress: .quad 0

.section __TEXT, __text

.globl _main

_main:
    enter $0, $0

    leaq filename(%rip), %rdi
    leaq fileMode(%rip), %rsi
    callq _fopen
    movq %rax, streamAddress(%rip)

    leaq message(%rip), %rdi
    movq $12, %rsi
    movq $1, %rdx
    movq streamAddress(%rip), %rcx
    callq _fwrite

    movq streamAddress(%rip), %rdi
    callq _fclose
    cmpq $0, %rax
    jz fileClosedOk
    leaq errorClosingFileMsg(%rip), %rdi
    call _printf
fileClosedOk:

    movl $0, %edi
    callq _exit

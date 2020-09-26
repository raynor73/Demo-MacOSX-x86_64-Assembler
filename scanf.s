.section __DATA, __data
str: .asciz "Enter integer value: "
resultMsg: .asciz "Your value is: %d\n"
valueFormat: .asciz "%d"
value: .quad 0

.section __TEXT, __text
.globl _main
_main:
    enter $0, $0

    leaq str(%rip), %rdi
    callq _printf

    xorq %rax, %rax
    leaq valueFormat(%rip), %rdi
    leaq value(%rip), %rsi
    callq _scanf

    xorq %rax, %rax
    leaq resultMsg(%rip), %rdi
    movq value(%rip), %rsi
    callq _printf

    movl $0, %edi
    callq _exit

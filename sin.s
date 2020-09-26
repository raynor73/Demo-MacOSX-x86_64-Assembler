.section __DATA, __data

argumentMsg: .asciz "Enter argument in radians: "
resultMsg: .asciz "Sin value of %f is %f\n"
argumentFormat: .asciz "%lf"
argument: .double 0
sinValue: .double 0

.section __TEXT, __text

.globl _main

_main:
    enter $0, $0

    leaq argumentMsg(%rip), %rdi
    callq _printf

    xorl %eax, %eax
    leaq argumentFormat(%rip), %rdi
    leaq argument(%rip), %rsi
    callq _scanf

    fldl argument(%rip)
    fsin
    fstl sinValue(%rip)

    movb $2, %al
    leaq resultMsg(%rip), %rdi
    movsd argument(%rip), %xmm0
    movsd sinValue(%rip), %xmm1
    callq _printf

    movl $0, %edi
    callq _exit

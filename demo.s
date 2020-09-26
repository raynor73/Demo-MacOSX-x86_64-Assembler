.section __DATA, __data
str:
    .asciz "Hello world %f\n"

value:
    .short 1234

floatValue:
    .double 1234.0

.section __TEXT, __text
.globl _main
_main:
    enter $0, $0

    #filds value(%rip)
    #fiadds value(%rip)
    #fists value(%rip)
    
    #filds value(%rip)
    #fiadds value(%rip)
    #fists value(%rip)

    fldl floatValue(%rip)
    faddl floatValue(%rip)
    fstl floatValue(%rip)

    leaq str(%rip), %rdi
    movsd floatValue(%rip), %xmm0
    movq $1, %rax
    callq _printf

    movl $0, %edi
    callq _exit

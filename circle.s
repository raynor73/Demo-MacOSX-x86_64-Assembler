.section __DATA, __data

filename: .asciz "ResultImage.tga"
fileMode: .asciz "w+"
errorClosingFileMsg: .asciz "Error closing file\n"
streamAddress: .quad 0
bufferAddress: .quad 0

OUTPUT_IMAGE_WIDTH = 1024
OUTPUT_IMAGE_HEIGHT = 768
OUTPUT_IMAGE_BYTES_PER_PIXEL = 4
BITS_IN_BYTE = 8
OUTPUT_IMAGE_BITS_PER_PIXEL = OUTPUT_IMAGE_BYTES_PER_PIXEL * BITS_IN_BYTE
BUFFER_SIZE = OUTPUT_IMAGE_WIDTH * OUTPUT_IMAGE_HEIGHT * OUTPUT_IMAGE_BYTES_PER_PIXEL

tgaHeader:
    .byte   0                               # ID Length
    .byte   0                               # Color map type(0 - no color map)
    .byte   2                               # Image type(2 - uncompressed true-color image)
    
    # Color map specification
    .short  0                               # Index of first color map entry that is included in the file
    .short  0                               # Number of entries of the color map that are included in the file
    .byte   0                               # Cumber of bits per pixel

    # Image specification
    .short  0                               # Absolute X coordinate of lower-left corner for displays where origin is at the lower left
    .short  OUTPUT_IMAGE_HEIGHT             # Absolute Y coordinate of lower-left corner for displays where origin is at the lower left
    .short  OUTPUT_IMAGE_WIDTH              # Width in pixels
    .short  OUTPUT_IMAGE_HEIGHT             # Height in pixels
    .byte   OUTPUT_IMAGE_BITS_PER_PIXEL     # Bits per pixel
    .byte   0x38                            # Image descriptor (0x30 is left-to-right(bit 4 is 1), up-to-down(bit 5 is 1))
TGA_HEADER_LENGTH = . - tgaHeader

.section __TEXT, __text

.globl _main

_main:
    enter $0, $0

    leaq filename(%rip), %rdi
    leaq fileMode(%rip), %rsi
    callq _fopen
    movq %rax, streamAddress(%rip)

    movq $BUFFER_SIZE, %rdi
    callq _malloc
    movq %rax, bufferAddress(%rip)

    movl $0xff0a1f65, %edi
    callq fillScreen

    movl $512, %edi
    movl $384, %esi
    movl $0xffffffff, %edx
    callq drawPoint

    leaq tgaHeader(%rip), %rdi
    movq $TGA_HEADER_LENGTH, %rsi
    movq $1, %rdx
    movq streamAddress(%rip), %rcx
    callq _fwrite

    movq bufferAddress(%rip), %rdi
    movq $TGA_HEADER_LENGTH, %rsi
    movq $BUFFER_SIZE, %rdx
    movq streamAddress(%rip), %rcx
    callq _fwrite

    movq bufferAddress(%rip), %rdi
    callq _free

    movq streamAddress(%rip), %rdi
    callq _fclose
    cmpq $0, %rax
    jz fileClosedOk
    leaq errorClosingFileMsg(%rip), %rdi
    call _printf
fileClosedOk:

    movl $0, %edi
    callq _exit

fillScreen: # edi - color
    enter $4, $0
    andq $0xfffffffffffffff0, %rsp

    movl %edi, (%rbp)
    movq bufferAddress(%rip), %rdi
    movq %rbp, %rsi
    movq $BUFFER_SIZE, %rdx
    callq _memset_pattern4

    leave
    retq

drawPoint: # edi - x, esi - y, edx - color
    enter $0, $0

    cmpw $OUTPUT_IMAGE_WIDTH, %di
    jge outOfScreen

    cmpw $OUTPUT_IMAGE_HEIGHT, %si
    jge outOfScreen

    movl %edx, %r9d

    movl %esi, %eax
    movl $OUTPUT_IMAGE_WIDTH, %r8d
    mull %r8d
    addl %edi, %eax
    shll $2, %eax

    movq bufferAddress(%rip), %rbx
    addq %rax, %rbx
    movl %r9d, (%rbx)

outOfScreen:
    leave
    retq

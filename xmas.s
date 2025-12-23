        .section __TEXT,__text
        .globl _start
        .p2align 2

_start:
        // base of mutable buffer (writable)
        adrp    x19, buf@PAGE
        add     x19, x19, buf@PAGEOFF

        // base of selector table
        adrp    x21, tw@PAGE
        add     x21, x21, tw@PAGEOFF

        // read counter frequency once
        mrs     x23, CNTFRQ_EL0          // ticks per second

        // interval = CNTFRQ / 2  (~500ms)
        mov     x24, #2
        udiv    x22, x23, x24

        mov     w20, #0

loop:
        // pick glyph (0/1)
        and     w1, w20, #1
        ldrb    w2, [x21, w1, uxtw]

        // buffer begins with ESC[H (3 bytes), then "*\n" => offset 6
        strb    w2, [x19, #6]

        // write(1, buf, tree_len)
        mov     x0, #1                  // fd = stdout (MUST be reloaded each time)
        mov     x1, x19
        mov     x2, #tree_len
        movz    x16, #0x0004
        movk    x16, #0x0200, lsl #16    // SYS_write
        svc     #0x80

        // target = now + interval
        mrs     x3, CNTVCT_EL0
        add     x4, x3, x22

wait:
        mrs     x5, CNTVCT_EL0
        cmp     x5, x4
        blo     wait

        add     w20, w20, #1
        b       loop


        .section __TEXT,__cstring
tw:
        .byte   '*', '+'                //blink

        .section __DATA,__data
buf:
        .ascii  "\033[H"                // cursor home
        .ascii  "   *\n"
        .ascii  "   ^\n"
        .ascii  "  ^^^\n"
        .ascii  " ^^^^^\n"
        .ascii  "^^^^^^^\n"
        .ascii  "   |\n"

tree_len = . - buf

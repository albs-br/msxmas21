Fonts:
    db  11111110 b
    db  11111110 b
    db  10000110 b
    db  10000110 b
    db  11111110 b
    db  11111110 b
    db  10000110 b
    db  10000110 b

    db  11111000 b
    db  11111100 b
    db  10000110 b
    db  11111100 b
    db  10000110 b
    db  10000110 b
    db  11111100 b
    db  11111000 b



; Inputs:
;   HL: Addr of char font
;   IY: VRAM dest addr
DrawChar:

    ld      c, PORT_0
    ld      ixl, 8          ; number of lines of the font
.loopFont:

    push    hl
        ld      a, 0000 0000 b
        
        ; hl = iy
        push    iy
        pop     hl
        
        call    SetVdp_Write
    pop     hl

    ld      a, (hl)
    ld      e, a

    ld      b, 4        ; counter (4 bytes will be written to VRAM)
.loop:


; -------- even bit
    rl      e ; put bit 7 in the carry
    jp      c, .drawPixel_even_1
;.drawPixel_even_0:
    ld      d, 0x00

    jp      .doBit_odd

.drawPixel_even_1:
    ld      d, 0xf0

; -------- odd bit
.doBit_odd:
    rl      e ; put bit 7 in the carry
    jp      c, .drawPixel_odd_1
;.drawPixel_odd_0:
    ld      a, 0xf0
    and     d
    ld      d, a

    jp      .next

.drawPixel_odd_1:
    ld      a, 0x0f
    or      d
    ld      d, a

.next:
    out     (c), d
    djnz    .loop

; next line on the screen (SC5)
    ; iy += 128
    push    hl
        push    de
            push    iy  ; hl = iy
            pop     hl
            
            ld      de, 128
            add     hl, de
            
            push     hl  ; iy = hl
            pop     iy
        pop     de
    pop     hl

; next line of font
    inc     hl

    dec     ixl
    jp      nz, .loopFont

    ret

; Inputs:
;   HL: Addr of string (0 terminated)
;   IY: VRAM dest addr
DrawString:
    ret
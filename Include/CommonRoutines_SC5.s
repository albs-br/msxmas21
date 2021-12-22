
; Input:
;   HL: source on RAM
;   ADE: 17-bits destiny on VRAM
Load_16x8_SC5_Image:
    ld      b, 8               ; number of lines
    jp      Load_SC5_Image

; Input:
;   HL: source on RAM
;   ADE: 17-bits destiny on VRAM
Load_16x16_SC5_Image:
    ld      b, 16               ; number of lines
    jp      Load_SC5_Image


; Input:
;   HL: source on RAM
;   ADE: 17-bits destiny on VRAM
;   B: number of lines
Load_SC5_Image:

    ld      c, a                ; save 17th bit of VRAM addr
.loop:
    push    bc

        ld      a, c            ; restore 17th bit of VRAM addr

        push    hl
            push    de
                ld      h, d
                ld      l, e
                call    SetVdp_Write
            pop     de
        pop    hl

        push    hl
            push    de
                ld      b, 8             ; bytes per line (16 pixels = 8 bytes on SC5)
                ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
                ;ld		hl, ConveyorBelt_Frame1		            ; RAM address (source)
                otir
            pop     de
        pop    hl

        ld      bc, 8              ; next line of image (16 pixels = 8 bytes on SC5)
        add     hl, bc

        ex      de, hl
            ld      bc, 128             ; next line of NAMTBL
            add     hl, bc
        ex      de, hl

    pop     bc
    djnz    .loop

    ret

; Input:
;   HL: source on RAM
;   ADE: 17-bits destiny on VRAM
Load_16x16_SC5_Image_WithTransparency:

    ; now DE = source (RAM), HL = destiny (VRAM)
    ex      de, hl


    ld      b, 16       
.loopLines:
    push    bc
        push    de
            push    hl

            ; loop through 16 pixels (8 bytes) of source image
                ld      b, 8

            .loopCols:
                push    bc

                    ; for each nibble:
                    ;   if source color == 0 then result = bgcolor
                    ;   else result = source color

                    ; get byte from source image (2 pixels)
                    ld      a, (de)
                    ld      c, a

                    ; high nibble (left pixel)
                    and     1111 0000b
                    or      a
                    jp      z, .isTransp

            ; source not transp
                    ; IXH = result = source color
                    ld      ixh, a
                    jp      .getLowNibble

            .isTransp:
                    ; get byte from VRAM NAMTBL (2 pixels)
                    ; push    hl
                    ;     push    de
                            call    BIOS_RDVRM
                    ;     pop     de
                    ; pop    hl

                    ; B = high nibble (left pixel)
                    and     1111 0000b
                    ld      b, a
                    
                    ; IXH = result = bg color
                    ld      ixh, b

            .getLowNibble:
                    ; low nibble (left pixel)
                    ld      a, c
                    and     0000 1111b
                    or      a
                    jp      z, .isTransp_Low

            ; source not transp
                    ld      b, a
                    ; join with high nibble
                    ld      a, ixh
                    or      b
                    jp      .writeResult

            .isTransp_Low:
                    ; get byte from VRAM NAMTBL (2 pixels)
                    ; push    hl
                    ;     push    de
                            call    BIOS_RDVRM
                    ;     pop     de
                    ; pop    hl

                    ; B = high nibble (left pixel)
                    and     0000 1111b
                    ld      b, a
                    
                    ; join with high nibble
                    ld      a, ixh
                    or      b

                    ;ld      ixh, a

            .writeResult:
                    ; write result to VRAM NAMTBL    
                    ;ld      a, ixh
                    ; push    hl
                    ;     push    de
                            call    BIOS_WRTVRM
                    ;     pop     de
                    ; pop    hl

                    ; next bytes from source and destiny
                    inc     hl
                    inc     de


                pop     bc
                djnz    .loopCols


            pop     hl
        pop     de

        ; HL += 128         ; destiny on VRAM
        ld      bc, 128
        add     hl, bc

        ; DE += 8           ; source image
        ex      de, hl
            ld      bc, 8
            add     hl, bc
        ex      de, hl

    pop     bc
    djnz    .loopLines

    ret

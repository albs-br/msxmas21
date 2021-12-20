UpdatePalette:

    ; animation only at n frames
    ld      a, (BIOS_JIFFY)
    and     0000 1111b
    or      a
    ret     nz


    ld      a, (UpdatePaletteCounter)
    inc     a
    cp      3
    jp      nz, .dontResetCounter
    xor     a
.dontResetCounter:
    ld      (UpdatePaletteCounter), a
    
    jp      z, .palette_0
    dec     a
    jp      z, .palette_1
    dec     a
    jp      z, .palette_2
    

.palette_0:
    ld      a, 10
    ld      b, 0x77
    ld      c, 0x07
    call    SetPaletteColor

    ld      a, 6
    ld      b, 0x77
    ld      c, 0x07
    call    SetPaletteColor

    ld      a, 13
    ld      b, 0x00
    ld      c, 0x00
    call    SetPaletteColor

    ret

.palette_1:
    ld      a, 10
    ld      b, 0x77
    ld      c, 0x07
    call    SetPaletteColor

    ld      a, 6
    ld      b, 0x00
    ld      c, 0x00
    call    SetPaletteColor

    ld      a, 13
    ld      b, 0x77
    ld      c, 0x07
    call    SetPaletteColor

    ret

.palette_2:
    ld      a, 10
    ld      b, 0x00
    ld      c, 0x00
    call    SetPaletteColor

    ld      a, 6
    ld      b, 0x77
    ld      c, 0x07
    call    SetPaletteColor

    ld      a, 13
    ld      b, 0x77
    ld      c, 0x07
    call    SetPaletteColor

    ret
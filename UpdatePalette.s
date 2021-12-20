                        ;0xrb          0x0g
COLOR_1:            equ (0x74 * 256) + 0x06
COLOR_2:            equ (0x63 * 256) + 0x05

UpdatePalette:

    ; animation only at n frames
    ld      a, (BIOS_JIFFY)
    and     0000 0111b
    or      a
    ret     nz


    ld      a, (UpdatePaletteCounter)
    inc     a
    cp      3
    jp      nz, .dontResetCounter
    xor     a
.dontResetCounter:
    ld      (UpdatePaletteCounter), a
    
    jp      z, .frame_0
    dec     a
    jp      z, .frame_1
    dec     a
    jp      z, .frame_2
    

.frame_0:
    ld      a, 10
    ld      bc, COLOR_1
    call    SetPaletteColor

    ld      a, 6
    ld      bc, COLOR_1
    call    SetPaletteColor

    ld      a, 13
    ld      bc, COLOR_2
    call    SetPaletteColor

    ret

.frame_1:
    ld      a, 10
    ld      bc, COLOR_1
    call    SetPaletteColor

    ld      a, 6
    ld      bc, COLOR_2
    call    SetPaletteColor

    ld      a, 13
    ld      bc, COLOR_1
    call    SetPaletteColor

    ret

.frame_2:
    ld      a, 10
    ld      bc, COLOR_2
    call    SetPaletteColor

    ld      a, 6
    ld      bc, COLOR_1
    call    SetPaletteColor

    ld      a, 13
    ld      bc, COLOR_1
    call    SetPaletteColor

    ret
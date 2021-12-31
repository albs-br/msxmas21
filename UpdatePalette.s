                        ; format:   0xrb          0x0g
CONVEYOR_BELT_COLOR_1_RB:         equ 0x74
CONVEYOR_BELT_COLOR_1_G:          equ 0x06
CONVEYOR_BELT_COLOR_2_RB:         equ 0x63
CONVEYOR_BELT_COLOR_2_G:          equ 0x05


CONVEYOR_BELT_COLOR_1:            equ (CONVEYOR_BELT_COLOR_1_RB * 256) + CONVEYOR_BELT_COLOR_1_G
CONVEYOR_BELT_COLOR_2:            equ (CONVEYOR_BELT_COLOR_2_RB * 256) + CONVEYOR_BELT_COLOR_2_G


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
    ld      bc, CONVEYOR_BELT_COLOR_1
    call    SetPaletteColor

    ld      a, 6
    ld      bc, CONVEYOR_BELT_COLOR_1
    call    SetPaletteColor

    ld      a, 13
    ld      bc, CONVEYOR_BELT_COLOR_2
    call    SetPaletteColor

    ret

.frame_1:
    ld      a, 10
    ld      bc, CONVEYOR_BELT_COLOR_1
    call    SetPaletteColor

    ld      a, 6
    ld      bc, CONVEYOR_BELT_COLOR_2
    call    SetPaletteColor

    ld      a, 13
    ld      bc, CONVEYOR_BELT_COLOR_1
    call    SetPaletteColor

    ret

.frame_2:
    ld      a, 10
    ld      bc, CONVEYOR_BELT_COLOR_2
    call    SetPaletteColor

    ld      a, 6
    ld      bc, CONVEYOR_BELT_COLOR_1
    call    SetPaletteColor

    ld      a, 13
    ld      bc, CONVEYOR_BELT_COLOR_1
    call    SetPaletteColor

    ret
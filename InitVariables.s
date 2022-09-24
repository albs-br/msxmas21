PLAYER_Y_ON_GROUND:     equ 192 - 24 - 8 + 4

InitVariables:
    ld      a, (BIOS_JIFFY)                  ; MSX BIOS time variable
    or      0x80                             ; A value different of zero is granted
    ld      (Seed), a

    ld      a, 128 - 8
    ld      (PlayerX), a

    ld      a, PLAYER_Y_ON_GROUND
    ld      (PlayerY), a



    xor     a
    ld      (Score), a
    ld      (PlayerAnimationFrame), a
    ld      (PlayerJumpingCounter), a
    ld      (UpdatePaletteCounter), a



    ld      hl, Gift_1_Struct
    ld      d, 1
    call    InitGift

    ld      hl, Gift_2_Struct
    ld      d, 2
    call    InitGift

    ld      hl, Gift_3_Struct
    ld      d, 3
    call    InitGift

    ld      hl, Gift_4_Struct
    ld      d, 4
    call    InitGift



    ; init sprite attributes table
    ld      hl, InitialSpriteAttributes
    ld      de, SpriteAttributes
    ld      bc, InitialSpriteAttributes.size
    ldir


    ret
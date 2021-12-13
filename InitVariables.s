InitVariables:
    ld      a, (BIOS_JIFFY)                  ; MSX BIOS time variable
    or      0x80                             ; A value different of zero is granted
    ld      (Seed), a

    ld      a, 128 - 8
    ld      (PlayerX), a

    ld      a, 192 - 24 - 8
    ld      (PlayerY), a



    xor     a
    ld      (PlayerAnimationFrame), a


    ld      hl, Gift_1_Struct
    call    InitGift

    ld      hl, Gift_2_Struct
    call    InitGift



    ; init sprite attributes table
    ld      hl, TestSpriteAttributes
    ld      de, SpriteAttributes
    ld      bc, TestSpriteAttributes.size
    ldir


    ret
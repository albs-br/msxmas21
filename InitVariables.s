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



;     ld      hl, ConveyorBeltOccupation
;     ld      b, 6
;     xor     a
; .loop:
;     ld      (hl), a
;     inc     hl
;     djnz    .loop
    


    ld      hl, Gift_1_Struct
    ld      d, 1
    call    InitGift

    ld      hl, Gift_2_Struct
    ld      d, 2
    call    InitGift



    ; init sprite attributes table
    ld      hl, TestSpriteAttributes
    ld      de, SpriteAttributes
    ld      bc, TestSpriteAttributes.size
    ldir


    ret
InitVariables:

    ld      a, 128 - 8
    ld      (PlayerX), a

    ld      a, 192 - 24 - 8
    ld      (PlayerY), a



    xor     a
    ld      (PlayerAnimationFrame), a


    ld      hl, Gift_1_Struct
    call    InitGift



    ; init sprite attributes table
    ld      hl, TestSpriteAttributes
    ld      de, SpriteAttributes
    ld      bc, TestSpriteAttributes.size
    ldir


    ret
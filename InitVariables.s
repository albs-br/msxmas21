InitVariables:

    ld      a, 128 - 8
    ld      (PlayerX), a

    ld      a, 192 - 16 - 8 - 16
    ld      (PlayerY), a



    xor     a
    ld      (PlayerAnimationFrame), a


    
    ; init sprite attributes table
    ld      hl, TestSpriteAttributes
    ld      de, SpriteAttributes
    ld      bc, TestSpriteAttributes.size
    ldir


    ret
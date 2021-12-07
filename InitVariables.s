InitVariables:

    ld      a, 128 - 8
    ld      (PlayerX), a

    
    
    ; init sprite attributes table
    ld      hl, TestSpriteAttributes
    ld      de, SpriteAttributes
    ld      bc, TestSpriteAttributes.size
    ldir


    ret
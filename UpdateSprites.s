UpdateSprites:

    ld      hl, SpriteAttributes
    
    ; Santa Claus top
    inc     hl
    ld      a, (PlayerX)
    ld      (hl), a

    inc     hl
    inc     hl
    inc     hl
    inc     hl
    ld      (hl), a

    inc     hl
    inc     hl
    inc     hl
    inc     hl
    ld      (hl), a

    inc     hl
    inc     hl
    inc     hl
    inc     hl
    ld      (hl), a

    ; Santa Claus bottom
    inc     hl
    inc     hl
    inc     hl
    inc     hl
    ld      (hl), a

    inc     hl
    inc     hl
    inc     hl
    inc     hl
    ld      (hl), a

    inc     hl
    inc     hl
    inc     hl
    inc     hl
    ld      (hl), a



    ; update sprite attributes table
    ld      a, 0000 0001 b
    ld      hl, SPRATR
    call    SetVdp_Write
    ld      b, SpriteAttributes.size
    ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
    ld      hl, SpriteAttributes
    otir

    ret
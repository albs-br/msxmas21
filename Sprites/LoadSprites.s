LoadSprites:

    ; Spr 0 pattern
    ld      a, 0000 0001 b
    ld      hl, SPRPAT + (32 * 0)
    call    SetVdp_Write
    ld      b, 32
    ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 0)
    otir

    ; Spr 1 pattern
    ld      a, 0000 0001 b
    ld      hl, SPRPAT + (32 * 1)
    call    SetVdp_Write
    ld      b, 32
    ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 1)
    otir

    ; Spr 2 pattern
    ld      a, 0000 0001 b
    ld      hl, SPRPAT + (32 * 2)
    call    SetVdp_Write
    ld      b, 32
    ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 2)
    otir

    ; Spr 3 pattern
    ld      a, 0000 0001 b
    ld      hl, SPRPAT + (32 * 3)
    call    SetVdp_Write
    ld      b, 32
    ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 3)
    otir



    ; Spr 0 color
    ld      a, 0000 0001 b
    ld      hl, SPRCOL + (16 * 0)
    call    SetVdp_Write
    ld      b, 16
    ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 0) + 32
    otir

    ; Spr 1 color
    ld      a, 0000 0001 b
    ld      hl, SPRCOL + (16 * 1)
    call    SetVdp_Write
    ld      b, 16
    ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 1) + 32
    otir

    ; Spr 2 color
    ld      a, 0000 0001 b
    ld      hl, SPRCOL + (16 * 2)
    call    SetVdp_Write
    ld      b, 16
    ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 2) + 32
    otir

    ; Spr 3 color
    ld      a, 0000 0001 b
    ld      hl, SPRCOL + (16 * 3)
    call    SetVdp_Write
    ld      b, 16
    ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 3) + 32
    otir

    ret
LoadSprites:

; -------------- Santa Claus standing right

    ; --- Sprite patterns

    ; Spr 0 pattern
    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 0)
    ld      de, SPRPAT + (32 * 0)
    call    LoadSpritePatterns_16x16

    ; Spr 1 pattern
    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 1)
    ld      de, SPRPAT + (32 * 1)
    call    LoadSpritePatterns_16x16

    ; Spr 2 pattern
    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 2)
    ld      de, SPRPAT + (32 * 2)
    call    LoadSpritePatterns_16x16

    ; Spr 3 pattern
    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 3)
    ld      de, SPRPAT + (32 * 3)
    call    LoadSpritePatterns_16x16



    ; --- Sprite colors

    ; Spr 0 color
    ; ld      a, 0000 0001 b
    ; ld      hl, SPRCOL + (16 * 0)
    ; call    SetVdp_Write
    ; ld      b, 16
    ; ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
    ; ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 0) + 32
    ; otir
    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 0) + 32
    ld      de, SPRCOL + (16 * 0)
    call    LoadSpriteColors_16x16

    ; Spr 1 color
    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 1) + 32
    ld      de, SPRCOL + (16 * 1)
    call    LoadSpriteColors_16x16

    ; Spr 2 color
    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 2) + 32
    ld      de, SPRCOL + (16 * 2)
    call    LoadSpriteColors_16x16

    ; Spr 3 color
    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 3) + 32
    ld      de, SPRCOL + (16 * 3)
    call    LoadSpriteColors_16x16

    ret




; HL: source on RAM
; DE: destiny on VRAM
LoadSpritePatterns_16x16:
    push    hl
        ld      a, 0000 0001 b
        ld      h, d
        ld      l, e
        call    SetVdp_Write

        ld      bc, 0 + (32 * 256) + PORT_0
    pop     hl
    otir

    ret


; HL: source on RAM
; DE: destiny on VRAM
LoadSpriteColors_16x16:
    push    hl
        ld      a, 0000 0001 b
        ld      h, d
        ld      l, e
        call    SetVdp_Write

        ld      bc, 0 + (16 * 256) + PORT_0
    pop     hl
    otir

    ret
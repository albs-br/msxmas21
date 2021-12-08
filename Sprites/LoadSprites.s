LoadSprites:

; -------------- Santa Claus standing right

    ; --- Sprite patterns


    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right_Top
    ld      IX, SPRPAT
    ld      IY, SPRCOL
    ld      b, 4
    call    LoadSpritesWithColors

    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right_Bottom
    ld      IX, SPRPAT + (4 * 32)
    ld      IY, SPRCOL + (4 * 16)
    ld      b, 3
    call    LoadSpritesWithColors

    ld      hl, SpritePatternsAndColors_Gift_1
    ld      IX, SPRPAT + (7 * 32)
    ld      IY, SPRCOL + (7 * 16)
    ld      b, 3
    call    LoadSpritesWithColors

    ; Spr 0 pattern
    ; ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 0)
    ; ld      de, SPRPAT + (32 * 0)
    ; call    LoadSpritePatterns_16x16

    ; ; Spr 1 pattern
    ; ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 1)
    ; ld      de, SPRPAT + (32 * 1)
    ; call    LoadSpritePatterns_16x16

    ; ; Spr 2 pattern
    ; ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 2)
    ; ld      de, SPRPAT + (32 * 2)
    ; call    LoadSpritePatterns_16x16

    ; ; Spr 3 pattern
    ; ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 3)
    ; ld      de, SPRPAT + (32 * 3)
    ; call    LoadSpritePatterns_16x16



    ; --- Sprite colors

    ; ; Spr 0 color
    ; ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 0) + 32
    ; ld      de, SPRCOL + (16 * 0)
    ; call    LoadSpriteColors_16x16

    ; ; Spr 1 color
    ; ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 1) + 32
    ; ld      de, SPRCOL + (16 * 1)
    ; call    LoadSpriteColors_16x16

    ; ; Spr 2 color
    ; ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 2) + 32
    ; ld      de, SPRCOL + (16 * 2)
    ; call    LoadSpriteColors_16x16

    ; ; Spr 3 color
    ; ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 3) + 32
    ; ld      de, SPRCOL + (16 * 3)
    ; call    LoadSpriteColors_16x16

    ret



; HL: source on RAM
; IX: pattern destiny on VRAM
; IY: color destiny on VRAM
; B: number of sprites
LoadSpritesWithColors:

    ; Spr 0 pattern
    ; ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 0)
    ; ld      de, SPRPAT + (32 * 0)

    push    hl
        push    bc

.loop:
            push    bc
                push    hl
                    ld      d, ixh
                    ld      e, ixl
                    call    LoadSpritePatterns_16x16
                pop     hl
                call    .nextHLAndIX
            pop     bc

            djnz    .loop

        pop     bc
    pop     hl


    ; ; Spr 1 pattern
    ; ; ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 1)
    ; ; ld      de, SPRPAT + (32 * 1)
    ; call    LoadSpritePatterns_16x16

    ; ; Spr 2 pattern
    ; ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 2)
    ; ld      de, SPRPAT + (32 * 2)
    ; call    LoadSpritePatterns_16x16

    ; ; Spr 3 pattern
    ; ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 3)
    ; ld      de, SPRPAT + (32 * 3)
    ; call    LoadSpritePatterns_16x16


    ; HL += 32
    ld      de, 32
    add     hl, de

.loop1:
    push    bc

        ; ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 0) + 32
        ; ld      de, SPRCOL + (16 * 0)
        push    hl
            ld      d, iyh
            ld      e, iyl
            call    LoadSpriteColors_16x16
        pop     hl
        call    .nextHLAndIY

    pop     bc

    djnz    .loop1



    ; Spr 0 color
    ; ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 0) + 32
    ; ld      de, SPRCOL + (16 * 0)
    ; call    LoadSpriteColors_16x16

    ; ; Spr 1 color
    ; ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 1) + 32
    ; ld      de, SPRCOL + (16 * 1)
    ; call    LoadSpriteColors_16x16

    ; ; Spr 2 color
    ; ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 2) + 32
    ; ld      de, SPRCOL + (16 * 2)
    ; call    LoadSpriteColors_16x16

    ; ; Spr 3 color
    ; ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right + (48 * 3) + 32
    ; ld      de, SPRCOL + (16 * 3)
    ; call    LoadSpriteColors_16x16



    ret

.nextHLAndIX:
    ; HL += 48
    ld      bc, 48
    add     hl, bc
    ; IX += 32
    push    hl
        ld      d, ixh
        ld      e, ixl
        ld      hl, 32
        add     hl, de
        ex      de, hl
        ld      ixh, d
        ld      ixl, e
    pop     hl
    ret

.nextHLAndIY:
    ; HL += 48
    ld      bc, 48
    add     hl, bc
    ; IX += 16
    push    hl
        ld      d, iyh
        ld      e, iyl
        ld      hl, 16
        add     hl, de
        ex      de, hl
        ld      iyh, d
        ld      iyl, e
    pop     hl
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
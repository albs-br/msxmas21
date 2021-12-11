; animation frames constants

SANTA_CLAUS_STANDING_RIGHT:     equ 0
SANTA_CLAUS_WALKING_RIGHT_1:     equ 10
SANTA_CLAUS_WALKING_RIGHT_2:     equ 17



LoadSprites:

; -------------- Santa Claus standing right

    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right_Top
    ld      IX, SPRPAT + (SANTA_CLAUS_STANDING_RIGHT * 32)
    ld      IY, SPRCOL + (SANTA_CLAUS_STANDING_RIGHT * 32)
    ld      b, 4
    call    LoadSpritePatternsWithColors

    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right_Bottom
    ld      IX, SPRPAT + ((SANTA_CLAUS_STANDING_RIGHT + 4) * 32)
    ld      IY, SPRCOL + ((SANTA_CLAUS_STANDING_RIGHT + 4) * 16)
    ld      b, 3
    call    LoadSpritePatternsWithColors


; --------------- Gift 1

    ld      hl, SpritePatternsAndColors_Gift_1
    ld      IX, SPRPAT + (7 * 32)
    ld      IY, SPRCOL + (7 * 16)
    ld      b, 3
    call    LoadSpritePatternsWithColors


; -------------- Santa Claus walking right 1

    ld      hl, SpritePatternsAndColors_SantaClaus_Walking_Right_1_Top
    ld      IX, SPRPAT + (SANTA_CLAUS_WALKING_RIGHT_1 * 32)
    ld      b, 4
    call    LoadSpritePatterns

    ld      hl, SpritePatternsAndColors_SantaClaus_Walking_Right_1_Bottom
    ld      IX, SPRPAT + ((SANTA_CLAUS_WALKING_RIGHT_1 + 4) * 32)
    ld      b, 3
    call    LoadSpritePatterns

; -------------- Santa Claus walking right 2

    ld      hl, SpritePatternsAndColors_SantaClaus_Walking_Right_2_Top
    ld      IX, SPRPAT + (SANTA_CLAUS_WALKING_RIGHT_2 * 32)
    ld      b, 4
    call    LoadSpritePatterns

    ld      hl, SpritePatternsAndColors_SantaClaus_Walking_Right_2_Bottom
    ld      IX, SPRPAT + ((SANTA_CLAUS_WALKING_RIGHT_2 + 4) * 32)
    ld      b, 3
    call    LoadSpritePatterns

; -------------- Santa Claus walking left 1

    ld      hl, SpritePatternsAndColors_SantaClaus_Walking_Left_1_Top
    ld      IX, SPRPAT + (24 * 32)
    ld      b, 4
    call    LoadSpritePatterns

    ld      hl, SpritePatternsAndColors_SantaClaus_Walking_Left_1_Bottom
    ld      IX, SPRPAT + (28 * 32)
    ld      b, 3
    call    LoadSpritePatterns

; -------------- Santa Claus walking left 2

    ld      hl, SpritePatternsAndColors_SantaClaus_Walking_Left_2_Top
    ld      IX, SPRPAT + (31 * 32)
    ld      b, 4
    call    LoadSpritePatterns

    ld      hl, SpritePatternsAndColors_SantaClaus_Walking_Left_2_Bottom
    ld      IX, SPRPAT + (35 * 32)
    ld      b, 3
    call    LoadSpritePatterns


    ret



; HL: source on RAM
; IX: pattern destiny on VRAM
; IY: color destiny on VRAM
; B: number of sprites
LoadSpritePatternsWithColors:

    call    LoadSpritePatterns

    call    LoadSpriteColors

    ret



; HL: source on RAM
; IX: pattern destiny on VRAM
; B: number of sprites
LoadSpritePatterns:

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

; HL: source on RAM
; IY: color destiny on VRAM
; B: number of sprites
LoadSpriteColors:
    ; HL += 32
    ld      de, 32
    add     hl, de

.loop:
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

    djnz    .loop

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
        ld      a, 0000 0000 b
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
        ld      a, 0000 0000 b
        ld      h, d
        ld      l, e
        call    SetVdp_Write

        ld      bc, 0 + (16 * 256) + PORT_0
    pop     hl
    otir

    ret
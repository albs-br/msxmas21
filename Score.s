
IncrementScore:
    ld      a, 1        ;
    ld      hl, (Score)
    add     a, l
    daa
    ld      l, a
    jp      c, .addH
    jp      .continue

.addH:
    ld      a, 1        ;
    add     a, h
    daa
    ld      h, a

.continue:
    ld      (Score), hl
    ret


DrawScore:
    ; get score (BCD encoded)
    ld      de, (Score)

    ; set pointer to start of jump table of the digit patterns
    ld      hl, DigitPatternsJumpTable
    
    ; get least significant digit (units) and multiply it by 2 (because the jump table items are two bytes long)
    ld      a, e
    and     0000 1111b          ; mask to get only low nibble
    add     a, a
    
    ; add it to HL to point to the corresponding digit pattern
    ld      b, 0
    ld      c, a
    add     hl, bc
    
    ; get the address pointed by HL and put it in HL
    ld      c, (hl)     ; least significant byte of addr
    inc     hl
    ld      b, (hl)     ; most significant byte of addr
    ld      l, c
    ld      h, b

    ; draw digit pattern on first position
    ; ld      hl, SpritePatternsAndColors_Number_0
    ld      IX, SPRPAT + (SCORE_DIGITS_0_AND_1 * 32) + 16
    ld      b, 2
    call    LoadSpritePatterns_2

    ; TODO:
    ld      hl, SpritePatternsAndColors_Number_0
    ld      IX, SPRPAT + (SCORE_DIGITS_0_AND_1 * 32)
    ld      b, 2
    call    LoadSpritePatterns_2

    ret


; Jump table for digit patterns
DigitPatternsJumpTable:
    dw  SpritePatternsAndColors_Number_0, SpritePatternsAndColors_Number_1, SpritePatternsAndColors_Number_2
    dw  SpritePatternsAndColors_Number_3, SpritePatternsAndColors_Number_4, SpritePatternsAndColors_Number_5
    dw  SpritePatternsAndColors_Number_6, SpritePatternsAndColors_Number_7, SpritePatternsAndColors_Number_8
    dw  SpritePatternsAndColors_Number_9

; DrawScore:
; ld hl, (Score) ; ld de, (Score)?
; ex de, hl


; ld hl, JumpTablePatternDigits
; ld d, 0
; ld a, e
; add hl, de
; ld hl, (hl)

; ld a, 0000 0000b
; ld de, FirstDigitScore
; call ?????


; ret
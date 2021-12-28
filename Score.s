
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


; -------- digit of units
    ; get score (BCD encoded)
    ld      a, (Score)

    ; get least significant digit (units)
    and     0000 1111b          ; mask to get only low nibble

    ld      IX, SPRPAT + (SCORE_DIGITS_0_AND_1 * 32) + 16
    call    DrawDigitPattern


; -------- digit of tens
    ; get score (BCD encoded)
    ld      a, (Score)

    ; get least significant digit (units)
    and     1111 0000b          ; mask to get only high nibble
    srl     a                   ; shift right 4 times
    srl     a
    srl     a
    srl     a

    ld      IX, SPRPAT + (SCORE_DIGITS_0_AND_1 * 32)
    call    DrawDigitPattern


    ret

; Jump table for digit patterns
DigitPatternsJumpTable:
    dw  SpritePatternsAndColors_Number_0, SpritePatternsAndColors_Number_1, SpritePatternsAndColors_Number_2
    dw  SpritePatternsAndColors_Number_3, SpritePatternsAndColors_Number_4, SpritePatternsAndColors_Number_5
    dw  SpritePatternsAndColors_Number_6, SpritePatternsAndColors_Number_7, SpritePatternsAndColors_Number_8
    dw  SpritePatternsAndColors_Number_9

; Inputs:
;   A: digit (0-9)
;  IX: pattern address on VRAM SPRTBL
DrawDigitPattern:
    ; multiply digit by 2 (because the jump table items are two bytes long)
    add     a, a
    
    ; set pointer to start of jump table of the digit patterns
    ld      hl, DigitPatternsJumpTable

    ; add it to HL to point to the corresponding digit pattern
    ld      b, 0
    ld      c, a
    add     hl, bc
    
    ; get the address pointed by HL and put it in HL
    ld      a, (hl)     ; least significant byte of addr
    inc     hl
    ld      h, (hl)     ; most significant byte of addr
    ld      l, a

    ; draw digit pattern on first position
    ; ld      hl, SpritePatternsAndColors_Number_0
    ;ld      IX, SPRPAT + (SCORE_DIGITS_0_AND_1 * 32) + 16
    ld      b, 2
    call    LoadSpritePatterns_2

    ret

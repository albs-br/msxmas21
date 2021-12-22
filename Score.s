
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
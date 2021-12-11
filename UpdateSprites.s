UpdateSprites:

    ld      hl, SpriteAttributes


; --------------------------------- Santa Claus top -----------------------------------

; --------- Sprite #0

    ld      a, (PlayerY)
    ld      (hl), a

    inc     hl
    ld      a, (PlayerX)
    ld      (hl), a

    inc     hl
    ld      a, (PlayerAnimationFrame)
    ld      (hl), a

    inc     hl
    inc     hl

; --------- Sprite #1

    ld      a, (PlayerY)
    ld      (hl), a

    inc     hl
    ld      a, (PlayerX)
    ld      (hl), a

    inc     hl
    ld      a, (PlayerAnimationFrame)
    add     a, 1 * 4
    ld      (hl), a

    inc     hl
    inc     hl

; --------- Sprite #2

    ld      a, (PlayerY)
    ld      (hl), a

    inc     hl
    ld      a, (PlayerX)
    ld      (hl), a

    inc     hl
    ld      a, (PlayerAnimationFrame)
    add     a, 2 * 4
    ld      (hl), a

    inc     hl
    inc     hl

; --------- Sprite #3

    ld      a, (PlayerY)
    ld      (hl), a

    inc     hl
    ld      a, (PlayerX)
    ld      (hl), a

    inc     hl
    ld      a, (PlayerAnimationFrame)
    add     a, 3 * 4
    ld      (hl), a

    inc     hl
    inc     hl

; --------------------------------- Santa Claus bottom -----------------------------------

; --------- Sprite #4

    ld      a, (PlayerY)
    add     a, 16
    ld      (hl), a

    inc     hl
    ld      a, (PlayerX)
    ld      (hl), a

    inc     hl
    ld      a, (PlayerAnimationFrame)
    add     a, 4 * 4
    ld      (hl), a

    inc     hl
    inc     hl

; --------- Sprite #5

    ld      a, (PlayerY)
    add     a, 16
    ld      (hl), a

    inc     hl
    ld      a, (PlayerX)
    ld      (hl), a

    inc     hl
    ld      a, (PlayerAnimationFrame)
    add     a, 5 * 4
    ld      (hl), a

    inc     hl
    inc     hl

; --------- Sprite #6

    ld      a, (PlayerY)
    add     a, 16
    ld      (hl), a

    inc     hl
    ld      a, (PlayerX)
    ld      (hl), a

    inc     hl
    ld      a, (PlayerAnimationFrame)
    add     a, 6 * 4
    ld      (hl), a

    inc     hl
    inc     hl

; --------- Sprite #7


    ; update sprite attributes table
    ld      a, 0000 0000 b
    ld      hl, SPRATR
    call    SetVdp_Write
    ld      b, SpriteAttributes.size
    ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
    ld      hl, SpriteAttributes
    otir

    ret
UpdateSprites:

    ld      hl, SpriteAttributes


; ================================== Santa Claus top ==================================

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

; ================================== Santa Claus bottom ==================================

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

; ================================== Gift 1 ==================================

; --------- Sprite #7

    ; Hide gift?
    ld      de, Gift_1_Struct + 7
    ld      a, (de)
    or      a
    jp      nz, .hideGift_1

    ; Y
    ld      de, Gift_1_Struct + 3
    ld      a, (de)
    jp      .continueGift_1

.hideGift_1:
    ld      a, 192

.continueGift_1:
    ld      c, a

    ; Y
    ld      (hl), c

    ; X
    ld      de, Gift_1_Struct + 2
    inc     hl
    ld      a, (de)
    ld      (hl), a

    inc     hl
    ld      a, GIFT_1 * 4
    ld      (hl), a

    inc     hl
    inc     hl

; --------- Sprite #8

    ; Y
    ld      (hl), c

    ; X
    ld      de, Gift_1_Struct + 2
    inc     hl
    ld      a, (de)
    ld      (hl), a

    inc     hl
    ld      a, 0 + (GIFT_1 + 1) * 4
    ld      (hl), a

    inc     hl
    inc     hl

; --------- Sprite #9

    ; Y
    ld      (hl), c

    ; X
    ld      de, Gift_1_Struct + 2
    inc     hl
    ld      a, (de)
    ld      (hl), a

    inc     hl
    ld      a, 0 + (GIFT_1 + 2) * 4
    ld      (hl), a

    inc     hl
    inc     hl

; ================================== Gift 2 ==================================

; --------- Sprite #10

    ; Hide gift?
    ld      de, Gift_2_Struct + 7
    ld      a, (de)
    or      a
    jp      nz, .hideGift_2

    ; Y
    ld      de, Gift_2_Struct + 3
    ld      a, (de)
    jp      .continueGift_2

.hideGift_2:
    ld      a, 192

.continueGift_2:
    ld      c, a

    ; Y
    ld      (hl), c

    ; X
    ld      de, Gift_2_Struct + 2
    inc     hl
    ld      a, (de)
    ld      (hl), a

    inc     hl
    ld      a, GIFT_1 * 4
    ld      (hl), a

    inc     hl
    inc     hl

; --------- Sprite #11

    ; Y
    ld      (hl), c

    ; X
    ld      de, Gift_2_Struct + 2
    inc     hl
    ld      a, (de)
    ld      (hl), a

    inc     hl
    ld      a, 0 + (GIFT_1 + 1) * 4
    ld      (hl), a

    inc     hl
    inc     hl

; --------- Sprite #12

    ; Y
    ld      (hl), c

    ; X
    ld      de, Gift_2_Struct + 2
    inc     hl
    ld      a, (de)
    ld      (hl), a

    inc     hl
    ld      a, 0 + (GIFT_1 + 2) * 4
    ld      (hl), a

    inc     hl
    inc     hl

; ================================== Gift 3 ==================================

; --------- Sprite #13

    ; Hide gift?
    ld      de, Gift_3_Struct + 7
    ld      a, (de)
    or      a
    jp      nz, .hideGift_3

    ; Y
    ld      de, Gift_3_Struct + 3
    ld      a, (de)
    jp      .continueGift_3

.hideGift_3:
    ld      a, 192

.continueGift_3:
    ld      c, a

    ; Y
    ld      (hl), c

    ; X
    ld      de, Gift_3_Struct + 2
    inc     hl
    ld      a, (de)
    ld      (hl), a

    inc     hl
    ld      a, GIFT_1 * 4
    ld      (hl), a

    inc     hl
    inc     hl

; --------- Sprite #14

    ; Y
    ld      (hl), c

    ; X
    ld      de, Gift_3_Struct + 2
    inc     hl
    ld      a, (de)
    ld      (hl), a

    inc     hl
    ld      a, 0 + (GIFT_1 + 1) * 4
    ld      (hl), a

    inc     hl
    inc     hl

; --------- Sprite #15

    ; Y
    ld      (hl), c

    ; X
    ld      de, Gift_3_Struct + 2
    inc     hl
    ld      a, (de)
    ld      (hl), a

    inc     hl
    ld      a, 0 + (GIFT_1 + 2) * 4
    ld      (hl), a

    inc     hl
    inc     hl


; ================================== Gift 4 ==================================

; --------- Sprite #16

    ; Hide gift?
    ld      de, Gift_4_Struct + 7
    ld      a, (de)
    or      a
    jp      nz, .hideGift_4

    ; Y
    ld      de, Gift_4_Struct + 3
    ld      a, (de)
    jp      .continueGift_4

.hideGift_4:
    ld      a, 192

.continueGift_4:
    ld      c, a

    ; Y
    ld      (hl), c

    ; X
    ld      de, Gift_4_Struct + 2
    inc     hl
    ld      a, (de)
    ld      (hl), a

    inc     hl
    ld      a, GIFT_1 * 4
    ld      (hl), a

    inc     hl
    inc     hl

; --------- Sprite #14

    ; Y
    ld      (hl), c

    ; X
    ld      de, Gift_4_Struct + 2
    inc     hl
    ld      a, (de)
    ld      (hl), a

    inc     hl
    ld      a, 0 + (GIFT_1 + 1) * 4
    ld      (hl), a

    inc     hl
    inc     hl

; --------- Sprite #15

    ; Y
    ld      (hl), c

    ; X
    ld      de, Gift_4_Struct + 2
    inc     hl
    ld      a, (de)
    ld      (hl), a

    inc     hl
    ld      a, 0 + (GIFT_1 + 2) * 4
    ld      (hl), a

    inc     hl
    inc     hl



    ; update sprite attributes table
    ld      a, 0000 0000 b
    ld      hl, SPRATR
    call    SetVdp_Write
    ; ld      b, SpriteAttributes.size
    ; ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
    ld      bc, 0 + (SpriteAttributes.size * 256) + PORT_0
    ld      hl, SpriteAttributes
    otir

    ret
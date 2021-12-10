ReadInput:
    ; read keyboard
    ld      a, 8                    ; 8th line
    call    BIOS_SNSMAT         ; Read Data Of Specified Line From Keyboard Matrix




    bit     4, a                    ; 4th bit (key left)
    jp      z, .playerLeft

    bit     7, a                    ; 7th bit (key right)
    jp      z, .playerRight



    ; ------------ no key pressed


    ; default animation frame
    xor      a
    ld      (PlayerAnimationFrame), a

    ; load colors
    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right_Top
    ld      iy, SPRCOL + (0 * 16)
    ld      b, 4
    call    LoadSpriteColors

    ld      hl, SpritePatternsAndColors_SantaClaus_Standing_Right_Bottom
    ld      iy, SPRCOL + (4 * 16)
    ld      b, 3
    call    LoadSpriteColors

    ret

.playerLeft:
    ld      a, (PlayerX)

    cp      0
    ret     z
    ret     c

    sub     a, 2
    ld      (PlayerX), a

    ret

.playerRight:
    ld      a, (PlayerX)

    cp      255 - 16
    ret     nc

    add     a, 2
    ld      (PlayerX), a



    ; load colors
    ld      hl, SpritePatternsAndColors_SantaClaus_Walking_Right_1_Top
    ld      iy, SPRCOL + (0 * 16)
    ld      b, 4
    call    LoadSpriteColors

    ld      hl, SpritePatternsAndColors_SantaClaus_Walking_Right_1_Bottom
    ld      iy, SPRCOL + (4 * 16)
    ld      b, 3
    call    LoadSpriteColors


    ld      a, 10 * 4

    ; ld a, 10
    ; add JIFFY AND 0000 0001
    ; mult a by 4

    ld      (PlayerAnimationFrame), a

    ret
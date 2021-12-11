ReadInput:
    ; read keyboard
    ld      a, 8                    ; 8th line
    call    BIOS_SNSMAT         ; Read Data Of Specified Line From Keyboard Matrix




    bit     4, a                    ; 4th bit (key left)
    jp      z, .playerLeft

    bit     7, a                    ; 7th bit (key right)
    jp      z, .playerRight



    ; ------------ no key pressed


    jp      .setFrame0

    ret

.playerLeft:
    ld      a, (PlayerX)

    cp      0
    ret     z
    ret     c

    sub     a, 2
    ld      (PlayerX), a





    ; animation
    
    ld      a, (BIOS_JIFFY)
    and     0000 1000b
    
    or      a       ; if (a == 0)
    jp      nz, .frame2_Left

; frame1

    ld      a, 24 * 4
    ld      (PlayerAnimationFrame), a

    ; load colors
    ld      hl, SpritePatternsAndColors_SantaClaus_Walking_Left_1_Top
    ld      iy, SPRCOL + (0 * 16)
    ld      b, 4
    call    LoadSpriteColors

    ld      hl, SpritePatternsAndColors_SantaClaus_Walking_Left_1_Bottom
    ld      iy, SPRCOL + (4 * 16)
    ld      b, 3
    call    LoadSpriteColors

    jp      .continue

.frame2_Left:

    ld      a, 31 * 4
    ld      (PlayerAnimationFrame), a

    ; load colors
    ld      hl, SpritePatternsAndColors_SantaClaus_Walking_Left_2_Top
    ld      iy, SPRCOL + (0 * 16)
    ld      b, 4
    call    LoadSpriteColors

    ld      hl, SpritePatternsAndColors_SantaClaus_Walking_Left_2_Bottom
    ld      iy, SPRCOL + (4 * 16)
    ld      b, 3
    call    LoadSpriteColors

    ret

.playerRight:
    ld      a, (PlayerX)

    cp      255 - 16
    jp      nc, .setFrame0

    add     a, 2
    ld      (PlayerX), a





    ; animation
    
    ld      a, (BIOS_JIFFY)
    and     0000 1000b
    
    or      a       ; if (a == 0)
    jp      nz, .frame2

; frame1

    ld      a, 10 * 4
    ld      (PlayerAnimationFrame), a

    ; load colors
    ld      hl, SpritePatternsAndColors_SantaClaus_Walking_Right_1_Top
    ld      iy, SPRCOL + (0 * 16)
    ld      b, 4
    call    LoadSpriteColors

    ld      hl, SpritePatternsAndColors_SantaClaus_Walking_Right_1_Bottom
    ld      iy, SPRCOL + (4 * 16)
    ld      b, 3
    call    LoadSpriteColors

    jp      .continue

.frame2:

    ld      a, 17 * 4
    ld      (PlayerAnimationFrame), a

    ; load colors
    ld      hl, SpritePatternsAndColors_SantaClaus_Walking_Right_2_Top
    ld      iy, SPRCOL + (0 * 16)
    ld      b, 4
    call    LoadSpriteColors

    ld      hl, SpritePatternsAndColors_SantaClaus_Walking_Right_2_Bottom
    ld      iy, SPRCOL + (4 * 16)
    ld      b, 3
    call    LoadSpriteColors

.continue:

    ret

.setFrame0:
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
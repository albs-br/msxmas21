ReadInput:
    ; read keyboard
    ld      a, 8                    ; 8th line
    call    BIOS_SNSMAT         ; Read Data Of Specified Line From Keyboard Matrix

    bit     4, a                    ; 4th bit (key left)
    jp      z, .playerLeft

    bit     7, a                    ; 7th bit (key right)
    jp      z, .playerRight

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

    ret
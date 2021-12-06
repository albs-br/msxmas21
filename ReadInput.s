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
    inc     a
    ld      (PlayerX), a


    ret

.playerRight:
    ret
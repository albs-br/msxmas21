GameLogic:

    ; if (Status == 0)
    ld      a, (Gift_1_Status)
    or      a

    jp      nz, .falling

    ; move horizontally
    
    ; X += DX
    ld      a, (Gift_1_Dx)
    ld      b, a
    ld      a, (Gift_1_X)
    add     a, b
    ld      (Gift_1_X), a

    ; (if X == ConveyorBeltEnd)
    ld      b, a
    ld      a, (Gift_1_ConveyorBeltEnd)
    cp      b
    jp      z, .startFalling

    ret



.startFalling:
    ld      a, 1
    ld      (Gift_1_Status), a
    ld      a, 2
    ld      (Gift_1_Dy), a

    ret



.falling:
    ; Y += DY
    ld      a, (Gift_1_Dy)
    ld      b, a
    ld      a, (Gift_1_Y)
    add     a, b
    ld      (Gift_1_Y), a

    ld      hl, Gift_1_Struct

    ; (if Y >= 192)
    ld      b, a
    ld      a, 192
    cp      b
    call    z, InitGift
    call    c, InitGift

    ret


InitGift:

    ; Status:              rb 1    ; 0: Horizontal; >= 1: Falling
    ; ConveyorBeltEnd:     rb 1    ; X coordinate where the conveyor belt ends (gift starts falling)
    ; X:                   rb 1
    ; Y:                   rb 1
    ; Dx:                  rb 1    ; Delta X (amount of pixels to move horizontally each frame; can be negative)
    ; Dy:                  rb 1    ; Delta Y

    ; Status
    ld      a, 0
    ld      (hl), a

    ; ConveyorBeltEnd
    inc     hl    
    ld      a, 127
    ld      (hl), a

    ; X
    inc     hl    
    ld      a, 0
    ld      (hl), a

    ; Y
    inc     hl    
    ld      a, 16
    ld      (hl), a

    ; DX
    inc     hl    
    ld      a, 1
    ld      (hl), a

    ; DY
    inc     hl    
    ld      a, 0
    ld      (hl), a

    ret
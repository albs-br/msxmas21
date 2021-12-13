GameLogic:

    ld      hl, Gift_1_Struct
    call    GiftLogic

    ret


InitGift:

    ; Status:              rb 1    ; 0: Horizontal; >= 1: Falling
    ; ConveyorBeltEnd:     rb 1    ; X coordinate where the conveyor belt ends (gift starts falling)
    ; X:                   rb 1
    ; Y:                   rb 1
    ; Dx:                  rb 1    ; Delta X (amount of pixels to move horizontally each frame; can be negative)
    ; Dy:                  rb 1    ; Delta Y


    jp .topRight; debug

.topLeft:
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

.topRight:
    ; Status
    ld      a, 0
    ld      (hl), a

    ; ConveyorBeltEnd
    inc     hl
    ld      a, 180
    ld      (hl), a

    ; X
    inc     hl
    ld      a, 255
    ld      (hl), a

    ; Y
    inc     hl
    ld      a, 16 + 32 + 32
    ld      (hl), a

    ; DX
    inc     hl
    ld      a, -1
    ld      (hl), a

    ; DY
    inc     hl
    ld      a, 0
    ld      (hl), a

    ret



GiftLogic:

    ; save hl
    push     hl

        ; Copy object vars to temp vars
        ;ld      hl, ?                                          ; source
        ld      de, Gift_Temp_Struct                            ; destiny
        ld      bc, Gift_Temp_Struct.size                       ; size
        ldir                                                    ; Copy BC bytes from HL to DE



        ; if (Status == 0)
        ld      a, (Gift_Temp_Status)
        or      a

        jp      nz, .falling

        ; move horizontally
        
        ; X += DX
        ld      a, (Gift_Temp_Dx)
        ld      b, a
        ld      a, (Gift_Temp_X)
        add     a, b
        ld      (Gift_Temp_X), a

        ; (if X == ConveyorBeltEnd)
        ld      b, a
        ld      a, (Gift_Temp_ConveyorBeltEnd)
        cp      b
        jp      z, .startFalling

        jp      .return



.startFalling:
        ld      a, 1
        ld      (Gift_Temp_Status), a
        ld      a, 2
        ld      (Gift_Temp_Dy), a

        jp      .return



.falling:
        ; Y += DY
        ld      a, (Gift_Temp_Dy)
        ld      b, a
        ld      a, (Gift_Temp_Y)
        add     a, b
        ld      (Gift_Temp_Y), a

        ld      hl, Gift_Temp_Struct

        ; (if Y >= 192)
        ld      b, a
        ld      a, 192
        cp      b
        call    z, InitGift
        call    c, InitGift


.return:
        ; Copy temp vars back to object vars
        ld      hl, Gift_Temp_Struct                        ; source
    pop     de                                              ; destiny
    ld      bc, Gift_Temp_Struct.size                       ; size
    ldir                                                    ; Copy BC bytes from HL to DE

    ret
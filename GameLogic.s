; CONVEYOR_BELT_TOP_LEFT_Y:           equ 16
; CONVEYOR_BELT_TOP_RIGHT_Y:           equ 16 + 16
; CONVEYOR_BELT_TOP_LEFT_Y:           equ 16
; CONVEYOR_BELT_TOP_RIGHT_Y:           equ 16 + 16

GIFT_WAIT_TIME:         equ 60

GameLogic:

    ld      hl, Gift_1_Struct
    call    GiftLogic

    ld      hl, Gift_2_Struct
    call    GiftLogic

    ld      hl, Gift_3_Struct
    call    GiftLogic

    ld      hl, Gift_4_Struct
    call    GiftLogic

    ret




; x = (256 - 2d) / 5
_D:     equ 30                      ; distance from screen border to first/last conveyor belt end
_X:     equ (256 - (2 * _D)) / 5    ; space from one conveyor belt end to another

TopLeft_ConveyorBelt_Data:
    db      240, _D + ((3 - 1) * _X),   0, 0,   1, 0, 1

TopRight_ConveyorBelt_Data:
    db      180, _D + ((4 - 1) * _X), 255, 16, -1, 0, 2

MidLeft_ConveyorBelt_Data:
    db      120, _D + ((2 - 1) * _X),   0, 32,   1, 0, 3

MidRight_ConveyorBelt_Data:
    db      60, _D + ((5 - 1) * _X), 255, 48, -1, 0, 4



InitGift:

    ld      a, d

    cp      1
    jp      z, .topLeft

    cp      2
    jp      z, .topRight

    cp      3
    jp      z, .midLeft

    cp      4
    jp      z, .midRight


.topLeft:

    ld      de, TopLeft_ConveyorBelt_Data
    jp      .return

.topRight:

    ld      de, TopRight_ConveyorBelt_Data
    jp      .return

.midLeft:

    ld      de, MidLeft_ConveyorBelt_Data
    jp      .return

.midRight:

    ld      de, MidRight_ConveyorBelt_Data
    jp      .return

.return:
    ex      de, hl
    push    de
        ld      bc, Gift_Temp_Struct.size
        ldir                                                    ; Copy BC bytes from HL to DE
    pop     de

    ; is it working?
    call    RandomNumber
    ld      (de), a

    ret    



GiftLogic:

    ; save hl
    push     hl

        ;ld      (Gift_Temp_Struct_ReturnAddr), hl


        ; Copy object vars to temp vars
        ;ld      hl, ?                                          ; source
        ld      de, Gift_Temp_Struct                            ; destiny
        ld      bc, Gift_Temp_Struct.size                       ; size
        ldir                                                    ; Copy BC bytes from HL to DE



        ; if (Status > 1) Status++
        ld      a, (Gift_Temp_Status)
        cp      2
        jp      c, .dontIncStatus
        inc     a
        ld      (Gift_Temp_Status), a
.dontIncStatus:

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


        ; (if Y >= 192)
        ld      a, (Gift_Temp_Y)
        ld      b, a
        ld      a, 192 - 8
        cp      b
        ld      hl, Gift_Temp_Struct
        ld      a, (Gift_Temp_ConveyorBelt_Number)
        ld      d, a
        call    z, InitGift
        call    c, InitGift
; .gameOver:
;         jp      z, .gameOver
;         jp      c, .gameOver


        ld      a, (PlayerX)
        ld      b, a
        ld      a, (PlayerY)
        ld      c, a

        ld      a, (Gift_Temp_X)
        ld      d, a
        ld      a, (Gift_Temp_Y)
        ld      e, a

        call    CheckCollision_16x24_16x16
        call    c, .collision


.return:
        ; Copy temp vars back to object vars
        ld      hl, Gift_Temp_Struct                        ; source
    pop     de                                              ; destiny
    ld      bc, Gift_Temp_Struct.size                       ; size
    ldir                                                    ; Copy BC bytes from HL to DE

    ret


.collision:
    call    BIOS_BEEP

    ld      hl, Gift_Temp_Struct
    ld      a, (Gift_Temp_ConveyorBelt_Number)
    ld      d, a
    call    InitGift
    
    ld      a, GIFT_WAIT_TIME
    ld      (Gift_Temp_Status), a

    ret
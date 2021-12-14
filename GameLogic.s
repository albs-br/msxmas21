; CONVEYOR_BELT_TOP_LEFT_Y:           equ 16
; CONVEYOR_BELT_TOP_RIGHT_Y:           equ 16 + 16
; CONVEYOR_BELT_TOP_LEFT_Y:           equ 16
; CONVEYOR_BELT_TOP_RIGHT_Y:           equ 16 + 16


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


; Status:                   rb 1    ; 0: Horizontal; >= 1: Falling
; ConveyorBeltEnd:          rb 1    ; X coordinate where the conveyor belt ends (gift starts falling)
; X:                        rb 1
; Y:                        rb 1
; Dx:                       rb 1    ; Delta X (amount of pixels to move horizontally each frame; can be negative)
; Dy:                       rb 1    ; Delta Y
; Conveyor belt number:     rb 1    ; 1-6

; x = (256 - 2d) / 5
_D:     equ 30                      ; distance from screen border to first/last conveyor belt end
_X:     equ (256 - (2 * _D)) / 5    ; space from one conveyor belt end to another

TopLeft_ConveyorBelt_Data:
    db      0, _D + ((3 - 1) * _X),   0, 16,   1, 0, 1

TopRight_ConveyorBelt_Data:
    db      0, _D + ((4 - 1) * _X), 255, 32, -1, 0, 2

MidLeft_ConveyorBelt_Data:
    db      0, _D + ((2 - 1) * _X),   0, 48,   1, 0, 3

MidRight_ConveyorBelt_Data:
    db      0, _D + ((5 - 1) * _X), 255, 64, -1, 0, 4



InitGift:

    ; call    RandomNumber
    ; and     0000 0001b
    ; jp      z, .topRight
    ; jp      .topLeft
    
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
    ld      bc, Gift_Temp_Struct.size
    ldir                                                    ; Copy BC bytes from HL to DE

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
        ld      a, (Gift_Temp_ConveyorBelt_Number)
        ld      d, a

        ; (if Y >= 192)
        ld      a, (Gift_Temp_Y)
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



; ResetGift:

;     ; push    hl
;     ;     ; hl += 6 (point to ConveyorBelt_Number)
;     ;     ld      bc, 6
;     ;     add     hl, bc

;     ;     ; get ConveyorBelt_Number
;     ;     ld      c, (hl)

;     ;     ld      hl, ConveyorBeltOccupation
;     ;     ld      b, 0
;     ;     add     hl, bc

;     ;     ld      a, 0
;     ;     ld      (hl), a

;     ; pop     hl
    
;     call    InitGift

;     ret
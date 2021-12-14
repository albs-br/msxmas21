CONVEYOR_BELT_TOP_LEFT_Y:           equ 16
CONVEYOR_BELT_TOP_RIGHT_Y:           equ 16 + 16


GameLogic:

    ld      hl, Gift_1_Struct
    call    GiftLogic

    ld      hl, Gift_2_Struct
    call    GiftLogic

    ret


InitGift:

    ; Status:              rb 1    ; 0: Horizontal; >= 1: Falling
    ; ConveyorBeltEnd:     rb 1    ; X coordinate where the conveyor belt ends (gift starts falling)
    ; X:                   rb 1
    ; Y:                   rb 1
    ; Dx:                  rb 1    ; Delta X (amount of pixels to move horizontally each frame; can be negative)
    ; Dy:                  rb 1    ; Delta Y


    ; call    RandomNumber
    ; and     0000 0001b
    ; jp      z, .topRight
    ; jp      .topLeft

    ld      de, Gift_1_Struct
    call    BIOS_DCOMPR                 ; Compares HL with DE. Zero flag set if HL and DE are equal. Carry flag set if HL is less than DE.
    jp      z, .topLeft
    
    ld      de, Gift_2_Struct
    call    BIOS_DCOMPR                 ; Compares HL with DE. Zero flag set if HL and DE are equal. Carry flag set if HL is less than DE.
    jp      z, .topRight
    

.topLeft:

    ; ld      a, 0
    ; call    CheckIfConveyorBeltIsFree
    ; or      a
    ; jp      nz, InitGift

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
    ld      a, CONVEYOR_BELT_TOP_LEFT_Y
    ld      (hl), a

    ; DX
    inc     hl    
    ld      a, 1
    ld      (hl), a

    ; DY
    inc     hl    
    ld      a, 0
    ld      (hl), a

    ; Conveyor belt number
    inc     hl    
    ld      a, 0
    ld      (hl), a

.topRight:

    ; ld      a, 1
    ; call    CheckIfConveyorBeltIsFree
    ; or      a
    ; jp      nz, InitGift

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
    ld      a, CONVEYOR_BELT_TOP_RIGHT_Y
    ld      (hl), a

    ; DX
    inc     hl
    ld      a, -1
    ld      (hl), a

    ; DY
    inc     hl
    ld      a, 0
    ld      (hl), a

    ; Conveyor belt number
    inc     hl    
    ld      a, 1
    ld      (hl), a

    ret



; ; Input: 
; ;   a: Y coord of conveyor belt
; ; Return: 
; ;   a = 0 : Free
; ;   a = 1 : Occupied
; CheckIfConveyorBeltIsFree:
;     ld      (CheckIfConveyorBeltIsFree_TempVar), a

;     ; loop through all gift structs
;     ld      d, 6
;     ld      hl, Gift_1_Struct
; .loop:
;     ; if(status == 0)
;     ld      a, (hl)
;     or      a
;     jp      nz, .next

;     ; if(y == A)
;     push    hl
;         ld      bc, 3
;         add     hl, bc
;         ld      a, (hl)
;     pop     hl
;     ld      b, a
;     ld      a, (CheckIfConveyorBeltIsFree_TempVar)
;     cp      b
;     jp      z, .occupied

; .next:
;     ; next gift
;     ld      bc, Gift_Temp_Struct.size
;     add     hl, bc

;     dec     d
;     jp      nz, .loop

; ; not found
;     ld      a, 0
;     ret

; .occupied:
;     ld      a, 1
;     ret



; CheckIfConveyorBeltIsFree:
;     ld      hl, ConveyorBeltOccupation
;     ld      b, 0
;     ld      c, a
;     add     hl, bc
;     ld      a, (hl)
;     ret


GiftLogic:

    ; save hl
    push     hl

        ld      (Gift_Temp_Struct_ReturnAddr), hl


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

        ld      hl, (Gift_Temp_Struct_ReturnAddr)

        ; (if Y >= 192)
        ld      b, a
        ld      a, 192
        cp      b
        call    z, ResetGift
        call    c, ResetGift


.return:
        ; Copy temp vars back to object vars
        ld      hl, Gift_Temp_Struct                        ; source
    pop     de                                              ; destiny
    ld      bc, Gift_Temp_Struct.size                       ; size
    ldir                                                    ; Copy BC bytes from HL to DE

    ret



ResetGift:

    ; push    hl
    ;     ; hl += 6 (point to ConveyorBelt_Number)
    ;     ld      bc, 6
    ;     add     hl, bc

    ;     ; get ConveyorBelt_Number
    ;     ld      c, (hl)

    ;     ld      hl, ConveyorBeltOccupation
    ;     ld      b, 0
    ;     add     hl, bc

    ;     ld      a, 0
    ;     ld      (hl), a

    ; pop     hl
    
    call    InitGift

    ret
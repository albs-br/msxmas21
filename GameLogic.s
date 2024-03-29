; CONVEYOR_BELT_TOP_LEFT_Y:           equ 16
; CONVEYOR_BELT_TOP_RIGHT_Y:           equ 16 + 16
; CONVEYOR_BELT_TOP_LEFT_Y:           equ 16
; CONVEYOR_BELT_TOP_RIGHT_Y:           equ 16 + 16

; GIFT_WAIT_TIME:         equ 60

GameLogic:

    ; player jump logic
    ld      a, (PlayerJumpingCounter)
    or      a
    call    nz, IsJumping

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
    db      240, _D + ((3 - 1) * _X),   0, 0,   1, 0, 1, 1

TopRight_ConveyorBelt_Data:
    db      180, _D + ((4 - 1) * _X), 255, 16, -1, 0, 2, 1

BottomLeft_ConveyorBelt_Data:
    db      120, _D + ((2 - 1) * _X) - 8,   0, 32,   1, 0, 3, 1

BottomRight_ConveyorBelt_Data:
    db      60, _D + ((5 - 1) * _X) - 8, 255, 48, -1, 0, 4, 1



; Inputs:
;   HL: Gift_Temp_Struct base address
;   D: conveyor belt number (1-4)
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

    ld      de, BottomLeft_ConveyorBelt_Data
    jp      .return

.midRight:

    ld      de, BottomRight_ConveyorBelt_Data
    jp      .return

.return:
    ex      de, hl
    push    de
        ld      bc, Gift_Temp_Struct.size
        ldir                                                    ; Copy BC bytes from HL to DE
    pop     de

    ; make the gift wait a random number of frames
    ; initial status should be >= (GIFT_ANIMATION_TOTAL_FRAMES + 2)
.randomStatus:
    call    RandomNumber
    cp      GIFT_ANIMATION_TOTAL_FRAMES + 2
    jp      c, .randomStatus                ; if (A < n)
    ld      (de), a

    ret    



GIFT_ANIMATION_TOTAL_FRAMES:        equ 16

GiftLogic:

    ; save hl
    push     hl

        ;ld      (Gift_Temp_Struct_ReturnAddr), hl


        ; Copy object vars to temp vars
        ;ld      hl, ?                                          ; source
        ld      de, Gift_Temp_Struct                            ; destiny
        ld      bc, Gift_Temp_Struct.size                       ; size
        ldir                                                    ; Copy BC bytes from HL to DE



        ; switch (Status)
        ld      a, (Gift_Temp_Status)
        or      a
        jp      z, .moveHoriz
        cp      1
        jp      z, .falling

        ; if (Status > 1 && <= GIFT_ANIMATION_TOTAL_FRAMES + 2) doAnimation
        cp      GIFT_ANIMATION_TOTAL_FRAMES + 2
        jp      c, .animation

        ; else { waiting }

        ; Status++
        ld      hl, Gift_Temp_Status
        inc     (hl)

        ; hide sprite
        ld      a, 1
        ld      (Gift_Temp_Hide), a
        
        jp      .return

.animation:
        ; X += DX
        ld      a, (Gift_Temp_Dx)
        ld      b, a
        ld      a, (Gift_Temp_X)
        add     a, b
        ld      (Gift_Temp_X), a

        ; Y += DY
        ld      a, (Gift_Temp_Dy)
        ld      b, a
        ld      a, (Gift_Temp_Y)
        add     a, b
        ld      (Gift_Temp_Y), a
        
        ; show sprite
        xor     a
        ld      (Gift_Temp_Hide), a

        ; Status++
        ld      hl, Gift_Temp_Status
        inc     (hl)

        ; if (Status >= END_OF_ANIMATION)
        ld      a, (Gift_Temp_Status)
        cp      GIFT_ANIMATION_TOTAL_FRAMES + 2
        jp      nc, .endAnimation


        jp      .return

.endAnimation:
        ld      hl, Gift_Temp_Struct
        ld      a, (Gift_Temp_ConveyorBelt_Number)
        ld      d, a
        call    InitGift
        
        jp      .return

.moveHoriz:

        ; show sprite
        xor     a
        ld      (Gift_Temp_Hide), a

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
        ; show sprite
        xor     a
        ld      (Gift_Temp_Hide), a

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
        ; call    z, InitGift
        ; call    c, InitGift

        jp      z, .gameOver
        jp      c, .gameOver


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

.gameOver:
    ; -------------- Show score and high score

    ; draw space string
    ld      hl, Space_String                   ; Addr of string
    ld      iy, NAMTBL + (128 * ((192/2) - 40)) + ((128/2)-((9*4)/2)-8)    ; VRAM destiny addr
    call    DrawString    

    ; draw 'GAME OVER' string
    ld      hl, GameOver_String                   ; Addr of string
    ld      iy, NAMTBL + (128 * ((192/2) - 32)) + ((128/2)-((9*4)/2)-8)    ; VRAM destiny addr
    call    DrawString    

    ; draw space string
    ld      hl, Space_String                   ; Addr of string
    ld      iy, NAMTBL + (128 * ((192/2) - 24)) + ((128/2)-((9*4)/2)-8)    ; VRAM destiny addr
    call    DrawString    

    ; draw 'SCORE' string
    ld      hl, Score_String                   ; Addr of string
    ld      iy, NAMTBL + (128 * ((192/2) - 16)) + ((128/2)-((9*4)/2)-8)    ; VRAM destiny addr
    call    DrawString    

    ; draw space string
    ld      hl, Space_String                   ; Addr of string
    ld      iy, NAMTBL + (128 * ((192/2) - 8)) + ((128/2)-((9*4)/2)-8)    ; VRAM destiny addr
    call    DrawString    

    ; draw 'HI SCORE' string
    ld      hl, HighScore_String                   ; Addr of string
    ld      iy, NAMTBL + (128 * ((192/2))) + ((128/2)-((9*4)/2)-8)    ; VRAM destiny addr
    call    DrawString

    ; draw space string
    ld      hl, Space_String                   ; Addr of string
    ld      iy, NAMTBL + (128 * ((192/2) + 8)) + ((128/2)-((9*4)/2)-8)    ; VRAM destiny addr
    call    DrawString    

    ; draw score
    ld      a, (Score)
    ld      iy, NAMTBL + (128 * ((192/2) - 16)) + ((128/2)-((9*4)/2)-8) + (10*4)    ; VRAM destiny addr
    call    DrawNumber

    ; draw hi score
    ld      a, (HighScore)
    ld      iy, NAMTBL + (128 * ((192/2))) + ((128/2)-((9*4)/2)-8) + (10*4)    ; VRAM destiny addr
    call    DrawNumber

    ; TODO: play a 'game over' sound

    ; wait 4 seconds
    ld      b, 4 * 60
    call    Wait_B_Vblanks

    jp      InitGame

.collision:
    ;call    BIOS_BEEP

    ;ld      a, 100             ; volume
    ld      a, SFX_GET_ITEM     ; number of sfx in the bank
    ld      c, 15               ; sound priority
    call    PlaySfx

    ;call    ayFX_END;debug

    call    IncrementScore
    
    ; if (Score >= HighScore) HighScore = Score;
    ld      hl, (Score)
    ld      de, (HighScore)
    call    BIOS_DCOMPR         ; Compare Contents Of HL & DE, Set Z-Flag IF (HL == DE), Set CY-Flag IF (HL < DE)
    jp      c, .dontUpdateHighScore
;.updateHighScore:
    ld      (HighScore), hl
.dontUpdateHighScore:

    call    DrawScore

    ld      a, 2
    ld      (Gift_Temp_Status), a

    ; Dx = (Gift_X - Score_X) / 16
    
    ; SCORE_X - Gift_X
    ld      a, (Gift_Temp_X)
    ld      b, a
    ld      a, SCORE_X

    ; check which of Gift_X and SCORE_X is greater
    cp      b   ; a - b ; SCORE_X - Gift_Temp_X
    jp      c, .giftX_is_Bigger

    sub     a, b
    srl     a                   ; shift right 4 times (divide by 16)
    srl     a
    srl     a
    srl     a

    jp      .calc_Dy
    
.giftX_is_Bigger:
    ; Gift_X - SCORE_X
    ld      a, (Gift_Temp_X)
    sub     a, SCORE_X

    srl     a                   ; shift right 4 times (divide by 16)
    srl     a
    srl     a
    srl     a
    neg     
    ld      (Gift_Temp_Dx), a


.calc_Dy:
    ; Dy = (Gift_Y - Score_Y) / 16
    ; Gift_X - SCORE_X
    ld      a, (Gift_Temp_Y)
    sub     a, SCORE_Y

    srl     a                   ; shift right 4 times (divide by 16)
    srl     a
    srl     a
    srl     a
    neg     
    ld      (Gift_Temp_Dy), a

    ret



IsJumping:

    ; update Y based on jump table
    ld      a, (PlayerJumpingCounter)
    ld      hl, JUMP_DELTA_Y_TABLE

    ld      b, 0
    ld      c, a
    dec     bc
    add     hl, bc

    ld      b, (hl)

    ld      a, (PlayerY)
    add     a, b
    ld      (PlayerY), a

    ; increment PlayerJumpingCounter
    ld      a, (PlayerJumpingCounter)
    inc     a
    ld      (PlayerJumpingCounter), a

    cp      JUMP_DELTA_Y_TABLE.size
    ret     z
    jp      nc, .endJump

    ret

.endJump:
    xor     a
    ld      (PlayerJumpingCounter), a

    ld      a, PLAYER_Y_ON_GROUND
    ld      (PlayerY), a

    ret

; Delta-Y (dY) table for jumping and falling
; original code from @TheNestruo (https://www.msx.org/forum/msx-talk/development/first-test-horizontal-scrolling-game-possibly-named-penguim-platformer?page=10)
JUMP_DELTA_Y_TABLE:        			                                    ; jump height: 58 pixels
	db	-4, -4, -4, -4                                                  ; 4 steps / 16 pixels
	db	-3, -3, -3, -3, -3, -3                                          ; 6 steps / 18 pixels
	db	-2, -2, -2, -2, -2, -2, -2, -2                                  ; 8 steps / 16 pixels
	db	-1, -1, -1, -1, -1, -1,  0, -1,  0,  0, -1                      ; 11 steps / 8 pixels
.TOP_OFFSET_ADDR:
	;db	 0,  0,  0 ;,  0,  0,  0
.FALL_OFFSET_ADDR:
	db	 1,  0,  0,  1,  0,  1,  1,  1,  1,  1,  1
	db	 2,  2,  2,  2,  2,  2,  2,  2
	db	 3,  3,  3,  3,  3,  3
	db	 4,  4,  4,  4
.end:
.size:  equ $ - JUMP_DELTA_Y_TABLE


Space_String:       db  '             ', 0
GameOver_String:    db  ' GAME OVER   ', 0
Score_String:       db  ' SCORE       ', 0
HighScore_String:   db  ' HI SCORE    ', 0
; VRAM tables only for Title Screen:
SPRCOL_1: equ 0x07400   ; to 0x0x075ff (512 bytes)      17-bit VRAM addr
SPRATR_1: equ 0x07600	; to 0x07680 (128 bytes)        17-bit VRAM addr

SPRCOL_2: equ 0x07800   ; to 0x0x079ff (512 bytes)      17-bit VRAM addr
SPRATR_2: equ 0x07a00	; to 0x07a80 (128 bytes)        17-bit VRAM addr

SPRCOL_3: equ 0x07c00   ; to 0x0x07dff (512 bytes)      17-bit VRAM addr
SPRATR_3: equ 0x07e00	; to 0x07e80 (128 bytes)        17-bit VRAM addr


LINE_INTERRUPT_NUMBER_1: equ 64
LINE_INTERRUPT_NUMBER_2: equ 128


TitleScreen:

    ; define screen colors
    ld 		a, 1      	            ; Foregoung color
    ld 		(BIOS_FORCLR), a    
    ld 		a, 1  		            ; Backgroung color
    ld 		(BIOS_BAKCLR), a     
    ld 		a, 1      	            ; Border color
    ld 		(BIOS_BDRCLR), a    
    call 	BIOS_CHGCLR        		; Change Screen Color



    ; change to screen 5
    ld      a, 5
    call    BIOS_CHGMOD

    call    BIOS_DISSCR

    call    ClearVram_MSX2

    call    SetSprites16x16

    call    Set192Lines

    call    SetColor0ToNonTransparent



    ;call    .Load_SPRATR_1
    ; call    .Load_SPRATR_2

    call    .Set_SPRATR_1




    ; -------------------------------------------------------
    ; Load sprite pattern #0
    ld      a, 0000 0000 b
    ld      hl, SPRPAT
    call    SetVdp_Write
    ld      b, 32 ; SpritePattern_SnowFlake_0.size
    ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
    ld      hl, SpritePattern_SnowFlake_0
    otir

    ; -------------------------------------------------------
    ; Load sprite colors table 1

    ld      a, 0000 0000 b ; TODO get only the high bit (bit 16)
    ld      hl, SPRCOL_1 AND 0 1111 1111 1111 1111 b    ; get 16 lower bits (bits 0-15)

    ld      d, 32       ; number of entries on SPRCOL table
.loadSPRCOL_loop:
    push    af, hl
        call    SetVdp_Write
        ld      b, 16
        ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
        ld      hl, SpritePattern_SnowFlake_0 + 32
        otir
    pop     hl, af
    ld      bc, 16      ; size of each entry on SPRCOL table
    add     hl, bc      ; next entry on SPRCOL table
    
    dec     d
    jp      nz, .loadSPRCOL_loop

    ; ----------------------------

    ; ld      a, 0000 0000 b ; TODO get only the high bit (bit 16)
    ; ld      hl, SPRATR_1 AND 0 1111 1111 1111 1111 b    ; get 16 lower bits (bits 0-15)
    ; call    SetVdp_Write
    ; ld      b, SpriteAttributes_test.size
    ; ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
    ; ld      hl, SpriteAttributes_test
    ; otir


    ld      c, 192-16
    ld      b, 32
.initSprites_loop:
    push    bc
        dec     b
        ld      a, b        ; Sprite position on SPRATR table
        ld      d, c        ; Y coord
        ld      e, 0        ; pattern number
        call    .InitSprite
    pop     bc

    ld      a, c
    sub     6
    ld      c, a

    djnz    .initSprites_loop

    ; ------------------------ Draw screen -----------------------------

;     ; test drawing on screen 5
;     ld      a, 0000 0000 b
;     ld      hl, NAMTBL
;     call    SetVdp_Write

;     ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
;     ld      b, 0
; .testLoop:
;     out     (c), b
;     djnz    .testLoop


    ld      hl, TitleScreen_Palette
    call    LoadPalette

    ld		hl, TitleScreen_SC5    				    ; RAM address (source)
    ld		de, NAMTBL + (128 * ((192-128)/2))      ; VRAM address (destiny)
    ld		bc, TitleScreen_SC5.size			    ; Block length
    call 	BIOS_LDIRVM        						; Block transfer to VRAM from memory




    ; Init variables
    xor  	a
    ld  	(Flag_LineInterrupt), a
    ld  	(Counter_LineInterrupt), a

    ; ld      a, LINE_INTERRUPT_NUMBER - 8
    ; ld      (Sprite_Y), a

    ; ld      a, 1
    ; ld      (Sprite_Direction), a

    ; Init random number generator
    ld      a, (BIOS_JIFFY)                  ; MSX BIOS time variable
    or      0x80                             ; A value different of zero is granted
    ld      (Seed), a


; ; ----------------- set sprite split

;     ; ------------------------ setup line interrupt -----------------------------

;     di

    
;     ; override HKEYI hook
;     ld 		a, 0xc3    ; 0xc3 is the opcode for "jp", so this sets "jp LineInterruptHook" as the interrupt code
;     ld 		(HKEYI), a
;     ld 		hl, .LineInterruptHook
;     ld 		(HKEYI + 1), hl

    
;     ; enable line interrupts
;     ld  	a, (REG0SAV)
;     or  	16
;     ld  	b, a		; data to write
;     ld  	c, 0		; register number
;     call  	WRTVDP_without_DI_EI		; Write B value to C register



;     ; set the interrupt to happen on line n
;     ld  	b, LINE_INTERRUPT_NUMBER_1 - 1 - 3		; data to write
;     ld  	c, 19		; register number
;     call  	WRTVDP_without_DI_EI		; Write B value to C register


;     ei


    call    BIOS_ENASCR

    ; ld      b, 255
    ; call    Wait_B_Vblanks

    ; jp      $ ; eternal loop

; ------------------------- Title screen loop --------------------

.titleScreen_Loop:
    call    Wait_Vblank


    ld      b, 32
.moveSprites_loop:
    push    bc
        dec     b
        ld      a, b        ; Sprite position on SPRATR table
        call    .MoveSprite
    pop     bc

    djnz    .moveSprites_loop

    ; check if space bar is pressed
    ld      a, 8                    ; 8th line
    ;call    SNSMAT_NO_DI_EI         ; Read Data Of Specified Line From Keyboard Matrix
    call    BIOS_SNSMAT        ; Read Data Of Specified Line From Keyboard Matrix
    bit     0, a                ; 0th bit (space bar)
    jp      z, .exit

    jp      .titleScreen_Loop


.exit:
    ret

.Set_SPRATR_1:
; ; ---- set SPRATR to 0x07600 (SPRCOL is automatically set 512 bytes before SPRATR, so 0x07400)
;     ; bits:    16 14   10   7
;     ;           |  |    |   |
;     ; 0x07600 = 0 0111 0110 0000 0000
;     ; low bits (aaaaa111: bits 14 to 10)
;     ld      b, 1110 1111 b  ; data          ; In sprite mode 2 the least significant three bits in register 5 should be 1 otherwise mirroring will occur. ; https://www.msx.org/forum/msx-talk/development/strange-behaviour-bug-on-spratr-base-addr-register-on-v993858
;     ld      c, 5            ; register #
;     ;call    BIOS_WRTVDP
;     call  	WRTVDP_without_DI_EI		; Write B value to C register

;     ; high bits (000000aa: bits 16 to 15)
;     ld      b, 0000 0000 b  ; data
;     ld      c, 11           ; register #
;     ;call    BIOS_WRTVDP
;     call  	WRTVDP_without_DI_EI		; Write B value to C register
;     ret

    ; R#5
    ;   step 1: AND with mask to get only bits 14 to 10
    ;   step 2: shift right 7 bits to align properly
    ;   step 3: OR with mask to set lower 3 bits
    ld      b, 0 + ((SPRATR_1 AND 0 0111 1100 0000 0000 b) >> 7) OR 0000 0111 b
    ld      c, 5            ; register #
    call  	WRTVDP_without_DI_EI		; Write B value to C register

    ; R#11
    ;   step 1: AND with mask to get only bits 16 and 15
    ;   step 2: shift right 15 bits to align properly
    ld      b, 0 + (SPRATR_1 AND 1 1000 0000 0000 0000 b) >> 17
    ld      c, 11           ; register #
    call  	WRTVDP_without_DI_EI		; Write B value to C register

    ret

; ---- set SPRATR to 0x07a00 (SPRCOL is automatically set 512 bytes before SPRATR, so 0x07800)
.Set_SPRATR_2:
    ; R#5
    ;   step 1: AND with mask to get only bits 14 to 10
    ;   step 2: shift right 7 bits to align properly
    ;   step 3: OR with mask to set lower 3 bits
    ld      b, 0 + ((SPRATR_2 AND 0 0111 1100 0000 0000 b) >> 7) OR 0000 0111 b
    ld      c, 5            ; register #
    call  	WRTVDP_without_DI_EI		; Write B value to C register

    ; R#11
    ;   step 1: AND with mask to get only bits 16 and 15
    ;   step 2: shift right 15 bits to align properly
    ld      b, 0 + (SPRATR_2 AND 1 1000 0000 0000 0000 b) >> 17
    ld      c, 11           ; register #
    call  	WRTVDP_without_DI_EI		; Write B value to C register

    ret

; ---- set SPRATR to 0x07e00 (SPRCOL is automatically set 512 bytes before SPRATR, so 0x07c00)
.Set_SPRATR_3:
    ; R#5
    ;   step 1: AND with mask to get only bits 14 to 10
    ;   step 2: shift right 7 bits to align properly
    ;   step 3: OR with mask to set lower 3 bits
    ld      b, 0 + ((SPRATR_3 AND 0 0111 1100 0000 0000 b) >> 7) OR 0000 0111 b
    ld      c, 5            ; register #
    call  	WRTVDP_without_DI_EI		; Write B value to C register

    ; R#11
    ;   step 1: AND with mask to get only bits 16 and 15
    ;   step 2: shift right 15 bits to align properly
    ld      b, 0 + (SPRATR_3 AND 1 1000 0000 0000 0000 b) >> 17
    ld      c, 11           ; register #
    call  	WRTVDP_without_DI_EI		; Write B value to C register

    ret


;-------------------
.LineInterruptHook:

            ; Interrupt routine (adapted from https://www.msx.org/forum/development/msx-development/how-line-interrupts-basic#comment-431760)
            ; Make sure that the example interrupt handler does not end up
            ; to infinite loop in case of nested interrupts
            ; if (Flag_LineInterrupt == 0) { 
            ;     Flag_LineInterrupt = 1; 
            ;     execute();
            ;     Flag_LineInterrupt = 0;
            ;     Counter_LineInterrupt = 0;
            ; }
            ; else {
            ;     Counter_LineInterrupt++;
            ;     if (Counter_LineInterrupt == 100) {
            ;         Flag_LineInterrupt = 0;
            ;         Counter_LineInterrupt = 0;
            ;     }
            ; }
            ld  	a, (Flag_LineInterrupt)
            or  	a
            jp  	nz, .else
; .then:
            inc     a ; ld a, 1 ; as A is always 0 here, inc a is the same as ld a, 1
            ld  	(Flag_LineInterrupt), a
            call  	.execute

            ; xor  	a
            ; ld  	(Flag_LineInterrupt), a
            ; ld  	(Counter_LineInterrupt), a
            ld      hl, 0
            ld      (Flag_LineInterrupt), hl ; as these two vars are on sequential addresses, this clear both

            ret     ;jp      .return
.else:
            ; Counter++
            ld  	hl, Counter_LineInterrupt
            inc		(hl)
            
			; if (Counter == 100) { Counter = 0; Flag = 0 }
            ld  	a, (hl)
            cp  	100
            ret  	nz
            ; jp      nz, .return

			; xor  	a
            ; ld  	(Counter_LineInterrupt), a
            ; ld  	(Flag_LineInterrupt), a
            ld      hl, 0
            ld      (Flag_LineInterrupt), hl ; as these two vars are on sequential addresses, this clear both

            ret     ;jp      .return

.execute:
    ; if (VDP(-1) and 1) == 1) ; check if is this a line interrupt
    ld  	b, 1
    call 	ReadStatusReg
    
    ld  	a, 0000 0001 b
    and  	b
    
    ;or      a ; this isn't necessary

    ; Code to run on Vblank:
    jp      z, .Set_SPRATR_1

    ; Code to run on line interrupt:
    jp   	.Set_SPRATR_2

; ------------



; Inputs:
;   A: Sprite position on SPRATR table
;   D: Y coord
;   E: pattern number
.InitSprite:

    call    .SetVDP_SPRATR_ToCurrentSprite

    ; Y coord
    out     (c), d

    ; X coord
    call    RandomNumber
    out     (c), a

    ; pattern
    out     (c), e

    ret

; Inputs:
;   A: Sprite position on SPRATR table
.MoveSprite:

    push    af
        ; ---------------- get current Y
        ; a = a * 4
        sla     a   ; shift left A
        sla     a

        ld      hl, SPRATR_1 AND 0 1111 1111 1111 1111 b    ; get 16 lower bits (bits 0-15)
        
        ; bc = a
        ld      b, 0
        ld      c, a

        add     hl, bc

        ld      a, 0000 0000 b ; TODO get only the high bit (bit 16)
        call    SetVdp_Read

        ld      c, PORT_0

        in      a, (c)

        inc     a
        cp      192
        ld      d, a
        jp      z, .reInitSprite

        in      e, (c)

        ; -------------------
    pop     af

    push    de
        call    .SetVDP_SPRATR_ToCurrentSprite
    pop     de

    ; Y coord
    out     (c), d

;     ; X coord
;     ; call    RandomNumber
;     ; and     0000 0011 b
;     ; jp      nz, .dontIncX
;     ld      a, (BIOS_JIFFY)
;     and     0000 0011 b
;     jp      nz, .dontIncX

;     inc     e
; .dontIncX:
;     out     (c), e

    ret

.reInitSprite:
    pop     af
    ;ld      a, b        ; Sprite position on SPRATR table
    ld      d, -16       ; Y coord
    ld      e, 0        ; pattern number
    call    .InitSprite
    ret

; Inputs:
;   A: Sprite position on SPRATR table
.SetVDP_SPRATR_ToCurrentSprite:
    ; adjust initial address to correct sprite position

    ; a = a * 4
    sla     a   ; shift left A
    sla     a

    ld      hl, SPRATR_1 AND 0 1111 1111 1111 1111 b    ; get 16 lower bits (bits 0-15)
    
    ; bc = a
    ld      b, 0
    ld      c, a

    add     hl, bc

    ld      a, 0000 0000 b ; TODO get only the high bit (bit 16)
    call    SetVdp_Write

    ld      c, PORT_0

    ret
;-----------

SpriteAttributes_test:
    db  -1 + 0, 0, 0, 0 ; -1 to compensate the Y+1 bug/feature of VDP
    db  -1 + 0, 16, 0, 0
    db  -1 + 0, 32, 0, 0
    db  -1 + 0, 48, 0, 0
    db  -1 + 0, 64, 0, 0
    db  -1 + 0, 80, 0, 0
    db  -1 + 0, 96, 0, 0
    db  -1 + 0, 112, 0, 0
    db  -1 + 16, 0, 0, 0
    db  -1 + 16, 16, 0, 0
    db  -1 + 16, 32, 0, 0
    db  -1 + 16, 48, 0, 0
    db  -1 + 16, 64, 0, 0
    db  -1 + 16, 80, 0, 0
    db  -1 + 16, 96, 0, 0
    db  -1 + 16, 112, 0, 0
    db  -1 + 32, 0, 0, 0
    db  -1 + 32, 16, 0, 0
    db  -1 + 32, 32, 0, 0
    db  -1 + 32, 48, 0, 0
    db  -1 + 32, 64, 0, 0
    db  -1 + 32, 80, 0, 0
    db  -1 + 32, 96, 0, 0
    db  -1 + 32, 112, 0, 0
    db  -1 + 48, 0, 0, 0
    db  -1 + 48, 16, 0, 0
    db  -1 + 48, 32, 0, 0
    db  -1 + 48, 48, 0, 0
    db  -1 + 48, 64, 0, 0
    db  -1 + 48, 80, 0, 0
    db  -1 + 48, 96, 0, 0
    db  -1 + 48, 112, 0, 0
.size:  equ $ - SpriteAttributes_test

TitleScreen_Palette:
    INCBIN "Bitmaps/title-screen.pal"

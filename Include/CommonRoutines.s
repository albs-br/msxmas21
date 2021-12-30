; Fill all RAM with 0x00
ClearRam:
    ld      hl, RamStart        ; RAM start address
    ld      de, RamEnd + 1      ; RAM end address

.loop:
    xor     a                   ; same as ld a, 0, but faster
    ld      (hl), a

    inc     hl
    call    BIOS_DCOMPR         ; Compare Contents Of HL & DE, Set Z-Flag IF (HL == DE), Set CY-Flag IF (HL < DE)
    ret     z
    jp      .loop



; Input:
;   A: Color number
;   B: high nibble: red 0-7; low nibble: blue 0-7
;   C: high nibble: 0000; low nibble:  green 0-7
SetPaletteColor:
    push    bc
        ; set palette register number in register R#16 (Color palette address pointer)
        ld      b, a        ; data
        ld      c, 16       ; register #
        call BIOS_WRTVDP
        ld c, 0x9a          ; v9938 port #2
    pop     de

    ld a, d                 ; data 1 (red 0-7; blue 0-7)
    di
    out (c), a
    ld a, e                 ; data 2 (0000; green 0-7)
    ei
    out (c), a

    ret



; Load palette data pointed by HL
LoadPalette:
			; set palette register number in register R#16 (Color palette address pointer)
			ld      b, 0    ; data
            ld      c, 16   ; register #
            call    BIOS_WRTVDP
            ld      c, 0x9a ; V9938 port #2

			ld      b, 16
.loop:
			di
                ld    a, (hl)
                out   (c), a
                inc   hl
                ld    a, (hl)
                out   (c), a
            ei
            inc     hl
            djnz    .loop
            
			ret



; Typical routine to select the ROM on page 8000h-BFFFh from page 4000h-7FFFh
EnableRomPage2:
; source: https://www.msx.org/wiki/Develop_a_program_in_cartridge_ROM#Typical_examples_to_make_a_32kB_ROM

	call	BIOS_RSLREG
	rrca
	rrca
	and	    3	;Keep bits corresponding to the page 4000h-7FFFh
	ld	    c,a
	ld	    b,0
	ld	    hl, BIOS_EXPTBL
	add	    hl,bc
	ld	    a,(hl)
	and	    80h
	or	    c
	ld	    c,a
	inc	    hl
	inc	    hl
	inc	    hl
	inc	    hl
	ld	    a,(hl)
	and	    0Ch
	or	    c
	ld	    h,080h
	call	BIOS_ENASLT		; Select the ROM on page 8000h-BFFFh

    ret


Wait_C_Vblanks:
	;ld		c, 15

	.loop:
		ld      a, (BIOS_JIFFY)
		ld      b, a
	.waitVBlank:
		ld      a, (BIOS_JIFFY)
		cp      b
		jp      z, .waitVBlank

	dec		c
	jp		nz, .loop

	ret

; WaitVblank:
;     ld      a, (BIOS_JIFFY)
;     ld      b, a
; .waitVBlank:
;     ld      a, (BIOS_JIFFY)
;     cp      b
;     jp      z, .waitVBlank

; 	ret

;
; Set VDP address counter to write from address AHL (17-bit)
; Enables the interrupts
;
SetVdp_Write:
    rlc h
    rla
    rlc h
    rla
    srl h
    srl h
    di
    out (PORT_1),a
    ld a,14 + 128
    out (PORT_1),a
    ld a,l
    nop
    out (PORT_1),a
    ld a,h
    or 64
    ei
    out (PORT_1),a
    ret

;
; Set VDP address counter to read from address AHL (17-bit)
; Enables the interrupts
;
SetVdp_Read:
    rlc h
    rla
    rlc h
    rla
    srl h
    srl h
    di
    out (PORT_1),a
    ld a,14 + 128
    out (PORT_1),a
    ld a,l
    nop
    out (PORT_1),a
    ld a,h
    ei
    out (PORT_1),a
    ret



ClearVram_MSX2:
    xor a           ; set vram write base address
    ld hl, 0     	; to 1st byte of page 0
    call SetVDP_Write

	xor		a

	ld		d, 2		; 2 repetitions
.loop_2:
	ld		c, 0		; 256 repetitions
.loop_1:
	ld		b, 0		; 256 repetitions
.loop:
	out		(PORT_0), a
	djnz	.loop
	dec		c
	jp		nz, .loop_1
	dec		d
	jp		nz, .loop_2

	ret


Screen11:
    ; change to screen 11
    ; it's needed to set screen 8 and change the YJK and YAE bits of R#25 manually
    ld      a, 8
    call    BIOS_CHGMOD
    ld      b, 0001 1000 b  ; data
    ld      c, 25            ; register #
    call    BIOS_WRTVDP
	ret

SetSprites16x16:
    ld      a, (REG1SAV)
    or      0000 0010 b
    ld      b, a
    ld      c, 1            ; register #
    call    BIOS_WRTVDP
	ret

Set192Lines:
    ; set 192 lines
    ; ld      b, 0000 0000 b  ; data
    ; ld      c, 9            ; register #
    ; call    BIOS_WRTVDP
    ld      a, (REG9SAV)
    and     0111 1111 b
    ld      b, a
    ld      c, 9            ; register #
    call    BIOS_WRTVDP
	ret

SetColor0ToTransparent:
    ; set color 0 to transparent
    ; ld      b, 0000 1000 b  ; data
    ; ld      c, 8            ; register #
    ; call    BIOS_WRTVDP
    ld      a, (REG8SAV)
    and     1101 1111 b
    ld      b, a
    ld      c, 8            ; register #
    call    BIOS_WRTVDP
	ret

; Inputs:
; 	HL: source addr in RAM
; 	ADE: 17 bits destiny addr in VRAM
; 	C: number of bytes x 256 (e.g. C=64, total = 64 * 256 = 16384)
LDIRVM_MSX2:
    ;ld      a, 0000 0000 b
    ex		de, hl
	;ld      hl, NAMTBL + (0 * (256 * 64))
    call    SetVdp_Write
    ex		de, hl
    ld      d, c
    ;ld      hl, ImageData_1
    ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
    ld      b, 0
.loop_1:
    otir
    dec     d
    jp      nz, .loop_1
	ret



;Random number generator:
; In: nothing
; Out: A with a random number
; Destroys: nothing
;Author: Ricardo Bittencourt aka RicBit (BrMSX, Tetrinet and several other projects)
; choose a random number in the set [0,255] with uniform distribution
RandomNumber:
    push    hl
        ld      hl, (Seed)
        add     hl, hl
        sbc     a, a
        and     0x83
        xor     l
        ld      l, a
        ld      (Seed), hl
    pop     hl
    ret

    ; The random number generated will be any number from 0 to FFh.
    ; Despite be a random number generator routine, your results will pass in several statistical tests.
    ; Before the first call, the SEED value must be initiated with a value different of 0.
    ; For a deterministic behavior (the sequence of values will be the same if the program was initiated), use a fixed SEED value.
    ; For a somewhat more random sequence, use:
    ; LD A,(JIFFY);MSX BIOS time variable
    ; OR 80H ;A value different of zero is granted
    ; LD A,(SEED)

    ; The values obtained from this method is much more *random* that what you get from LD A,R.



;  Calculates whether a collision occurs between two 16x16 objects
;  of a fixed size
; IN: 
;    B = x1; C = y1
;    D = x2; E = y2
; OUT: Carry set if collision
; CHANGES: AF
CheckCollision_16x24_16x16:

        ld      a, d                        ; get x2
        sub     b                           ; calculate x2 - x1
        jr      c, .x1IsLarger              ; jump if x2 < x1
        sub     16                          ; compare with size 1
        ret     nc                          ; return if no collision
        jp      .checkVerticalCollision
.x1IsLarger:
        neg                                 ; use negative value (Z80)
        ; emulate neg instruction (Gameboy)
        ; ld      b, a
        ; xor     a                           ; same as ld a, 0
        ; sub     a, b
    
        sub     16                          ; compare with size 2
        ret     nc                          ; return if no collision

.checkVerticalCollision:
        ld      a, e                        ; get y2
        sub     c                           ; calculate y2 - y1
        jr      c, .y1IsLarger              ; jump if y2 < y1
        sub     24                          ; compare with size 1
        ret                                 ; return collision or no collision
.y1IsLarger:
        neg                                 ; use negative value (Z80)
        ; emulate neg instruction (Gameboy)
        ; ld      c, a
        ; xor     a                           ; same as ld a, 0
        ; sub     a, c
    
        sub     16                          ; compare with size 2
        ret                                 ; return collision or no collision


; Fade from black screen to palette pointed by HL
FadeIn:



    ; reset temp palette
    ld      de, FadeInTempPalette
    ld      b, FadeInTempPalette.size
    xor     a
.loop_1:
    ld      (de), a
    inc     de
    djnz    .loop_1


    ld      b, 7
.outerLoop:
    push    bc

        ; loop through all temp palette incrementing each component (RGB) of each color
        ld      de, FadeInTempPalette
        ld      b, 0 + (FadeInTempPalette.size / 2)
    .loop_2:
        push    bc

            ld      ixh, b

            push    hl
                push    de
                    ; read from temp palette
                    ld      a, (de)
                    ld      b, a
                    inc     de
                    ld      a, (de)
                    ld      c, a
                    
                    ; ; set palette
                    ; push    de
                    ;     push    bc
                    ;         ld      a, ixh
                    ;         call    SetPaletteColor
                    ;     pop     bc
                    ; pop     de

                    ; IYH = Red (rrrr 0000)
                    ; get RED component
                    ld      a, b
                    and     1111 0000b
                    ld      iyh, a

                    ; compare with destiny palette
                    ld      a, (hl)
                    and     1111 0000b
                    cp      iyh                       ; if (a >= n) NC      ; if (a < n) C
                    ;ld      a, 
                    jp      z, .dontIncrementRed

                    ; increment RED
                    ld      a, iyh
                    ld      b, 0x10
                    add     a, b
                    ld      iyh, a

.dontIncrementRed:


                    ; IYL = Blue (0000 rrrr)
                    ; get BLUE component
                    dec     de
                    ld      a, (de)
                    and     0000 1111b
                    ld      iyl, a

                    ; compare with destiny palette
                    ld      a, (hl)
                    and     0000 1111b
                    cp      iyl                       ; if (a >= n) NC      ; if (a < n) C
                    jp      z, .dontIncrementBlue

                    ; increment BLUE
                    ;ld      a, iyl
                    ; ld      b, 0x01
                    ; add     a, b
                    inc     iyl
                    ;ld      iyh, a


.dontIncrementBlue:

                    ; save updated RED (IYH) and BLUE (IYL)
                    ld      a, iyh
                    or      iyl
                    ld      (de), a




                    ; B = Green
                    ; get GREEN component
                    inc     de
                    ld      a, (de)
                    ;and     0000 1111b
                    ld      b, a

                    ; compare with destiny palette
                    inc     hl
                    ld      a, (hl)
                    ;and     0000 1111b
                    cp      b                       ; if (a >= n) NC      ; if (a < n) C
                    jp      z, .dontIncrementGreen

                    ; increment GREEN
                    inc     b

.dontIncrementGreen:
                    ; save updated GREEN
                    ld      a, b
                    ld      (de), a


                pop     de
            pop     hl
            

            ; read from temp palette
            ld      a, (de)
            ld      b, a
            inc     de
            ld      a, (de)
            ld      c, a
            
            ; set palette
            push    de
                push    bc
                    ld      a, ixh
                    call    SetPaletteColor
                pop     bc
            pop     de


            ; increment pointers by 2
            inc     hl
            inc     hl
            inc     de
            inc     de



        pop     bc
        djnz    .loop_2


        call    BIOS_ENASCR

        ld      c, 10
        call    Wait_C_Vblanks

    pop     bc
    djnz    .outerLoop






    ; call    SetPaletteColor


    ; ; SetPaletteColor:
    ; push    bc
    ;     ; set palette register number in register R#16 (Color palette address pointer)
    ;     ld      b, a        ; data
    ;     ld      c, 16       ; register #
    ;     call    BIOS_WRTVDP
    ;     ld      c, 0x9a          ; v9938 port #2
    ; pop     de

    ; ld a, d                 ; data 1 (red 0-7; blue 0-7)
    ; di
    ; out (c), a
    ; ld a, e                 ; data 2 (0000; green 0-7)
    ; ei
    ; out (c), a

    ret
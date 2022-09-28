FNAME "msxmas21.rom"      ; output file

CPU Z80

PageSize:	    equ	0x4000	        ; 16kB


; DEBUG:          equ 255             ; defines debug mode, value is irrelevant (comment it out for production version)


; Compilation address
    ;org 0x4000, 0xbeff	                    ; 0x8000 can be also used here if Rom size is 16kB or less.
    org 0x4000

StartROM:

    ; Common
    INCLUDE "Include/RomHeader.s"
    INCLUDE "Include/MsxBios.s"
    INCLUDE "Include/MsxConstants.s"
    INCLUDE "Include/CommonRoutines.s"
    INCLUDE "Include/CommonRoutines_SC5.s"

    ; Game
    INCLUDE "InitVram.s"
    INCLUDE "Sprites/LoadSprites.s"
    INCLUDE "ReadInput.s"
    INCLUDE "InitVariables.s"
    INCLUDE "GameLogic.s"
    INCLUDE "UpdateSprites.s"
    INCLUDE "UpdatePalette.s"
    INCLUDE "UpdateAnimations.s"
    INCLUDE "Score.s"
    INCLUDE "TitleScreen/TitleScreen.s"

    ; Assets
    INCLUDE "Sprites/SpriteAssets.s"
    INCLUDE "Bitmaps/Bitmaps.s"

Execute:

; Typical routine to select the ROM on page 8000h-BFFFh from page 4000h-7BFFFh

	call	BIOS_RSLREG
	rrca
	rrca
	and	3	;Keep bits corresponding to the page 4000h-7FFFh
	ld	c,a
	ld	b,0
	ld	hl,BIOS_EXPTBL
	add	hl,bc
	ld	a,(hl)
	and	80h
	or	c
	ld	c,a
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	ld	a,(hl)
	and	0Ch
	or	c
	ld	h,080h
	call	BIOS_ENASLT		; Select the ROM on page 8000h-BFFFh


    ; disable keyboard click
    ld 		a, 0
    ld 		(BIOS_CLIKSW), a     ; Key Press Click Switch 0:Off 1:On (1B/RW)

    call    TitleScreen

InitGame:

    call    InitVram

    call    ClearRam

    call    InitVariables

    call    DrawScore

    
    
    call    CreateFadeInOutPalette
    call    FadeIn
    ;call    FadeOut


MainLoop:

    ld      hl, BIOS_JIFFY              ; (v-blank sync)
    ld      a, (hl)
.waitVBlank:
    cp      (hl)
    jr      z, .waitVBlank



    ; Save Jiffy to check if previous frame ended
    ld      a, (hl)
    ld      (CurrentJiffy), a



    IFDEF DEBUG
        ld 		a, 4       	            ; Border color
        ld 		(BIOS_BDRCLR), a    
        call 	BIOS_CHGCLR        		; Change Screen Color
    ENDIF

    call    UpdateSprites





    call    UpdatePalette




    IFDEF DEBUG
        ld 		a, 8       	            ; Border color
        ld 		(BIOS_BDRCLR), a    
        call 	BIOS_CHGCLR        		; Change Screen Color
    ENDIF

    call    UpdateAnimations






    IFDEF DEBUG
        ld 		a, 10       	        ; Border color
        ld 		(BIOS_BDRCLR), a    
        call 	BIOS_CHGCLR        		; Change Screen Color
    ENDIF

    call    ReadInput




    IFDEF DEBUG
        ld 		a, 12       	        ; Border color
        ld 		(BIOS_BDRCLR), a    
        call 	BIOS_CHGCLR        		; Change Screen Color
    ENDIF

    call    GameLogic




    IFDEF DEBUG
        ld 		a, 7       	        ; Border color
        ld 		(BIOS_BDRCLR), a    
        call 	BIOS_CHGCLR        		; Change Screen Color
    ENDIF

    ; Checks if main loop takes more than one frame to run
    ld      a, (BIOS_JIFFY)
    ld      b, a
    ld      a, (CurrentJiffy)
    cp      b
    call    nz, .frameSkip



    jp      MainLoop



.frameSkip:
   
    ld      hl, FramesSkipped
    inc     (hl)

    ret



End:







InitialSpriteAttributes:
    ;   Y, X, Pattern, Reserved

    ; ; Santa Claus Top
    ; db  110, 120, 7 * 4, 0
    ; db  110, 120, 8 * 4, 0
    ; db  110, 120, 9 * 4, 0
    ; db  110, 120, 10 * 4, 0

    ; ; Santa Claus Bottom
    ; db  126, 120, 11 * 4, 0
    ; db  126, 120, 12 * 4, 0
    ; db  126, 120, 13 * 4, 0

    

    ; Santa Claus Top
    ; db  192 - 16 - 8 - 16, 120, 0 * 4, 0
    ; db  192 - 16 - 8 - 16, 120, 1 * 4, 0
    ; db  192 - 16 - 8 - 16, 120, 2 * 4, 0
    ; db  192 - 16 - 8 - 16, 120, 3 * 4, 0

    ; ; Santa Claus Bottom
    ; db  192 - 16 - 8, 120, 4 * 4, 0
    ; db  192 - 16 - 8, 120, 5 * 4, 0
    ; db  192 - 16 - 8, 120, 6 * 4, 0

    db  216, 0, 0, 0    ; y=216 disable current sprite and all following
    ; db  0, 0, 0, 0
    ; db  0, 0, 0, 0
    ; db  0, 0, 0, 0
    ; db  0, 0, 0, 0
    ; db  0, 0, 0, 0
    ; db  0, 0, 0, 0



    ; ; Gift 1
    ; db  0, 0, 7 * 4, 0
    ; db  0, 0, 8 * 4, 0
    ; db  0, 0, 9 * 4, 0

.size:  equ $ - InitialSpriteAttributes


    db      "End ROM started at 0x4000"

Page0x4000_size: equ $ - StartROM

	ds      PageSize - ($ - 0x4000), 255	; Fill the unused area with 0xFF


; --------------------- 0x8000
    org     0x8000

TitleScreen_SC5:
    INCBIN "Bitmaps/msxmas title scr.SC5"
.size:  equ $ - TitleScreen_SC5

	ds      PageSize - ($ - 0x8000), 255	; Fill the unused area with 0xFF

; --------------------- RAM
	org     0xc000, 0xe5ff                   ; for machines with 16kb of RAM (use it if you need 16kb RAM, will crash on 8kb machines, such as the Casio PV-7)


RamStart:

    INCLUDE "Variables.s"
RamEnd:

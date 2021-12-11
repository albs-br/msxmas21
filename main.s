FNAME "msxmas21.rom"      ; output file

PageSize:	    equ	0x4000	        ; 16kB

; Compilation address
    org 0x4000, 0xbeff	                    ; 0x8000 can be also used here if Rom size is 16kB or less.

    ; Common
    INCLUDE "Include/RomHeader.s"
    INCLUDE "Include/MsxBios.s"
    INCLUDE "Include/MsxConstants.s"
    INCLUDE "Include/CommonRoutines.s"

    ; Game
    INCLUDE "InitVram.s"
    INCLUDE "Sprites/LoadSprites.s"
    INCLUDE "ReadInput.s"
    INCLUDE "InitVariables.s"
    INCLUDE "GameLogic.s"
    INCLUDE "UpdateSprites.s"

    INCLUDE "Sprites/SpriteAssets.s"

Execute:

    call    InitVram

InitGame:
    call    ClearRam

    call    InitVariables




MainLoop:

    ld      hl, BIOS_JIFFY              ; (v-blank sync)
    ld      a, (hl)
.waitVBlank:
    cp      (hl)
    jr      z, .waitVBlank


    call    ReadInput

    call    GameLogic

    call    UpdateSprites
    
    jp      MainLoop


End:







TestSpriteAttributes:
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

    db  0, 0, 0, 0
    db  0, 0, 0, 0
    db  0, 0, 0, 0
    db  0, 0, 0, 0
    db  0, 0, 0, 0
    db  0, 0, 0, 0
    db  0, 0, 0, 0



    ; Gift 1
    db  0, 0, 7 * 4, 0
    db  0, 0, 8 * 4, 0
    db  0, 0, 9 * 4, 0

.size:  equ $ - TestSpriteAttributes


    db      "End ROM started at 0x4000"

	ds PageSize - ($ - 0x4000), 255	; Fill the unused area with 0xFF



; RAM
	org     0xc000, 0xe5ff                   ; for machines with 16kb of RAM (use it if you need 16kb RAM, will crash on 8kb machines, such as the Casio PV-7)


RamStart:

    INCLUDE "Variables.s"
RamEnd:

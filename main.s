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
    INCLUDE "UpdateSprites.s"

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

    ;call    GameLogic

    call    UpdateSprites
    
    jp      MainLoop


End:


SpritePatternsAndColors_SantaClaus_Standing_Right:
    INCLUDE "Sprites/SantaClaus/Standing_Right.s"
.size:  equ $ - SpritePatternsAndColors_SantaClaus_Standing_Right


;SpritePattern_1:
;     INCBIN "Images/player_plane_0.pat"
; .size:  equ $ - SpritePattern_1

SpritePattern_1:
    DB 00000111b
    DB 00011111b
    DB 00111111b
    DB 01111111b
    DB 01110011b
    DB 11110011b
    DB 11111111b
    DB 11111111b

    DB 11111111b
    DB 11111111b
    DB 11110111b
    DB 01111011b
    DB 01111100b
    DB 00111111b
    DB 00011111b
    DB 00000111b

    DB 11100000b
    DB 11111000b
    DB 11111100b
    DB 11111110b
    DB 11001110b
    DB 11001111b
    DB 11111111b
    DB 11111111b
    
    DB 11111111b
    DB 11111111b
    DB 11101111b
    DB 11011110b
    DB 00111110b
    DB 11111100b
    DB 11111000b
    DB 11100000b
.size:  equ $ - SpritePattern_1

; SpritePattern_2:
;     DB 00000111b
;     DB 00011000b
;     DB 00100000b
;     DB 01000000b
;     DB 01001100b
;     DB 10001100b
;     DB 10000000b
;     DB 10000000b

;     DB 11111111b
;     DB 11111111b
;     DB 11110111b
;     DB 01111011b
;     DB 01111100b
;     DB 00111111b
;     DB 00011111b
;     DB 00000111b

;     DB 11100000b
;     DB 11111000b
;     DB 11111100b
;     DB 11111110b
;     DB 11001110b
;     DB 11001111b
;     DB 11111111b
;     DB 11111111b
    
;     DB 11111111b
;     DB 11111111b
;     DB 11101111b
;     DB 11011110b
;     DB 00111110b
;     DB 11111100b
;     DB 11111000b
;     DB 11100000b
; .size:  equ $ - SpritePattern_2

; SpriteColors_1:
;     INCBIN "Images/player_plane_0.col"
; .size:  equ $ - SpriteColors_1


SpriteColors_1:
    ;db 0x02, 0x0a, 0x03, 0x03, 0x08, 0x08, 0x03, 0x0a, 0x04, 0x07, 0x0a, 0x0a, 0x0a, 0x0a, 0x0f, 0x0f
    db  4
    db  4
    db  4
    db  4
    db  4
    db  4
    db  4
    db  4
    db  4
    db  4
    db  4
    db  4
    db  4
    db  4
    db  4
    db  4
.size:  equ $ - SpriteColors_1

; SpriteColors_2:
;     ; Only the sprite on the lower layer should have the bit 6 set to enable the OR-color
;     db  0100 0000 b + 2
;     db  0100 0000 b + 2
;     db  0100 0000 b + 2
;     db  0100 0000 b + 2
;     db  0100 0000 b + 2
;     db  0100 0000 b + 2
;     db  0100 0000 b + 2
;     db  0100 0000 b + 2
;     db  0100 0000 b + 2
;     db  0100 0000 b + 2
;     db  0100 0000 b + 2
;     db  0100 0000 b + 2
;     db  0100 0000 b + 2
;     db  0100 0000 b + 2
;     db  0100 0000 b + 2
;     db  0100 0000 b + 2
; .size:  equ $ - SpriteColors_2

TestSpriteAttributes:
    ;   Y, X, Pattern, Reserved
    db  150, 120, 0, 0
    db  150, 120, 4, 0
    db  150, 120, 8, 0
    db  150, 120, 12, 0
.size:  equ $ - TestSpriteAttributes


; ImageTest:
;     db  0xff, 0xff, 0xff, 0xff
;     db  0xff, 0xff, 0xff, 0xff
;     db  0xff, 0xff, 0xff, 0xff
;     db  0xff, 0xff, 0xff, 0xff
;     db  0xff, 0xff, 0xff, 0xff
;     db  0xff, 0xff, 0xff, 0xff
;     db  0xff, 0xff, 0xff, 0xff
;     db  0xff, 0xff, 0xff, 0xff
; .size:  equ $ - ImageTest



; TODO: put correct palette here
PaletteData:
;     INCBIN "Images/player_plane_0.pal"

    ;  data 1 (red 0-7; blue 0-7); data 2 (0000; green 0-7)
    db 0x00, 0x00 ; Color index 0
    db 0x77, 0x00 ; Color index 1
    db 0x10, 0x00 ; Color index 2
    db 0x20, 0x00 ; Color index 3
    db 0x30, 0x00 ; Color index 4
    db 0x40, 0x00 ; Color index 5
    db 0x50, 0x00 ; Color index 6
    db 0x60, 0x00 ; Color index 7
    db 0x70, 0x00 ; Color index 8
    db 0x11, 0x01 ; Color index 9
    db 0x22, 0x02 ; Color index 10
    db 0x33, 0x03 ; Color index 11
    db 0x77, 0x07 ; Color index 12
    db 0x66, 0x06 ; Color index 13
    db 0x55, 0x05 ; Color index 14
    db 0x44, 0x04 ; Color index 15



    db      "End ROM started at 0x4000"

	ds PageSize - ($ - 0x4000), 255	; Fill the unused area with 0xFF




; 	org	0x8000, 0xBFFF
; ImageData_1:
;     ;INCBIN "Images/aerofighters_0.sra.new"
;     ;INCBIN "Images/aerofighters_0.sr8.new"
;     ;INCBIN "Images/metalslug-xaa"
; .size:      equ $ - ImageData_1
; 	ds PageSize - ($ - 0x8000), 255



; RAM
	org     0xc000, 0xe5ff                   ; for machines with 16kb of RAM (use it if you need 16kb RAM, will crash on 8kb machines, such as the Casio PV-7)


RamStart:

    INCLUDE "Variables.s"
RamEnd:

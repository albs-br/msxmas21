Seed:                       rw 1            ; Seed for random number generator


PlayerX:                    rb 1
PlayerY:                    rb 1
PlayerAnimationFrame:       rb 1
PlayerJumpingCounter:       rb 1
Score:                      rw 1

UpdatePaletteCounter:       rb 1


; Debug variables:
FramesSkipped:              rb 1
CurrentJiffy:               rb 1






; Gift struct
Gift_Temp_Struct:


; 0: Horizontal
; 1: Falling
; > 1: Animation
; >= (GIFT_ANIMATION_TOTAL_FRAMES + 2): Waiting ; 
Gift_Temp_Status:              rb 1    

Gift_Temp_ConveyorBeltEnd:     rb 1    ; X coordinate where the conveyor belt ends (gift starts falling)
Gift_Temp_X:                   rb 1
Gift_Temp_Y:                   rb 1
Gift_Temp_Dx:                  rb 1    ; Delta X (amount of pixels to move horizontally each frame; can be negative)
Gift_Temp_Dy:                  rb 1    ; Delta Y
Gift_Temp_ConveyorBelt_Number: rb 1    ; 1-6
Gift_Temp_Hide:                rb 1    ; 0: show; 1: hide
Gift_Temp_Struct.size:         equ $ - Gift_Temp_Struct


Gift_1_Struct:              rb Gift_Temp_Struct.size
Gift_2_Struct:              rb Gift_Temp_Struct.size
Gift_3_Struct:              rb Gift_Temp_Struct.size
Gift_4_Struct:              rb Gift_Temp_Struct.size
Gift_5_Struct:              rb Gift_Temp_Struct.size
Gift_6_Struct:              rb Gift_Temp_Struct.size



SpriteAttributes:               rb 32 * 4
.size:                          equ 32 * 4

FadeInTempPalette:              rb 16 * 2
.size:                          equ $ - FadeInTempPalette

FadeInTemp_8_Palettes:          rb 16 * 2 * 8
.size:                          equ $ - FadeInTemp_8_Palettes


FadeInDestinyPaletteAddr:       rw 1




;    dw    0, 256 ; Source X (9 bits), Source Y (10 bits)
;    dw    128, 96 ; Destiny X (9 bits), Destiny Y (10 bits)
;    dw    7, 9	; number of cols/lines
;    db    0, 0, VDP_COMMAND_HMMM

VdpCommand:
VdpCommand_SourceX:             rw 1 ; Source X (9 bits)
VdpCommand_SourceY:             rw 1
VdpCommand_DestinyX:            rw 1
VdpCommand_DestinyY:            rw 1
VdpCommand_Cols:                rw 1
VdpCommand_Lines:               rw 1
VdpCommand_ColorRegister:       rb 1
VdpCommand_DestMemAndDirection: rb 1
VdpCommand_CommandSelection:    rb 1



Debug_Temp_Byte:                 rb 1
Debug_Temp_Word:                 rw 1


; ---------------------------------------

;ayFX variables:
ayFX_Variables:
AYREGS:		    rb 14
ayFX_MODE:      rb 1 ;				; ayFX mode
ayFX_BANK:      rb 2 ;				; Current ayFX Bank
ayFX_PRIORITY:  rb 1 ;				; Current ayFX stream priotity
ayFX_POINTER:   rb 2 ;				; Pointer to the current ayFX stream
ayFX_TONE:      rb 2 ;				; Current tone of the ayFX stream
ayFX_NOISE:	    rb 1 ;				; Current noise of the ayFX stream
ayFX_VOLUME: 	rb 1 ;				; Current volume of the ayFX stream
ayFX_CHANNEL: 	rb 1 ;				; PSG channel to play the ayFX stream
ayFX_VT: 	    rb 2 ;				; ayFX relative volume table pointer
VARayFXEND:     rb 1 ; 
ayFX_Variables.size:     equ $ - ayFX_Variables




; ------------- Title screen

; vars for line interrupt routine:
Flag_LineInterrupt:	    rb 1        ; these two vars MUST be on sequential addresses 
Counter_LineInterrupt:	rb 1        ; this var MUST be imediately after Flag_LineInterrupt

; CurrentScreenSplit:     rb 1        ; 0: top; 2: bottom
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
Gift_Temp_Status:              rb 1    ; 0: Horizontal; 1: Falling ; >1: Waiting
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



SpriteAttributes:           rb 32 * 4
.size:                      equ 32 * 4


Debug_Temp_Byte:                 rb 1
Debug_Temp_Word:                 rw 1
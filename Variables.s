Seed:                       rw 1            ; Seed for random number generator


PlayerX:                    rb 1
PlayerY:                    rb 1
PlayerAnimationFrame:       rb 1



CheckIfConveyorBeltIsFree_TempVar:      rb 1

; Gift_Temp_Struct_ReturnAddr:    rw 1

; Gift struct
Gift_Temp_Struct:
Gift_Temp_Status:              rb 1    ; 0: Horizontal; >= 1: Falling
Gift_Temp_ConveyorBeltEnd:     rb 1    ; X coordinate where the conveyor belt ends (gift starts falling)
Gift_Temp_X:                   rb 1
Gift_Temp_Y:                   rb 1
Gift_Temp_Dx:                  rb 1    ; Delta X (amount of pixels to move horizontally each frame; can be negative)
Gift_Temp_Dy:                  rb 1    ; Delta Y
Gift_Temp_Struct.size:         equ $ - Gift_Temp_Struct


Gift_1_Struct:              rb Gift_Temp_Struct.size
Gift_2_Struct:              rb Gift_Temp_Struct.size
Gift_3_Struct:              rb Gift_Temp_Struct.size
Gift_4_Struct:              rb Gift_Temp_Struct.size
Gift_5_Struct:              rb Gift_Temp_Struct.size
Gift_6_Struct:              rb Gift_Temp_Struct.size



SpriteAttributes:           rb 32 * 4
.size:                      equ 32 * 4
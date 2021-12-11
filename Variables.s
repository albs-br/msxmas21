PlayerX:                    rb 1
PlayerY:                    rb 1
PlayerAnimationFrame:       rb 1



; Gift struct
Gift_1_Struct:
Gift_1_Status:              rb 1
Gift_1_ConveyorBeltEnd:     rb 1
Gift_1_X:                   rb 1
Gift_1_Y:                   rb 1
Gift_1_Dx:                  rb 1
Gift_1_Dy:                  rb 1
Gift_1_Struct.size:         equ $ - Gift_1_Struct


Gift_2_Struct:              rb Gift_1_Struct.size
Gift_3_Struct:              rb Gift_1_Struct.size
Gift_4_Struct:              rb Gift_1_Struct.size
Gift_5_Struct:              rb Gift_1_Struct.size
Gift_6_Struct:              rb Gift_1_Struct.size



SpriteAttributes:           rb 32 * 4
.size:                      equ 32 * 4
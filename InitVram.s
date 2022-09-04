; Default VRAM tables for Screen 5
NAMTBL:     equ 0x0000
SPRPAT:     equ 0x7800
SPRCOL:     equ 0x7400
SPRATR:     equ 0x7600



; ------------------

WINDOW_LEFT_X:      equ 48+2
WINDOW_LEFT_Y:      equ 128-32+16+8

WINDOW_LEFT_TOP_LEFT_GLASS_X:       equ WINDOW_LEFT_X + 9
WINDOW_LEFT_TOP_LEFT_GLASS_Y:       equ WINDOW_LEFT_Y + 7

InitVram:

    ; disable keyboard click
    ld 		a, 0
    ld 		(BIOS_CLIKSW), a     ; Key Press Click Switch 0:Off 1:On (1B/RW)

    ; define screen colors
    ld 		a, 1      	            ; Foregoung color
    ld 		(BIOS_FORCLR), a    
    ld 		a, 1  		            ; Backgroung color
    ld 		(BIOS_BAKCLR), a     
    ld 		a, 1      	            ; Border color
    ld 		(BIOS_BDRCLR), a    
    call 	BIOS_CHGCLR        		; Change Screen Color

    ; screen 5
    ld      a, 5
    call    BIOS_CHGMOD

    call    BIOS_DISSCR

    call    ClearVram_MSX2

    call    SetSprites16x16

    call    Set192Lines

    call    SetColor0ToTransparent

    ; ; set Video RAM active (instead of Expansion RAM)
    ; ld      b, 0000 0000 b  ; data
    ; ld      c, 45            ; register #
    ; call    BIOS_WRTVDP



; ; ---- set SPRATR to 0x1fa00 (SPRCOL is automatically set 512 bytes before SPRATR, so 0x1f800)
;     ; bits:    16 14        7
;     ;           |  |        |
;     ; 0x1fa00 = 1 1111 1010 1000 0000
;     ; low bits (aaaaaaaa: bits 14 to 7)
;     ld      b, 1111 0101 b  ; data
;     ld      c, 5            ; register #
;     call    BIOS_WRTVDP
;     ; high bits (000000aa: bits 16 to 15)
;     ld      b, 0000 0011 b  ; data
;     ld      c, 11           ; register #
;     call    BIOS_WRTVDP

; ; ---- set SPRPAT to 0x1f000
;     ; bits:    16     11
;     ;           |      |
;     ; 0x1fa00 = 1 1111 0000 0000 0000
;     ; high bits (00aaaaaa: bits 16 to 11)
;     ld      b, 0011 1110 b  ; data
;     ld      c, 6            ; register #
;     call    BIOS_WRTVDP




    ; ld      hl, PaletteData
    ; call    LoadPalette



    ; ; Fill NAMTBL with value
    ; ld      hl, NAMTBL
    ; ld      bc, 0 + (256 * 192) / 2
    ; ld      a, 0x7b
    ; call    BIOS_BIGFIL





    call    LoadSprites



    ; Atributes of all sprites
    ld      a, 0000 0000 b
    ld      hl, SPRATR
    call    SetVdp_Write
    ld      b, TestSpriteAttributes.size
    ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
    ld      hl, TestSpriteAttributes
    otir

; -----------

    ; Load test bg image
    ; ld		hl, ConveyorBelt_Frame1		            ; RAM address (source)
    ; ld      a, 0                                    ; VRAM address (destiny, bit 16)
    ; ld		de, NAMTBL ;+ (1 * (256 * 64))           ; VRAM address (destiny, bits 15-0)
    ; ld		c, 0 + ((16 * 16) / 2) * 256            ; Block length * 256
    ; call    LDIRVM_MSX2



    call    LoadBackground

    ; ; test
    ; ld		hl, ConveyorBelt_Frame1		            ; RAM address (source)
    ; ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ; ld      de, NAMTBL + (128 / 2) + (160 * 128)    ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    ; call    Load_16x16_SC5_Image    

    ; ld		hl, ConveyorBelt_Frame1		            ; RAM address (source)
    ; ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ; ld      de, NAMTBL + (128 / 2) + (28 * 128)    ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    ; call    Load_16x16_SC5_Image    



    ld      hl, GamePalette
    call    LoadPalette


    ;call    BIOS_ENASCR

    ; ld      hl, GamePalette
    ; call    FadeIn

    ; call    CreateFadeInOutPalette
    ; call    FadeIn2


    ; ld      hl, FadeInTemp_8_Palettes + 128
    ; call    LoadPalette


    ;call    DoExampleCopy

; ----- TEST HMMM
;     xor     a           	; set vram write base address
;     ld      hl, 0x8000     	;  to 1st byte of page 1...
;     call    SetVDP_Write

;     ld      a, 0x88        	; use color 8 (red)

; 	ld      c, 16          	; fill 1st N lines of page 1
; .fillL1:
;     ld      b, 128        	; one line in SC5 = 128 bytes
; .fillL2:
;     out     (0x98), a     	; could also have been done with
;     djnz    .fillL2     	; a vdp command (probably faster)
;     dec     c           	; (and could also use a fast loop)
;     jp      nz, .fillL1

WINDOW_SNOW_1_VRAM_ADDR:        equ 0x8000
WINDOW_SNOW_2_VRAM_ADDR:        equ 0x8000 + 8 ; (16 bytes to right of previous image)
WINDOW_SNOW_3_VRAM_ADDR:        equ 0x8000 + 16
WINDOW_SNOW_4_VRAM_ADDR:        equ 0x8000 + 24

    ld      hl, Window_Snow_1
    xor     a
    ld      de, WINDOW_SNOW_1_VRAM_ADDR     	;  to 1st byte of page 1...
    call    Load_16x16_SC5_Image

    ld      hl, Window_Snow_2
    xor     a
    ld      de, WINDOW_SNOW_2_VRAM_ADDR
    call    Load_16x16_SC5_Image

    ld      hl, Window_Snow_3
    xor     a
    ld      de, WINDOW_SNOW_3_VRAM_ADDR
    call    Load_16x16_SC5_Image

    ld      hl, Window_Snow_4
    xor     a
    ld      de, WINDOW_SNOW_4_VRAM_ADDR
    call    Load_16x16_SC5_Image


    ; ; test loading frame 0 of snow animation to top left glass of left window
    ; ld      hl, COPYBLOCK
    ; ld      de, VdpCommand
    ; ld      bc, 15
    ; ldir

    ; ld      hl, WINDOW_LEFT_X + 9
    ; ld      (VdpCommand_DestinyX), hl     ; dest x
    ; ld      hl, WINDOW_LEFT_Y + 7
    ; ld      (VdpCommand_DestinyY), hl     ; dest y
    ; ld      hl, VdpCommand 	; execute the copy
    ; call    DoCopy



    ; ; test loading frame 1 of snow animation to top left glass of left window
    ; ld      hl, COPYBLOCK
    ; ld      de, VdpCommand
    ; ld      bc, 15
    ; ldir

    ; ld      hl, 9
    ; ld      (VdpCommand_SourceX), hl     ; source x
    ; ld      hl, 256
    ; ld      (VdpCommand_SourceY), hl     ; source y
    ; ld      hl, WINDOW_LEFT_X + 9
    ; ld      (VdpCommand_DestinyX), hl     ; dest x
    ; ld      hl, WINDOW_LEFT_Y + 7
    ; ld      (VdpCommand_DestinyY), hl     ; dest y
    ; ld      hl, VdpCommand 	; execute the copy
    ; call    DoCopy




    ret



; ----- TEST HMMM
COPYBLOCK:
   dw    0, 256 ; Source X (9 bits), Source Y (10 bits)
   dw    128, 96 ; Destiny X (9 bits), Destiny Y (10 bits)
   dw    7, 9	; number of cols/lines
   db    0, 0, VDP_COMMAND_HMMM

VDP_COMMAND_HMMM:       equ 1101 0000b




GamePalette: 
; format: 0rrr 0bbb,     0000 0ggg
    db 0x00, 0x00   ; color 0
    db 0x00, 0x00
    db 0x11, 0x06
    db 0x33, 0x07
    db 0x17, 0x01
    db 0x27, 0x03

    ;db 0x51, 0x01
    db CONVEYOR_BELT_COLOR_1_RB, CONVEYOR_BELT_COLOR_1_G      ; color 6

    db 0x27, 0x06   ; color 7

    db 0x71, 0x01   ; color 8
    db 0x73, 0x03
    
    ;db 0x61, 0x06
    db CONVEYOR_BELT_COLOR_1_RB, CONVEYOR_BELT_COLOR_1_G      ; color 10

    db 0x64, 0x06
    db 0x11, 0x04
    
    ;db 0x65, 0x02
    db CONVEYOR_BELT_COLOR_2_RB, CONVEYOR_BELT_COLOR_2_G      ; color 13
    
    db 0x55, 0x05
    db 0x77, 0x07   ; color 15


; DefaultMSX2Palette: 
; ; format: 0rrr 0bbb,     0000 0ggg
;     db 0x00, 0x00   ; color 0
;     db 0x00, 0x00
;     db 0x11, 0x06
;     db 0x33, 0x07
;     db 0x17, 0x01
;     db 0x27, 0x03
;     db 0x51, 0x01
;     db 0x27, 0x06   ; color 7

;     db 0x71, 0x01   ; color 8
;     db 0x73, 0x03
;     db 0x61, 0x06
;     db 0x64, 0x06
;     db 0x11, 0x04
;     db 0x65, 0x02
;     db 0x55, 0x05
;     db 0x77, 0x07   ; color 15


LoadBackground:

    ; ----------------------- Bricks
    ld      de, NAMTBL + (0 / 2) + (0 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)

    ld      b, 12
.loop_a:
    push    bc

        ld      b, 16                                    ; number of repetitions
.loop_b:
        push    bc
            push    de
                call    RandomNumber
                and     0000 0001b
                or      a
                jp      nz, .bricks1
                ld		hl, Bricks		                        ; RAM address (source)
                jp      .continue_Bricks
.bricks1:
                ld		hl, Bricks_1		                    ; RAM address (source)
.continue_Bricks:
                ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
                ; ld      de, NAMTBL + (176 / 2) + (25 * 128)   ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
                call    Load_16x16_SC5_Image    
            pop     de
            ex      de, hl
                ld      bc, 8
                add     hl, bc
            ex      de, hl
        pop     bc
        djnz    .loop_b
        
        ex      de, hl
        ld      bc, 128 * 15        ; next (skip 16 lines)
            add     hl, bc
        ex      de, hl

    pop     bc
    djnz    .loop_a



    ; ----------------------- Floor
    ld      de, NAMTBL + (0 / 2) + (184 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)

    ld      b, 16                                    ; number of repetitions
.loop_c:
    push    bc
        push    de
            ld		hl, Floor		            ; RAM address (source)
            ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
            ; ld      de, NAMTBL + (176 / 2) + (25 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
            call    Load_16x8_SC5_Image    
        pop     de
        ex      de, hl
            ld      bc, 8
            add     hl, bc
        ex      de, hl
    pop     bc
    djnz    .loop_c
        




    ; test
    ; ld		hl, Window_1		                    ; RAM address (source)
    ; ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ; ld      de, NAMTBL + (16 / 2) + ((120) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    ; call    Load_16x16_SC5_Image_WithTransparency

    ; ----------------------- Tree left
    ld		hl, Tree_1		                        ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + (8 / 2) + ((192 - 8 - 32 + 4) * 128)   ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Tree_2		                        ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((8 + 16) / 2) + ((192 - 8 - 32 + 4) * 128)   ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Tree_3		                        ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + (8 / 2) + ((192 - 8 - 32 + 16 + 4) * 128)   ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Tree_4		                        ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((8 + 16) / 2) + ((192 - 8 - 32 + 16 + 4) * 128)   ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ; ----------------------- Tree right
    ld		hl, Tree_B_1		                        ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((256-32-8) / 2) + ((192 - 8 - 32 + 4) * 128)   ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Tree_B_2		                        ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + (((256-32-8) + 16) / 2) + ((192 - 8 - 32 + 4) * 128)   ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Tree_B_3		                        ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((256-32-8) / 2) + ((192 - 8 - 32 + 16 + 4) * 128)   ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Tree_B_4		                        ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + (((256-32-8) + 16) / 2) + ((192 - 8 - 32 + 16 + 4) * 128)   ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ; ------------------------ Small gifts left
    ld		hl, Small_Gift_1                        ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((32 + 8) / 2) + ((192 - 8 - 32 + 4 + 24) * 128)   ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Small_Gift_2                        ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((32 + 8 + 12) / 2) + ((192 - 8 - 32 + 4 + 24 - 2) * 128)   ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Small_Gift_3                        ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((32 + 8 + 24) / 2) + ((192 - 8 - 32 + 4 + 24) * 128)   ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Small_Gift_4                        ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((32 + 8 + 36) / 2) + ((192 - 8 - 32 + 4 + 24 - 2) * 128)   ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ; ------------------------ Small gifts right
    ld		hl, Small_Gift_1                        ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((32 + 8 + 128) / 2) + ((192 - 8 - 32 + 4 + 24) * 128)   ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Small_Gift_4                        ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((32 + 8 + 12 + 128) / 2) + ((192 - 8 - 32 + 4 + 24 - 2) * 128)   ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Small_Gift_2                        ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((32 + 8 + 24 + 128) / 2) + ((192 - 8 - 32 + 4 + 24) * 128)   ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Small_Gift_3                        ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((32 + 8 + 36 + 128) / 2) + ((192 - 8 - 32 + 4 + 24 - 2) * 128)   ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ; ----------------------- Window left
    ld		hl, Window_1		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((WINDOW_LEFT_X) / 2) + ((WINDOW_LEFT_Y) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Window_2		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((WINDOW_LEFT_X + 16) / 2) + ((WINDOW_LEFT_Y) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Window_3		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((WINDOW_LEFT_X) / 2) + ((WINDOW_LEFT_Y + 16) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Window_4		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((WINDOW_LEFT_X + 16) / 2) + ((WINDOW_LEFT_Y + 16) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ; ----------------------- Window right
    ld		hl, Window_1		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((256-48-32+2) / 2) + ((128-32+16+8) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Window_2		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((256-48-16+2) / 2) + ((128-32+16+8) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Window_3		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((256-48-32+2) / 2) + ((128-16+16+8) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Window_4		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((256-48-16+2) / 2) + ((128-16+16+8) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ; ----------------------- Window top center
    ld		hl, Window_1		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((128-16) / 2) + ((40-16) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Window_2		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((128-16+16) / 2) + ((40-16) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Window_3		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((128-16) / 2) + ((40+16-16) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Window_4		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((128-16+16) / 2) + ((40+16-16) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ; ----------------------- Wood horizontal
    ld      de, NAMTBL + (0 / 2) + (88 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)

    ld      b, 16                                    ; number of repetitions
.loop_wh:
    push    bc
        push    de
            ld		hl, Wood_Horizontal		                    ; RAM address (source)
            ld      a, 0000 0000 b                              ; destiny on VRAM (17 bits)
            ; ld      de, NAMTBL + (176 / 2) + (25 * 128)       ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
            call    Load_16x8_SC5_Image    
        pop     de
        ex      de, hl
            ld      bc, 8
            add     hl, bc
        ex      de, hl
    pop     bc
    djnz    .loop_wh
        
    ; ----------------------- Wood vertical 1
    ld      de, NAMTBL + (0 / 2) + ((88 + 8) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)

    ld      b, 10                                    ; number of repetitions
.loop_wv_1:
    push    bc
        push    de
            ld		hl, Wood_Vertical		                    ; RAM address (source)
            ld      a, 0000 0000 b                              ; destiny on VRAM (17 bits)
            ; ld      de, NAMTBL + (176 / 2) + (25 * 128)       ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
            call    Load_16x16_SC5_Image_WithTransparency    
        pop     de
        ex      de, hl
            ld      bc, 128 * 8         ; add 128 * 8 bytes = skip 8 lines
            add     hl, bc
        ex      de, hl
    pop     bc
    djnz    .loop_wv_1

    ; ----------------------- Wood vertical 2
    ld      de, NAMTBL + ((128 - 4) / 2) + ((88 + 8) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)

    ld      b, 10                                    ; number of repetitions
.loop_wv_2:
    push    bc
        push    de
            ld		hl, Wood_Vertical		                    ; RAM address (source)
            ld      a, 0000 0000 b                              ; destiny on VRAM (17 bits)
            ; ld      de, NAMTBL + (176 / 2) + (25 * 128)       ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
            call    Load_16x16_SC5_Image_WithTransparency    
        pop     de
        ex      de, hl
            ld      bc, 128 * 8         ; add 128 * 8 bytes = skip 8 lines
            add     hl, bc
        ex      de, hl
    pop     bc
    djnz    .loop_wv_2

    ; ----------------------- Wood vertical 3
    ld      de, NAMTBL + ((256 - 8) / 2) + ((88 + 8) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)

    ld      b, 10                                    ; number of repetitions
.loop_wv_3:
    push    bc
        push    de
            ld		hl, Wood_Vertical		                    ; RAM address (source)
            ld      a, 0000 0000 b                              ; destiny on VRAM (17 bits)
            ; ld      de, NAMTBL + (176 / 2) + (25 * 128)       ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
            call    Load_16x16_SC5_Image_WithTransparency    
        pop     de
        ex      de, hl
            ld      bc, 128 * 8         ; add 128 * 8 bytes = skip 8 lines
            add     hl, bc
        ex      de, hl
    pop     bc
    djnz    .loop_wv_3

    ; ----------------------- Wood vertical 4
    ld      de, NAMTBL + ((64-4) / 2) + (0 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)

    ld      b, 10                                    ; number of repetitions
.loop_wv_4:
    push    bc
        push    de
            ld		hl, Wood_Vertical		                    ; RAM address (source)
            ld      a, 0000 0000 b                              ; destiny on VRAM (17 bits)
            ; ld      de, NAMTBL + (176 / 2) + (25 * 128)       ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
            call    Load_16x16_SC5_Image_WithTransparency    
        pop     de
        ex      de, hl
            ld      bc, 128 * 8         ; add 128 * 8 bytes = skip 8 lines
            add     hl, bc
        ex      de, hl
    pop     bc
    djnz    .loop_wv_4

    ; ----------------------- Wood vertical 5
    ld      de, NAMTBL + ((64-4+128) / 2) + (0 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)

    ld      b, 10                                    ; number of repetitions
.loop_wv_5:
    push    bc
        push    de
            ld		hl, Wood_Vertical		                    ; RAM address (source)
            ld      a, 0000 0000 b                              ; destiny on VRAM (17 bits)
            ; ld      de, NAMTBL + (176 / 2) + (25 * 128)       ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
            call    Load_16x16_SC5_Image_WithTransparency    
        pop     de
        ex      de, hl
            ld      bc, 128 * 8         ; add 128 * 8 bytes = skip 8 lines
            add     hl, bc
        ex      de, hl
    pop     bc
    djnz    .loop_wv_5





    ; ----------------------- Top right conveyor belt
    ld		hl, ConveyorBelt_Frame1		            ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + (160 / 2) + (25 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency    

    ld      de, NAMTBL + (176 / 2) + (25 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    ld      b, 5                                    ; number of repetitions
.loop_0:
    push    bc
        push    de
            ld		hl, ConveyorBelt_Frame2		            ; RAM address (source)
            ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
            ; ld      de, NAMTBL + (176 / 2) + (25 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
            call    Load_16x16_SC5_Image_WithTransparency    
        pop     de
        ex      de, hl
            ld      bc, 8
            add     hl, bc
        ex      de, hl
    pop     bc
    djnz    .loop_0
    

    ; ----------------------- Bottom right conveyor belt
    ld		hl, ConveyorBelt_Frame1		            ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((199-8) / 2) + (57 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency    

    ld      de, NAMTBL + ((215-8) / 2) + (57 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    ld      b, 3                                    ; number of repetitions
.loop_1:
    push    bc
        push    de
            ld		hl, ConveyorBelt_Frame2		            ; RAM address (source)
            ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
            ; ld      de, NAMTBL + (176 / 2) + (25 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
            call    Load_16x16_SC5_Image_WithTransparency    
        pop     de
        ex      de, hl
            ld      bc, 8
            add     hl, bc
        ex      de, hl
    pop     bc
    djnz    .loop_1
    

    ; ----------------------- Top left conveyor belt
    ld		hl, ConveyorBelt_Frame3		            ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((108-13) / 2) + ((25-16) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency    

    ld      de, NAMTBL + (0 / 2) + ((25-16) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    ld      b, 6                                    ; number of repetitions
.loop_2:
    push    bc
        push    de
            ld		hl, ConveyorBelt_Frame4		            ; RAM address (source)
            ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
            ; ld      de, NAMTBL + (176 / 2) + (25 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
            call    Load_16x16_SC5_Image_WithTransparency    
        pop     de
        ex      de, hl
            ld      bc, 8
            add     hl, bc
        ex      de, hl
    pop     bc
    djnz    .loop_2
    

    ; ----------------------- Bottom left conveyor belt
    ld		hl, ConveyorBelt_Frame3		            ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((69-13-8) / 2) + ((25+16) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency    

    ld      de, NAMTBL + (0 / 2) + ((25+16) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    ld      b, 3                                    ; number of repetitions
.loop_3:
    push    bc
        push    de
            ld		hl, ConveyorBelt_Frame4		            ; RAM address (source)
            ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
            ; ld      de, NAMTBL + (176 / 2) + (25 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
            call    Load_16x16_SC5_Image_WithTransparency    
        pop     de
        ex      de, hl
            ld      bc, 8
            add     hl, bc
        ex      de, hl
    pop     bc
    djnz    .loop_3






    ; test
    ; ld      a, 0
    ; ld      hl, NAMTBL + (128 / 2) + (191 * 128)
    ; call    SetVdp_Write
    ; ld      b, 8             ; bytes per line (16 pixels = 8 bytes on SC5)
    ; ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
    ; ld		hl, DataTest		            ; RAM address (source)
    ; otir

    ret


; TestData:
;     db  0x01, 0x10, 0x11, 0x00, 0xb0, 0xbb, 0x0b, 0xff
NAMTBL:     equ 0x0000
SPRPAT:     equ 0x7800
SPRCOL:     equ 0x7400
SPRATR:     equ 0x7600



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




    call    BIOS_ENASCR


    ret




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
                ld		hl, Bricks		            ; RAM address (source)
                ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
                ; ld      de, NAMTBL + (176 / 2) + (25 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
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
    ld		hl, Window_1		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + (16 / 2) + ((120) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency




    ; ----------------------- Window left
    ld		hl, Window_1		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + (48 / 2) + ((128-32) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Window_2		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + (64 / 2) + ((128-32) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Window_3		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + (48 / 2) + ((128-16) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Window_4		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + (64 / 2) + ((128-16) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ; ----------------------- Window right
    ld		hl, Window_1		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((256-48-32) / 2) + ((128-32) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Window_2		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((256-48-16) / 2) + ((128-32) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Window_3		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((256-48-32) / 2) + ((128-16) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency

    ld		hl, Window_4		                    ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((256-48-16) / 2) + ((128-16) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image_WithTransparency






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
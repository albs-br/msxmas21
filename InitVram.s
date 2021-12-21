NAMTBL:     equ 0x0000
SPRPAT:     equ 0x7800
SPRCOL:     equ 0x7400
SPRATR:     equ 0x7600



InitVram:

    ; disable keyboard click
    ld 		a, 0
    ld 		(BIOS_CLIKSW), a     ; Key Press Click Switch 0:Off 1:On (1B/RW)

    ; define screen colors
    ld 		a, 7       	            ; Foregoung color
    ld 		(BIOS_FORCLR), a    
    ld 		a, 7   		            ; Backgroung color
    ld 		(BIOS_BAKCLR), a     
    ld 		a, 7       	            ; Border color
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



    ; Fill NAMTBL with value
    ld      hl, NAMTBL
    ld      bc, 0 + (256 * 192) / 2
    ld      a, 0x77
    call    BIOS_BIGFIL





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




    call    BIOS_ENASCR


    ret



Load_16x16_SC5_Image:
    ld      b, 16               ; number of lines

    ld      c, a                ; save 17th bit of VRAM addr
.loop:
    push    bc

        ld      a, c            ; restore 17th bit of VRAM addr
        ex      de, hl
            call    SetVdp_Write
        ex      de, hl

        push    hl
            push    de


                ld      b, 8             ; bytes per line (16 pixels = 8 bytes on SC5)
                ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
                ;ld		hl, ConveyorBelt_Frame1		            ; RAM address (source)
                otir
            pop     de
        pop    hl

        ld      bc, 8              ; next line of image (16 pixels = 8 bytes on SC5)
        add     hl, bc

        ex      de, hl
            ld      bc, 128             ; next line of NAMTBL
            add     hl, bc
        ex      de, hl

    pop     bc
    djnz    .loop

    ret



Loadbackground:


    ; ----------------------- Top right conveyor belt
    ld		hl, ConveyorBelt_Frame1		            ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + (160 / 2) + (25 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image    

    ld      de, NAMTBL + (176 / 2) + (25 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    ld      b, 5                                    ; number of repetitions
.loop:
    push    bc
        push    de
            ld		hl, ConveyorBelt_Frame2		            ; RAM address (source)
            ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
            ; ld      de, NAMTBL + (176 / 2) + (25 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
            call    Load_16x16_SC5_Image    
        pop     de
        ex      de, hl
            ld      bc, 8
            add     hl, bc
        ex      de, hl
    pop     bc
    djnz    .loop
    

    ; ----------------------- Bottom right conveyor belt
    ld		hl, ConveyorBelt_Frame1		            ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + ((199-8) / 2) + (57 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    call    Load_16x16_SC5_Image    

    ld      de, NAMTBL + ((215-8) / 2) + (57 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    ld      b, 3                                    ; number of repetitions
.loop_1:
    push    bc
        push    de
            ld		hl, ConveyorBelt_Frame2		            ; RAM address (source)
            ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
            ; ld      de, NAMTBL + (176 / 2) + (25 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
            call    Load_16x16_SC5_Image    
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
    call    Load_16x16_SC5_Image    

    ld      de, NAMTBL + (0 / 2) + ((25-16) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    ld      b, 6                                    ; number of repetitions
.loop_2:
    push    bc
        push    de
            ld		hl, ConveyorBelt_Frame4		            ; RAM address (source)
            ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
            ; ld      de, NAMTBL + (176 / 2) + (25 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
            call    Load_16x16_SC5_Image    
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
    call    Load_16x16_SC5_Image    

    ld      de, NAMTBL + (0 / 2) + ((25+16) * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
    ld      b, 3                                    ; number of repetitions
.loop_3:
    push    bc
        push    de
            ld		hl, ConveyorBelt_Frame4		            ; RAM address (source)
            ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
            ; ld      de, NAMTBL + (176 / 2) + (25 * 128)     ; destiny on VRAM (17 bits) - (x / 2) + (y * 128)
            call    Load_16x16_SC5_Image    
        pop     de
        ex      de, hl
            ld      bc, 8
            add     hl, bc
        ex      de, hl
    pop     bc
    djnz    .loop_3

    ret
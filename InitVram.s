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



    ; test loading 16x16 SC5 image
    ld		hl, ConveyorBelt_Frame1		            ; RAM address (source)
    ld      a, 0000 0000 b                          ; destiny on VRAM (17 bits)
    ld      de, NAMTBL + 8 + (16 * 128)             ; destiny on VRAM (17 bits)
    call    Load_16x16_SC5_Image    



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
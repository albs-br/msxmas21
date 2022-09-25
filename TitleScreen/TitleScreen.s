TitleScreen:

    ; define screen colors
    ld 		a, 1      	            ; Foregoung color
    ld 		(BIOS_FORCLR), a    
    ld 		a, 1  		            ; Backgroung color
    ld 		(BIOS_BAKCLR), a     
    ld 		a, 1      	            ; Border color
    ld 		(BIOS_BDRCLR), a    
    call 	BIOS_CHGCLR        		; Change Screen Color



    ; change to screen 5
    ld      a, 5
    call    BIOS_CHGMOD

    call    BIOS_DISSCR

    call    ClearVram_MSX2

    call    SetSprites16x16

    call    Set192Lines

    call    SetColor0ToTransparent



;     ; test drawing on screen 5
;     ld      a, 0000 0000 b
;     ld      hl, NAMTBL
;     call    SetVdp_Write

;     ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
;     ld      b, 0
; .testLoop:
;     out     (c), b
;     djnz    .testLoop



    ; call    .Load_SPRATR_1
    ; call    .Load_SPRATR_2

    ; call    .Set_SPRATR_1




    ; ; Load sprite pattern #0
    ; ld      a, 0000 0000 b
    ; ld      hl, SPRPAT
    ; call    SetVdp_Write
    ; ld      b, SpritePattern_SnowFlake_0.size
    ; ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
    ; ld      hl, SpritePattern_SnowFlake_0
    ; otir



    call    BIOS_ENASCR

    ; ld      b, 255
    ; call    Wait_B_Vblanks

    jp      $ ; eternal loop


    ret

; .Set_SPRATR_1:
; ; ---- set SPRATR to 0x07600 (SPRCOL is automatically set 512 bytes before SPRATR, so 0x07400)
;     ; bits:    16 14   10   7
;     ;           |  |    |   |
;     ; 0x07600 = 0 0111 0110 0000 0000
;     ; low bits (aaaaa111: bits 14 to 10)
;     ld      b, 1110 1111 b  ; data          ; In sprite mode 2 the least significant three bits in register 5 should be 1 otherwise mirroring will occur. ; https://www.msx.org/forum/msx-talk/development/strange-behaviour-bug-on-spratr-base-addr-register-on-v993858
;     ld      c, 5            ; register #
;     ;call    BIOS_WRTVDP
;     call  	WRTVDP_without_DI_EI		; Write B value to C register

;     ; high bits (000000aa: bits 16 to 15)
;     ld      b, 0000 0000 b  ; data
;     ld      c, 11           ; register #
;     ;call    BIOS_WRTVDP
;     call  	WRTVDP_without_DI_EI		; Write B value to C register
;     ret


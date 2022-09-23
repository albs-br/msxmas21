UpdateAnimations:

    ld      a, (BIOS_JIFFY)
    and     0011 1111b
    cp      8
    jp      z, .frame1
    cp      16
    jp      z, .frame2
    cp      24
    jp      z, .frame3
    cp      32
    jp      z, .frame4
    cp      40
    jp      z, .frame5
    cp      48
    jp      z, .frame6
    cp      56
    jp      z, .frame7
    cp      63
    jp      z, .frame8
    ret

.frame1:
    ; test loading frame 0 of snow animation to top left glass of left window
    ld      hl, 0
    ld      b,WINDOW_LEFT_TOP_LEFT_GLASS_X
    ld      c,WINDOW_LEFT_TOP_LEFT_GLASS_Y
    call    LoadAnimationFrameToWindow
    ; ld      hl, 0
    ; ld      (VdpCommand_SourceX), hl     ; source x
    ; ld      hl, 256
    ; ld      (VdpCommand_SourceY), hl     ; source y
    ; ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_X
    ; ld      (VdpCommand_DestinyX), hl     ; dest x
    ; ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ; ld      (VdpCommand_DestinyY), hl     ; dest y
    ; ld      hl, VdpCommand 	; execute the copy
    ; call    DoCopy

    ld      hl, 0
    ld      b,WINDOW_LEFT_TOP_RIGHT_GLASS_X
    ld      c,WINDOW_LEFT_TOP_RIGHT_GLASS_Y
    call    LoadAnimationFrameToWindow

    ret

.frame2:
    ; test loading frame 1 of snow animation to top left glass of left window
    ld      hl, 9
    ld      b,WINDOW_LEFT_TOP_LEFT_GLASS_X
    ld      c,WINDOW_LEFT_TOP_LEFT_GLASS_Y
    call    LoadAnimationFrameToWindow

    ; ld      hl, 9
    ; ld      (VdpCommand_SourceX), hl     ; source x
    ; ld      hl, 256
    ; ld      (VdpCommand_SourceY), hl     ; source y
    ; ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_X
    ; ld      (VdpCommand_DestinyX), hl     ; dest x
    ; ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ; ld      (VdpCommand_DestinyY), hl     ; dest y
    ; ld      hl, VdpCommand 	; execute the copy
    ; call    DoCopy

    ld      hl, 9
    ld      b,WINDOW_LEFT_TOP_RIGHT_GLASS_X
    ld      c,WINDOW_LEFT_TOP_RIGHT_GLASS_Y
    call    LoadAnimationFrameToWindow

    ret

.frame3:
    ; test loading frame 3 of snow animation to top left glass of left window
    ld      hl, 16
    ld      b,WINDOW_LEFT_TOP_LEFT_GLASS_X
    ld      c,WINDOW_LEFT_TOP_LEFT_GLASS_Y
    call    LoadAnimationFrameToWindow
    ; ld      hl, 16
    ; ld      (VdpCommand_SourceX), hl     ; source x
    ; ld      hl, 256
    ; ld      (VdpCommand_SourceY), hl     ; source y
    ; ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_X
    ; ld      (VdpCommand_DestinyX), hl     ; dest x
    ; ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ; ld      (VdpCommand_DestinyY), hl     ; dest y
    ; ld      hl, VdpCommand 	; execute the copy
    ; call    DoCopy

    ld      hl, 16
    ld      b,WINDOW_LEFT_TOP_RIGHT_GLASS_X
    ld      c,WINDOW_LEFT_TOP_RIGHT_GLASS_Y
    call    LoadAnimationFrameToWindow

    ret

.frame4:
    ; test loading frame 4 of snow animation to top left glass of left window
    ld      hl, 16 + 9
    ld      b,WINDOW_LEFT_TOP_LEFT_GLASS_X
    ld      c,WINDOW_LEFT_TOP_LEFT_GLASS_Y
    call    LoadAnimationFrameToWindow
    ; ld      hl, 16 + 9
    ; ld      (VdpCommand_SourceX), hl     ; source x
    ; ld      hl, 256
    ; ld      (VdpCommand_SourceY), hl     ; source y
    ; ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_X
    ; ld      (VdpCommand_DestinyX), hl     ; dest x
    ; ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ; ld      (VdpCommand_DestinyY), hl     ; dest y
    ; ld      hl, VdpCommand 	; execute the copy
    ; call    DoCopy

    ld      hl, 16 + 9
    ld      b,WINDOW_LEFT_TOP_RIGHT_GLASS_X
    ld      c,WINDOW_LEFT_TOP_RIGHT_GLASS_Y
    call    LoadAnimationFrameToWindow

    ret

.frame5:
    ; test loading frame 5 of snow animation to top left glass of left window
    ld      hl, 32
    ld      b,WINDOW_LEFT_TOP_LEFT_GLASS_X
    ld      c,WINDOW_LEFT_TOP_LEFT_GLASS_Y
    call    LoadAnimationFrameToWindow
    ; ld      hl, 32
    ; ld      (VdpCommand_SourceX), hl     ; source x
    ; ld      hl, 256
    ; ld      (VdpCommand_SourceY), hl     ; source y
    ; ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_X
    ; ld      (VdpCommand_DestinyX), hl     ; dest x
    ; ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ; ld      (VdpCommand_DestinyY), hl     ; dest y
    ; ld      hl, VdpCommand 	; execute the copy
    ; call    DoCopy

    ld      hl, 32
    ld      b,WINDOW_LEFT_TOP_RIGHT_GLASS_X
    ld      c,WINDOW_LEFT_TOP_RIGHT_GLASS_Y
    call    LoadAnimationFrameToWindow

    ret

.frame6:
    ; test loading frame 6 of snow animation to top left glass of left window
    ld      hl, 32 + 9
    ld      b,WINDOW_LEFT_TOP_LEFT_GLASS_X
    ld      c,WINDOW_LEFT_TOP_LEFT_GLASS_Y
    call    LoadAnimationFrameToWindow
    ; ld      hl, 32 + 9
    ; ld      (VdpCommand_SourceX), hl     ; source x
    ; ld      hl, 256
    ; ld      (VdpCommand_SourceY), hl     ; source y
    ; ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_X
    ; ld      (VdpCommand_DestinyX), hl     ; dest x
    ; ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ; ld      (VdpCommand_DestinyY), hl     ; dest y
    ; ld      hl, VdpCommand 	; execute the copy
    ; call    DoCopy

    ld      hl, 32 + 9
    ld      b,WINDOW_LEFT_TOP_RIGHT_GLASS_X
    ld      c,WINDOW_LEFT_TOP_RIGHT_GLASS_Y
    call    LoadAnimationFrameToWindow

    ret

.frame7:
    ; test loading frame 7 of snow animation to top left glass of left window
    ld      hl, 48
    ld      b,WINDOW_LEFT_TOP_LEFT_GLASS_X
    ld      c,WINDOW_LEFT_TOP_LEFT_GLASS_Y
    call    LoadAnimationFrameToWindow
    ; ld      hl, 48
    ; ld      (VdpCommand_SourceX), hl     ; source x
    ; ld      hl, 256
    ; ld      (VdpCommand_SourceY), hl     ; source y
    ; ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_X
    ; ld      (VdpCommand_DestinyX), hl     ; dest x
    ; ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ; ld      (VdpCommand_DestinyY), hl     ; dest y
    ; ld      hl, VdpCommand 	; execute the copy
    ; call    DoCopy

    ld      hl, 48
    ld      b,WINDOW_LEFT_TOP_RIGHT_GLASS_X
    ld      c,WINDOW_LEFT_TOP_RIGHT_GLASS_Y
    call    LoadAnimationFrameToWindow

    ret

.frame8:
    ; test loading frame 8 of snow animation to top left glass of left window

    ld      hl, 48 + 9
    ld      b,WINDOW_LEFT_TOP_LEFT_GLASS_X
    ld      c,WINDOW_LEFT_TOP_LEFT_GLASS_Y
    call    LoadAnimationFrameToWindow
    ; ld      hl, 48 + 9
    ; ld      (VdpCommand_SourceX), hl     ; source x
    ; ld      hl, 256
    ; ld      (VdpCommand_SourceY), hl     ; source y
    ; ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_X
    ; ld      (VdpCommand_DestinyX), hl     ; dest x
    ; ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ; ld      (VdpCommand_DestinyY), hl     ; dest y
    ; ld      hl, VdpCommand 	; execute the copy
    ; call    DoCopy

    ld      hl, 48 + 9
    ld      b, WINDOW_LEFT_TOP_RIGHT_GLASS_X
    ld      c, WINDOW_LEFT_TOP_RIGHT_GLASS_Y
    call    LoadAnimationFrameToWindow

    ret



; Inputs:
;   HL: VdpCommand_SourceX
;   B:  VdpCommand_DestinyX
;   C:  VdpCommand_DestinyY
LoadAnimationFrameToWindow:
    push    hl, bc
        ld      hl, COPYBLOCK
        ld      de, VdpCommand
        ld      bc, 15
        ldir
    pop     bc, hl

    ld      (VdpCommand_SourceX), hl     ; source x
    ld      hl, 256
    ld      (VdpCommand_SourceY), hl     ; source y
    
    ;ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_X
    ld      h, 0
    ld      l, b
    ld      (VdpCommand_DestinyX), hl     ; dest x

    ;ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ld      h, 0
    ld      l, c
    ld      (VdpCommand_DestinyY), hl     ; dest y
    ld      hl, VdpCommand 	; execute the copy
    
    call    DoCopy

    ret
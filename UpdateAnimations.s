UpdateAnimations:

    ld      a, (BIOS_JIFFY)
    and     0011 1111b
    cp      8
    jp      z, .frame0
    cp      16
    jp      z, .frame1
    cp      24
    jp      z, .frame2
    cp      32
    jp      z, .frame3
    cp      40
    jp      z, .frame4
    cp      48
    jp      z, .frame5
    cp      56
    jp      z, .frame6
    cp      63
    jp      z, .frame7
    ret

.frame0:
    ; loading frame 0 of snow animation to all 4 parts of left window
    ld      hl, SNOW_ANIMATION_FRAME_0
    call    LoadAnimationFrameToAll4Windows

    ; ld      b,WINDOW_LEFT_TOP_LEFT_GLASS_X
    ; ld      c,WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ; call    LoadAnimationFrameToWindow
    ; ; ld      hl, 0
    ; ; ld      (VdpCommand_SourceX), hl     ; source x
    ; ; ld      hl, 256
    ; ; ld      (VdpCommand_SourceY), hl     ; source y
    ; ; ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_X
    ; ; ld      (VdpCommand_DestinyX), hl     ; dest x
    ; ; ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ; ; ld      (VdpCommand_DestinyY), hl     ; dest y
    ; ; ld      hl, VdpCommand 	; execute the copy
    ; ; call    DoCopy

    ; ld      hl, SNOW_ANIMATION_FRAME_0
    ; ld      b,WINDOW_LEFT_TOP_RIGHT_GLASS_X
    ; ld      c,WINDOW_LEFT_TOP_RIGHT_GLASS_Y
    ; call    LoadAnimationFrameToWindow

    ; ld      hl, SNOW_ANIMATION_FRAME_0
    ; ld      b,WINDOW_LEFT_BOTTOM_LEFT_GLASS_X
    ; ld      c,WINDOW_LEFT_BOTTOM_LEFT_GLASS_Y
    ; call    LoadAnimationFrameToWindow

    ; ld      hl, SNOW_ANIMATION_FRAME_0
    ; ld      b,WINDOW_LEFT_BOTTOM_RIGHT_GLASS_X
    ; ld      c,WINDOW_LEFT_BOTTOM_RIGHT_GLASS_Y
    ; call    LoadAnimationFrameToWindow

    ret

.frame1:
    ld      hl, SNOW_ANIMATION_FRAME_1
    call    LoadAnimationFrameToAll4Windows

    ; ld      hl, SNOW_ANIMATION_FRAME_1
    ; ld      b,WINDOW_LEFT_TOP_LEFT_GLASS_X
    ; ld      c,WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ; call    LoadAnimationFrameToWindow

    ; ld      hl, SNOW_ANIMATION_FRAME_1
    ; ld      b,WINDOW_LEFT_TOP_RIGHT_GLASS_X
    ; ld      c,WINDOW_LEFT_TOP_RIGHT_GLASS_Y
    ; call    LoadAnimationFrameToWindow

    ret

.frame2:
    ld      hl, SNOW_ANIMATION_FRAME_2
    call    LoadAnimationFrameToAll4Windows

    ; ld      hl, SNOW_ANIMATION_FRAME_2
    ; ld      b,WINDOW_LEFT_TOP_LEFT_GLASS_X
    ; ld      c,WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ; call    LoadAnimationFrameToWindow

    ; ld      hl, SNOW_ANIMATION_FRAME_2
    ; ld      b,WINDOW_LEFT_TOP_RIGHT_GLASS_X
    ; ld      c,WINDOW_LEFT_TOP_RIGHT_GLASS_Y
    ; call    LoadAnimationFrameToWindow

    ret

.frame3:
    ld      hl, SNOW_ANIMATION_FRAME_3
    call    LoadAnimationFrameToAll4Windows

    ; ld      hl, SNOW_ANIMATION_FRAME_3
    ; ld      b,WINDOW_LEFT_TOP_LEFT_GLASS_X
    ; ld      c,WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ; call    LoadAnimationFrameToWindow

    ; ld      hl, SNOW_ANIMATION_FRAME_3
    ; ld      b,WINDOW_LEFT_TOP_RIGHT_GLASS_X
    ; ld      c,WINDOW_LEFT_TOP_RIGHT_GLASS_Y
    ; call    LoadAnimationFrameToWindow

    ret

.frame4:
    ld      hl, SNOW_ANIMATION_FRAME_4
    call    LoadAnimationFrameToAll4Windows

    ; ld      hl, SNOW_ANIMATION_FRAME_4
    ; ld      b,WINDOW_LEFT_TOP_LEFT_GLASS_X
    ; ld      c,WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ; call    LoadAnimationFrameToWindow

    ; ld      hl, SNOW_ANIMATION_FRAME_4
    ; ld      b,WINDOW_LEFT_TOP_RIGHT_GLASS_X
    ; ld      c,WINDOW_LEFT_TOP_RIGHT_GLASS_Y
    ; call    LoadAnimationFrameToWindow

    ret

.frame5:
    ld      hl, SNOW_ANIMATION_FRAME_5
    call    LoadAnimationFrameToAll4Windows

    ; ld      hl, SNOW_ANIMATION_FRAME_5
    ; ld      b,WINDOW_LEFT_TOP_LEFT_GLASS_X
    ; ld      c,WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ; call    LoadAnimationFrameToWindow

    ; ld      hl, SNOW_ANIMATION_FRAME_5
    ; ld      b,WINDOW_LEFT_TOP_RIGHT_GLASS_X
    ; ld      c,WINDOW_LEFT_TOP_RIGHT_GLASS_Y
    ; call    LoadAnimationFrameToWindow

    ret

.frame6:
    ld      hl, SNOW_ANIMATION_FRAME_6
    call    LoadAnimationFrameToAll4Windows

    ; ld      hl, SNOW_ANIMATION_FRAME_6
    ; ld      b,WINDOW_LEFT_TOP_LEFT_GLASS_X
    ; ld      c,WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ; call    LoadAnimationFrameToWindow

    ; ld      hl, SNOW_ANIMATION_FRAME_6
    ; ld      b,WINDOW_LEFT_TOP_RIGHT_GLASS_X
    ; ld      c,WINDOW_LEFT_TOP_RIGHT_GLASS_Y
    ; call    LoadAnimationFrameToWindow

    ret

.frame7:
    ld      hl, SNOW_ANIMATION_FRAME_7
    call    LoadAnimationFrameToAll4Windows

    ; ld      hl, SNOW_ANIMATION_FRAME_7
    ; ld      b,WINDOW_LEFT_TOP_LEFT_GLASS_X
    ; ld      c,WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ; call    LoadAnimationFrameToWindow

    ; ld      hl, SNOW_ANIMATION_FRAME_7
    ; ld      b, WINDOW_LEFT_TOP_RIGHT_GLASS_X
    ; ld      c, WINDOW_LEFT_TOP_RIGHT_GLASS_Y
    ; call    LoadAnimationFrameToWindow

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

LoadAnimationFrameToAll4Windows:
    push    hl
        ;ld      hl, SNOW_ANIMATION_FRAME_0
        ld      b,WINDOW_LEFT_TOP_LEFT_GLASS_X
        ld      c,WINDOW_LEFT_TOP_LEFT_GLASS_Y
        call    LoadAnimationFrameToWindow
    pop     hl

    push    hl
        ld      b,WINDOW_LEFT_TOP_RIGHT_GLASS_X
        ld      c,WINDOW_LEFT_TOP_RIGHT_GLASS_Y
        call    LoadAnimationFrameToWindow
    pop     hl

    push    hl
        ld      b,WINDOW_LEFT_BOTTOM_LEFT_GLASS_X
        ld      c,WINDOW_LEFT_BOTTOM_LEFT_GLASS_Y
        call    LoadAnimationFrameToWindow
    pop     hl

    push    hl
        ld      b,WINDOW_LEFT_BOTTOM_RIGHT_GLASS_X
        ld      c,WINDOW_LEFT_BOTTOM_RIGHT_GLASS_Y
        call    LoadAnimationFrameToWindow
    pop     hl

    ret
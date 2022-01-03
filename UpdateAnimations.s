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
    ld      hl, COPYBLOCK
    ld      de, VdpCommand
    ld      bc, 15
    ldir

    ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_X
    ld      (VdpCommand_DestinyX), hl     ; dest x
    ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ld      (VdpCommand_DestinyY), hl     ; dest y
    ld      hl, VdpCommand 	; execute the copy
    call    DoCopy

    ret

.frame2:
    ; test loading frame 1 of snow animation to top left glass of left window
    ld      hl, COPYBLOCK
    ld      de, VdpCommand
    ld      bc, 15
    ldir

    ld      hl, 9
    ld      (VdpCommand_SourceX), hl     ; source x
    ld      hl, 256
    ld      (VdpCommand_SourceY), hl     ; source y
    ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_X
    ld      (VdpCommand_DestinyX), hl     ; dest x
    ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ld      (VdpCommand_DestinyY), hl     ; dest y
    ld      hl, VdpCommand 	; execute the copy
    call    DoCopy

    ret

.frame3:
    ; test loading frame 3 of snow animation to top left glass of left window
    ld      hl, COPYBLOCK
    ld      de, VdpCommand
    ld      bc, 15
    ldir

    ld      hl, 16
    ld      (VdpCommand_SourceX), hl     ; source x
    ld      hl, 256
    ld      (VdpCommand_SourceY), hl     ; source y
    ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_X
    ld      (VdpCommand_DestinyX), hl     ; dest x
    ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ld      (VdpCommand_DestinyY), hl     ; dest y
    ld      hl, VdpCommand 	; execute the copy
    call    DoCopy

    ret

.frame4:
    ; test loading frame 4 of snow animation to top left glass of left window
    ld      hl, COPYBLOCK
    ld      de, VdpCommand
    ld      bc, 15
    ldir

    ld      hl, 16 + 9
    ld      (VdpCommand_SourceX), hl     ; source x
    ld      hl, 256
    ld      (VdpCommand_SourceY), hl     ; source y
    ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_X
    ld      (VdpCommand_DestinyX), hl     ; dest x
    ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ld      (VdpCommand_DestinyY), hl     ; dest y
    ld      hl, VdpCommand 	; execute the copy
    call    DoCopy

    ret

.frame5:
    ; test loading frame 5 of snow animation to top left glass of left window
    ld      hl, COPYBLOCK
    ld      de, VdpCommand
    ld      bc, 15
    ldir

    ld      hl, 32
    ld      (VdpCommand_SourceX), hl     ; source x
    ld      hl, 256
    ld      (VdpCommand_SourceY), hl     ; source y
    ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_X
    ld      (VdpCommand_DestinyX), hl     ; dest x
    ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ld      (VdpCommand_DestinyY), hl     ; dest y
    ld      hl, VdpCommand 	; execute the copy
    call    DoCopy

    ret

.frame6:
    ; test loading frame 6 of snow animation to top left glass of left window
    ld      hl, COPYBLOCK
    ld      de, VdpCommand
    ld      bc, 15
    ldir

    ld      hl, 32 + 9
    ld      (VdpCommand_SourceX), hl     ; source x
    ld      hl, 256
    ld      (VdpCommand_SourceY), hl     ; source y
    ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_X
    ld      (VdpCommand_DestinyX), hl     ; dest x
    ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ld      (VdpCommand_DestinyY), hl     ; dest y
    ld      hl, VdpCommand 	; execute the copy
    call    DoCopy

    ret

.frame7:
    ; test loading frame 7 of snow animation to top left glass of left window
    ld      hl, COPYBLOCK
    ld      de, VdpCommand
    ld      bc, 15
    ldir

    ld      hl, 48
    ld      (VdpCommand_SourceX), hl     ; source x
    ld      hl, 256
    ld      (VdpCommand_SourceY), hl     ; source y
    ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_X
    ld      (VdpCommand_DestinyX), hl     ; dest x
    ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ld      (VdpCommand_DestinyY), hl     ; dest y
    ld      hl, VdpCommand 	; execute the copy
    call    DoCopy

    ret

.frame8:
    ; test loading frame 8 of snow animation to top left glass of left window
    ld      hl, COPYBLOCK
    ld      de, VdpCommand
    ld      bc, 15
    ldir

    ld      hl, 48 + 9
    ld      (VdpCommand_SourceX), hl     ; source x
    ld      hl, 256
    ld      (VdpCommand_SourceY), hl     ; source y
    ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_X
    ld      (VdpCommand_DestinyX), hl     ; dest x
    ld      hl, WINDOW_LEFT_TOP_LEFT_GLASS_Y
    ld      (VdpCommand_DestinyY), hl     ; dest y
    ld      hl, VdpCommand 	; execute the copy
    call    DoCopy

    ret
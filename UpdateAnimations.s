UpdateAnimations:

    ld      a, (BIOS_JIFFY)
    and     0001 0000b
    or      a
    jp      nz, .frame1

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

.frame1:
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
//Petdraw (Commander X16 version)
//by David Murray 2019
//dfwgreencars@gmail.com
//
//Converted to KickAssembler
//by Marcelo Lv Cabral 2020
//https://github.com/lvcabral

// The following routine is the Pixel-Draw screen
// which allows the user to draw using an 80x50 matrix
// of PETSCII block characters. it is accessed by
// pressing F3.

PIXEL_DRAW_SCREEN:
    jsr MAIN_CURSOR_UNPLOT
    lda XLOC //convert coordinates from regular screen to 
    asl   //the pixel-draw matrix so that cursor shows
    sta PX  //up around the same place.
    lda YLOC
    asl 
    sta PY
    jsr POSTMOVE

PXGETKEYBOARD:
    jsr PXCURSOR
    jsr $FFE4
    cmp #$00
    beq PXGETKEYBOARD
    cmp #138 // F4
    bne PXKEY01
    jsr PREMOVE
    jsr COLOR_SCREEN
    jsr POSTMOVE
PXKEY01: cmp #$85 //F1-KEY
    bne PXKEY02
    jsr PREMOVE
    jsr MAIN_CURSOR_PLOT
    jmp MAIN_DRAW_SCREEN
PXKEY02: cmp #$91 //CURSOR UP
    bne PXKEY03
    jsr PXUP
    jmp PXGETKEYBOARD
PXKEY03: cmp #$11 //CURSOR DOWN
    bne PXKEY04
    jsr PXDOWN
    jmp PXGETKEYBOARD
PXKEY04: cmp #$9D //CURSOR LEFT
    bne PXKEY05
    jsr PXLEFT
    jmp PXGETKEYBOARD
PXKEY05: cmp #$1D //CURSOR RIGHT
    bne PXKEY06 
    jsr PXRIGHT
    jmp PXGETKEYBOARD
PXKEY06: cmp #$20 //SPACE
    bne PXKEY07
    jsr PIXELPLOT
    lda PCHAR
    sta CHRTEMP
    lda SELCOL
    sta COLTEMP
    jmp PXGETKEYBOARD
PXKEY07: cmp #$14 //BACKSPACE
    bne PXKEY08
    jsr PIXELUNPLOT
    jmp PXGETKEYBOARD
PXKEY08: cmp #134 //F3
    bne PXKEY09
    //jmp TYPINGMODESCREEN
PXKEY09:
    jmp PXGETKEYBOARD

PXRIGHT:
    lda SCR_SIZE_X
    asl //MULTIPLY BY 2
    sec
    sbc #1
    cmp PX
    beq PXR01
    jsr PREMOVE
    inc PX
    jsr CONVPXPY
    jsr POSTMOVE
PXR01: rts

PXLEFT:
    lda PX
    cmp #$00
    beq PXL01
    jsr PREMOVE
    dec PX
    jsr CONVPXPY
    jsr POSTMOVE
PXL01: rts

PXDOWN:
    lda SCR_SIZE_Y
    asl //MULTIPLY BY 2
    sec
    sbc #1
    cmp PY
    beq PXD01
    jsr PREMOVE
    inc PY
    jsr CONVPXPY
    jsr POSTMOVE
PXD01: rts

PXUP:
    lda PY
    cmp #$00
    beq PXU01
    jsr PREMOVE
    dec PY
    jsr CONVPXPY
    jsr POSTMOVE
PXU01: rts

//The following routine blinks the cursor for pixel mode. However
//it is a carry over from the C64 version and needs to be re-written
//to use the VIA timers instead of a loop like it does now.

PXCURSOR:
    inc CRXTIMER  //TIMING ROUTINE
    lda #$00
    cmp CRXTIMER
    bne PXCR10
    inc CRXTIM2
    lda #$04
    cmp CRXTIM2
    bne PXCR10
    lda #$00
    sta CRXTIM2
    
    lda PXCRST  //TIME TO DO SOMETHING
    cmp #$01  // check cursor state
    bne PXCR01
    lda #$00
    sta PXCRST  //TURN CURSOR ON
    jsr PIXELCRPLOT
    jmp PXCR10
PXCR01: lda #$01
    sta PXCRST
    jsr PIXELCRUNPLOT //TURN CURSOR OFF
PXCR10: rts

//The following routing converts the pixel coordinates
//into regular 40x25 text coordinates.

CONVPXPY:
    lda PX
    lsr   //divide by 2
    sta XLOC
    lda PY
    lsr   //divide by 2
    sta YLOC 
    rts

// The following routine takes the coordinates in 
// PX and PY and plots a pixel on the screen.

PIXELPLOTFIND:
    jsr CONVPXPY
    jsr GETCHAR  //find out what char is already there 
    ldx #$00 
PP01: lda PIXELMAP,X
    cmp PCHAR
    beq PP02
    inx
    cpx  #$00
    beq PP02
    jmp PP01
PP02: stx PIXEL
    lda PX
    and #%00000001
    cmp #%00000001
    beq PP03
    lda #%00000010
    jmp PP04
PP03: lda #%00000001
PP04: sta PIXEL2
    lda PY
    and #%00000001
    cmp #%00000001
    beq PP05
    asl PIXEL2
    asl PIXEL2 
PP05: rts

PX: .byte $00 // X-Location (0-79)
PY: .byte $00 // Y-Location (0-49)
PIXEL: .byte $00 // CURRENT 4-BIT PIXEL
PIXEL2: .byte $00 // TEMP

PIXELPLOT: 
    jsr PIXELPLOTFIND
    lda PIXEL2
    ora PIXEL
    tax
    lda PIXELMAP,X
    sta PCHAR
    sta CHRTEMP
    lda SELCOL
    sta PCOL
    jsr PLOTCHAR
    rts

PIXELUNPLOT:
    jsr PIXELPLOTFIND
    lda PIXEL2
    eor #%11111111
    and PIXEL
    tax
    lda PIXELMAP,X
    sta PCHAR
    sta CHRTEMP
    lda SELCOL
    sta PCOL
    jsr PLOTCHAR
    rts

PIXELCRPLOT: 
    jsr PIXELPLOTFIND
    lda PIXEL2
    ora PIXEL
    tax
    lda PIXELMAP,X
    sta PCHAR
    lda SELCOL
    sta PCOL
    jsr PLOTCHAR
    rts

PIXELCRUNPLOT:
    jsr PIXELPLOTFIND
    lda PIXEL2
    eor #%11111111
    and PIXEL
    tax
    lda PIXELMAP,X
    sta PCHAR
    lda SELCOL
    sta PCOL
    jsr PLOTCHAR
    rts

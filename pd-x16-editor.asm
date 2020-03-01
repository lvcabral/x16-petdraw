//Petdraw (Commander X16 version)
//by David Murray 2019
//dfwgreencars@gmail.com
//
//Converted to KickAssembler
//by Marcelo Lv Cabral 2020
//https://github.com/lvcabral

SHIFT_LINE_RIGHT:
    lda SCR_SIZE_X
    sec
    sbc #1
    sta XTEMP
    lda #%00010000 //INCREMENT SET TO 1
    sta VERA_INC
    //FIRST GRAB RIGHT CHARACTER+COLOR FOR STORAGE
    lda YLOC
    sta VERA_HI
    lda SCR_SIZE_X
    sec
    sbc #1
    asl  //MULT BY 2
    sta VERA_LO
    lda VERA_RW
    sta SHIFT_TEMP1
    lda VERA_RW
    sta SHIFT_TEMP2
SHRT02: 
    //NEXT GET BYTE FROM COLUMN TO LEFT
    lda XTEMP
    sec
    sbc #1
    asl  //MULT BY 2
    sta VERA_LO
    lda VERA_RW
    sta CHRTEMP
    lda VERA_RW
    sta COLTEMP
    //NOW STORE TO CURRENT COLUMN
    lda XTEMP
    asl  //MULT BY 2
    sta VERA_LO
    lda CHRTEMP
    sta VERA_RW
    lda COLTEMP
    sta VERA_RW
    //NOW MOVE TO LEFT
    dec XTEMP
    lda XTEMP
    cmp #0
    bne SHRT02
    //NOW PLACE TEMP CHAR AT LEFT OF SCREEN
    lda 0
    sta VERA_LO
    lda SHIFT_TEMP1
    sta VERA_RW
    lda SHIFT_TEMP2
    sta VERA_RW
    rts

SHIFT_LINE_LEFT:
    lda #0
    sta XTEMP
    lda #%00010000 //INCREMENT SET TO 1
    sta VERA_INC
    //FIRST GRAB LEFT CHARACTER+COLOR FOR STORAGE
    lda YLOC
    sta VERA_HI
    lda #0
    sta VERA_LO
    lda VERA_RW
    sta SHIFT_TEMP1
    lda VERA_RW
    sta SHIFT_TEMP2
SHLF02: 
    //NEXT GET BYTE FROM COLUMN TO RIGHT
    lda XTEMP
    clc
    adc #1
    asl  //MULT BY 2
    sta VERA_LO
    lda VERA_RW
    sta CHRTEMP
    lda VERA_RW
    sta COLTEMP
    //NOW STORE TO CURRENT COLUMN
    lda XTEMP
    asl  //MULT BY 2
    sta VERA_LO
    lda CHRTEMP
    sta VERA_RW
    lda COLTEMP
    sta VERA_RW
    //NOW MOVE TO RIGHT
    inc XTEMP
    lda SCR_SIZE_X
    sec
    sbc #1
    cmp XTEMP
    bne SHLF02
    //NOW PLACE TEMP CHAR AT RIGHT OF SCREEN
    lda SCR_SIZE_X
    sec
    sbc #1
    asl  //MULT BY 2
    sta VERA_LO
    lda SHIFT_TEMP1
    sta VERA_RW
    lda SHIFT_TEMP2
    sta VERA_RW
    rts

SHIFT_LINE_UP:
    lda #0
    sta YTEMP
    lda #%00010000 //INCREMENT SET TO 1
    sta VERA_INC
    //FIRST GRAB TOP CHARACTER+COLOR FOR STORAGE
    lda #0
    sta VERA_HI
    lda XLOC
    asl  //MULT BY 2
    sta VERA_LO
    lda VERA_RW
    sta SHIFT_TEMP1
    lda VERA_RW
    sta SHIFT_TEMP2
SHUP02: 
    //NEXT GET BYTE FROM ROW BELOW
    lda YTEMP
    clc
    adc #1
    sta VERA_HI
    lda XLOC
    asl  //MULT BY 2
    sta VERA_LO
    lda VERA_RW
    sta CHRTEMP
    lda VERA_RW
    sta COLTEMP
    //NOW STORE TO CURRENT ROW
    lda YTEMP
    sta VERA_HI
    lda XLOC
    asl  //MULT BY 2
    sta VERA_LO
    lda CHRTEMP
    sta VERA_RW
    lda COLTEMP
    sta VERA_RW
    //NOW MOVE DOWN
    inc YTEMP
    lda SCR_SIZE_Y
    sec
    sbc #1
    cmp YTEMP
    bne SHUP02
    //NOW PLACE TEMP CHAR AT BOTTOM OF SCREEN
    lda SCR_SIZE_Y
    sec
    sbc #1
    sta VERA_HI 
    lda XLOC
    asl  //MULT BY 2
    sta VERA_LO
    lda SHIFT_TEMP1
    sta VERA_RW
    lda SHIFT_TEMP2
    sta VERA_RW
    rts

SHIFT_LINE_DOWN:
    lda SCR_SIZE_Y
    sec
    sbc #1
    sta YTEMP
    lda #%00010000 //INCREMENT SET TO 1
    sta VERA_INC
    //FIRST GRAB BOTTOM CHARACTER+COLOR FOR STORAGE
    lda SCR_SIZE_Y
    sec
    sbc #1
    sta VERA_HI
    lda XLOC
    asl  //MULT BY 2
    sta VERA_LO
    lda VERA_RW
    sta SHIFT_TEMP1
    lda VERA_RW
    sta SHIFT_TEMP2
SHDN02: 
    //NEXT GET BYTE FROM ROW ABOVE
    lda YTEMP
    sec
    sbc #1
    sta VERA_HI
    lda XLOC
    asl  //MULT BY 2
    sta VERA_LO
    lda VERA_RW
    sta CHRTEMP
    lda VERA_RW
    sta COLTEMP
    //NOW STORE TO CURRENT ROW
    lda YTEMP
    sta VERA_HI
    lda XLOC
    asl  //MULT BY 2
    sta VERA_LO
    lda CHRTEMP
    sta VERA_RW
    lda COLTEMP
    sta VERA_RW
    //NOW MOVE UP
    dec YTEMP
    lda YTEMP
    cmp 0
    bne SHDN02
    //NOW PLACE TEMP CHAR AT TOP OF SCREEN
    lda #0
    sta VERA_HI 
    lda XLOC
    asl  //MULT BY 2
    sta VERA_LO
    lda SHIFT_TEMP1
    sta VERA_RW
    lda SHIFT_TEMP2
    sta VERA_RW
    rts

PASTE_COLOR_ONLY:
    lda SELCOL
    sta CRSR_OLD_COL
    jsr MAIN_CURSOR_UNPLOT
    jsr MAIN_CURSOR_PLOT
    rts

KEYS_SET_COLOR:
    and #%00001111
    tax
    lda SELCOL
    and #%11110000
    sta SELCOL
    txa
    ora SELCOL
    sta SELCOL
    rts

MAIN_KEY_UP:
    jsr MAIN_CURSOR_UNPLOT
    lda YLOC
    cmp #0
    beq MKU1
    dec YLOC
MKU1:
    jsr MAIN_CURSOR_PLOT
    rts

MAIN_KEY_DOWN:
    jsr MAIN_CURSOR_UNPLOT
    lda YLOC
    clc
    adc #01
    cmp SCR_SIZE_Y
    beq MKD1
    inc YLOC
MKD1:
    jsr MAIN_CURSOR_PLOT
    rts

MAIN_KEY_LEFT:
    jsr MAIN_CURSOR_UNPLOT
    lda XLOC
    cmp #0
    beq MKU1
    dec XLOC
MKL1:
    jsr MAIN_CURSOR_PLOT
    rts

MAIN_KEY_RIGHT:
    jsr MAIN_CURSOR_UNPLOT
    lda XLOC
    clc
    adc #01
    cmp SCR_SIZE_X
    beq MKR1
    inc XLOC
MKR1:
    jsr MAIN_CURSOR_PLOT
    rts

//currently the cursor plot just inverts the color, but
//I plan to make it more intersting later.

MAIN_CURSOR_PLOT:
    lda #00
    sta VERA_INC //INCREMENT SET TO ZERO
    lda YLOC
    sta VERA_HI
    lda XLOC
    asl  //MULT BY 2
    clc
    adc #01
    sta VERA_LO
    lda VERA_RW //GET COLOR
    sta CRSR_OLD_COL
    sta CHRTEMP
    asl   //INVERT COLORS
    asl
    asl
    asl
    lsr CHRTEMP
    lsr CHRTEMP
    lsr CHRTEMP
    lsr CHRTEMP
    ora CHRTEMP
    sta VERA_RW
    rts

MAIN_CURSOR_UNPLOT:
    lda #00
    sta VERA_INC //INCREMENT SET TO ZERO
    lda YLOC
    sta VERA_HI
    lda XLOC
    asl  //MULT BY 2
    clc
    adc #01
    sta VERA_LO
    lda CRSR_OLD_COL
    sta VERA_RW
    rts

CHARACTER_SELECT_SCREEN:
    jsr MAIN_CURSOR_UNPLOT
    jsr COPY_SCREEN_TO_BUFFER
    jsr SET40
    
//This routine is a bit unique because I had to design the
//character pick screen from the C64 version of PetDraw which
//stores the data in a very different way.  So this routine
//converts it while simultaneously displays it on screen. 
    
CSS01:
    lda #%00010000 //INCREMENT BY 1
    sta VERA_INC
    ldy #00
    sty VERA_HI
    sty VERA_LO  //SET STARTING POSITION
    lda #<CHAR_SEL_SCREEN_TEXT+2
    sta $FB
    lda #>CHAR_SEL_SCREEN_TEXT+2
    sta $FC
    lda #<CHAR_SEL_SCREEN_COLOR+2
    sta $FD
    lda #>CHAR_SEL_SCREEN_COLOR+2
    sta $FE
    jsr SCREENCOPY
    jsr CHAR_SEL_CURSOR_PLOT

CHAR_SEL_KEYWAIT:
    jsr $FFE4
    cmp #$00
    beq CHAR_SEL_KEYWAIT
    cmp #$91 //CURSOR UP
    bne CSK01
    jmp CHAR_SEL_KEY_UP
CSK01:
    cmp #$11 //CURSOR DOWN
    bne CSK02
    jmp CHAR_SEL_KEY_DOWN
CSK02: 
    cmp #$9D //CURSOR LEFT
    bne CSK03
    jmp CHAR_SEL_KEY_LEFT
CSK03:
    cmp #$1D //CURSOR RIGHT
    bne CSK04
    jmp CHAR_SEL_KEY_RIGHT
CSK04:
    cmp #$0D //RETURN
    bne CSK05
    jmp CHAR_SEL_FINISHED
CSK05:
    cmp #$31 //1-KEY
    bne CSK06
    jsr SWBANK1
    jsr CHAR_SEL_CURSOR_PLOT
    jmp CHAR_SEL_KEYWAIT
CSK06:
    cmp #$32 //2-KEY
    bne CSK07
    jsr SWBANK2
    jsr CHAR_SEL_CURSOR_PLOT
    jmp CHAR_SEL_KEYWAIT
CSK07:
    jmp CHAR_SEL_KEYWAIT

CHAR_SEL_KEY_UP:
    jsr CHAR_SEL_CURSOR_UNPLOT
    lda CHAR_SEL_Y
    cmp CHAR_SEL_MIN_Y
    beq CSKU1
    dec CHAR_SEL_Y
CSKU1:
    jsr CHAR_SEL_CURSOR_PLOT 
    jmp CHAR_SEL_KEYWAIT

CHAR_SEL_KEY_DOWN:
    jsr CHAR_SEL_CURSOR_UNPLOT
    lda CHAR_SEL_Y
    cmp CHAR_SEL_MAX_Y
    beq CSKD1
    inc CHAR_SEL_Y
CSKD1:
    jsr CHAR_SEL_CURSOR_PLOT 
    jmp CHAR_SEL_KEYWAIT

CHAR_SEL_KEY_LEFT:
    jsr CHAR_SEL_CURSOR_UNPLOT
    lda CHAR_SEL_X
    cmp CHAR_SEL_MIN_X
    beq CSKL1
    dec CHAR_SEL_X
CSKL1:
    jsr CHAR_SEL_CURSOR_PLOT 
    jmp CHAR_SEL_KEYWAIT

CHAR_SEL_KEY_RIGHT:
    jsr CHAR_SEL_CURSOR_UNPLOT
    lda CHAR_SEL_X
    cmp CHAR_SEL_MAX_X
    beq CSKR1
    inc CHAR_SEL_X
CSKR1:
    jsr CHAR_SEL_CURSOR_PLOT 
    jmp CHAR_SEL_KEYWAIT

CHAR_SEL_CURSOR_PLOT:
    lda CHAR_SEL_Y
    sta VERA_HI
    lda CHAR_SEL_X
    asl  //MULT BY 2
    clc
    adc #01  //ADD ONE FOR COLORSPACE
    sta VERA_LO
    lda CHAR_SEL_COLOR
    sta VERA_RW
    rts

CHAR_SEL_CURSOR_UNPLOT:
    lda CHAR_SEL_Y
    sta VERA_HI
    lda CHAR_SEL_X
    asl  //MULT BY 2
    clc
    adc #01  //ADD ONE FOR COLORSPACE
    sta VERA_LO
    lda CHAR_SEL_NORM
    sta VERA_RW
    rts

SWBANK1:
    jsr CHAR_SEL_CURSOR_UNPLOT
    lda #07
    sta CHAR_SEL_MIN_Y
    lda #22
    sta CHAR_SEL_MAX_Y
    lda #0
    sta CHAR_SEL_MIN_X
    lda #19
    sta CHAR_SEL_MAX_X
    lda #97
    sta CHAR_SEL_COLOR
    lda #12
    sta CHAR_SEL_NORM
    lda #10
    sta CHAR_SEL_X
    lda #14
    sta CHAR_SEL_Y
    rts
SWBANK2:
    jsr CHAR_SEL_CURSOR_UNPLOT
    lda #09 
    sta CHAR_SEL_MIN_Y
    lda #23
    sta CHAR_SEL_MAX_Y
    lda #23
    sta CHAR_SEL_MIN_X
    lda #38
    sta CHAR_SEL_MAX_X
    lda #01
    sta CHAR_SEL_COLOR
    lda #06
    sta CHAR_SEL_NORM
    lda #30
    sta CHAR_SEL_X
    lda #15
    sta CHAR_SEL_Y
    rts

CHAR_SEL_FINISHED:
    lda CHAR_SEL_Y
    sta VERA_HI
    lda CHAR_SEL_X
    asl  //MULT BY 2
    sta VERA_LO
    lda VERA_RW
    sta PCHAR
    jsr SET_MODE
    jsr COPY_BUFFER_TO_SCREEN
    jsr MAIN_CURSOR_PLOT
    rts
    
// The following routine plots a character on the screen
// based on what is stored in XLOC, YLOC, PCHAR, and PCOL

PLOTCHAR:
    lda #%00010000 //INCREMENT BY 1
    sta VERA_INC
    lda YLOC
    sta VERA_HI
    lda XLOC
    asl  //MULTIPLY BY 2
    sta VERA_LO
    lda PCHAR
    sta VERA_RW //WRITE CHAR
    lda PCOL
    sta VERA_RW //WRITE COLOR
    rts 
    
// The following routine does the exact opposite
// in that it gets the character and color from 
// the screen and places them in PCAR and PCOL

GETCHAR:
    lda #%00010000 //INCREMENT BY 1
    sta VERA_INC
    lda YLOC
    sta VERA_HI
    lda XLOC
    asl  //MULTIPLY BY 2
    sta VERA_LO
    lda VERA_RW
    sta PCHAR
    lda VERA_RW
    sta PCOL
    rts
    
POSTMOVE:
    jsr GETCHAR
    lda PCHAR
    sta CHRTEMP
    lda PCOL
    sta COLTEMP
    rts

PREMOVE:
    lda CHRTEMP
    sta PCHAR
    lda COLTEMP
    sta PCOL
    jsr PLOTCHAR
    rts

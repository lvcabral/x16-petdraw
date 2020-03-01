//Petdraw (Commander X16 version)
//by David Murray 2019
//dfwgreencars@gmail.com
//
//Converted to KickAssembler
//by Marcelo Lv Cabral 2020
//https://github.com/lvcabral

SETUP_MENU:
    jsr MAIN_CURSOR_UNPLOT
    lda #160
    sta COPY_WIDTH
    lda #30
    sta COPY_HEIGHT
    jsr COPY_SCREEN_TO_BUFFER
    lda #1 //WHITE
    sta $0286  //CURRENT COLOR
    jsr CLEAR_SCREEN
    ldy #0
SM01:
    lda SETUP_TEXT,Y
    jsr $FFD2 //CHROUT
    iny
    cpy #73
    bne SM01
    jsr CALC123
    jsr HILITE_MODE
SM10:
    jsr $FFE4
    cmp #$00
    beq SM10
    cmp #$91 //CURSOR UP
    bne SM15
    lda TEXT_MODE
    cmp #00
    beq SM10
    jsr UNHILITE_MODE
    dec TEXT_MODE
    jsr HILITE_MODE
    jsr SET_MODE
    jmp SM10
SM15:
    cmp #$11 //CURSOR DOWN
    bne SM20
    lda TEXT_MODE
    cmp #5
    beq SM10
    jsr UNHILITE_MODE
    inc TEXT_MODE
    jsr HILITE_MODE
    jsr SET_MODE 
    jmp SM10
SM20:
    cmp #13 //RETURN
    bne SM10
    lda #0
    sta YLOC //Need to reposition cursor in case
    sta XLOC //moving to small screen size
    jsr COPY_BUFFER_TO_SCREEN
    lda SCR_SIZE_X
    asl  //MULT BY 2
    sta COPY_WIDTH
    lda SCR_SIZE_Y
    sta COPY_HEIGHT
    jsr MAIN_CURSOR_PLOT
    rts

SET_MODE:
    lda #$0F //BANK 4
    sta VERA_INC
    lda #00
    sta VERA_HI
    lda #$41 //H-SCALE
    sta VERA_LO
    ldy TEXT_MODE
    lda MODEX,Y
    sta VERA_RW 
    lda #$42 //V-SCALE
    sta VERA_LO
    ldy TEXT_MODE
    lda MODEY,Y
    sta VERA_RW 
    lda #0 //BANK 0
    sta VERA_INC
    lda SIZEX,Y
    sta SCR_SIZE_X
    lda SIZEY,Y
    sta SCR_SIZE_Y
    rts

MODEX: .byte 128,128,64,64,32,32
MODEY: .byte 128,64,128,64,64,32
SIZEX: .byte 80,80,40,40,20,20
SIZEY: .byte 60,30,60,30,30,15

//FSIZE_H .byte $25,$12,$12,$09,$04,$02
//FSIZE_L .byte $80,$C0,$C0,$60,$B0,$58

FSIZE_L: .byte <SCREEN_BUFFER+9600
        .byte <SCREEN_BUFFER+4800
        .byte <SCREEN_BUFFER+4800
        .byte <SCREEN_BUFFER+2400
        .byte <SCREEN_BUFFER+1200
        .byte <SCREEN_BUFFER+600
FSIZE_H: .byte >SCREEN_BUFFER+9600
        .byte >SCREEN_BUFFER+4800
        .byte >SCREEN_BUFFER+4800
        .byte >SCREEN_BUFFER+2400
        .byte >SCREEN_BUFFER+1200
        .byte >SCREEN_BUFFER+600

SET40:
    lda #4 //BANK 4
    sta VERA_INC
    lda #00
    sta VERA_HI
    lda #$41 //H-SCALE
    sta VERA_LO
    lda #64
    sta VERA_RW 
    lda #$42 //V-SCALE
    sta VERA_LO
    lda #64
    sta VERA_RW 
    lda #0 //BANK 0
    sta VERA_INC
    rts

CALC123:
    lda #%00100000 //INCREMENT 2
    sta VERA_INC
    lda #1
    sta VERA_LO
    lda TEXT_MODE
    clc
    adc #2
    sta VERA_HI
    rts

HILITE_MODE:
    jsr CALC123
    lda #97 //WHITE TEXT ON BLUE
    sta VERA_RW
    sta VERA_RW
    sta VERA_RW
    sta VERA_RW
    sta VERA_RW
    sta VERA_RW
    sta VERA_RW
    rts

UNHILITE_MODE:
    jsr CALC123
    lda #14 //L.BLUE TEXT ON BLACK
    sta VERA_RW
    sta VERA_RW
    sta VERA_RW
    sta VERA_RW
    sta VERA_RW
    sta VERA_RW
    sta VERA_RW
    rts

SETUP_TEXT:
    .byte 19 //HOME
    .text "SCREEN SIZE"
    .byte 13
    .byte  163,163,163,163,163,163,163,163,163,163,163 //UNDERLINE
    .byte 13,154 //return and then light blue
    .text "80 X 60"
    .byte 13
    .text "80 X 30"
    .byte 13
    .text "40 X 60"
    .byte 13
    .text "40 X 30"
    .byte 13
    .text "20 X 30"
    .byte 13
    .text "20 X 15"

TYPE_MODE:
    jsr $FFE4
    cmp #$00
    beq TYPE_MODE
    cmp #$91 //CURSOR UP
    bne TM01
    jsr MAIN_KEY_UP
    jmp TYPE_MODE
TM01:
    cmp #$11 //CURSOR DOWN
    bne TM02
    jsr MAIN_KEY_DOWN
    jmp TYPE_MODE
TM02: 
    cmp #$9D //CURSOR LEFT
    bne TM03
    jsr MAIN_KEY_LEFT
    jmp TYPE_MODE
TM03:
    cmp #$1D //CURSOR RIGHT
    bne TM04
    jsr MAIN_KEY_RIGHT
    jmp TYPE_MODE
TM04:
    cmp #$0D //RETURN
    bne TM05
    jsr TYPE_RETURN
    jmp TYPE_MODE
TM05:
    cmp #138 //F4-KEY
    bne TM07
    jsr COLOR_SCREEN
    jmp TYPE_MODE
TM07:
    cmp #137 //F2-KEY (PIXEL DRAW MODE)
    bne TM08
    jmp PIXEL_DRAW_SCREEN
TM08:
    cmp #$85 //F1-KEY
    bne TM09
    jmp MAIN_DRAW_SCREEN
TM09:
    cmp #20 //BACKSPACE
    bne TM20
    jsr TYPE_BACKSPACE
    jmp TYPE_MODE
TM20:
    jsr PETSCII_TO_SCREENCODE
    sta PCHAR
    jsr MAIN_CURSOR_UNPLOT
    lda SELCOL
    sta PCOL
    jsr PLOTCHAR
    lda SCR_SIZE_X
    sec
    sbc #1
    cmp XLOC
    beq TM21  
    inc XLOC
TM21:
    jsr MAIN_CURSOR_PLOT
    jmp TYPE_MODE

TYPE_RETURN:
    jsr MAIN_CURSOR_UNPLOT
    lda #0
    sta XLOC
    lda SCR_SIZE_Y
    sec
    sbc #1
    cmp YLOC
    beq TR01
    inc YLOC
TR01:
    jsr MAIN_CURSOR_PLOT
    rts

TYPE_BACKSPACE:
    jsr MAIN_CURSOR_UNPLOT
    lda XLOC
    cmp #0
    beq TB01
    dec XLOC
    lda #32 //SPACE
    sta PCHAR
    jsr PLOTCHAR
TB01:
    jsr MAIN_CURSOR_PLOT
    rts

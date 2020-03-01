//Petdraw (Commander X16 version)
//by David Murray 2019
//dfwgreencars@gmail.com
//
//Converted to KickAssembler
//by Marcelo Lv Cabral 2020
//https://github.com/lvcabral

//The following routine clears the entire 80x60 screen
//and sets the color attributes to white on black.

CLEAR_SCREEN:
    lda #%00010000 //SET INCREMENT TO 1
    sta VERA_INC
    lda #00   //SET STARTING POINT TO ZERO
    ldx #0
    ldy #0
CLSC01:
    sty VERA_HI
    lda #00
    sta VERA_LO
CLSC02:
    lda #32   //SPACE
    sta VERA_RW
    lda #01   //WHITE ON BLACK
    sta VERA_RW
    inx
    cpx #80
    bne CLSC02
    ldx #0
    iny
    cpy #60
    bne CLSC01
    rts

COPY_SCREEN_TO_BUFFER:
    lda #%00010000 //INCREMENT SET TO ONE
    sta VERA_INC
    ldx #00
    ldy #00
    lda #<SCREEN_BUFFER
    sta $FB
    lda #>SCREEN_BUFFER
    sta $FC
CSTB01:
    lda #00
    sta VERA_LO
    stx VERA_HI
CSTB02:
    lda VERA_RW
    sta ($FB),Y
    iny
    cpy COPY_WIDTH
    bne CSTB02
    ldy #00
    lda $FB
    clc
    adc COPY_WIDTH
    sta $FB
    lda $FC
    adc #00
    sta $FC
    inx
    cpx COPY_HEIGHT
    bne CSTB01
    rts

COPY_BUFFER_TO_SCREEN:
    lda #%00010000 //INCREMENT SET TO ONE
    sta VERA_INC
    ldx #00
    ldy #00
    lda #<SCREEN_BUFFER
    sta $FB
    lda #>SCREEN_BUFFER
    sta $FC
CBTS01:
    lda #0
    sta VERA_LO
    stx VERA_HI
CBTS02:
    lda ($FB),Y
    sta VERA_RW
    iny
    cpy COPY_WIDTH
    bne CBTS02
    ldy #$00
    lda $FB
    clc
    adc COPY_WIDTH
    sta $FB
    lda $FC
    adc #00
    sta $FC
    inx
    cpx COPY_HEIGHT
    bne CBTS01
    rts

HELP_SCREEN:
    jsr MAIN_CURSOR_UNPLOT
    jsr COPY_SCREEN_TO_BUFFER
    jsr SET40
    
//This routine is a bit unique because I had to design the
//character pick screen from the C64 version of PetDraw which
//stores the data in a very different way.  So this routine
//converts it while simultaneously displays it on screen. 
    
HS01:
    lda #%00010000 //INCREMENT BY 1
    sta VERA_INC
    ldy #00
    sty VERA_HI
    sty VERA_LO  //SET STARTING POSITION
    lda #<HELP_SCREEN_TEXT
    sta $FB
    lda #>HELP_SCREEN_TEXT
    sta $FC
    lda #<HELP_SCREEN_COLOR
    sta $FD
    lda #>HELP_SCREEN_COLOR
    sta $FE
    jsr SCREENCOPY
HS05:
    jsr $FFE4
    cmp #$00
    beq HS05
    jsr SET_MODE
    jsr COPY_BUFFER_TO_SCREEN
    jsr MAIN_CURSOR_PLOT
    rts

SCREENCOPY:
    ldx #$00
    ldy #$00
HS04:
    lda ($FB),Y
    sta VERA_RW
    lda ($FD),Y
    and #%00001111 //REMOVE UPPER 4 BITS OF COLOR DATA
    sta VERA_RW
    iny
    cpy #40
    bne HS04
    ldy #00
    clc
    lda $FB  //INCREASE ORIGIN TEXT BY 40 CHARACTERS
    adc #40
    sta $FB
    lda $FC
    adc #$00
    sta $FC
    clc   //INCREASE ORIGIN COLOR BY 40 BYTES
    lda $FD
    adc #40
    sta $FD
    lda $FE
    adc #$00
    sta $FE
    inx
    stx VERA_HI //SET NEW LINE ON VIDEO RAM
    lda #$00
    sta VERA_LO
    cpx #25
    bne HS04
    rts

COLOR_SCREEN:
    jsr COPY_SCREEN_TO_BUFFER
    jsr SET40
CS01:
    lda SELCOL //GET CURRENT COLOR
    and #%00001111 //Strip top bits to get FG color
    sta COLSEL_FG
    lda SELCOL //GET CURRENT COLOR
    and #%11110000 //Strip lower bits to get BG color
    lsr
    lsr
    lsr
    lsr
    sta COLSEL_BG
    
//This routine is a bit unique because I had to design the
//character pick screen from the C64 version of PetDraw which
//stores the data in a very different way.  So this routine
//converts it while simultaneously displays it on screen. 
    
CS02:
    lda #%00010000 //INCREMENT BY 1
    sta VERA_INC
    ldy #00
    sty VERA_HI
    sty VERA_LO  //SET STARTING POSITION
    lda #<COLOR_SCREEN_TEXT+2
    sta $FB
    lda #>COLOR_SCREEN_TEXT+2
    sta $FC
    lda #<COLOR_SCREEN_COLOR+2
    sta $FD
    lda #>COLOR_SCREEN_COLOR+2
    sta $FE
    jsr SCREENCOPY
    jsr COLBANKHILITE
    jsr FGCOLORHILITE
    jsr BGCOLORHILITE
    jsr SAMPLE_COLOR_DISPLAY

CS05:
    jsr $FFE4
    cmp #$00
    beq CS05
    cmp #$91 //CURSOR UP
    bne CS06
    jmp COLOR_UP
CS06:
    cmp #$11 //CURSOR DOWN
    bne CS07
    jmp COLOR_DOWN
CS07: 
    cmp #$9D //CURSOR LEFT
    bne CS08
    jmp COLOR_LEFT
CS08:
    cmp #$1D //CURSOR RIGHT
    bne CS09
    jmp COLOR_RIGHT
CS09:
    cmp #$0D //RETURN
    bne CS10
    jsr COLOR_CONVERT
    jsr SET_MODE
    jsr COPY_BUFFER_TO_SCREEN
    rts
CS10:
    jmp CS05

COLOR_CONVERT:
    lda COLSEL_BG
    asl
    asl
    asl
    asl
    ora COLSEL_FG
    sta SELCOL
    sta PCOL
    rts

COLOR_UP:
    lda COLSEL_BANK
    cmp #00
    bne CU02
    lda COLSEL_FG
    cmp #0
    beq CU01
    jsr FGCOLORHILITE //UNHILITE SELECTION
    dec COLSEL_FG
    jsr FGCOLORHILITE //RE-HILITE SELECTION
    jsr SAMPLE_COLOR_DISPLAY
    jmp CS05
CU01:
    jmp CS05
CU02:
    lda COLSEL_BG
    cmp #0
    beq CU01
    jsr BGCOLORHILITE //UNHILITE SELECTION
    dec COLSEL_BG
    jsr BGCOLORHILITE //RE-HILITE SELECTION
    jsr SAMPLE_COLOR_DISPLAY
    jmp CS05

COLOR_DOWN:
    lda COLSEL_BANK
    cmp #00
    bne CD02
    lda COLSEL_FG
    cmp #15
    beq CD01
    jsr FGCOLORHILITE //UNHILITE SELECTION
    inc COLSEL_FG
    jsr FGCOLORHILITE //RE-HILITE SELECTION
    jsr SAMPLE_COLOR_DISPLAY
    jmp CS05
CD01:
    jmp CS05
CD02:
    lda COLSEL_BG
    cmp #15
    beq CD01
    jsr BGCOLORHILITE //UNHILITE SELECTION
    inc COLSEL_BG
    jsr BGCOLORHILITE //RE-HILITE SELECTION
    jsr SAMPLE_COLOR_DISPLAY
    jmp CS05

COLOR_LEFT:
    jsr COLBANKHILITE //UNHILITE CORRENT SELECTION
    lda #0
    sta COLSEL_BANK  //SET LEFT SIDE
    jsr COLBANKHILITE //RE-HILITE CORRENT SELECTION  
    jmp CS05
COLOR_RIGHT:
    jsr COLBANKHILITE //UNHILITE CORRENT SELECTION
    lda #1
    sta COLSEL_BANK  //SET LEFT SIDE
    jsr COLBANKHILITE //RE-HILITE CORRENT SELECTION  
    jmp CS05

//This routine highlights the currently selected FG color
//on the color picker screen 

FGCOLORHILITE:
    lda #%00000000 //INCREMENT DISABLE
    sta VERA_INC
    lda COLSEL_FG
    clc
    adc #08
    sta VERA_HI
    lda #09
    sta VERA_LO
    jsr TEXTINVERT
    rts

//This routine highlights the currently selected BG color
//on the color picker screen 

BGCOLORHILITE:
    lda #%00000000 //INCREMENT DISABLE
    sta VERA_INC
    lda COLSEL_BG
    clc
    adc #08
    sta VERA_HI
    lda #53
    sta VERA_LO
    jsr TEXTINVERT
    rts

//This routine highlights the currently selected bank on the
//color picker screen (foreground or background) 

COLBANKHILITE:
    lda #%00000000 //INCREMENT DISABLE
    sta VERA_INC
    lda #6
    sta VERA_HI
    lda COLSEL_BANK
    cmp #0
    bne CBHL1
    lda #9  //"FOREGROUND" LOCATED AT X=4 Y=6
    sta VERA_LO
    jmp CBHL2
CBHL1:
    lda #53  //"FOREGROUND" LOCATED AT X=28 Y=6
    sta VERA_LO
CBHL2:
    jsr TEXTINVERT
    rts

//The following routine inverts 10 characters, but it needs
//to have the STARTing position set for VERA_LO and VERA_HI
//first, and also needs VERA_INC set to 0.

TEXTINVERT: 
    ldx #0
THL01:
    lda VERA_RW //GET COLOR
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
    inc VERA_LO
    inc VERA_LO
    inx
    cpx #10
    bne THL01
    rts

//The following routine sets the colors for the
//sample figure in the middle of the color select
//screen.

SAMPLE_COLOR_DISPLAY:
    jsr COLOR_CONVERT
    lda #%00000000 //NO INCREMENT
    sta VERA_INC //START POSITION X=16 Y=12
    ldy #12
SCD01:
    lda #33
    sta VERA_LO
    sty VERA_HI
    lda SELCOL
    ldx #00
SCD02:
    sta VERA_RW
    inc VERA_LO
    inc VERA_LO
    inx
    cpx #8
    bne SCD02
    iny
    cpy #20
    bne SCD01
    rts

LOAD_SAVE_MENU:
    jsr COPY_SCREEN_TO_BUFFER
    jsr SET40
    lda #1 //WHITE
    sta $0286  //CURRENT COLOR
    jsr CLEAR_SCREEN
    ldy #0
LSM01:
    lda LOAD_SAVE_TEXT,Y
    jsr $FFD2 //CHROUT
    iny
    cpy #72
    bne LSM01
    jsr DISPLAY_FILENAME
    jsr NAME_TYPE
    jmp LOAD_SAVE_SELECT

LOAD_SAVE_TEXT:
    .byte 19 //HOME
    .text "FILE NAME:"
    .byte 13,32,32,32,32,32,32,32,32,32,32 
    .byte 163,163,163,163,163,163,163,163 //UNDERLINE
    .byte 163,163,163,163,163,163,163,163 //UNDERLINE
    .byte 13
    .text "DEVICE# 01"
    .byte 13,13
    .text " SAVE   LOAD   CANCEL"

LOAD_SAVE_SELECT:
    lda #00
    sta XTEMP
    jsr DISPLAY_LS_SELECT
LSS1:
    jsr $FFE4
    cmp #$00
    beq LSS1
    cmp #$9D //CURSOR LEFT
    bne LSS5
    lda XTEMP
    cmp #00
    beq LSS1
    dec XTEMP
    jsr DISPLAY_LS_SELECT
    jmp LSS1
LSS5:
    cmp #$1D //CURSOR RIGHT
    bne LSS8
    lda XTEMP
    cmp #02
    beq LSS1
    inc XTEMP
    jsr DISPLAY_LS_SELECT
    jmp LSS1
LSS8:
    cmp #13  //RETURN
    bne LSS10
    jmp SEL_FINISHED
LSS10:
    jmp LSS1

SEL_FINISHED:
    lda XTEMP
    cmp #0 //SAVE
    bne SF05
    jsr SAVE_ROUTINE
    jsr SET_MODE
    jsr COPY_BUFFER_TO_SCREEN
    rts
SF05:
    cmp #1 //LOAD
    bne SF08
    jsr LOAD_ROUTINE
    jsr SET_MODE
    jsr COPY_BUFFER_TO_SCREEN
    rts
SF08:
    cmp #2 //CANCEL
    bne SF10
    jsr SET_MODE
    jsr COPY_BUFFER_TO_SCREEN
    rts
SF10:
    jmp LSS1

DISPLAY_LS_SELECT:
    lda #%00100000 //INCREMENT BY 2
    sta VERA_INC
    lda #04 //5TH ROW FROM TOP
    sta VERA_HI
    lda #1 //LEFT MOST COLUMN COLOR ATTRIBUTE
    sta VERA_LO
    lda #06 //WHITE ON BLACK
    ldy #00
DLS01:
    sta VERA_RW
    iny
    cpy #22
    bne DLS01
    //HILIGHT SELECTED UNIT
    ldy XTEMP
    lda LSMENU,Y
    sta VERA_LO
    ldy #0
    lda #97// WHITE TEXT ON BLUE
DLS02:
    sta VERA_RW
    iny
    cpy #6
    bne DLS02
    rts
LSMENU: .byte 1,15,31

DISPLAY_FILENAME:
    lda #%00010000 //INCREMENT BY 1
    sta VERA_INC
    lda #00
    sta VERA_HI
    lda #20 //STARTING SCREEN LOCATION
    sta VERA_LO
    ldy #00
    lda NAME_LENGTH
    cmp #00 //If name is 0 length, skip to cursor
    beq FLOOP3
FLOOP1: 
    lda FILE_NAME,Y
    jsr PETSCII_TO_SCREENCODE
    sta VERA_RW
    lda #14 //LIGHT BLUE
    sta VERA_RW
    iny
    cpy NAME_LENGTH
    bne FLOOP1 
    //NOW ADD CURSOR
FLOOP3:
    lda #32
    sta VERA_RW
    lda #224 //INVERTED BLUE
    sta VERA_RW
FLOOP2:
    lda #32//SPACE
    sta VERA_RW
    lda #14 //BLUE
    sta VERA_RW
    iny
    cpy #17
    bne FLOOP2
    rts

NAME_TYPE:
    jsr $FFE4
    cmp #$00
    beq NAME_TYPE
    cmp #13 //RETURN
    bne NT01
    lda NAME_LENGTH
    cmp #00
    beq NAME_TYPE
    rts
NT01:
    cmp #20 //BACKSPACE
    bne NT02
    lda NAME_LENGTH
    cmp #0
    beq NAME_TYPE
    dec NAME_LENGTH
    jsr DISPLAY_FILENAME
    jmp NAME_TYPE 
NT02:
    cmp #47 //IS IT GREATER THAN CHR$(47)
    bcs NT03
    jmp NAME_TYPE
NT03:
    cmp #91 //IS IT GREATER THAN CHR$(91)
    bcc NT04
    jmp NAME_TYPE
NT04: 
    ldy NAME_LENGTH
    cpy #16
    bne NT05
    jmp NAME_TYPE 
NT05:
    sta FILE_NAME,Y
    iny
    sty NAME_LENGTH
    jsr DISPLAY_FILENAME
    jmp NAME_TYPE

PETSCII_TO_SCREENCODE:
    cmp #$ff
    bne l1
    lda #$5e
    rts
l1: pha
    lsr
    lsr 
    lsr
    lsr
    lsr
    tax
    pla
    clc
    adc table_p2s,x
    rts
table_p2s: .byte 128,0,192,224,64,192,128,128

SCREENCODE_TO_PETSCII:
    pha
    lsr
    lsr 
    lsr
    lsr
    lsr
    tax
    pla
    clc
    adc table_s2p,x
    rts

table_s2p: .byte 64,0,128,64,128,192,192,0

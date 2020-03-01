//Petdraw (Commander X16 version)
//by David Murray 2019
//dfwgreencars@gmail.com
//
//Converted to KickAssembler
//by Marcelo Lv Cabral 2020
//https://github.com/lvcabral

.const VERA_INC=$9F22
.const VERA_HI=$9F21
.const VERA_LO=$9F20
.const VERA_RW=$9F23

:BasicUpstart2(INIT1)

INIT1:
    jsr SWBANK2
    jsr SET_MODE

INIT2:
    jsr CLEAR_SCREEN
    lda #00 //SET INITIAL VALUES
    sta XLOC
    sta YLOC
    lda #01
    sta PCOL
    lda #40
    sta SCR_SIZE_X
    lda #30
    sta SCR_SIZE_Y
    jsr MAIN_CURSOR_PLOT
    jsr HELP_SCREEN
    
MAIN_DRAW_SCREEN:

MAIN_DRAW_KEYWAIT:
    jsr $FFE4
    cmp #$00
    beq MAIN_DRAW_KEYWAIT
    cmp #$91 //CURSOR UP
    bne MDK01
    jsr MAIN_KEY_UP
    jmp MAIN_DRAW_KEYWAIT
MDK01:
    cmp #$11 //CURSOR DOWN
    bne MDK02
    jsr MAIN_KEY_DOWN
    jmp MAIN_DRAW_KEYWAIT
MDK02: 
    cmp #$9D //CURSOR LEFT
    bne MDK03
    jsr MAIN_KEY_LEFT
    jmp MAIN_DRAW_KEYWAIT
MDK03:
    cmp #$1D //CURSOR RIGHT
    bne MDK04
    jsr MAIN_KEY_RIGHT
    jmp MAIN_DRAW_KEYWAIT
MDK04:
    cmp #$0D //RETURN
    bne MDK05
    jsr CHARACTER_SELECT_SCREEN
    jmp MAIN_DRAW_KEYWAIT
MDK05:
    cmp #32  //SPACE BAR
    bne MDK06
    jsr MAIN_CURSOR_UNPLOT
    lda SELCOL
    sta PCOL
    jsr PLOTCHAR
    jsr MAIN_CURSOR_PLOT
    jmp MAIN_DRAW_KEYWAIT
MDK06:
    cmp #$48 //H KEY
    bne MDK07
    jsr HELP_SCREEN
    jmp MAIN_DRAW_KEYWAIT
MDK07:
    cmp #137 //F2-KEY (PIXEL DRAW MODE)
    bne MDK08
    jmp PIXEL_DRAW_SCREEN
MDK08:
    cmp #$47 //G-key 
    bne MDK09
    jsr MAIN_CURSOR_UNPLOT
    jsr GETCHAR
    lda PCOL
    sta SELCOL
    jsr MAIN_CURSOR_PLOT
    jmp MAIN_DRAW_KEYWAIT 
MDK09:
    cmp #$1F //BLUE
    bne MDK10
    lda #06  //COLOR BLUE
    jsr KEYS_SET_COLOR
    jmp MAIN_DRAW_KEYWAIT
MDK10:
    cmp #$05 //WHITE
    bne MDK11
    lda #01  //COLOR WHITE
    jsr KEYS_SET_COLOR
    jmp MAIN_DRAW_KEYWAIT
MDK11:
    cmp #$1C //RED
    bne MDK12
    lda #02  //COLOR RED
    jsr KEYS_SET_COLOR
    jmp MAIN_DRAW_KEYWAIT
MDK12:
    cmp #138 //F4-KEY
    bne MDK13
    jsr MAIN_CURSOR_UNPLOT
    jsr COLOR_SCREEN
    jsr MAIN_CURSOR_PLOT
    jmp MAIN_DRAW_KEYWAIT
MDK13:
    cmp #134 //F3-KEY (TYPING MODE)
    bne MDK14
    jmp TYPE_MODE
MDK14:
    cmp #$14 //BACKSPACE
    bne MDK15 
    jsr MAIN_CURSOR_UNPLOT
    lda #32
    sta PCHAR
    jsr PLOTCHAR
    jsr MAIN_CURSOR_PLOT
    jmp MAIN_DRAW_KEYWAIT
MDK15:
    cmp #$90 //BLACK
    bne MDK16
    lda #00  //COLOR BLACK
    jsr KEYS_SET_COLOR
    jmp MAIN_DRAW_KEYWAIT
MDK16:
    cmp #$9F //CYAN
    bne MDK17
    lda #03  //COLOR CYAN
    jsr KEYS_SET_COLOR
    jmp MAIN_DRAW_KEYWAIT
MDK17:
    cmp #$9C //PURPLE
    bne MDK18
    lda #04  //COLOR PURPLE
    jsr KEYS_SET_COLOR
    jmp MAIN_DRAW_KEYWAIT
MDK18:
    cmp #$1E //GREEN
    bne MDK19
    lda #05  //COLOR GREEN
    jsr KEYS_SET_COLOR
    jmp MAIN_DRAW_KEYWAIT
MDK19:
    cmp #$9E //YELLOW
    bne MDK20
    lda #07  //COLOR YELLOW
    jsr KEYS_SET_COLOR
    jmp MAIN_DRAW_KEYWAIT
MDK20:
    cmp #$81 //ORANGE
    bne MDK21
    lda #08  //COLOR ORANGE
    jsr KEYS_SET_COLOR
    jmp MAIN_DRAW_KEYWAIT
MDK21:
    cmp #$95 //BROWN
    bne MDK22
    lda #09  //COLOR BROWN
    jsr KEYS_SET_COLOR
    jmp MAIN_DRAW_KEYWAIT
MDK22:
    cmp #$96 //LIGHT RED
    bne MDK23
    lda #10  //COLOR LIGHT RED
    jsr KEYS_SET_COLOR
    jmp MAIN_DRAW_KEYWAIT
MDK23:
    cmp #$97 //DARK GRAY
    bne MDK24
    lda #11  //COLOR DARK GRAY
    jsr KEYS_SET_COLOR
    jmp MAIN_DRAW_KEYWAIT
MDK24:
    cmp #$98 //GRAY
    bne MDK25
    lda #12  //COLOR GRAY
    jsr KEYS_SET_COLOR
    jmp MAIN_DRAW_KEYWAIT
MDK25:
    cmp #$99 //LIGHT GREEN
    bne MDK26
    lda #13  //COLOR LIGHT GREEN
    jsr KEYS_SET_COLOR
    jmp MAIN_DRAW_KEYWAIT
MDK26:
    cmp #$9A //LIGHT BLUE
    bne MDK27
    lda #14  //COLOR LIGHT BLUE
    jsr KEYS_SET_COLOR
    jmp MAIN_DRAW_KEYWAIT
MDK27:
    cmp #$9B //LIGHT GRAY
    bne MDK28
    lda #15  //COLOR LIGHT GRAY
    jsr KEYS_SET_COLOR
    jmp MAIN_DRAW_KEYWAIT
MDK28:
    cmp #135 //F5 KEY (SETUP)
    bne MDK29
    jsr SETUP_MENU
    jmp MAIN_DRAW_KEYWAIT
MDK29: 
    cmp #$43 //C-KEY
    bne MDK30
    jsr PASTE_COLOR_ONLY
    jmp MAIN_DRAW_KEYWAIT
MDK30:
    cmp #139 //F6 key (LOAD/SAVE)
    bne MDK31
    jsr MAIN_CURSOR_UNPLOT
    jsr LOAD_SAVE_MENU
    jsr MAIN_CURSOR_PLOT
    jmp MAIN_DRAW_KEYWAIT 
MDK31: 
    cmp #$93 //CLR-SCREEN
    bne MDK32
    jsr CLEAR_SCREEN
    jsr MAIN_CURSOR_PLOT
    jmp MAIN_DRAW_KEYWAIT
MDK32:
    cmp #$D5 //SHIFT-U
    bne MDK33
    jsr MAIN_CURSOR_UNPLOT
    jsr SHIFT_LINE_UP
    jsr MAIN_CURSOR_PLOT
    jmp MAIN_DRAW_KEYWAIT
MDK33: 
    cmp #$C4 //SHIFT-D
    bne MDK34
    jsr MAIN_CURSOR_UNPLOT
    jsr SHIFT_LINE_DOWN
    jsr MAIN_CURSOR_PLOT
    jmp MAIN_DRAW_KEYWAIT
MDK34:
    cmp #$CC //SHIFT-L
    bne MDK35
    jsr MAIN_CURSOR_UNPLOT
    jsr SHIFT_LINE_LEFT
    jsr MAIN_CURSOR_PLOT
    jmp MAIN_DRAW_KEYWAIT
MDK35:
    cmp #$D2 //SHIFT-R
    bne MDK36
    jsr MAIN_CURSOR_UNPLOT
    jsr SHIFT_LINE_RIGHT
    jsr MAIN_CURSOR_PLOT
    jmp MAIN_DRAW_KEYWAIT
MDK36:
    jmp MAIN_DRAW_KEYWAIT

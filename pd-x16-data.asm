//Petdraw (Commander X16 version)
//by David Murray 2019
//dfwgreencars@gmail.com
//
//Converted to KickAssembler
//by Marcelo Lv Cabral 2020
//https://github.com/lvcabral

XLOC: .byte $00 //X Coordinate (0-39)
YLOC: .byte $00 //Y Coordinate (0-24)
PCHAR: .byte $00 //Character (0-255)
PCOL: .byte $00 //Color (0-15)
SELCHAR: .byte $00 //SELECTED CHAR
SELCOL: .byte $01 //SELECTED COLOR
XTEMP: .byte $00
YTEMP: .byte $00
CHRTEMP: .byte $20
COLTEMP: .byte $01
PXCRST: .byte $00 //PIXEL CURSOR staTE (0 OR 1)
CRXTIMER: .byte $00
CRXTIM2: .byte $00
SCR_SIZE_X: .byte 40 // screen size X (20, 40, or 80)
SCR_SIZE_Y: .byte 30 // screen size Y (15, 30, or 60)
CHAR_SEL_X: .byte $00 // location of character select cursor
CHAR_SEL_Y: .byte $00 //
CHAR_SEL_MIN_X: .byte 23  //These are used to determine the window
CHAR_SEL_MAX_X: .byte 38  //or "bank" that the character select screen 
CHAR_SEL_MIN_Y: .byte 09  //is currently confined to.
CHAR_SEL_MAX_Y: .byte 23  //
CHAR_SEL_COLOR: .byte $01  //Color of char select cursor
CHAR_SEL_NORM: .byte $06  //normal color of char select screen
CRSR_OLD_COL: .byte $00  //Color before cursor was plotted
COLSEL_FG:  .byte $00  //Foreground color selection
COLSEL_BG:  .byte $00  //background color selection
COLSEL_BANK:  .byte $00  //0=Left 1=right selection
NAME_LENGTH:  .byte 0  //Length of filename
FILE_NAME:  .text "                "
DEVICE_NUMBER: .byte $08  //DISK DRIVE DEVICE
TEXT_MODE:  .byte 03  //DEFAULT 3=40X30
SHIFT_TEMP1:  .byte 00
SHIFT_TEMP2:  .byte 00
COPY_WIDTH:  .byte 80  //Width of screen (IN BYTES) for copy purposes
COPY_HEIGHT:  .byte 30  //height of copy process
//The following data is for representing each of the
//PETSCII block characters as an 4-bit binary number
//arranged as following:
// 33332222
// 33332222
// 33332222
// 33332222
// 11110000
// 11110000
// 11110000
// 11110000

PIXELMAP:
    .byte $20 
    .byte $6C 
    .byte $7B 
    .byte $62
    .byte $7C
    .byte $E1
    .byte $FF
    .byte $FE
    .byte $7E
    .byte $7F
    .byte $61
    .byte $FC
    .byte $E2
    .byte $FB
    .byte $EC
    .byte $A0

CHAR_SEL_SCREEN_TEXT:  
.import binary "pdcharsel_text.bin"
CHAR_SEL_SCREEN_COLOR: 
.import binary "pdcharsel_color.bin"
HELP_SCREEN_TEXT:  
.import binary "x16help_text.bin"
HELP_SCREEN_COLOR: 
.import binary "x16help_color.bin"
COLOR_SCREEN_TEXT: 
.import binary "pdcolpick_text.bin"
COLOR_SCREEN_COLOR: 
.import binary "pdcolpick_color.bin" 

//The last item here is the screen buffer, which is where the edit screen 
//gets copied to when using the character or color select screens.

SCREEN_BUFFER:

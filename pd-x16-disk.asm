//Petdraw (Commander X16 version)
//by David Murray 2019
//dfwgreencars@gmail.com
//
//Converted to KickAssembler
//by Marcelo Lv Cabral 2020
//https://github.com/lvcabral

// The following routine loads a file from disk

LOAD_ROUTINE: 
    lda NAME_LENGTH
    ldx #<FILE_NAME
    ldy #>FILE_NAME
    jsr $FFBD //SETNAM A=FILE NAME LENGTH X/Y=POINTER TO FILENAME
    lda #$02
    ldx #$08 //DRIVE 8
    ldy #$00
    jsr $FFBA //SETLFS A=LOGICAL NUMBER X=DEVICE NUMBER Y=secONDARY
    ldx #<SCREEN_BUFFER
    ldy #>SCREEN_BUFFER
    lda #$00
    jsr $FFD5 //LOAD FILE A=0 FOR LOAD X/Y=LOAD ADDRESS
    rts

// The following routine saves a file to disk

SAVE_ROUTINE:
    ldy TEXT_MODE //FIND OUT SIZE OF FILE
    lda FSIZE_L,Y
    sta SHIFT_TEMP1
    lda FSIZE_H,Y
    sta SHIFT_TEMP2
    
    lda NAME_LENGTH
    ldx #<FILE_NAME
    ldy #>FILE_NAME
    jsr $FFBD //SETNAM A=FILE NAME LENGTH X/Y=POINTER TO FILENAME
    lda #$02
    ldx #$08 //DRIVE 8
    ldy #$02
    jsr $FFBA //SETLFS A=LOGICAL NUMBER X=DEVICE NUMBER Y=secONDARY
    lda #<SCREEN_BUFFER 
    sta $FB
    lda #>SCREEN_BUFFER
    sta $FC
    lda #$FB //START LOCATION STORED AT $FB
    ldx SHIFT_TEMP1 //END LOCATION LOW-BYTE
    ldy SHIFT_TEMP2 //END LOCATION HIGH-BYTE
    jsr $FFD8 //SAVE FILE A=ADDRESS ZEROPAGE POINTER, X/Y= END OF ADDRESS+1
    rts

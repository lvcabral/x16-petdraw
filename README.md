# PetDraw for the Commander X16
KickAssembler version of the 8 Bit Guy's PetDraw tool for the Commander X16 computer

## Repository
The PetDraw is a program developed by [David Murray "The 8bit Guy"] (http://www.the8bitguy.com/) for several different Commodore machines, that allows the creation of PETSCII graphics and screens. This repository contains a **KickAssembler** conversion of the version for the Commander X16 Computer, made available by David at the [x16-demo](https://github.com/commanderx16/x16-demo) repository.

## How to Build
Make sure you have [KickAssembler](http://www.theweb.dk/KickAssembler/) available (v5.x) and run the following command:

```
java -jar KickAss.jar pd-x16-build.asm -o petdraw.prg
```

## How to Run
Download the [**Commander X16** Emulator](https://github.com/commanderx16/x16-emulator) and execute the following command:

```
x16emu -prg petdraw.prg -run
```

## Legal Stuff
Copyright (c) 2019 David Murray All Rights Reserved

KickAssembler version licensed under [MIT](https://github.com/lvcabral/x16-petdraw/blob/master/LICENSE) License.



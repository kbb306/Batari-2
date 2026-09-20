game
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L00 ;  dim BaudByte  =  a

.L01 ;  dim index  =  b

.L02 ;  dim TextIndex  =  c

.L03 ;  dim qtcontroller  =  d

.L04 ;  dim ShiftMode  =  e

.
 ; 

.L05 ;  COLUPF  =  $0E

	LDA #$0E
	STA COLUPF
.
 ; 

.L06 ;  playfield:

  ifconst pfres
	  ldx #(12>pfres)*(pfres*pfwidth-1)+(12<=pfres)*47
  else
	  ldx #((12*pfwidth-1)*((12*pfwidth-1)<47))+(47*((12*pfwidth-1)>=47))
  endif
	jmp pflabel0
PF_data0
	.byte %11100000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000000
 endif
	.byte %11100000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000000
 endif
	.byte %11100000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000000
 endif
	.byte %00000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000000
 endif
	.byte %00000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000000
 endif
	.byte %00000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000000
 endif
	.byte %00000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000000
 endif
	.byte %00000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000000
 endif
	.byte %00000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000000
 endif
	.byte %00000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000000
 endif
	.byte %00000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000000
 endif
	.byte %00000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000000
 endif
pflabel0
	lda PF_data0,x
	sta playfield,x
	dex
	bpl pflabel0
.
 ; 

.BaudByte=0
 ; BaudByte=0

.index=0
 ; index=0

.TextIndex=0
 ; TextIndex=0

.ShiftMode=0
 ; ShiftMode=0

.
 ; 

.mainloop
 ; mainloop

.drawscreen
 ; drawscreen

.
 ; 


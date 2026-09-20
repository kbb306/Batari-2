game
.L00 ;  set romsize 4k

.L01 ;  const p0color  =  $9A

.L02 ;  const p1color  =  $4A

.L03 ;  const explode_color  =  $3F

.L04 ;  const bkcolor  =  $00

.L05 ;  const gameoverbkcolor  =  $E0

.L06 ;  const offscreen  =  200

.L07 ;  const pfscore  =  1

.L08 ;  const press_fire  =  0

.L09 ;  const red_hits  =  12

.L010 ;  const blue_hits  =  24

.L011 ;  const red_wins  =  36

.L012 ;  const blue_wins  =  48

.L013 ;  const blank_text  =  60

.L014 ;  const scorebkcolor  =  $60

.L015 ;  const textbkcolor  =  $12

.L016 ;  const fontstyle  =  SQUISH

.
 ; 

.
 ; 

.
 ; 

.L017 ;  dim TextIndex  =  z

.L018 ;  dim P0FlippedBit0  =  a

.L019 ;  dim P1FlippedBit1  =  a

.L020 ;  dim Prev0x  =  b

.L021 ;  dim Prev0y  =  c

.L022 ;  dim Prev1x  =  d

.L023 ;  dim Prev1y  =  e

.L024 ;  dim Loop  =  f

.L025 ;  dim Temp  =  g

.L026 ;  dim Temp2  =  h

.L027 ;  dim TextCounter  =  i

.L028 ;  TextColor  =  $0F

	LDA #$0F
	STA TextColor
.L029 ;  scorecolor  =  $DF

	LDA #$DF
	STA scorecolor
.L030 ;  score  =  012345

	LDA #$45
	STA score+2
	LDA #$23
	STA score+1
	LDA #$01
	STA score
.
 ; 

.L031 ;  player0:

	LDX #<playerL031_0
	STX player0pointerlo
	LDA #>playerL031_0
	STA player0pointerhi
	LDA #10
	STA player0height
.
 ; 

.
 ; 

.L032 ;  player1:

	LDX #<playerL032_1
	STX player1pointerlo
	LDA #>playerL032_1
	STA player1pointerhi
	LDA #10
	STA player1height
.
 ; 

.ResetGame
 ; ResetGame

.
 ; 

.L033 ;  playfield:

  ifconst pfres
	  ldx #(12>pfres)*(pfres*pfwidth-1)+(12<=pfres)*47
  else
	  ldx #((12*pfwidth-1)*((12*pfwidth-1)<47))+(47*((12*pfwidth-1)>=47))
  endif
	jmp pflabel0
PF_data0
	.byte %00000000, %10000000
	if (pfwidth>2)
	.byte %10000000, %00000000
 endif
	.byte %00000000, %10000000
	if (pfwidth>2)
	.byte %10000000, %00000000
 endif
	.byte %00000000, %10000000
	if (pfwidth>2)
	.byte %10000000, %00000000
 endif
	.byte %00000000, %10000000
	if (pfwidth>2)
	.byte %10000000, %00000000
 endif
	.byte %00000000, %10000000
	if (pfwidth>2)
	.byte %10000000, %00000000
 endif
	.byte %00000000, %10000000
	if (pfwidth>2)
	.byte %10000000, %00000000
 endif
	.byte %00000000, %10000000
	if (pfwidth>2)
	.byte %10000000, %00000000
 endif
	.byte %00000000, %10000000
	if (pfwidth>2)
	.byte %10000000, %00000000
 endif
	.byte %00000000, %10000000
	if (pfwidth>2)
	.byte %10000000, %00000000
 endif
	.byte %00000000, %10000000
	if (pfwidth>2)
	.byte %10000000, %00000000
 endif
	.byte %00000000, %10000000
	if (pfwidth>2)
	.byte %10000000, %00000000
 endif
	.byte %00000000, %10000000
	if (pfwidth>2)
	.byte %10000000, %00000000
 endif
pflabel0
	lda PF_data0,x
	sta playfield,x
	dex
	bpl pflabel0
.
 ; 

.L034 ;  player0x  =  20  :  player0y  =  50

	LDA #20
	STA player0x
	LDA #50
	STA player0y
.L035 ;  player1x  =  130  :  player1y  =  50

	LDA #130
	STA player1x
	LDA #50
	STA player1y
.L036 ;  pfscorecolor  =  $68

	LDA #$68
	STA pfscorecolor
.L037 ;  missile0y  =  offscreen  :  missile1y  =  offscreen

	LDA #offscreen
	STA missile0y
	STA missile1y
.L038 ;  missile0height  =  2  :  missile1height  =  2

	LDA #2
	STA missile0height
	STA missile1height
.L039 ;  Temp  =  0  :  Temp2  =  0  :  AUDC0  =  0  :  AUDV0  =  0

	LDA #0
	STA Temp
	STA Temp2
	STA AUDC0
	STA AUDV0
.
 ; 

.
 ; 

.SubGameOver
 ; SubGameOver

.L040 ;  Loop  =  Loop  +  1

	INC Loop
.L041 ;  NUSIZ0  =  $15  :  NUSIZ1  =  $15

	LDA #$15
	STA NUSIZ0
	STA NUSIZ1
.L042 ;  COLUPF  =  $08

	LDA #$08
	STA COLUPF
.L043 ;  COLUP0  =  p0color

	LDA #p0color
	STA COLUP0
.L044 ;  COLUP1  =  p1color

	LDA #p1color
	STA COLUP1
.L045 ;  COLUBK  =  gameoverbkcolor

	LDA #gameoverbkcolor
	STA COLUBK
.L046 ;  temp1  =  Loop  /  16

	LDA Loop
	lsr
	lsr
	lsr
	lsr
	STA temp1
.L047 ;  temp2  =  temp1  *  16  +  15

; complex statement detected
	LDA temp1
	asl
	asl
	asl
	asl
	CLC
	ADC #15
	STA temp2
.L048 ;  if TextIndex then TextColor  =  temp2

	LDA TextIndex
	BEQ .skipL048
.condpart0
	LDA temp2
	STA TextColor
.skipL048
.L049 ;  drawscreen

 jsr drawscreen
.L050 ;  Temp  =  Temp  +  1

	INC Temp
.L051 ;  if Temp  =  60 then Temp2  =  1

	LDA Temp
	CMP #60
     BNE .skipL051
.condpart1
	LDA #1
	STA Temp2
.skipL051
.L052 ;  if Temp2  =  0 then goto SubGameOver

	LDA Temp2
	CMP #0
     BNE .skipL052
.condpart2
 jmp .SubGameOver

.skipL052
.L053 ;  if !switchreset  &&  !joy0fire  &&  !joy1fire then goto SubGameOver

 lda #1
 bit SWCHB
	BEQ .skipL053
.condpart3
 bit INPT4
	BPL .skip3then
.condpart4
 bit INPT5
	BPL .skip4then
.condpart5
 jmp .SubGameOver

.skip4then
.skip3then
.skipL053
.
 ; 

.
 ; 

.L054 ;  pfscore1  =  42  :  pfscore2  =  42

	LDA #42
	STA pfscore1
	STA pfscore2
.
 ; 

.L055 ;  TextIndex  =  blank_text

	LDA #blank_text
	STA TextIndex
.
 ; 

.
 ; 

.MainLoop
 ; MainLoop

.L056 ;  NUSIZ0  =  $15  :  NUSIZ1  =  $15

	LDA #$15
	STA NUSIZ0
	STA NUSIZ1
.L057 ;  COLUBK  =  bkcolor

	LDA #bkcolor
	STA COLUBK
.L058 ;  COLUPF  =  $08

	LDA #$08
	STA COLUPF
.L059 ;  COLUP0  =  p0color

	LDA #p0color
	STA COLUP0
.L060 ;  COLUP1  =  p1color

	LDA #p1color
	STA COLUP1
.L061 ;  pfscroll up

	LDA #2
 jsr pfscroll
.L062 ;  Prev0x  =  player0x

	LDA player0x
	STA Prev0x
.L063 ;  Prev0y  =  player0y

	LDA player0y
	STA Prev0y
.L064 ;  Prev1x  =  player1x

	LDA player1x
	STA Prev1x
.L065 ;  Prev1y  =  player1y

	LDA player1y
	STA Prev1y
.L066 ;  if joy0left  &&  player0x  >  0 then player0x  =  player0x  -  1

 bit SWCHA
	BVS .skipL066
.condpart6
	LDA #0
	CMP player0x
     BCS .skip6then
.condpart7
	DEC player0x
.skip6then
.skipL066
.L067 ;  if joy0right  &&  player0x  <  144 then player0x  =  player0x  +  1

 bit SWCHA
	BMI .skipL067
.condpart8
	LDA player0x
	CMP #144
     BCS .skip8then
.condpart9
	INC player0x
.skip8then
.skipL067
.L068 ;  if joy1left  &&  player1x  >  0 then player1x  =  player1x  -  1

 lda #4
 bit SWCHA
	BNE .skipL068
.condpart10
	LDA #0
	CMP player1x
     BCS .skip10then
.condpart11
	DEC player1x
.skip10then
.skipL068
.L069 ;  if joy1right  &&  player1x  <  144 then player1x  =  player1x  +  1

 lda #8
 bit SWCHA
	BNE .skipL069
.condpart12
	LDA player1x
	CMP #144
     BCS .skip12then
.condpart13
	INC player1x
.skip12then
.skipL069
.
 ; 

.L070 ;  if joy0up  &&  player0y  >  player0height  +  2 then player0y  =  player0y  -  1

 lda #$10
 bit SWCHA
	BNE .skipL070
.condpart14
; complex condition detected
	LDA player0height
	CLC
	ADC #2
	CMP player0y
     BCS .skip14then
.condpart15
	DEC player0y
.skip14then
.skipL070
.L071 ;  if joy0down  &&  player0y  <  82 then player0y  =  player0y  +  1

 lda #$20
 bit SWCHA
	BNE .skipL071
.condpart16
	LDA player0y
	CMP #82
     BCS .skip16then
.condpart17
	INC player0y
.skip16then
.skipL071
.L072 ;  if joy1up  &&  player1y  >  player1height  +  2 then player1y  =  player1y  -  1

 lda #1
 bit SWCHA
	BNE .skipL072
.condpart18
; complex condition detected
	LDA player1height
	CLC
	ADC #2
	CMP player1y
     BCS .skip18then
.condpart19
	DEC player1y
.skip18then
.skipL072
.L073 ;  if joy1down  &&  player1y  <  82 then player1y  =  player1y  +  1

 lda #2
 bit SWCHA
	BNE .skipL073
.condpart20
	LDA player1y
	CMP #82
     BCS .skip20then
.condpart21
	INC player1y
.skip20then
.skipL073
.L074 ;  if missile0y  =  offscreen then goto ____skip_move_p0missile

	LDA missile0y
	CMP #offscreen
     BNE .skipL074
.condpart22
 jmp .____skip_move_p0missile

.skipL074
.L075 ;  missile0x  =  missile0x  +  1

	INC missile0x
.L076 ;  if missile0x  >  158 then missile0y  =  offscreen

	LDA #158
	CMP missile0x
     BCS .skipL076
.condpart23
	LDA #offscreen
	STA missile0y
.skipL076
.L077 ;  goto ____p0missile_done

 jmp .____p0missile_done

.____skip_move_p0missile
 ; ____skip_move_p0missile

.L078 ;  if !joy0fire then goto ____skip_joy0fire

 bit INPT4
	BPL .skipL078
.condpart24
 jmp .____skip_joy0fire

.skipL078
.L079 ;  if missile0y  <>  offscreen then goto ____skip_joy0fire

	LDA missile0y
	CMP #offscreen
     BEQ .skipL079
.condpart25
 jmp .____skip_joy0fire

.skipL079
.L080 ;  missile0x  =  player0x  +  16

	LDA player0x
	CLC
	ADC #16
	STA missile0x
.L081 ;  missile0y  =  player0y  -  7

	LDA player0y
	SEC
	SBC #7
	STA missile0y
.____skip_joy0fire
 ; ____skip_joy0fire

.____p0missile_done
 ; ____p0missile_done

.L082 ;  if missile1y  =  offscreen then goto ____skip_move_p1missile

	LDA missile1y
	CMP #offscreen
     BNE .skipL082
.condpart26
 jmp .____skip_move_p1missile

.skipL082
.L083 ;  missile1x  =  missile1x  -  1

	DEC missile1x
.L084 ;  if missile1x  <  1 then missile1y  =  offscreen

	LDA missile1x
	CMP #1
     BCS .skipL084
.condpart27
	LDA #offscreen
	STA missile1y
.skipL084
.L085 ;  goto ____p1missile_done

 jmp .____p1missile_done

.____skip_move_p1missile
 ; ____skip_move_p1missile

.L086 ;  if !joy1fire then goto ____skip_joy1fire

 bit INPT5
	BPL .skipL086
.condpart28
 jmp .____skip_joy1fire

.skipL086
.L087 ;  if missile1y  <>  offscreen then goto ____skip_joy1fire

	LDA missile1y
	CMP #offscreen
     BEQ .skipL087
.condpart29
 jmp .____skip_joy1fire

.skipL087
.L088 ;  missile1x  =  player1x

	LDA player1x
	STA missile1x
.L089 ;  missile1y  =  player1y  -  7

	LDA player1y
	SEC
	SBC #7
	STA missile1y
.____skip_joy1fire
 ; ____skip_joy1fire

.____p1missile_done
 ; ____p1missile_done

.L090 ;  drawscreen

 jsr drawscreen
.L091 ;  AUDC0  =  0  :  AUDV0  =  0

	LDA #0
	STA AUDC0
	STA AUDV0
.L092 ;  if collision(missile0,playfield) then temp1  =  missile0x  :  temp2  =  missile0y  :  missile0y  =  offscreen  :  temp5  =  79  :  gosub SubBreakWall

	bit 	CXM0FB
	BPL .skipL092
.condpart30
	LDA missile0x
	STA temp1
	LDA missile0y
	STA temp2
	LDA #offscreen
	STA missile0y
	LDA #79
	STA temp5
 jsr .SubBreakWall

.skipL092
.L093 ;  if collision(missile0,player1) then pfscore2  =  pfscore2  /  4  :  missile0y  =  offscreen  :  Temp  =  1  :  gosub SubPlayerHit

	bit 	CXM0P
	BPL .skipL093
.condpart31
	LDA pfscore2
	lsr
	lsr
	STA pfscore2
	LDA #offscreen
	STA missile0y
	LDA #1
	STA Temp
 jsr .SubPlayerHit

.skipL093
.L094 ;  if collision(missile1,playfield) then temp1  =  missile1x  :  temp2  =  missile1y  :  missile1y  =  offscreen  :  temp5  =  81  :  gosub SubBreakWall

	bit 	CXM1FB
	BPL .skipL094
.condpart32
	LDA missile1x
	STA temp1
	LDA missile1y
	STA temp2
	LDA #offscreen
	STA missile1y
	LDA #81
	STA temp5
 jsr .SubBreakWall

.skipL094
.L095 ;  if collision(missile1,player0) then pfscore1  =  pfscore1  /  4  :  missile1y  =  offscreen  :  Temp  =  0  :  gosub SubPlayerHit

	bit 	CXM1P
	BPL .skipL095
.condpart33
	LDA pfscore1
	lsr
	lsr
	STA pfscore1
	LDA #offscreen
	STA missile1y
	LDA #0
	STA Temp
 jsr .SubPlayerHit

.skipL095
.L096 ;  if collision(player0,playfield) then player0x  =  player0x  -  8

	bit 	CXP0FB
	BPL .skipL096
.condpart34
	LDA player0x
	SEC
	SBC #8
	STA player0x
.skipL096
.L097 ;  if collision(player1,playfield) then player1x  =  player1x  +  8

	bit 	CXP1FB
	BPL .skipL097
.condpart35
	LDA player1x
	CLC
	ADC #8
	STA player1x
.skipL097
.L098 ;  if collision(player0,player1) then player0x  =  Prev0x  :  player0y  =  Prev0y  :  player1x  =  Prev1x  :  player1y  =  Prev1y

	bit 	CXPPMM
	BPL .skipL098
.condpart36
	LDA Prev0x
	STA player0x
	LDA Prev0y
	STA player0y
	LDA Prev1x
	STA player1x
	LDA Prev1y
	STA player1y
.skipL098
.L099 ;  if pfscore1  =  0  ||  pfscore2  =  0 then goto ResetGame

	LDA pfscore1
	CMP #0
     BNE .skipL099
.condpart37
 jmp .condpart38
.skipL099
	LDA pfscore2
	CMP #0
     BNE .skip10OR
.condpart38
 jmp .ResetGame

.skip10OR
.L0100 ;  if !TextCounter then goto ____end_text_counter

	LDA TextCounter
	BNE .skipL0100
.condpart39
 jmp .____end_text_counter

.skipL0100
.L0101 ;  TextCounter  =  TextCounter  -  1

	DEC TextCounter
.L0102 ;  if !TextCounter then TextIndex  =  blank_text

	LDA TextCounter
	BNE .skipL0102
.condpart40
	LDA #blank_text
	STA TextIndex
.skipL0102
.____end_text_counter
 ; ____end_text_counter

.
 ; 

.
 ; 

.L0103 ;  goto MainLoop

 jmp .MainLoop

.
 ; 

.
 ; 

.SubBreakWall
 ; SubBreakWall

.L0104 ;  AUDC0  =  12  :  AUDV0  =  8  :  AUDF0  =  31

	LDA #12
	STA AUDC0
	LDA #8
	STA AUDV0
	LDA #31
	STA AUDF0
.L0105 ;  if temp1  >  temp5 then temp3  =  16 else temp3  =  15

	LDA temp5
	CMP temp1
     BCS .skipL0105
.condpart41
	LDA #16
	STA temp3
 jmp .skipelse0
.skipL0105
	LDA #15
	STA temp3
.skipelse0
.L0106 ;  temp4  =  temp4  -  playfieldpos

	LDA temp4
	SEC
	SBC playfieldpos
	STA temp4
.L0107 ;  temp4  =  temp2  /  8

	LDA temp2
	lsr
	lsr
	lsr
	STA temp4
.L0108 ;  if !pfread ( temp3 , temp4 )  then temp4  =  temp4  +  1

	LDA temp3
	LDY temp4
 jsr pfread
	BEQ .skipL0108
.condpart42
	INC temp4
.skipL0108
.L0109 ;  if !pfread ( temp3 , temp4 )  then temp4  =  temp4  -  2

	LDA temp3
	LDY temp4
 jsr pfread
	BEQ .skipL0109
.condpart43
	LDA temp4
	SEC
	SBC #2
	STA temp4
.skipL0109
.L0110 ;  pfpixel temp3 temp4 off

	LDX #1
	LDY temp4
	LDA temp3
 jsr pfpixel
.L0111 ;  return

	RTS
.
 ; 

.
 ; 

.
 ; 

.SubPlayerHit
 ; SubPlayerHit

.L0112 ;  Temp2  =  player0height

	LDA player0height
	STA Temp2
.L0113 ;  temp1  =  player0height  *  2

	LDA player0height
	asl
	STA temp1
.L0114 ;  AUDC0  =  8  :  AUDV0  =  8  :  AUDF0  =  31

	LDA #8
	STA AUDC0
	STA AUDV0
	LDA #31
	STA AUDF0
.L0115 ;  for Loop = temp1 to 0 step -1

	LDA temp1
	STA Loop
.L0115forLoop
.L0116 ;  COLUBK  =  bkcolor

	LDA #bkcolor
	STA COLUBK
.L0117 ;  NUSIZ0  =  $15  :  NUSIZ1  =  $15

	LDA #$15
	STA NUSIZ0
	STA NUSIZ1
.L0118 ;  COLUPF  =  $08

	LDA #$08
	STA COLUPF
.L0119 ;  if Temp = 1 then goto ____skip_p0

	LDA Temp
	CMP #1
     BNE .skipL0119
.condpart44
 jmp .____skip_p0

.skipL0119
.L0120 ;  player0height  =  Loop  /  2

	LDA Loop
	lsr
	STA player0height
.L0121 ;  COLUP0  =  explode_color

	LDA #explode_color
	STA COLUP0
.L0122 ;  COLUP1  =  p1color

	LDA #p1color
	STA COLUP1
.L0123 ;  if pfscore1 then TextIndex  =  red_hits else TextIndex  =  red_wins

	LDA pfscore1
	BEQ .skipL0123
.condpart45
	LDA #red_hits
	STA TextIndex
 jmp .skipelse1
.skipL0123
	LDA #red_wins
	STA TextIndex
.skipelse1
.L0124 ;  TextCounter  =  120

	LDA #120
	STA TextCounter
.L0125 ;  TextColor  =  $4F

	LDA #$4F
	STA TextColor
.L0126 ;  goto ____skip_p1

 jmp .____skip_p1

.____skip_p0
 ; ____skip_p0

.L0127 ;  player1height  =  Loop  /  2

	LDA Loop
	lsr
	STA player1height
.L0128 ;  COLUP0  =  p0color

	LDA #p0color
	STA COLUP0
.L0129 ;  COLUP1  =  explode_color

	LDA #explode_color
	STA COLUP1
.L0130 ;  if pfscore2 then TextIndex  =  blue_hits else TextIndex  =  blue_wins

	LDA pfscore2
	BEQ .skipL0130
.condpart46
	LDA #blue_hits
	STA TextIndex
 jmp .skipelse2
.skipL0130
	LDA #blue_wins
	STA TextIndex
.skipelse2
.L0131 ;  TextCounter  =  120

	LDA #120
	STA TextCounter
.L0132 ;  TextColor  =  $9F

	LDA #$9F
	STA TextColor
.____skip_p1
 ; ____skip_p1

.L0133 ;  drawscreen

 jsr drawscreen
.L0134 ;  next

	LDA Loop
	CLC
	ADC #-1

	bcc .L0115forLoop_failsafe
	STA Loop
	CMP #0
	bcs .L0115forLoop
.L0115forLoop_failsafe
.L0135 ;  if Temp  =  0 then player0height  =  Temp2 else player1height  =  Temp2

	LDA Temp
	CMP #0
     BNE .skipL0135
.condpart47
	LDA Temp2
	STA player0height
 jmp .skipelse3
.skipL0135
	LDA Temp2
	STA player1height
.skipelse3
.L0136 ;  return

	RTS
.
 ; 

.
 ; 

.
 ; 

.L0137 ;  data text_strings

	JMP .skipL0137
text_strings
	.byte    _hy, __P, __R, __E, __S, __S, _sp, __F, __I, __R, __E, _hy

	.byte    __R, __E, __D, _sp, __H, __I, __T, __S, _ex, _sp, _sp, _sp

	.byte    __B, __L, __U, __E, _sp, __H, __I, __T, __S, _ex, _sp, _sp

	.byte    __R, __E, __D, _sp, __W, __I, __N, __S, _ex, _sp, _sp, _sp

	.byte    __B, __L, __U, __E, _sp, __W, __I, __N, __S, _ex, _sp, _sp

	.byte    _sp, _sp, _sp, _sp, _sp, _sp, _sp, _sp, _sp, _sp, _sp, _sp

.skipL0137
.
 ; 

.L0138 ;  inline text12a.asm

 include text12a.asm

.L0139 ;  inline text12b.asm
 include text12b.asm
 if (<*) > (<(*+10))
	repeat ($100-<*)
	.byte 0
	repend
	endif
playerL031_0
	.byte     %00100000
	.byte     %01010000
	.byte     %10001000
	.byte     %10101000
	.byte     %10001000
	.byte     %01010000
	.byte     %01111111
	.byte     %01111111
	.byte     %11111111
	.byte     %01111111
	.byte     %00010000
 if (<*) > (<(*+10))
	repeat ($100-<*)
	.byte 0
	repend
	endif
playerL032_1
	.byte     %00000100
	.byte     %00001010
	.byte     %00010001
	.byte     %00010101
	.byte     %00010001
	.byte     %00001010
	.byte     %11111110
	.byte     %11111110
	.byte     %11111111
	.byte     %11111110
	.byte     %00001000
 if ECHOFIRST
       echo "    ",[(scoretable - *)]d , "bytes of ROM space left")
 endif 
ECHOFIRST = 1
 
 
 

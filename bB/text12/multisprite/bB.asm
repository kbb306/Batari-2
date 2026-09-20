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

.L00 ;  includesfile multisprite_bankswitch.inc

.L01 ;  set kernel multisprite

.L02 ;  set romsize 16k

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

.L03 ;  dim _Current_Object  =  a

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L04 ;  dim _Sprite_Size0  =  b

.L05 ;  dim _Sprite_Size1  =  c

.L06 ;  dim _Sprite_Size2  =  d

.L07 ;  dim _Sprite_Size3  =  e

.L08 ;  dim _Sprite_Size4  =  f

.L09 ;  dim _Sprite_Size5  =  g

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L010 ;  dim _Missile0_Width  =  l

.L011 ;  dim _Missile1_Width  =  m

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L012 ;  dim _Ball_Width  =  n

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L013 ;  dim _Jiggle_Counter  =  o

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L014 ;  dim _P0_NUSIZ  =  p

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L015 ;  dim _Bit0_Reset_Restrainer  =  t

.L016 ;  dim _Bit1_Joy0_Restrainer  =  t

.L017 ;  dim _Bit2_Activate_Jiggle  =  t

.L018 ;  dim _Bit3_Flip_p0  =  t

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L019 ;  dim _Memx  =  x

.L020 ;  dim _Memy  =  y

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L021 ;  dim rand16  =  z

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L022 ;  dim _sc1  =  score

.L023 ;  dim _sc2  =  score + 1

.L024 ;  dim _sc3  =  score + 2

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

.L025 ;  const _Sprite0  =  0

.L026 ;  const _Sprite1  =  1

.L027 ;  const _Sprite2  =  2

.L028 ;  const _Sprite3  =  3

.L029 ;  const _Sprite4  =  4

.L030 ;  const _Sprite5  =  5

.L031 ;  const _Missile0  =  6

.L032 ;  const _Missile1  =  7

.L033 ;  const _Ball  =  8

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

.L034 ;  dim TextIndex  =  w

.L035 ;  const noscore  =  1

.L036 ;  const textbank  =  3

.L037 ;  const p0_text  =  0

.L038 ;  const p1_text  =  12

.L039 ;  const p2_text  =  24

.L040 ;  const p3_text  =  36

.L041 ;  const p4_text  =  48

.L042 ;  const p5_text  =  60

.L043 ;  const m0_text  =  72

.L044 ;  const m1_text  =  84

.L045 ;  const ball_text  =  96

.L046 ;  const fontstyle  =  SQUISH

.L047 ;  const screenheight  =  80

.L048 ;  pfheight  =  7

	LDA #7
	STA pfheight
.L049 ;  TextColor  =  $0F

	LDA #$0F
	STA TextColor
.
 ; 

.L050 ;  playfield:

	LDA #<PF1_data0
	STA PF1pointer
	LDA #>PF1_data0
	STA PF1pointer+1
	LDA #<PF2_data0
	STA PF2pointer
	LDA #>PF2_data0
	STA PF2pointer+1
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

.__Start_Restart
 ; __Start_Restart

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

.L051 ;  drawscreen

 sta temp7
 lda #>(ret_point1-1)
 pha
 lda #<(ret_point1-1)
 pha
 lda #>(drawscreen-1)
 pha
 lda #<(drawscreen-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point1
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

.L052 ;  player0:

	LDX #<playerL052_0
	STX player0pointerlo
	LDA #>playerL052_0
	STA player0pointerhi
	LDA #9
	STA player0height
.
 ; 

.
 ; 

.L053 ;  player1:

	LDX #<playerL053_1
	STX player1pointerlo
	LDA #>playerL053_1
	STA player1pointerhi
	LDA #8
	STA player1height
.
 ; 

.
 ; 

.L054 ;  player2:

	LDX #<playerL054_2
	STX player2pointerlo
	LDA #>playerL054_2
	STA player2pointerhi
	LDA #8
	STA player2height
.
 ; 

.
 ; 

.L055 ;  player3:

	LDX #<playerL055_3
	STX player3pointerlo
	LDA #>playerL055_3
	STA player3pointerhi
	LDA #8
	STA player3height
.
 ; 

.
 ; 

.L056 ;  player4:

	LDX #<playerL056_4
	STX player4pointerlo
	LDA #>playerL056_4
	STA player4pointerhi
	LDA #8
	STA player4height
.
 ; 

.
 ; 

.L057 ;  player5:

	LDX #<playerL057_5
	STX player5pointerlo
	LDA #>playerL057_5
	STA player5pointerhi
	LDA #8
	STA player5height
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

.L058 ;  player0x  =  77  :  player0y  =  80

	LDA #77
	STA player0x
	LDA #80
	STA player0y
.L059 ;  player1x  =  85  :  player1y  =  player0y  -  16

	LDA #85
	STA player1x
	LDA player0y
	SEC
	SBC #16
	STA player1y
.L060 ;  player2x  =  85  :  player2y  =  player1y  -  14

	LDA #85
	STA player2x
	LDA player1y
	SEC
	SBC #14
	STA player2y
.L061 ;  player3x  =  85  :  player3y  =  player2y  -  14

	LDA #85
	STA player3x
	LDA player2y
	SEC
	SBC #14
	STA player3y
.L062 ;  player4x  =  85  :  player4y  =  player3y  -  14

	LDA #85
	STA player4x
	LDA player3y
	SEC
	SBC #14
	STA player4y
.L063 ;  player5x  =  85  :  player5y  =  player4y  -  14

	LDA #85
	STA player5x
	LDA player4y
	SEC
	SBC #14
	STA player5y
.L064 ;  missile0x  =  98  :  missile0y  =  78

	LDA #98
	STA missile0x
	LDA #78
	STA missile0y
.L065 ;  missile1x  =  98  :  missile1y  =  missile0y  -  15

	LDA #98
	STA missile1x
	LDA missile0y
	SEC
	SBC #15
	STA missile1y
.L066 ;  ballx  =  98  :  bally  =  missile1y  -  15

	LDA #98
	STA ballx
	LDA missile1y
	SEC
	SBC #15
	STA bally
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

.L067 ;  _NUSIZ1{3}  =  0  :  NUSIZ2{3}  =  0  :  NUSIZ3{3}  =  0

	LDA _NUSIZ1
	AND #247
	STA _NUSIZ1
	LDA NUSIZ2
	AND #247
	STA NUSIZ2
	LDA NUSIZ3
	AND #247
	STA NUSIZ3
.L068 ;  NUSIZ4{3}  =  0  :  NUSIZ5{3}  =  0

	LDA NUSIZ4
	AND #247
	STA NUSIZ4
	LDA NUSIZ5
	AND #247
	STA NUSIZ5
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

.L069 ;  AUDV0  =  0  :  AUDV1  =  0

	LDA #0
	STA AUDV0
	STA AUDV1
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

.L070 ;  a  =  0  :  b  =  0  :  c  =  0  :  d  =  0  :  e  =  0  :  f  =  0  :  g  =  0  :  h  =  0  :  i  =  0

	LDA #0
	STA a
	STA b
	STA c
	STA d
	STA e
	STA f
	STA g
	STA h
	STA i
.L071 ;  j  =  0  :  k  =  0  :  l  =  0  :  m  =  0  :  n  =  0  :  o  =  0  :  p  =  0  :  q  =  0  :  r  =  0

	LDA #0
	STA j
	STA k
	STA l
	STA m
	STA n
	STA o
	STA p
	STA q
	STA r
.L072 ;  s  =  0  :  t  =  0  :  u  =  0  :  v  =  0  :  w  =  0  :  x  =  0  :  y  =  0

	LDA #0
	STA s
	STA t
	STA u
	STA v
	STA w
	STA x
	STA y
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

.L073 ;  _Bit0_Reset_Restrainer{0}  =  1

	LDA _Bit0_Reset_Restrainer
	ORA #1
	STA _Bit0_Reset_Restrainer
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

.L074 ;  _Missile0_Width  =  0  :  _Missile1_Width  =  0  :  _Ball_Width  =  0

	LDA #0
	STA _Missile0_Width
	STA _Missile1_Width
	STA _Ball_Width
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

.
 ; 

.
 ; 

.
 ; 

.__Main_Loop
 ; __Main_Loop

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

.L075 ;  COLUP0  =  $08  :  COLUP1  =  $BA  :  _COLUP1  =  $1A  :  COLUP2  =  $3A  :  COLUP3  =  $6A

	LDA #$08
	STA COLUP0
	LDA #$BA
	STA COLUP1
	LDA #$1A
	STA _COLUP1
	LDA #$3A
	STA COLUP2
	LDA #$6A
	STA COLUP3
.
 ; 

.L076 ;  COLUP4  =  $8A  :  COLUP5  =  $CA  :  COLUBK =  0  :  COLUPF  =  $4A

	LDA #$8A
	STA COLUP4
	LDA #$CA
	STA COLUP5
	LDA #0
	STA COLUBK
	LDA #$4A
	STA COLUPF
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

.
 ; 

.
 ; 

.
 ; 

.L077 ;  if !joy0fire then _Bit1_Joy0_Restrainer{1}  =  0  :  goto __Skip_Fire_Button

 bit INPT4
	BPL .skipL077
.condpart0
	LDA _Bit1_Joy0_Restrainer
	AND #253
	STA _Bit1_Joy0_Restrainer
 jmp .__Skip_Fire_Button

.skipL077
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

.L078 ;  if !joy0up  &&  !joy0down  &&  !joy0left  &&  !joy0right then _Bit1_Joy0_Restrainer{1}  =  0

 lda #$10
 bit SWCHA
	BEQ .skipL078
.condpart1
 lda #$20
 bit SWCHA
	BEQ .skip1then
.condpart2
 bit SWCHA
	BVC .skip2then
.condpart3
 bit SWCHA
	BPL .skip3then
.condpart4
	LDA _Bit1_Joy0_Restrainer
	AND #253
	STA _Bit1_Joy0_Restrainer
.skip3then
.skip2then
.skip1then
.skipL078
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L079 ;  if _Bit1_Joy0_Restrainer{1} then goto __Skip_Movement

	LDA _Bit1_Joy0_Restrainer
	AND #2
	BEQ .skipL079
.condpart5
 jmp .__Skip_Movement

.skipL079
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L080 ;  if joy0up then _Bit1_Joy0_Restrainer{1}  =  1  :  _Bit2_Activate_Jiggle{2}  =  1  :  _Jiggle_Counter  =  0  :  _Current_Object  =  _Current_Object  -  1  :  if _Current_Object  >=  250 then _Current_Object  =  8

 lda #$10
 bit SWCHA
	BNE .skipL080
.condpart6
	LDA _Bit1_Joy0_Restrainer
	ORA #2
	STA _Bit1_Joy0_Restrainer
	LDA _Bit2_Activate_Jiggle
	ORA #4
	STA _Bit2_Activate_Jiggle
	LDA #0
	STA _Jiggle_Counter
	DEC _Current_Object
	LDA _Current_Object
	CMP #250
     BCC .skip6then
.condpart7
	LDA #8
	STA _Current_Object
.skip6then
.skipL080
.
 ; 

.L081 ;  if joy0down then _Bit1_Joy0_Restrainer{1}  =  1  :  _Bit2_Activate_Jiggle{2}  =  1  :  _Jiggle_Counter  =  0  :  _Current_Object  =  _Current_Object  +  1  :  if _Current_Object  >=  9 then _Current_Object  =  0

 lda #$20
 bit SWCHA
	BNE .skipL081
.condpart8
	LDA _Bit1_Joy0_Restrainer
	ORA #2
	STA _Bit1_Joy0_Restrainer
	LDA _Bit2_Activate_Jiggle
	ORA #4
	STA _Bit2_Activate_Jiggle
	LDA #0
	STA _Jiggle_Counter
	INC _Current_Object
	LDA _Current_Object
	CMP #9
     BCC .skip8then
.condpart9
	LDA #0
	STA _Current_Object
.skip8then
.skipL081
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L082 ;  if !joy0left then goto __Skip_Size_Decrease

 bit SWCHA
	BVC .skipL082
.condpart10
 jmp .__Skip_Size_Decrease

.skipL082
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L083 ;  _Bit1_Joy0_Restrainer{1}  =  1

	LDA _Bit1_Joy0_Restrainer
	ORA #2
	STA _Bit1_Joy0_Restrainer
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L084 ;  if _Current_Object  =  _Sprite0 then _Sprite_Size0  =  _Sprite_Size0  -  1  :  if _Sprite_Size0  >=  250 then _Sprite_Size0  =  2

	LDA _Current_Object
	CMP #_Sprite0
     BNE .skipL084
.condpart11
	DEC _Sprite_Size0
	LDA _Sprite_Size0
	CMP #250
     BCC .skip11then
.condpart12
	LDA #2
	STA _Sprite_Size0
.skip11then
.skipL084
.L085 ;  if _Current_Object  =  _Sprite1 then _Sprite_Size1  =  _Sprite_Size1  -  1  :  if _Sprite_Size1  >=  250 then _Sprite_Size1  =  2

	LDA _Current_Object
	CMP #_Sprite1
     BNE .skipL085
.condpart13
	DEC _Sprite_Size1
	LDA _Sprite_Size1
	CMP #250
     BCC .skip13then
.condpart14
	LDA #2
	STA _Sprite_Size1
.skip13then
.skipL085
.L086 ;  if _Current_Object  =  _Sprite2 then _Sprite_Size2  =  _Sprite_Size2  -  1  :  if _Sprite_Size2  >=  250 then _Sprite_Size2  =  2

	LDA _Current_Object
	CMP #_Sprite2
     BNE .skipL086
.condpart15
	DEC _Sprite_Size2
	LDA _Sprite_Size2
	CMP #250
     BCC .skip15then
.condpart16
	LDA #2
	STA _Sprite_Size2
.skip15then
.skipL086
.L087 ;  if _Current_Object  =  _Sprite3 then _Sprite_Size3  =  _Sprite_Size3  -  1  :  if _Sprite_Size3  >=  250 then _Sprite_Size3  =  2

	LDA _Current_Object
	CMP #_Sprite3
     BNE .skipL087
.condpart17
	DEC _Sprite_Size3
	LDA _Sprite_Size3
	CMP #250
     BCC .skip17then
.condpart18
	LDA #2
	STA _Sprite_Size3
.skip17then
.skipL087
.L088 ;  if _Current_Object  =  _Sprite4 then _Sprite_Size4  =  _Sprite_Size4  -  1  :  if _Sprite_Size4  >=  250 then _Sprite_Size4  =  2

	LDA _Current_Object
	CMP #_Sprite4
     BNE .skipL088
.condpart19
	DEC _Sprite_Size4
	LDA _Sprite_Size4
	CMP #250
     BCC .skip19then
.condpart20
	LDA #2
	STA _Sprite_Size4
.skip19then
.skipL088
.L089 ;  if _Current_Object  =  _Sprite5 then _Sprite_Size5  =  _Sprite_Size5  -  1  :  if _Sprite_Size5  >=  250 then _Sprite_Size5  =  2

	LDA _Current_Object
	CMP #_Sprite5
     BNE .skipL089
.condpart21
	DEC _Sprite_Size5
	LDA _Sprite_Size5
	CMP #250
     BCC .skip21then
.condpart22
	LDA #2
	STA _Sprite_Size5
.skip21then
.skipL089
.L090 ;  if _Current_Object  =  _Missile0 then _Missile0_Width  =  _Missile0_Width  -  1  :  if _Missile0_Width  =  255 then _Missile0_Width  =  3

	LDA _Current_Object
	CMP #_Missile0
     BNE .skipL090
.condpart23
	DEC _Missile0_Width
	LDA _Missile0_Width
	CMP #255
     BNE .skip23then
.condpart24
	LDA #3
	STA _Missile0_Width
.skip23then
.skipL090
.L091 ;  if _Current_Object  =  _Missile1 then _Missile1_Width  =  _Missile1_Width  -  1  :  if _Missile1_Width  =  255 then _Missile1_Width  =  3

	LDA _Current_Object
	CMP #_Missile1
     BNE .skipL091
.condpart25
	DEC _Missile1_Width
	LDA _Missile1_Width
	CMP #255
     BNE .skip25then
.condpart26
	LDA #3
	STA _Missile1_Width
.skip25then
.skipL091
.L092 ;  if _Current_Object  =  _Ball then _Ball_Width  =  _Ball_Width  -  1  :  if _Ball_Width  =  255 then _Ball_Width  =  3

	LDA _Current_Object
	CMP #_Ball
     BNE .skipL092
.condpart27
	DEC _Ball_Width
	LDA _Ball_Width
	CMP #255
     BNE .skip27then
.condpart28
	LDA #3
	STA _Ball_Width
.skip27then
.skipL092
.
 ; 

.L093 ;  goto __Skip_Size_Increase

 jmp .__Skip_Size_Increase

.
 ; 

.__Skip_Size_Decrease
 ; __Skip_Size_Decrease

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L094 ;  if !joy0right then goto __Skip_Size_Increase

 bit SWCHA
	BPL .skipL094
.condpart29
 jmp .__Skip_Size_Increase

.skipL094
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L095 ;  _Bit1_Joy0_Restrainer{1}  =  1

	LDA _Bit1_Joy0_Restrainer
	ORA #2
	STA _Bit1_Joy0_Restrainer
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L096 ;  if _Current_Object  =  _Sprite0 then _Sprite_Size0  =  _Sprite_Size0  +  1  :  if _Sprite_Size0  >=  3 then _Sprite_Size0  =  0

	LDA _Current_Object
	CMP #_Sprite0
     BNE .skipL096
.condpart30
	INC _Sprite_Size0
	LDA _Sprite_Size0
	CMP #3
     BCC .skip30then
.condpart31
	LDA #0
	STA _Sprite_Size0
.skip30then
.skipL096
.L097 ;  if _Current_Object  =  _Sprite1 then _Sprite_Size1  =  _Sprite_Size1  +  1  :  if _Sprite_Size1  >=  3 then _Sprite_Size1  =  0

	LDA _Current_Object
	CMP #_Sprite1
     BNE .skipL097
.condpart32
	INC _Sprite_Size1
	LDA _Sprite_Size1
	CMP #3
     BCC .skip32then
.condpart33
	LDA #0
	STA _Sprite_Size1
.skip32then
.skipL097
.L098 ;  if _Current_Object  =  _Sprite2 then _Sprite_Size2  =  _Sprite_Size2  +  1  :  if _Sprite_Size2  >=  3 then _Sprite_Size2  =  0

	LDA _Current_Object
	CMP #_Sprite2
     BNE .skipL098
.condpart34
	INC _Sprite_Size2
	LDA _Sprite_Size2
	CMP #3
     BCC .skip34then
.condpart35
	LDA #0
	STA _Sprite_Size2
.skip34then
.skipL098
.L099 ;  if _Current_Object  =  _Sprite3 then _Sprite_Size3  =  _Sprite_Size3  +  1  :  if _Sprite_Size3  >=  3 then _Sprite_Size3  =  0

	LDA _Current_Object
	CMP #_Sprite3
     BNE .skipL099
.condpart36
	INC _Sprite_Size3
	LDA _Sprite_Size3
	CMP #3
     BCC .skip36then
.condpart37
	LDA #0
	STA _Sprite_Size3
.skip36then
.skipL099
.L0100 ;  if _Current_Object  =  _Sprite4 then _Sprite_Size4  =  _Sprite_Size4  +  1  :  if _Sprite_Size4  >=  3 then _Sprite_Size4  =  0

	LDA _Current_Object
	CMP #_Sprite4
     BNE .skipL0100
.condpart38
	INC _Sprite_Size4
	LDA _Sprite_Size4
	CMP #3
     BCC .skip38then
.condpart39
	LDA #0
	STA _Sprite_Size4
.skip38then
.skipL0100
.L0101 ;  if _Current_Object  =  _Sprite5 then _Sprite_Size5  =  _Sprite_Size5  +  1  :  if _Sprite_Size5  >=  3 then _Sprite_Size5  =  0

	LDA _Current_Object
	CMP #_Sprite5
     BNE .skipL0101
.condpart40
	INC _Sprite_Size5
	LDA _Sprite_Size5
	CMP #3
     BCC .skip40then
.condpart41
	LDA #0
	STA _Sprite_Size5
.skip40then
.skipL0101
.L0102 ;  if _Current_Object  =  _Missile0 then _Missile0_Width  =  _Missile0_Width  +  1  :  if _Missile0_Width  >=  4 then _Missile0_Width  =  0

	LDA _Current_Object
	CMP #_Missile0
     BNE .skipL0102
.condpart42
	INC _Missile0_Width
	LDA _Missile0_Width
	CMP #4
     BCC .skip42then
.condpart43
	LDA #0
	STA _Missile0_Width
.skip42then
.skipL0102
.L0103 ;  if _Current_Object  =  _Missile1 then _Missile1_Width  =  _Missile1_Width  +  1  :  if _Missile1_Width  >=  4 then _Missile1_Width  =  0

	LDA _Current_Object
	CMP #_Missile1
     BNE .skipL0103
.condpart44
	INC _Missile1_Width
	LDA _Missile1_Width
	CMP #4
     BCC .skip44then
.condpart45
	LDA #0
	STA _Missile1_Width
.skip44then
.skipL0103
.L0104 ;  if _Current_Object  =  _Ball then _Ball_Width  =  _Ball_Width  +  1  :  if _Ball_Width  >=  4 then _Ball_Width  =  0

	LDA _Current_Object
	CMP #_Ball
     BNE .skipL0104
.condpart46
	INC _Ball_Width
	LDA _Ball_Width
	CMP #4
     BCC .skip46then
.condpart47
	LDA #0
	STA _Ball_Width
.skip46then
.skipL0104
.
 ; 

.__Skip_Size_Increase
 ; __Skip_Size_Increase

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0105 ;  goto __Skip_Movement

 jmp .__Skip_Movement

.
 ; 

.__Skip_Fire_Button
 ; __Skip_Fire_Button

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

.
 ; 

.
 ; 

.L0106 ;  if _Current_Object  >  _Sprite0 then goto __Skip_Sprite0_Movement

	LDA #_Sprite0
	CMP _Current_Object
     BCS .skipL0106
.condpart48
 jmp .__Skip_Sprite0_Movement

.skipL0106
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0107 ;  if joy0up then if player0y  <=  81 then player0y  =  player0y  +  1

 lda #$10
 bit SWCHA
	BNE .skipL0107
.condpart49
	LDA #81
	CMP player0y
     BCC .skip49then
.condpart50
	INC player0y
.skip49then
.skipL0107
.
 ; 

.L0108 ;  if joy0down then if player0y  >=  2  +  player0height then player0y  =  player0y  -  1

 lda #$20
 bit SWCHA
	BNE .skipL0108
.condpart51
; complex condition detected
	LDA #2
	CLC
	ADC player0height
  PHA
  TSX
  PLA
	LDA player0y
	CMP  1,x
     BCC .skip51then
.condpart52
	DEC player0y
.skip51then
.skipL0108
.
 ; 

.L0109 ;  if joy0left then if player0x  >=  1 then player0x  =  player0x  -  1  :  _Bit3_Flip_p0{3}  =  0

 bit SWCHA
	BVS .skipL0109
.condpart53
	LDA player0x
	CMP #1
     BCC .skip53then
.condpart54
	DEC player0x
	LDA _Bit3_Flip_p0
	AND #247
	STA _Bit3_Flip_p0
.skip53then
.skipL0109
.
 ; 

.L0110 ;  if joy0right then temp5  =  _Data_Sprite0_Width[_Sprite_Size0]  :  if player0x  <=  temp5 then player0x  =  player0x  +  1  :  _Bit3_Flip_p0{3}  =  1

 bit SWCHA
	BMI .skipL0110
.condpart55
	LDX _Sprite_Size0
	LDA _Data_Sprite0_Width,x
	STA temp5
	LDA temp5
	CMP player0x
     BCC .skip55then
.condpart56
	INC player0x
	LDA _Bit3_Flip_p0
	ORA #8
	STA _Bit3_Flip_p0
.skip55then
.skipL0110
.
 ; 

.L0111 ;  goto __Skip_Movement

 jmp .__Skip_Movement

.
 ; 

.__Skip_Sprite0_Movement
 ; __Skip_Sprite0_Movement

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0112 ;  if _Current_Object  >  _Sprite1 then goto __Skip_Sprite1_Movement

	LDA #_Sprite1
	CMP _Current_Object
     BCS .skipL0112
.condpart57
 jmp .__Skip_Sprite1_Movement

.skipL0112
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0113 ;  if joy0up then if player1y  <=  75 then player1y  =  player1y  +  1

 lda #$10
 bit SWCHA
	BNE .skipL0113
.condpart58
	LDA #75
	CMP player1y
     BCC .skip58then
.condpart59
	INC player1y
.skip58then
.skipL0113
.
 ; 

.L0114 ;  if joy0down then if player1y  >=  player1height then player1y  =  player1y  -  1

 lda #$20
 bit SWCHA
	BNE .skipL0114
.condpart60
	LDA player1y
	CMP player1height
     BCC .skip60then
.condpart61
	DEC player1y
.skip60then
.skipL0114
.
 ; 

.L0115 ;  if joy0left then if player1x  >=  9 then player1x  =  player1x  -  1  :  _NUSIZ1{3}  =  0  :  _NUSIZ1{6}  =  0

 bit SWCHA
	BVS .skipL0115
.condpart62
	LDA player1x
	CMP #9
     BCC .skip62then
.condpart63
	DEC player1x
	LDA _NUSIZ1
	AND #247
	STA _NUSIZ1
	LDA _NUSIZ1
	AND #191
	STA _NUSIZ1
.skip62then
.skipL0115
.
 ; 

.L0116 ;  if joy0right then temp5  =  _Data_1to5_Width[_Sprite_Size1]  :  if player1x  <=  temp5 then player1x  =  player1x  +  1  :  _NUSIZ1{3}  =  1  :  _NUSIZ1{6}  =  1

 bit SWCHA
	BMI .skipL0116
.condpart64
	LDX _Sprite_Size1
	LDA _Data_1to5_Width,x
	STA temp5
	LDA temp5
	CMP player1x
     BCC .skip64then
.condpart65
	INC player1x
	LDA _NUSIZ1
	ORA #8
	STA _NUSIZ1
	LDA _NUSIZ1
	ORA #64
	STA _NUSIZ1
.skip64then
.skipL0116
.
 ; 

.L0117 ;  goto __Skip_Movement

 jmp .__Skip_Movement

.
 ; 

.__Skip_Sprite1_Movement
 ; __Skip_Sprite1_Movement

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0118 ;  if _Current_Object  >  _Sprite2 then goto __Skip_Sprite2_Movement

	LDA #_Sprite2
	CMP _Current_Object
     BCS .skipL0118
.condpart66
 jmp .__Skip_Sprite2_Movement

.skipL0118
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0119 ;  if joy0up then if player2y  <=  75 then player2y  =  player2y  +  1

 lda #$10
 bit SWCHA
	BNE .skipL0119
.condpart67
	LDA #75
	CMP player2y
     BCC .skip67then
.condpart68
	INC player2y
.skip67then
.skipL0119
.
 ; 

.L0120 ;  if joy0down then if player2y  >=  player2height then player2y  =  player2y  -  1

 lda #$20
 bit SWCHA
	BNE .skipL0120
.condpart69
	LDA player2y
	CMP player2height
     BCC .skip69then
.condpart70
	DEC player2y
.skip69then
.skipL0120
.
 ; 

.L0121 ;  if joy0left then if player2x  >=  9 then player2x  =  player2x  -  1  :  NUSIZ2{3}  =  0  :  NUSIZ2{6}  =  0

 bit SWCHA
	BVS .skipL0121
.condpart71
	LDA player2x
	CMP #9
     BCC .skip71then
.condpart72
	DEC player2x
	LDA NUSIZ2
	AND #247
	STA NUSIZ2
	LDA NUSIZ2
	AND #191
	STA NUSIZ2
.skip71then
.skipL0121
.
 ; 

.L0122 ;  if joy0right then temp5  =  _Data_1to5_Width[_Sprite_Size2]  :  if player2x  <=  temp5 then player2x  =  player2x  +  1  :  NUSIZ2{3}  =  1  :  NUSIZ2{6}  =  1

 bit SWCHA
	BMI .skipL0122
.condpart73
	LDX _Sprite_Size2
	LDA _Data_1to5_Width,x
	STA temp5
	LDA temp5
	CMP player2x
     BCC .skip73then
.condpart74
	INC player2x
	LDA NUSIZ2
	ORA #8
	STA NUSIZ2
	LDA NUSIZ2
	ORA #64
	STA NUSIZ2
.skip73then
.skipL0122
.
 ; 

.L0123 ;  goto __Skip_Movement

 jmp .__Skip_Movement

.
 ; 

.__Skip_Sprite2_Movement
 ; __Skip_Sprite2_Movement

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0124 ;  if _Current_Object  >  _Sprite3 then goto __Skip_Sprite3_Movement

	LDA #_Sprite3
	CMP _Current_Object
     BCS .skipL0124
.condpart75
 jmp .__Skip_Sprite3_Movement

.skipL0124
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0125 ;  if joy0up then if player3y  <=  75 then player3y  =  player3y  +  1

 lda #$10
 bit SWCHA
	BNE .skipL0125
.condpart76
	LDA #75
	CMP player3y
     BCC .skip76then
.condpart77
	INC player3y
.skip76then
.skipL0125
.
 ; 

.L0126 ;  if joy0down then if player3y  >=  player3height then player3y  =  player3y  -  1

 lda #$20
 bit SWCHA
	BNE .skipL0126
.condpart78
	LDA player3y
	CMP player3height
     BCC .skip78then
.condpart79
	DEC player3y
.skip78then
.skipL0126
.
 ; 

.L0127 ;  if joy0left then if player3x  >=  9 then player3x  =  player3x  -  1  :  NUSIZ3{3}  =  0  :  NUSIZ3{6}  =  0

 bit SWCHA
	BVS .skipL0127
.condpart80
	LDA player3x
	CMP #9
     BCC .skip80then
.condpart81
	DEC player3x
	LDA NUSIZ3
	AND #247
	STA NUSIZ3
	LDA NUSIZ3
	AND #191
	STA NUSIZ3
.skip80then
.skipL0127
.
 ; 

.L0128 ;  if joy0right then temp5  =  _Data_1to5_Width[_Sprite_Size3]  :  if player3x  <=  temp5 then player3x  =  player3x  +  1  :  NUSIZ3{3}  =  1  :  NUSIZ3{6}  =  1

 bit SWCHA
	BMI .skipL0128
.condpart82
	LDX _Sprite_Size3
	LDA _Data_1to5_Width,x
	STA temp5
	LDA temp5
	CMP player3x
     BCC .skip82then
.condpart83
	INC player3x
	LDA NUSIZ3
	ORA #8
	STA NUSIZ3
	LDA NUSIZ3
	ORA #64
	STA NUSIZ3
.skip82then
.skipL0128
.
 ; 

.L0129 ;  goto __Skip_Movement

 jmp .__Skip_Movement

.
 ; 

.__Skip_Sprite3_Movement
 ; __Skip_Sprite3_Movement

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0130 ;  if _Current_Object  >  _Sprite4 then goto __Skip_Sprite4_Movement

	LDA #_Sprite4
	CMP _Current_Object
     BCS .skipL0130
.condpart84
 jmp .__Skip_Sprite4_Movement

.skipL0130
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0131 ;  if joy0up then if player4y  <=  75 then player4y  =  player4y  +  1

 lda #$10
 bit SWCHA
	BNE .skipL0131
.condpart85
	LDA #75
	CMP player4y
     BCC .skip85then
.condpart86
	INC player4y
.skip85then
.skipL0131
.
 ; 

.L0132 ;  if joy0down then if player4y  >=  player4height then player4y  =  player4y  -  1

 lda #$20
 bit SWCHA
	BNE .skipL0132
.condpart87
	LDA player4y
	CMP player4height
     BCC .skip87then
.condpart88
	DEC player4y
.skip87then
.skipL0132
.
 ; 

.L0133 ;  if joy0left then if player4x  >=  9 then player4x  =  player4x  -  1  :  NUSIZ4{3}  =  0  :  NUSIZ4{6}  =  0

 bit SWCHA
	BVS .skipL0133
.condpart89
	LDA player4x
	CMP #9
     BCC .skip89then
.condpart90
	DEC player4x
	LDA NUSIZ4
	AND #247
	STA NUSIZ4
	LDA NUSIZ4
	AND #191
	STA NUSIZ4
.skip89then
.skipL0133
.
 ; 

.L0134 ;  if joy0right then temp5  =  _Data_1to5_Width[_Sprite_Size4]  :  if player4x  <=  temp5 then player4x  =  player4x  +  1  :  NUSIZ4{3}  =  1  :  NUSIZ4{6}  =  1

 bit SWCHA
	BMI .skipL0134
.condpart91
	LDX _Sprite_Size4
	LDA _Data_1to5_Width,x
	STA temp5
	LDA temp5
	CMP player4x
     BCC .skip91then
.condpart92
	INC player4x
	LDA NUSIZ4
	ORA #8
	STA NUSIZ4
	LDA NUSIZ4
	ORA #64
	STA NUSIZ4
.skip91then
.skipL0134
.
 ; 

.L0135 ;  goto __Skip_Movement

 jmp .__Skip_Movement

.
 ; 

.__Skip_Sprite4_Movement
 ; __Skip_Sprite4_Movement

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0136 ;  if _Current_Object  >  _Sprite5 then goto __Skip_Sprite5_Movement

	LDA #_Sprite5
	CMP _Current_Object
     BCS .skipL0136
.condpart93
 jmp .__Skip_Sprite5_Movement

.skipL0136
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0137 ;  if joy0up then if player5y  <=  75 then player5y  =  player5y  +  1

 lda #$10
 bit SWCHA
	BNE .skipL0137
.condpart94
	LDA #75
	CMP player5y
     BCC .skip94then
.condpart95
	INC player5y
.skip94then
.skipL0137
.
 ; 

.L0138 ;  if joy0down then if player5y  >=  player5height then player5y  =  player5y  -  1

 lda #$20
 bit SWCHA
	BNE .skipL0138
.condpart96
	LDA player5y
	CMP player5height
     BCC .skip96then
.condpart97
	DEC player5y
.skip96then
.skipL0138
.
 ; 

.L0139 ;  if joy0left then if player5x  >=  9 then player5x  =  player5x  -  1  :  NUSIZ5{3}  =  0  :  NUSIZ5{6}  =  0

 bit SWCHA
	BVS .skipL0139
.condpart98
	LDA player5x
	CMP #9
     BCC .skip98then
.condpart99
	DEC player5x
	LDA NUSIZ5
	AND #247
	STA NUSIZ5
	LDA NUSIZ5
	AND #191
	STA NUSIZ5
.skip98then
.skipL0139
.
 ; 

.L0140 ;  if joy0right then temp5  =  _Data_1to5_Width[_Sprite_Size5]  :  if player5x  <=  temp5 then player5x  =  player5x  +  1  :  NUSIZ5{3}  =  1  :  NUSIZ5{6}  =  1

 bit SWCHA
	BMI .skipL0140
.condpart100
	LDX _Sprite_Size5
	LDA _Data_1to5_Width,x
	STA temp5
	LDA temp5
	CMP player5x
     BCC .skip100then
.condpart101
	INC player5x
	LDA NUSIZ5
	ORA #8
	STA NUSIZ5
	LDA NUSIZ5
	ORA #64
	STA NUSIZ5
.skip100then
.skipL0140
.
 ; 

.L0141 ;  goto __Skip_Movement

 jmp .__Skip_Movement

.
 ; 

.__Skip_Sprite5_Movement
 ; __Skip_Sprite5_Movement

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0142 ;  if _Current_Object  <>  _Missile0 then goto __Skip_Missile0_Movement

	LDA _Current_Object
	CMP #_Missile0
     BEQ .skipL0142
.condpart102
 jmp .__Skip_Missile0_Movement

.skipL0142
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0143 ;  if joy0up then if missile0y  <=  79 then missile0y  =  missile0y  +  1

 lda #$10
 bit SWCHA
	BNE .skipL0143
.condpart103
	LDA #79
	CMP missile0y
     BCC .skip103then
.condpart104
	INC missile0y
.skip103then
.skipL0143
.
 ; 

.L0144 ;  if joy0down then if missile0y  >=  3 then missile0y  =  missile0y  -  1

 lda #$20
 bit SWCHA
	BNE .skipL0144
.condpart105
	LDA missile0y
	CMP #3
     BCC .skip105then
.condpart106
	DEC missile0y
.skip105then
.skipL0144
.
 ; 

.L0145 ;  if joy0left then if missile0x  >=  2 then missile0x  =  missile0x  -  1

 bit SWCHA
	BVS .skipL0145
.condpart107
	LDA missile0x
	CMP #2
     BCC .skip107then
.condpart108
	DEC missile0x
.skip107then
.skipL0145
.
 ; 

.L0146 ;  if joy0right then temp5  =  _Data_M_B_x_Size[_Missile0_Width]  :  if missile0x  <=  temp5 then missile0x  =  missile0x  +  1

 bit SWCHA
	BMI .skipL0146
.condpart109
	LDX _Missile0_Width
	LDA _Data_M_B_x_Size,x
	STA temp5
	LDA temp5
	CMP missile0x
     BCC .skip109then
.condpart110
	INC missile0x
.skip109then
.skipL0146
.
 ; 

.L0147 ;  goto __Skip_Movement

 jmp .__Skip_Movement

.
 ; 

.__Skip_Missile0_Movement
 ; __Skip_Missile0_Movement

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0148 ;  if _Current_Object  <>  _Missile1 then goto __Skip_Missile1_Movement

	LDA _Current_Object
	CMP #_Missile1
     BEQ .skipL0148
.condpart111
 jmp .__Skip_Missile1_Movement

.skipL0148
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0149 ;  if joy0up then if missile1y  <=  79 then missile1y  =  missile1y  +  1

 lda #$10
 bit SWCHA
	BNE .skipL0149
.condpart112
	LDA #79
	CMP missile1y
     BCC .skip112then
.condpart113
	INC missile1y
.skip112then
.skipL0149
.
 ; 

.L0150 ;  if joy0down then if missile1y  >=  3 then missile1y  =  missile1y  -  1

 lda #$20
 bit SWCHA
	BNE .skipL0150
.condpart114
	LDA missile1y
	CMP #3
     BCC .skip114then
.condpart115
	DEC missile1y
.skip114then
.skipL0150
.
 ; 

.L0151 ;  if joy0left then if missile1x  >=  2 then missile1x  =  missile1x  -  1

 bit SWCHA
	BVS .skipL0151
.condpart116
	LDA missile1x
	CMP #2
     BCC .skip116then
.condpart117
	DEC missile1x
.skip116then
.skipL0151
.
 ; 

.L0152 ;  if joy0right then temp5  =  _Data_M_B_x_Size[_Missile1_Width]  :  if missile1x  <=  temp5 then missile1x  =  missile1x  +  1

 bit SWCHA
	BMI .skipL0152
.condpart118
	LDX _Missile1_Width
	LDA _Data_M_B_x_Size,x
	STA temp5
	LDA temp5
	CMP missile1x
     BCC .skip118then
.condpart119
	INC missile1x
.skip118then
.skipL0152
.
 ; 

.L0153 ;  goto __Skip_Movement

 jmp .__Skip_Movement

.
 ; 

.__Skip_Missile1_Movement
 ; __Skip_Missile1_Movement

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0154 ;  if _Current_Object  <>  _Ball then goto __Skip_Movement

	LDA _Current_Object
	CMP #_Ball
     BEQ .skipL0154
.condpart120
 jmp .__Skip_Movement

.skipL0154
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0155 ;  if joy0up then if bally  <=  79 then bally  =  bally  +  1

 lda #$10
 bit SWCHA
	BNE .skipL0155
.condpart121
	LDA #79
	CMP bally
     BCC .skip121then
.condpart122
	INC bally
.skip121then
.skipL0155
.
 ; 

.L0156 ;  if joy0down then if bally  >=  3 then bally  =  bally  -  1

 lda #$20
 bit SWCHA
	BNE .skipL0156
.condpart123
	LDA bally
	CMP #3
     BCC .skip123then
.condpart124
	DEC bally
.skip123then
.skipL0156
.
 ; 

.L0157 ;  if joy0left then if ballx  >=  2 then ballx  =  ballx  -  1

 bit SWCHA
	BVS .skipL0157
.condpart125
	LDA ballx
	CMP #2
     BCC .skip125then
.condpart126
	DEC ballx
.skip125then
.skipL0157
.
 ; 

.L0158 ;  if joy0right then temp5  =  _Data_M_B_x_Size[_Ball_Width] :  if ballx  <=  temp5 then ballx  =  ballx  +  1

 bit SWCHA
	BMI .skipL0158
.condpart127
	LDX _Ball_Width
	LDA _Data_M_B_x_Size,x
	STA temp5
	LDA temp5
	CMP ballx
     BCC .skip127then
.condpart128
	INC ballx
.skip127then
.skipL0158
.
 ; 

.__Skip_Movement
 ; __Skip_Movement

.
 ; 

.
 ; 

.
 ; 

.L0159 ;  goto __Bank_2 bank2

 sta temp7
 lda #>(.__Bank_2-1)
 pha
 lda #<(.__Bank_2-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #2
 jmp BS_jsr
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

.
 ; 

.L0160 ;  data _Data_M_B_x_Size

	JMP .skipL0160
_Data_M_B_x_Size
	.byte    158, 157, 155, 151

.skipL0160
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

.L0161 ;  data _Data_Sprite0_Width

	JMP .skipL0161
_Data_Sprite0_Width
	.byte    150, 141, 125

.skipL0161
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

.L0162 ;  data _Data_1to5_Width

	JMP .skipL0162
_Data_1to5_Width
	.byte    158, 150, 134

.skipL0162
.
 ; 

.
 ; 

.
 ; 

.L0163 ;  bank 2

 if ECHO1
 echo "    ",[(start_bank1 - *)]d , "bytes of ROM space left in bank 1")
 endif
ECHO1 = 1
 ORG $1FF4-bscode_length
 RORG $9FF4-bscode_length
start_bank1 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif 
 txs
 if bankswitch == 64
   lda #(((>(start-1)) & $0F) | $F0)
 else
   lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha
 pha
 txa
 pha
 tsx
 if bankswitch != 64
   lda 4,x ; get high byte of return address
   rol
   rol
   rol
   rol
   and #bs_mask ;1 3 or 7 for F8/F6/F4
   tax
   inx
 else
   lda 4,x ; get high byte of return address
   tay
   ora #$10 ; change our bank nibble into a valid rom mirror
   sta 4,x
   tya
   lsr 
   lsr 
   lsr 
   lsr 
   tax
   inx
 endif
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
   echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
   echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif
 ORG $1FFC
 RORG $9FFC
 .word (start_bank1 & $ffff)
 .word (start_bank1 & $ffff)
 ORG $2000
 RORG $B000
.
 ; 

.
 ; 

.
 ; 

.__Bank_2
 ; __Bank_2

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

.L0164 ;  if _Bit3_Flip_p0{3} then REFP0  =  8

	LDA _Bit3_Flip_p0
	AND #8
	BEQ .skipL0164
.condpart129
	LDA #8
	STA REFP0
.skipL0164
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

.
 ; 

.
 ; 

.L0165 ;  _P0_NUSIZ  =  _P0_NUSIZ  &  %11111000

	LDA _P0_NUSIZ
	AND #%11111000
	STA _P0_NUSIZ
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0166 ;  _P0_NUSIZ  =  _P0_NUSIZ  |  _Data_Sprite_Size[_Sprite_Size0]

	LDA _P0_NUSIZ
	LDX _Sprite_Size0
	ORA _Data_Sprite_Size,x
	STA _P0_NUSIZ
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0167 ;  NUSIZ0  =  _P0_NUSIZ

	LDA _P0_NUSIZ
	STA NUSIZ0
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

.L0168 ;  _NUSIZ1  =  _NUSIZ1  &  %11111000  :  _NUSIZ1  =  _NUSIZ1  |  _Data_Sprite_Size[_Sprite_Size1]

	LDA _NUSIZ1
	AND #%11111000
	STA _NUSIZ1
	LDA _NUSIZ1
	LDX _Sprite_Size1
	ORA _Data_Sprite_Size,x
	STA _NUSIZ1
.L0169 ;  NUSIZ2  =  NUSIZ2  &  %11111000  :  NUSIZ2  =  NUSIZ2  |  _Data_Sprite_Size[_Sprite_Size2]

	LDA NUSIZ2
	AND #%11111000
	STA NUSIZ2
	LDA NUSIZ2
	LDX _Sprite_Size2
	ORA _Data_Sprite_Size,x
	STA NUSIZ2
.L0170 ;  NUSIZ3  =  NUSIZ3  &  %11111000  :  NUSIZ3  =  NUSIZ3  |  _Data_Sprite_Size[_Sprite_Size3]

	LDA NUSIZ3
	AND #%11111000
	STA NUSIZ3
	LDA NUSIZ3
	LDX _Sprite_Size3
	ORA _Data_Sprite_Size,x
	STA NUSIZ3
.L0171 ;  NUSIZ4  =  NUSIZ4  &  %11111000  :  NUSIZ4  =  NUSIZ4  |  _Data_Sprite_Size[_Sprite_Size4]

	LDA NUSIZ4
	AND #%11111000
	STA NUSIZ4
	LDA NUSIZ4
	LDX _Sprite_Size4
	ORA _Data_Sprite_Size,x
	STA NUSIZ4
.L0172 ;  NUSIZ5  =  NUSIZ5  &  %11111000  :  NUSIZ5  =  NUSIZ5  |  _Data_Sprite_Size[_Sprite_Size5]

	LDA NUSIZ5
	AND #%11111000
	STA NUSIZ5
	LDA NUSIZ5
	LDX _Sprite_Size5
	ORA _Data_Sprite_Size,x
	STA NUSIZ5
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

.
 ; 

.
 ; 

.L0173 ;  _P0_NUSIZ  =  _P0_NUSIZ  &  %11001111

	LDA _P0_NUSIZ
	AND #%11001111
	STA _P0_NUSIZ
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0174 ;  _P0_NUSIZ  =  _P0_NUSIZ  |  _Data_MB_Width[_Missile0_Width]

	LDA _P0_NUSIZ
	LDX _Missile0_Width
	ORA _Data_MB_Width,x
	STA _P0_NUSIZ
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0175 ;  NUSIZ0  =  _P0_NUSIZ

	LDA _P0_NUSIZ
	STA NUSIZ0
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

.
 ; 

.
 ; 

.L0176 ;  temp5  =  _Data_MB_Width[_Missile1_Width]

	LDX _Missile1_Width
	LDA _Data_MB_Width,x
	STA temp5
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

.L0177 ;  NUSIZ1  =  NUSIZ1  &  %11001111  :  NUSIZ1  =  NUSIZ1  |  temp5

	LDA NUSIZ1
	AND #%11001111
	STA NUSIZ1
	LDA NUSIZ1
	ORA temp5
	STA NUSIZ1
.L0178 ;  _NUSIZ1  =  _NUSIZ1  &  %11001111  :  _NUSIZ1  =  _NUSIZ1  |  temp5

	LDA _NUSIZ1
	AND #%11001111
	STA _NUSIZ1
	LDA _NUSIZ1
	ORA temp5
	STA _NUSIZ1
.L0179 ;  NUSIZ2  =  NUSIZ2  &  %11001111  :  NUSIZ2  =  NUSIZ2  |  temp5

	LDA NUSIZ2
	AND #%11001111
	STA NUSIZ2
	LDA NUSIZ2
	ORA temp5
	STA NUSIZ2
.L0180 ;  NUSIZ3  =  NUSIZ3  &  %11001111  :  NUSIZ3  =  NUSIZ3  |  temp5

	LDA NUSIZ3
	AND #%11001111
	STA NUSIZ3
	LDA NUSIZ3
	ORA temp5
	STA NUSIZ3
.L0181 ;  NUSIZ4  =  NUSIZ4  &  %11001111  :  NUSIZ4  =  NUSIZ4  |  temp5

	LDA NUSIZ4
	AND #%11001111
	STA NUSIZ4
	LDA NUSIZ4
	ORA temp5
	STA NUSIZ4
.L0182 ;  NUSIZ5  =  NUSIZ5  &  %11001111  :  NUSIZ5  =  NUSIZ5  |  temp5

	LDA NUSIZ5
	AND #%11001111
	STA NUSIZ5
	LDA NUSIZ5
	ORA temp5
	STA NUSIZ5
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

.
 ; 

.
 ; 

.L0183 ;  CTRLPF  =  _Data_MB_Width[_Ball_Width]  +  1

	LDX _Ball_Width
	LDA _Data_MB_Width,x
	CLC
	ADC #1
	STA CTRLPF
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

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0184 ;  if !_Bit2_Activate_Jiggle{2} then goto __Skip_Object_Jiggle

	LDA _Bit2_Activate_Jiggle
	AND #4
	BNE .skipL0184
.condpart130
 jmp .__Skip_Object_Jiggle

.skipL0184
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0185 ;  if _Jiggle_Counter  >=  1 then goto __Skip_Memory

	LDA _Jiggle_Counter
	CMP #1
     BCC .skipL0185
.condpart131
 jmp .__Skip_Memory

.skipL0185
.L0186 ;  if _Current_Object  =  _Sprite0 then _Memx  =  player0x  :  _Memy  =  player0y  :  TextIndex  =  p0_text

	LDA _Current_Object
	CMP #_Sprite0
     BNE .skipL0186
.condpart132
	LDA player0x
	STA _Memx
	LDA player0y
	STA _Memy
	LDA #p0_text
	STA TextIndex
.skipL0186
.L0187 ;  if _Current_Object  =  _Sprite1 then _Memx  =  player1x  :  _Memy  =  player1y  :  TextIndex  =  p1_text

	LDA _Current_Object
	CMP #_Sprite1
     BNE .skipL0187
.condpart133
	LDA player1x
	STA _Memx
	LDA player1y
	STA _Memy
	LDA #p1_text
	STA TextIndex
.skipL0187
.L0188 ;  if _Current_Object  =  _Sprite2 then _Memx  =  player2x  :  _Memy  =  player2y  :  TextIndex  =  p2_text

	LDA _Current_Object
	CMP #_Sprite2
     BNE .skipL0188
.condpart134
	LDA player2x
	STA _Memx
	LDA player2y
	STA _Memy
	LDA #p2_text
	STA TextIndex
.skipL0188
.L0189 ;  if _Current_Object  =  _Sprite3 then _Memx  =  player3x  :  _Memy  =  player3y  :  TextIndex  =  p3_text

	LDA _Current_Object
	CMP #_Sprite3
     BNE .skipL0189
.condpart135
	LDA player3x
	STA _Memx
	LDA player3y
	STA _Memy
	LDA #p3_text
	STA TextIndex
.skipL0189
.L0190 ;  if _Current_Object  =  _Sprite4 then _Memx  =  player4x  :  _Memy  =  player4y  :  TextIndex  =  p4_text

	LDA _Current_Object
	CMP #_Sprite4
     BNE .skipL0190
.condpart136
	LDA player4x
	STA _Memx
	LDA player4y
	STA _Memy
	LDA #p4_text
	STA TextIndex
.skipL0190
.L0191 ;  if _Current_Object  =  _Sprite5 then _Memx  =  player5x  :  _Memy  =  player5y  :  TextIndex  =  p5_text

	LDA _Current_Object
	CMP #_Sprite5
     BNE .skipL0191
.condpart137
	LDA player5x
	STA _Memx
	LDA player5y
	STA _Memy
	LDA #p5_text
	STA TextIndex
.skipL0191
.L0192 ;  if _Current_Object  =  _Missile0 then _Memx  =  missile0x  :  _Memy  =  missile0y  :  TextIndex  =  m0_text

	LDA _Current_Object
	CMP #_Missile0
     BNE .skipL0192
.condpart138
	LDA missile0x
	STA _Memx
	LDA missile0y
	STA _Memy
	LDA #m0_text
	STA TextIndex
.skipL0192
.L0193 ;  if _Current_Object  =  _Missile1 then _Memx  =  missile1x  :  _Memy  =  missile1y  :  TextIndex  =  m1_text

	LDA _Current_Object
	CMP #_Missile1
     BNE .skipL0193
.condpart139
	LDA missile1x
	STA _Memx
	LDA missile1y
	STA _Memy
	LDA #m1_text
	STA TextIndex
.skipL0193
.L0194 ;  if _Current_Object  =  _Ball then _Memx  =  ballx  :  _Memy  =  bally  :  TextIndex  =  ball_text

	LDA _Current_Object
	CMP #_Ball
     BNE .skipL0194
.condpart140
	LDA ballx
	STA _Memx
	LDA bally
	STA _Memy
	LDA #ball_text
	STA TextIndex
.skipL0194
.
 ; 

.__Skip_Memory
 ; __Skip_Memory

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0195 ;  _Jiggle_Counter  =  _Jiggle_Counter  +  1

	INC _Jiggle_Counter
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0196 ;  if _Current_Object  =  _Sprite0 then temp5  =  255  +   ( rand & 3 )   :  player0x  =  player0x  +  temp5 :  temp5  =  255  +   ( rand & 3 )   :  player0y  =  player0y  +  temp5

	LDA _Current_Object
	CMP #_Sprite0
     BNE .skipL0196
.condpart141
; complex statement detected
	LDA #255
	PHA
 sta temp7
 lda #>(ret_point2-1)
 pha
 lda #<(ret_point2-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point2
	AND #3
	TSX
	INX
	TXS
	CLC
	ADC $00,x
	STA temp5
	LDA player0x
	CLC
	ADC temp5
	STA player0x
; complex statement detected
	LDA #255
	PHA
 sta temp7
 lda #>(ret_point3-1)
 pha
 lda #<(ret_point3-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point3
	AND #3
	TSX
	INX
	TXS
	CLC
	ADC $00,x
	STA temp5
	LDA player0y
	CLC
	ADC temp5
	STA player0y
.skipL0196
.L0197 ;  if _Current_Object  =  _Sprite1 then temp5  =  255  +   ( rand & 3 )   :  player1x  =  player1x  +  temp5 :  temp5  =  255  +   ( rand & 3 )   :  player1y  =  player1y  +  temp5

	LDA _Current_Object
	CMP #_Sprite1
     BNE .skipL0197
.condpart142
; complex statement detected
	LDA #255
	PHA
 sta temp7
 lda #>(ret_point4-1)
 pha
 lda #<(ret_point4-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point4
	AND #3
	TSX
	INX
	TXS
	CLC
	ADC $00,x
	STA temp5
	LDA player1x
	CLC
	ADC temp5
	STA player1x
; complex statement detected
	LDA #255
	PHA
 sta temp7
 lda #>(ret_point5-1)
 pha
 lda #<(ret_point5-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point5
	AND #3
	TSX
	INX
	TXS
	CLC
	ADC $00,x
	STA temp5
	LDA player1y
	CLC
	ADC temp5
	STA player1y
.skipL0197
.L0198 ;  if _Current_Object  =  _Sprite2 then temp5  =  255  +   ( rand & 3 )   :  player2x  =  player2x  +  temp5 :  temp5  =  255  +   ( rand & 3 )   :  player2y  =  player2y  +  temp5

	LDA _Current_Object
	CMP #_Sprite2
     BNE .skipL0198
.condpart143
; complex statement detected
	LDA #255
	PHA
 sta temp7
 lda #>(ret_point6-1)
 pha
 lda #<(ret_point6-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point6
	AND #3
	TSX
	INX
	TXS
	CLC
	ADC $00,x
	STA temp5
	LDA player2x
	CLC
	ADC temp5
	STA player2x
; complex statement detected
	LDA #255
	PHA
 sta temp7
 lda #>(ret_point7-1)
 pha
 lda #<(ret_point7-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point7
	AND #3
	TSX
	INX
	TXS
	CLC
	ADC $00,x
	STA temp5
	LDA player2y
	CLC
	ADC temp5
	STA player2y
.skipL0198
.L0199 ;  if _Current_Object  =  _Sprite3 then temp5  =  255  +   ( rand & 3 )   :  player3x  =  player3x  +  temp5 :  temp5  =  255  +   ( rand & 3 )   :  player3y  =  player3y  +  temp5

	LDA _Current_Object
	CMP #_Sprite3
     BNE .skipL0199
.condpart144
; complex statement detected
	LDA #255
	PHA
 sta temp7
 lda #>(ret_point8-1)
 pha
 lda #<(ret_point8-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point8
	AND #3
	TSX
	INX
	TXS
	CLC
	ADC $00,x
	STA temp5
	LDA player3x
	CLC
	ADC temp5
	STA player3x
; complex statement detected
	LDA #255
	PHA
 sta temp7
 lda #>(ret_point9-1)
 pha
 lda #<(ret_point9-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point9
	AND #3
	TSX
	INX
	TXS
	CLC
	ADC $00,x
	STA temp5
	LDA player3y
	CLC
	ADC temp5
	STA player3y
.skipL0199
.L0200 ;  if _Current_Object  =  _Sprite4 then temp5  =  255  +   ( rand & 3 )   :  player4x  =  player4x  +  temp5 :  temp5  =  255  +   ( rand & 3 )   :  player4y  =  player4y  +  temp5

	LDA _Current_Object
	CMP #_Sprite4
     BNE .skipL0200
.condpart145
; complex statement detected
	LDA #255
	PHA
 sta temp7
 lda #>(ret_point10-1)
 pha
 lda #<(ret_point10-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point10
	AND #3
	TSX
	INX
	TXS
	CLC
	ADC $00,x
	STA temp5
	LDA player4x
	CLC
	ADC temp5
	STA player4x
; complex statement detected
	LDA #255
	PHA
 sta temp7
 lda #>(ret_point11-1)
 pha
 lda #<(ret_point11-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point11
	AND #3
	TSX
	INX
	TXS
	CLC
	ADC $00,x
	STA temp5
	LDA player4y
	CLC
	ADC temp5
	STA player4y
.skipL0200
.L0201 ;  if _Current_Object  =  _Sprite5 then temp5  =  255  +   ( rand & 3 )   :  player5x  =  player5x  +  temp5 :  temp5  =  255  +   ( rand & 3 )   :  player5y  =  player5y  +  temp5

	LDA _Current_Object
	CMP #_Sprite5
     BNE .skipL0201
.condpart146
; complex statement detected
	LDA #255
	PHA
 sta temp7
 lda #>(ret_point12-1)
 pha
 lda #<(ret_point12-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point12
	AND #3
	TSX
	INX
	TXS
	CLC
	ADC $00,x
	STA temp5
	LDA player5x
	CLC
	ADC temp5
	STA player5x
; complex statement detected
	LDA #255
	PHA
 sta temp7
 lda #>(ret_point13-1)
 pha
 lda #<(ret_point13-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point13
	AND #3
	TSX
	INX
	TXS
	CLC
	ADC $00,x
	STA temp5
	LDA player5y
	CLC
	ADC temp5
	STA player5y
.skipL0201
.L0202 ;  if _Current_Object  =  _Missile0 then temp5  =  255  +   ( rand & 3 )   :  missile0x  =  missile0x  +  temp5 :  temp5  =  255  +   ( rand & 3 )   :  missile0y  =  missile0y  +  temp5

	LDA _Current_Object
	CMP #_Missile0
     BNE .skipL0202
.condpart147
; complex statement detected
	LDA #255
	PHA
 sta temp7
 lda #>(ret_point14-1)
 pha
 lda #<(ret_point14-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point14
	AND #3
	TSX
	INX
	TXS
	CLC
	ADC $00,x
	STA temp5
	LDA missile0x
	CLC
	ADC temp5
	STA missile0x
; complex statement detected
	LDA #255
	PHA
 sta temp7
 lda #>(ret_point15-1)
 pha
 lda #<(ret_point15-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point15
	AND #3
	TSX
	INX
	TXS
	CLC
	ADC $00,x
	STA temp5
	LDA missile0y
	CLC
	ADC temp5
	STA missile0y
.skipL0202
.L0203 ;  if _Current_Object  =  _Missile1 then temp5  =  255  +   ( rand & 3 )   :  missile1x  =  missile1x  +  temp5 :  temp5  =  255  +   ( rand & 3 )   :  missile1y  =  missile1y  +  temp5

	LDA _Current_Object
	CMP #_Missile1
     BNE .skipL0203
.condpart148
; complex statement detected
	LDA #255
	PHA
 sta temp7
 lda #>(ret_point16-1)
 pha
 lda #<(ret_point16-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point16
	AND #3
	TSX
	INX
	TXS
	CLC
	ADC $00,x
	STA temp5
	LDA missile1x
	CLC
	ADC temp5
	STA missile1x
; complex statement detected
	LDA #255
	PHA
 sta temp7
 lda #>(ret_point17-1)
 pha
 lda #<(ret_point17-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point17
	AND #3
	TSX
	INX
	TXS
	CLC
	ADC $00,x
	STA temp5
	LDA missile1y
	CLC
	ADC temp5
	STA missile1y
.skipL0203
.L0204 ;  if _Current_Object  =  _Ball then temp5  =  255  +   ( rand & 3 )   :  ballx  =  ballx  +  temp5 :  temp5  =  255  +   ( rand & 3 )   :  bally  =  bally  +  temp5

	LDA _Current_Object
	CMP #_Ball
     BNE .skipL0204
.condpart149
; complex statement detected
	LDA #255
	PHA
 sta temp7
 lda #>(ret_point18-1)
 pha
 lda #<(ret_point18-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point18
	AND #3
	TSX
	INX
	TXS
	CLC
	ADC $00,x
	STA temp5
	LDA ballx
	CLC
	ADC temp5
	STA ballx
; complex statement detected
	LDA #255
	PHA
 sta temp7
 lda #>(ret_point19-1)
 pha
 lda #<(ret_point19-1)
 pha
 lda #>(randomize-1)
 pha
 lda #<(randomize-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point19
	AND #3
	TSX
	INX
	TXS
	CLC
	ADC $00,x
	STA temp5
	LDA bally
	CLC
	ADC temp5
	STA bally
.skipL0204
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

.L0205 ;  if _Jiggle_Counter  <=  4 then goto __Skip_Object_Jiggle

	LDA #4
	CMP _Jiggle_Counter
     BCC .skipL0205
.condpart150
 jmp .__Skip_Object_Jiggle

.skipL0205
.
 ; 

.L0206 ;  _Bit2_Activate_Jiggle{2}  =  0  :  _Jiggle_Counter  =  0

	LDA _Bit2_Activate_Jiggle
	AND #251
	STA _Bit2_Activate_Jiggle
	LDA #0
	STA _Jiggle_Counter
.
 ; 

.L0207 ;  if _Current_Object  =  _Sprite0 then player0x  =  _Memx  :  player0y  =  _Memy

	LDA _Current_Object
	CMP #_Sprite0
     BNE .skipL0207
.condpart151
	LDA _Memx
	STA player0x
	LDA _Memy
	STA player0y
.skipL0207
.L0208 ;  if _Current_Object  =  _Sprite1 then player1x  =  _Memx  :  player1y  =  _Memy

	LDA _Current_Object
	CMP #_Sprite1
     BNE .skipL0208
.condpart152
	LDA _Memx
	STA player1x
	LDA _Memy
	STA player1y
.skipL0208
.L0209 ;  if _Current_Object  =  _Sprite2 then player2x  =  _Memx  :  player2y  =  _Memy

	LDA _Current_Object
	CMP #_Sprite2
     BNE .skipL0209
.condpart153
	LDA _Memx
	STA player2x
	LDA _Memy
	STA player2y
.skipL0209
.L0210 ;  if _Current_Object  =  _Sprite3 then player3x  =  _Memx  :  player3y  =  _Memy

	LDA _Current_Object
	CMP #_Sprite3
     BNE .skipL0210
.condpart154
	LDA _Memx
	STA player3x
	LDA _Memy
	STA player3y
.skipL0210
.L0211 ;  if _Current_Object  =  _Sprite4 then player4x  =  _Memx  :  player4y  =  _Memy

	LDA _Current_Object
	CMP #_Sprite4
     BNE .skipL0211
.condpart155
	LDA _Memx
	STA player4x
	LDA _Memy
	STA player4y
.skipL0211
.L0212 ;  if _Current_Object  =  _Sprite5 then player5x  =  _Memx  :  player5y  =  _Memy

	LDA _Current_Object
	CMP #_Sprite5
     BNE .skipL0212
.condpart156
	LDA _Memx
	STA player5x
	LDA _Memy
	STA player5y
.skipL0212
.L0213 ;  if _Current_Object  =  _Missile0 then missile0x  =  _Memx  :  missile0y  =  _Memy

	LDA _Current_Object
	CMP #_Missile0
     BNE .skipL0213
.condpart157
	LDA _Memx
	STA missile0x
	LDA _Memy
	STA missile0y
.skipL0213
.L0214 ;  if _Current_Object  =  _Missile1 then missile1x  =  _Memx  :  missile1y  =  _Memy

	LDA _Current_Object
	CMP #_Missile1
     BNE .skipL0214
.condpart158
	LDA _Memx
	STA missile1x
	LDA _Memy
	STA missile1y
.skipL0214
.L0215 ;  if _Current_Object  =  _Ball then ballx  =  _Memx  :  bally  =  _Memy

	LDA _Current_Object
	CMP #_Ball
     BNE .skipL0215
.condpart159
	LDA _Memx
	STA ballx
	LDA _Memy
	STA bally
.skipL0215
.
 ; 

.__Skip_Object_Jiggle
 ; __Skip_Object_Jiggle

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

.L0216 ;  if _Current_Object  =  _Sprite0 then scorecolor  =  $08  :  temp4  =  player0x

	LDA _Current_Object
	CMP #_Sprite0
     BNE .skipL0216
.condpart160
	LDA #$08
	STA scorecolor
	LDA player0x
	STA temp4
.skipL0216
.L0217 ;  if _Current_Object  =  _Sprite1 then scorecolor  =  $1A  :  temp4  =  player1x

	LDA _Current_Object
	CMP #_Sprite1
     BNE .skipL0217
.condpart161
	LDA #$1A
	STA scorecolor
	LDA player1x
	STA temp4
.skipL0217
.L0218 ;  if _Current_Object  =  _Sprite2 then scorecolor  =  $3A  :  temp4  =  player2x

	LDA _Current_Object
	CMP #_Sprite2
     BNE .skipL0218
.condpart162
	LDA #$3A
	STA scorecolor
	LDA player2x
	STA temp4
.skipL0218
.L0219 ;  if _Current_Object  =  _Sprite3 then scorecolor  =  $6A  :  temp4  =  player3x

	LDA _Current_Object
	CMP #_Sprite3
     BNE .skipL0219
.condpart163
	LDA #$6A
	STA scorecolor
	LDA player3x
	STA temp4
.skipL0219
.L0220 ;  if _Current_Object  =  _Sprite4 then scorecolor  =  $8A  :  temp4  =  player4x

	LDA _Current_Object
	CMP #_Sprite4
     BNE .skipL0220
.condpart164
	LDA #$8A
	STA scorecolor
	LDA player4x
	STA temp4
.skipL0220
.L0221 ;  if _Current_Object  =  _Sprite5 then scorecolor  =  $CA  :  temp4  =  player5x

	LDA _Current_Object
	CMP #_Sprite5
     BNE .skipL0221
.condpart165
	LDA #$CA
	STA scorecolor
	LDA player5x
	STA temp4
.skipL0221
.L0222 ;  if _Current_Object  =  _Missile0 then scorecolor  =  $5A  :  temp4  =  missile0x

	LDA _Current_Object
	CMP #_Missile0
     BNE .skipL0222
.condpart166
	LDA #$5A
	STA scorecolor
	LDA missile0x
	STA temp4
.skipL0222
.L0223 ;  if _Current_Object  =  _Missile1 then scorecolor  =  $BA  :  temp4  =  missile1x

	LDA _Current_Object
	CMP #_Missile1
     BNE .skipL0223
.condpart167
	LDA #$BA
	STA scorecolor
	LDA missile1x
	STA temp4
.skipL0223
.L0224 ;  if _Current_Object  =  _Ball then scorecolor  =  $4A  :  temp4  =  ballx

	LDA _Current_Object
	CMP #_Ball
     BNE .skipL0224
.condpart168
	LDA #$4A
	STA scorecolor
	LDA ballx
	STA temp4
.skipL0224
.
 ; 

.L0225 ;  _sc1  =  0  :  _sc2  =  _sc2  &  15

	LDA #0
	STA _sc1
	LDA _sc2
	AND #15
	STA _sc2
.L0226 ;  if temp4  >=  100 then _sc1  =  _sc1  +  16  :  temp4  =  temp4  -  100

	LDA temp4
	CMP #100
     BCC .skipL0226
.condpart169
	LDA _sc1
	CLC
	ADC #16
	STA _sc1
	LDA temp4
	SEC
	SBC #100
	STA temp4
.skipL0226
.L0227 ;  if temp4  >=  100 then _sc1  =  _sc1  +  16  :  temp4  =  temp4  -  100

	LDA temp4
	CMP #100
     BCC .skipL0227
.condpart170
	LDA _sc1
	CLC
	ADC #16
	STA _sc1
	LDA temp4
	SEC
	SBC #100
	STA temp4
.skipL0227
.L0228 ;  if temp4  >=  50 then _sc1  =  _sc1  +  5  :  temp4  =  temp4  -  50

	LDA temp4
	CMP #50
     BCC .skipL0228
.condpart171
	LDA _sc1
	CLC
	ADC #5
	STA _sc1
	LDA temp4
	SEC
	SBC #50
	STA temp4
.skipL0228
.L0229 ;  if temp4  >=  30 then _sc1  =  _sc1  +  3  :  temp4  =  temp4  -  30

	LDA temp4
	CMP #30
     BCC .skipL0229
.condpart172
	LDA _sc1
	CLC
	ADC #3
	STA _sc1
	LDA temp4
	SEC
	SBC #30
	STA temp4
.skipL0229
.L0230 ;  if temp4  >=  20 then _sc1  =  _sc1  +  2  :  temp4  =  temp4  -  20

	LDA temp4
	CMP #20
     BCC .skipL0230
.condpart173
	LDA _sc1
	CLC
	ADC #2
	STA _sc1
	LDA temp4
	SEC
	SBC #20
	STA temp4
.skipL0230
.L0231 ;  if temp4  >=  10 then _sc1  =  _sc1  +  1  :  temp4  =  temp4  -  10

	LDA temp4
	CMP #10
     BCC .skipL0231
.condpart174
	INC _sc1
	LDA temp4
	SEC
	SBC #10
	STA temp4
.skipL0231
.L0232 ;  _sc2  =   ( temp4  *  4  *  4 )   |  _sc2

; complex statement detected
	LDA temp4
	asl
	asl
	asl
	asl
	ORA _sc2
	STA _sc2
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

.L0233 ;  if _Current_Object  =  _Sprite0 then temp4  =  player0y

	LDA _Current_Object
	CMP #_Sprite0
     BNE .skipL0233
.condpart175
	LDA player0y
	STA temp4
.skipL0233
.L0234 ;  if _Current_Object  =  _Sprite1 then temp4  =  player1y

	LDA _Current_Object
	CMP #_Sprite1
     BNE .skipL0234
.condpart176
	LDA player1y
	STA temp4
.skipL0234
.L0235 ;  if _Current_Object  =  _Sprite2 then temp4  =  player2y

	LDA _Current_Object
	CMP #_Sprite2
     BNE .skipL0235
.condpart177
	LDA player2y
	STA temp4
.skipL0235
.L0236 ;  if _Current_Object  =  _Sprite3 then temp4  =  player3y

	LDA _Current_Object
	CMP #_Sprite3
     BNE .skipL0236
.condpart178
	LDA player3y
	STA temp4
.skipL0236
.L0237 ;  if _Current_Object  =  _Sprite4 then temp4  =  player4y

	LDA _Current_Object
	CMP #_Sprite4
     BNE .skipL0237
.condpart179
	LDA player4y
	STA temp4
.skipL0237
.L0238 ;  if _Current_Object  =  _Sprite5 then temp4  =  player5y

	LDA _Current_Object
	CMP #_Sprite5
     BNE .skipL0238
.condpart180
	LDA player5y
	STA temp4
.skipL0238
.L0239 ;  if _Current_Object  =  _Missile0 then temp4  =  missile0y

	LDA _Current_Object
	CMP #_Missile0
     BNE .skipL0239
.condpart181
	LDA missile0y
	STA temp4
.skipL0239
.L0240 ;  if _Current_Object  =  _Missile1 then temp4  =  missile1y

	LDA _Current_Object
	CMP #_Missile1
     BNE .skipL0240
.condpart182
	LDA missile1y
	STA temp4
.skipL0240
.L0241 ;  if _Current_Object  =  _Ball then temp4  =  bally

	LDA _Current_Object
	CMP #_Ball
     BNE .skipL0241
.condpart183
	LDA bally
	STA temp4
.skipL0241
.
 ; 

.L0242 ;  _sc2  =  _sc2  &  240  :  _sc3  =  0

	LDA _sc2
	AND #240
	STA _sc2
	LDA #0
	STA _sc3
.L0243 ;  if temp4  >=  100 then _sc2  =  _sc2  +  1  :  temp4  =  temp4  -  100

	LDA temp4
	CMP #100
     BCC .skipL0243
.condpart184
	INC _sc2
	LDA temp4
	SEC
	SBC #100
	STA temp4
.skipL0243
.L0244 ;  if temp4  >=  100 then _sc2  =  _sc2  +  1  :  temp4  =  temp4  -  100

	LDA temp4
	CMP #100
     BCC .skipL0244
.condpart185
	INC _sc2
	LDA temp4
	SEC
	SBC #100
	STA temp4
.skipL0244
.L0245 ;  if temp4  >=  50 then _sc3  =  _sc3  +  80  :  temp4  =  temp4  -  50

	LDA temp4
	CMP #50
     BCC .skipL0245
.condpart186
	LDA _sc3
	CLC
	ADC #80
	STA _sc3
	LDA temp4
	SEC
	SBC #50
	STA temp4
.skipL0245
.L0246 ;  if temp4  >=  30 then _sc3  =  _sc3  +  48  :  temp4  =  temp4  -  30

	LDA temp4
	CMP #30
     BCC .skipL0246
.condpart187
	LDA _sc3
	CLC
	ADC #48
	STA _sc3
	LDA temp4
	SEC
	SBC #30
	STA temp4
.skipL0246
.L0247 ;  if temp4  >=  20 then _sc3  =  _sc3  +  32  :  temp4  =  temp4  -  20

	LDA temp4
	CMP #20
     BCC .skipL0247
.condpart188
	LDA _sc3
	CLC
	ADC #32
	STA _sc3
	LDA temp4
	SEC
	SBC #20
	STA temp4
.skipL0247
.L0248 ;  if temp4  >=  10 then _sc3  =  _sc3  +  16  :  temp4  =  temp4  -  10

	LDA temp4
	CMP #10
     BCC .skipL0248
.condpart189
	LDA _sc3
	CLC
	ADC #16
	STA _sc3
	LDA temp4
	SEC
	SBC #10
	STA temp4
.skipL0248
.L0249 ;  _sc3  =  _sc3  |  temp4

	LDA _sc3
	ORA temp4
	STA _sc3
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

.L0250 ;  drawscreen

 sta temp7
 lda #>(ret_point20-1)
 pha
 lda #<(ret_point20-1)
 pha
 lda #>(drawscreen-1)
 pha
 lda #<(drawscreen-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #4
 jmp BS_jsr
ret_point20
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

.L0251 ;  if !switchreset then _Bit0_Reset_Restrainer{0}  =  0  :  goto __Main_Loop bank1

 lda #1
 bit SWCHB
	BEQ .skipL0251
.condpart190
	LDA _Bit0_Reset_Restrainer
	AND #254
	STA _Bit0_Reset_Restrainer
 sta temp7
 lda #>(.__Main_Loop-1)
 pha
 lda #<(.__Main_Loop-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #1
 jmp BS_jsr
.skipL0251
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

.L0252 ;  if _Bit0_Reset_Restrainer{0} then goto __Main_Loop bank1

	LDA _Bit0_Reset_Restrainer
	LSR
	BCC .skipL0252
.condpart191
 sta temp7
 lda #>(.__Main_Loop-1)
 pha
 lda #<(.__Main_Loop-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #1
 jmp BS_jsr
.skipL0252
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L0253 ;  goto __Start_Restart bank1

 sta temp7
 lda #>(.__Start_Restart-1)
 pha
 lda #<(.__Start_Restart-1)
 pha
 lda temp7
 pha
 txa
 pha
 ldx #1
 jmp BS_jsr
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

.
 ; 

.L0254 ;  data _Data_Sprite_Size

	JMP .skipL0254
_Data_Sprite_Size
	.byte    0, 5, 7

.skipL0254
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

.L0255 ;  data _Data_MB_Width

	JMP .skipL0255
_Data_MB_Width
	.byte    $00, $10, $20, $30

.skipL0255
.
 ; 

.
 ; 

.
 ; 

.L0256 ;  bank 3

 if ECHO2
 echo "    ",[(start_bank2 - *)]d , "bytes of ROM space left in bank 2")
 endif
ECHO2 = 1
 ORG $2FF4-bscode_length
 RORG $BFF4-bscode_length
start_bank2 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif 
 txs
 if bankswitch == 64
   lda #(((>(start-1)) & $0F) | $F0)
 else
   lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha
 pha
 txa
 pha
 tsx
 if bankswitch != 64
   lda 4,x ; get high byte of return address
   rol
   rol
   rol
   rol
   and #bs_mask ;1 3 or 7 for F8/F6/F4
   tax
   inx
 else
   lda 4,x ; get high byte of return address
   tay
   ora #$10 ; change our bank nibble into a valid rom mirror
   sta 4,x
   tya
   lsr 
   lsr 
   lsr 
   lsr 
   tax
   inx
 endif
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
   echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
   echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif
 ORG $2FFC
 RORG $BFFC
 .word (start_bank2 & $ffff)
 .word (start_bank2 & $ffff)
 ORG $3000
 RORG $D000
.
 ; 

.L0257 ;  data text_strings

	JMP .skipL0257
text_strings
	.byte    __P, __0, _sp, __O, __B, __J, __E, __C, __T, _sp, _sp, _sp

	.byte    __P, __1, _sp, _lp, __V, __I, __R, __T, __U, __A, __L, _rp

	.byte    __P, __2, _sp, _lp, __V, __I, __R, __T, __U, __A, __L, _rp

	.byte    __P, __3, _sp, _lp, __V, __I, __R, __T, __U, __A, __L, _rp

	.byte    __P, __4, _sp, _lp, __V, __I, __R, __T, __U, __A, __L, _rp

	.byte    __P, __5, _sp, _lp, __V, __I, __R, __T, __U, __A, __L, _rp

	.byte    __M, __0, _sp, __O, __B, __J, __E, __C, __T, _sp, _sp, _sp

	.byte    __M, __1, _sp, __O, __B, __J, __E, __C, __T, _sp, _sp, _sp

	.byte    __B, __A, __L, __L, _sp, __O, __B, __J, __E, __C, __T, _sp

.skipL0257
.
 ; 

.
 ; 

.L0258 ;  inline text12b.asm

 include text12b.asm

.
 ; 

.
 ; 

.L0259 ;  bank 4

 if ECHO3
 echo "    ",[(start_bank3 - *)]d , "bytes of ROM space left in bank 3")
 endif
ECHO3 = 1
 ORG $3FF4-bscode_length
 RORG $DFF4-bscode_length
start_bank3 ldx #$ff
 ifconst FASTFETCH ; using DPC+
 stx FASTFETCH
 endif 
 txs
 if bankswitch == 64
   lda #(((>(start-1)) & $0F) | $F0)
 else
   lda #>(start-1)
 endif
 pha
 lda #<(start-1)
 pha
 pha
 txa
 pha
 tsx
 if bankswitch != 64
   lda 4,x ; get high byte of return address
   rol
   rol
   rol
   rol
   and #bs_mask ;1 3 or 7 for F8/F6/F4
   tax
   inx
 else
   lda 4,x ; get high byte of return address
   tay
   ora #$10 ; change our bank nibble into a valid rom mirror
   sta 4,x
   tya
   lsr 
   lsr 
   lsr 
   lsr 
   tax
   inx
 endif
 lda bankswitch_hotspot-1,x
 pla
 tax
 pla
 rts
 if ((* & $1FFF) > ((bankswitch_hotspot & $1FFF) - 1))
   echo "WARNING: size parameter in banksw.asm too small - the program probably will not work."
   echo "Change to",[(*-begin_bscode+1)&$FF]d,"and try again."
 endif
 ORG $3FFC
 RORG $DFFC
 .word (start_bank3 & $ffff)
 .word (start_bank3 & $ffff)
 ORG $4000
 RORG $F000
; bB.asm file is split here
.
 ; 

.L0260 ;  inline text12a.asm
 include text12a.asm
 if (<*) > (<(*+8))
	repeat ($100-<*)
	.byte 0
	repend
	endif
 if (<*) < 90
	repeat (90-<*)
	.byte 0
	repend
	endif
playerL052_0
	.byte 0
	.byte    %00001111
	.byte    %00000110
	.byte    %11111111
	.byte    %00111110
	.byte    %11111111
	.byte    %00000110
	.byte    %00001111
	.byte 
 if (<*) > (<(*+6))
	repeat ($100-<*)
	.byte 0
	repend
	endif
 if (<*) < 90
	repeat (90-<*)
	.byte 0
	repend
	endif
playerL053_1
	.byte    %00000011
	.byte    %00000110
	.byte    %00011111
	.byte    %11111110
	.byte    %00011111
	.byte    %00000110
	.byte    %00000011
 if (<*) > (<(*+6))
	repeat ($100-<*)
	.byte 0
	repend
	endif
 if (<*) < 90
	repeat (90-<*)
	.byte 0
	repend
	endif
playerL054_2
	.byte    %00001111
	.byte    %00000110
	.byte    %11111110
	.byte    %00001111
	.byte    %11111110
	.byte    %00000110
	.byte    %00001111
 if (<*) > (<(*+6))
	repeat ($100-<*)
	.byte 0
	repend
	endif
 if (<*) < 90
	repeat (90-<*)
	.byte 0
	repend
	endif
playerL055_3
	.byte    %00111110
	.byte    %00000111
	.byte    %00011110
	.byte    %11111110
	.byte    %00011110
	.byte    %00000111
	.byte    %00111110
 if (<*) > (<(*+6))
	repeat ($100-<*)
	.byte 0
	repend
	endif
 if (<*) < 90
	repeat (90-<*)
	.byte 0
	repend
	endif
playerL056_4
	.byte    %00001111
	.byte    %00000110
	.byte    %00011110
	.byte    %11111111
	.byte    %00011110
	.byte    %00000110
	.byte    %00001111
 if (<*) > (<(*+6))
	repeat ($100-<*)
	.byte 0
	repend
	endif
 if (<*) < 90
	repeat (90-<*)
	.byte 0
	repend
	endif
playerL057_5
	.byte    %00011111
	.byte    %00000100
	.byte    %11111110
	.byte    %00111110
	.byte    %11111110
	.byte    %00000100
	.byte    %00011111
 if ((>(*+11)) > (>*))
 ALIGN 256
 endif
PF1_data0
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 if ((>(*+11)) > (>*))
 ALIGN 256
 endif
PF2_data0
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 .byte %00000000
 if ECHOFIRST
       echo "    ",[(scoretable - *)]d , "bytes of ROM space left in bank 4")
 endif 
ECHOFIRST = 1
 
 
 

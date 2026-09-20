game
.L00 ;  set tv ntsc

.L01 ;  include div_mul16.asm

.L02 ;  const pfscore  =  1

.L03 ;  pfscorecolor  =  $B8

	LDA #$B8
	STA pfscorecolor
.L04 ;  pfscore1  =  %10101010

	LDA #%10101010
	STA pfscore1
.L05 ;  dim doorctl  =  a

.L06 ;  dim tick  =  b

.L07 ;  dim seconds  =  c

.L08 ;  dim time  =  d

.L09 ;  dim night  =  e

.L010 ;  dim powertotal  =  f

.L011 ;  dim powerloss  =  g

.L012 ;  dim rand16  =  h

.L013 ;  dim move_rate  =  i

.L014 ;  dim Bon_Tick  =  j

.L015 ;  dim Chic_Tick  =  k

.L016 ;  dim Fox_Tick  =  l

.L017 ;  dim power_tick  =  m

.L018 ;  dim ai_second  =  n

.L019 ;  dim input_latch  =  o

.L020 ;  dim blackout_tick  =  p

.L021 ;  dim blackout_seconds  =  q

.L022 ;  doorctl  =  %00000000

	LDA #%00000000
	STA doorctl
.L023 ;  powertotal = 255

	LDA #255
	STA powertotal
.L024 ;  powerloss =  1

	LDA #1
	STA powerloss
.L025 ;  COLUPF = $0E

	LDA #$0E
	STA COLUPF
.L026 ;  scorecolor  =  $0E

	LDA #$0E
	STA scorecolor
.
 ; 

.L027 ;  player0:

	LDX #<playerL027_0
	STX player0pointerlo
	LDA #>playerL027_0
	STA player0pointerhi
	LDA #15
	STA player0height
.
 ; 

.L028 ;  player1:

	LDX #<playerL028_1
	STX player1pointerlo
	LDA #>playerL028_1
	STA player1pointerhi
	LDA #15
	STA player1height
.
 ; 

.
 ; 

.L029 ;  goto __Start

 jmp .__Start

.
 ; 

.__Map
 ; __Map

.
 ; 

.L030 ;  playfield:

  ifconst pfres
	  ldx #(11>pfres)*(pfres*pfwidth-1)+(11<=pfres)*43
  else
	  ldx #((11*pfwidth-1)*((11*pfwidth-1)<47))+(47*((11*pfwidth-1)>=47))
  endif
	jmp pflabel0
PF_data0
	.byte %11110000, %11111100
	if (pfwidth>2)
	.byte %11111000, %11011100
 endif
	.byte %11111111, %11111111
	if (pfwidth>2)
	.byte %11111111, %11111111
 endif
	.byte %11110011, %11111111
	if (pfwidth>2)
	.byte %11111111, %00011101
 endif
	.byte %00000011, %11111111
	if (pfwidth>2)
	.byte %11111111, %00011101
 endif
	.byte %00111111, %11111111
	if (pfwidth>2)
	.byte %11111111, %11011101
 endif
	.byte %00111111, %11111111
	if (pfwidth>2)
	.byte %11111111, %11111101
 endif
	.byte %00000000, %00000100
	if (pfwidth>2)
	.byte %00100000, %00000001
 endif
	.byte %00001110, %00001110
	if (pfwidth>2)
	.byte %01110000, %11111111
 endif
	.byte %00001111, %11101111
	if (pfwidth>2)
	.byte %01110000, %11111111
 endif
	.byte %00001110, %11111110
	if (pfwidth>2)
	.byte %11110000, %11111111
 endif
	.byte %00000000, %11101110
	if (pfwidth>2)
	.byte %01110000, %00000000
 endif
pflabel0
	lda PF_data0,x
	sta playfield,x
	dex
	bpl pflabel0
.L031 ;  return

	RTS
.
 ; 

.__Start
 ; __Start

.L032 ;  gosub __Map

 jsr .__Map

.
 ; 

.
 ; 

.L033 ;  night  =  1

	LDA #1
	STA night
.L034 ;  score  =  0

	LDA #$00
	STA score+2
	LDA #$00
	STA score+1
	LDA #$00
	STA score
.L035 ;  move_rate  =  8

	LDA #8
	STA move_rate
.L036 ;  Bon_Tick  =  0

	LDA #0
	STA Bon_Tick
.L037 ;  Chic_Tick  =  0

	LDA #0
	STA Chic_Tick
.L038 ;  Fox_Tick  =  0

	LDA #0
	STA Fox_Tick
.L039 ;  doorctl  =  %00000000

	LDA #%00000000
	STA doorctl
.L040 ;  tick  =  0

	LDA #0
	STA tick
.L041 ;  seconds  =  0

	LDA #0
	STA seconds
.L042 ;  time  =  0

	LDA #0
	STA time
.L043 ;  powertotal  =  255

	LDA #255
	STA powertotal
.L044 ;  powerloss  =  1

	LDA #1
	STA powerloss
.L045 ;  power_tick  =  0

	LDA #0
	STA power_tick
.L046 ;  ai_second  =  0

	LDA #0
	STA ai_second
.L047 ;  input_latch  =  0

	LDA #0
	STA input_latch
.L048 ;  blackout_tick  =  0

	LDA #0
	STA blackout_tick
.L049 ;  blackout_seconds  =  0

	LDA #0
	STA blackout_seconds
.L050 ;  pfscorecolor  =  $B8

	LDA #$B8
	STA pfscorecolor
.L051 ;  scorecolor  =  $0E

	LDA #$0E
	STA scorecolor
.L052 ;  pfscore1  =  %10101010

	LDA #%10101010
	STA pfscore1
.
 ; 

.L053 ;  player0x  =  68

	LDA #68
	STA player0x
.L054 ;  player0y  =  4

	LDA #4
	STA player0y
.L055 ;  player1x  =  82

	LDA #82
	STA player1x
.L056 ;  player1y  =  4

	LDA #4
	STA player1y
.
 ; 

.L057 ;  ballx  =  26

	LDA #26
	STA ballx
.L058 ;  bally  =  18

	LDA #18
	STA bally
.L059 ;  ballheight  =  2

	LDA #2
	STA ballheight
.mainloop
 ; mainloop

.L060 ;  AUDV0  =  0

	LDA #0
	STA AUDV0
.L061 ;  AUDC0  =  0

	LDA #0
	STA AUDC0
.L062 ;  AUDF0  =  0

	LDA #0
	STA AUDF0
.L063 ;  AUDV1  =  0

	LDA #0
	STA AUDV1
.L064 ;  AUDC1  =  0

	LDA #0
	STA AUDC1
.L065 ;  AUDF1  =  0

	LDA #0
	STA AUDF1
.L066 ;  pfscorecolor  =  $B8

	LDA #$B8
	STA pfscorecolor
.L067 ;  scorecolor  =  $0E

	LDA #$0E
	STA scorecolor
.L068 ;  COLUPF = $0E

	LDA #$0E
	STA COLUPF
.L069 ;  COLUP0  =  $74

	LDA #$74
	STA COLUP0
.L070 ;  COLUP1  =  $1C

	LDA #$1C
	STA COLUP1
.L071 ;  missile1x  =  84

	LDA #84
	STA missile1x
.L072 ;  if doorctl{2} then missile1y  =  81 else missile1y  =  72

	LDA doorctl
	AND #4
	BEQ .skipL072
.condpart0
	LDA #81
	STA missile1y
 jmp .skipelse0
.skipL072
	LDA #72
	STA missile1y
.skipelse0
.L073 ;  missile1height  =  9

	LDA #9
	STA missile1height
.L074 ;  missile0x  =  68

	LDA #68
	STA missile0x
.L075 ;  if doorctl{1} then missile0y  =  81 else missile0y  =  72

	LDA doorctl
	AND #2
	BEQ .skipL075
.condpart1
	LDA #81
	STA missile0y
 jmp .skipelse1
.skipL075
	LDA #72
	STA missile0y
.skipelse1
.L076 ;  missile0height  =  9

	LDA #9
	STA missile0height
.L077 ;  drawscreen

 jsr drawscreen
.
 ; 

.
 ; 

.L078 ;  if joy0left  &&  !input_latch{0} then doorctl{1}  =  !doorctl{1} : input_latch{0} = 1

 bit SWCHA
	BVS .skipL078
.condpart2
	LDA input_latch
	LSR
	BCS .skip2then
.condpart3
	LDA doorctl
	AND #2
  PHP
	LDA doorctl
	AND #253
  PLP
	.byte $D0, $02
	ORA #2
	STA doorctl
	LDA input_latch
	ORA #1
	STA input_latch
.skip2then
.skipL078
.L079 ;  if !joy0left then input_latch{0} = 0

 bit SWCHA
	BVC .skipL079
.condpart4
	LDA input_latch
	AND #254
	STA input_latch
.skipL079
.L080 ;  if joy0right  &&  !input_latch{1} then doorctl{2}  =  !doorctl{2} : input_latch{1} = 1

 bit SWCHA
	BMI .skipL080
.condpart5
	LDA input_latch
	AND #2
	BNE .skip5then
.condpart6
	LDA doorctl
	AND #4
  PHP
	LDA doorctl
	AND #251
  PLP
	.byte $D0, $02
	ORA #4
	STA doorctl
	LDA input_latch
	ORA #2
	STA input_latch
.skip5then
.skipL080
.L081 ;  if !joy0right then input_latch{1} = 0

 bit SWCHA
	BPL .skipL081
.condpart7
	LDA input_latch
	AND #253
	STA input_latch
.skipL081
.L082 ;  if time  =  6 then goto __6am

	LDA time
	CMP #6
     BNE .skipL082
.condpart8
 jmp .__6am

.skipL082
.
 ; 

.
 ; 

.
 ; 

.L083 ;  if powertotal  >  75 then pfscore1  =  %10101010

	LDA #75
	CMP powertotal
     BCS .skipL083
.condpart9
	LDA #%10101010
	STA pfscore1
.skipL083
.L084 ;  if powertotal  <=  75 then pfscore1  =  %00101010

	LDA #75
	CMP powertotal
     BCC .skipL084
.condpart10
	LDA #%00101010
	STA pfscore1
.skipL084
.L085 ;  if powertotal  <=  50 then pfscore1  =  %00001010

	LDA #50
	CMP powertotal
     BCC .skipL085
.condpart11
	LDA #%00001010
	STA pfscore1
.skipL085
.L086 ;  if powertotal  <=  25 then pfscore1  =  %00000010

	LDA #25
	CMP powertotal
     BCC .skipL086
.condpart12
	LDA #%00000010
	STA pfscore1
.skipL086
.L087 ;  if powertotal  =  0 then goto __EnterBlackout

	LDA powertotal
	CMP #0
     BNE .skipL087
.condpart13
 jmp .__EnterBlackout

.skipL087
.
 ; 

.
 ; 

.L088 ;  tick  =  tick + 1

	INC tick
.L089 ;  if tick  =  60 then seconds = seconds + 1 : tick = 0

	LDA tick
	CMP #60
     BNE .skipL089
.condpart14
	INC seconds
	LDA #0
	STA tick
.skipL089
.L090 ;  if seconds  =  90 then time = time + 1 : score = score + 1 : seconds = 0 : power_tick = 0 : ai_second = 0

	LDA seconds
	CMP #90
     BNE .skipL090
.condpart15
	INC time
	SED
	CLC
	LDA score+2
	ADC #$01
	STA score+2
	LDA score+1
	ADC #$00
	STA score+1
	LDA score
	ADC #$00
	STA score
	CLD
	LDA #0
	STA seconds
	STA power_tick
	STA ai_second
.skipL090
.
 ; 

.
 ; 

.
 ; 

.L091 ;  z  =  seconds  //  10

	LDA seconds
	LDY #10
 jsr div16
	STA z
.L092 ;  if temp1  =  0  &&  seconds  <>  power_tick then power_tick = seconds : goto __power

	LDA temp1
	CMP #0
     BNE .skipL092
.condpart16
	LDA seconds
	CMP power_tick
     BEQ .skip16then
.condpart17
	LDA seconds
	STA power_tick
 jmp .__power

.skip16then
.skipL092
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L093 ;  move_rate  =  8

	LDA #8
	STA move_rate
.L094 ;  move_rate  =  move_rate  //  night

	LDA move_rate
	LDY night
 jsr div16
	STA move_rate
.L095 ;  if move_rate  =  0 then move_rate  =  1

	LDA move_rate
	CMP #0
     BNE .skipL095
.condpart18
	LDA #1
	STA move_rate
.skipL095
.L096 ;  z  =  seconds  //  move_rate

	LDA seconds
	LDY move_rate
 jsr div16
	STA z
.L097 ;  if temp1  =  0  &&  seconds  <>  ai_second then ai_second = seconds : z = rand // 32 : rand16 = temp1 : goto __AIroll

	LDA temp1
	CMP #0
     BNE .skipL097
.condpart19
	LDA seconds
	CMP ai_second
     BEQ .skip19then
.condpart20
	LDA seconds
	STA ai_second
 jsr randomize
	ldx #0
	stx temp1
	lsr
  rol temp1
	lsr
  rol temp1
	lsr
  rol temp1
	lsr
  rol temp1
	lsr
  rol temp1
	STA z
	LDA temp1
	STA rand16
 jmp .__AIroll

.skip19then
.skipL097
.L098 ;  goto __AIstate

 jmp .__AIstate

.
 ; 

.__AIroll
 ; __AIroll

.
 ; 

.
 ; 

.L099 ;  if rand16  >=  20  &&  rand16  <=  21 then goto __Foxy

	LDA rand16
	CMP #20
     BCC .skipL099
.condpart21
	LDA #21
	CMP rand16
     BCC .skip21then
.condpart22
 jmp .__Foxy

.skip21then
.skipL099
.L0100 ;  if rand16  >=  9  &&  rand16  <=  10 then goto __Chica

	LDA rand16
	CMP #9
     BCC .skipL0100
.condpart23
	LDA #10
	CMP rand16
     BCC .skip23then
.condpart24
 jmp .__Chica

.skip23then
.skipL0100
.L0101 ;  if rand16  <=  1 then goto __Bonnie

	LDA #1
	CMP rand16
     BCC .skipL0101
.condpart25
 jmp .__Bonnie

.skipL0101
.L0102 ;  goto __AIstate

 jmp .__AIstate

.
 ; 

.__AIstate
 ; __AIstate

.L0103 ;  if joy1fire then goto __EnterBlackout

 bit INPT5
	BMI .skipL0103
.condpart26
 jmp .__EnterBlackout

.skipL0103
.
 ; 

.
 ; 

.
 ; 

.L0104 ;  if Bon_Tick  =  1 then goto Bon1

	LDA Bon_Tick
	CMP #1
     BNE .skipL0104
.condpart27
 jmp .Bon1

.skipL0104
.L0105 ;  if Bon_Tick  =  2 then goto Bon2

	LDA Bon_Tick
	CMP #2
     BNE .skipL0105
.condpart28
 jmp .Bon2

.skipL0105
.L0106 ;  if Bon_Tick  =  3 then goto Bon3

	LDA Bon_Tick
	CMP #3
     BNE .skipL0106
.condpart29
 jmp .Bon3

.skipL0106
.L0107 ;  if Bon_Tick  =  4 then goto Bon4

	LDA Bon_Tick
	CMP #4
     BNE .skipL0107
.condpart30
 jmp .Bon4

.skipL0107
.L0108 ;  if Bon_Tick  >=  5 then goto BonJump

	LDA Bon_Tick
	CMP #5
     BCC .skipL0108
.condpart31
 jmp .BonJump

.skipL0108
.L0109 ;  if Chic_Tick  =  1 then goto Chic1

	LDA Chic_Tick
	CMP #1
     BNE .skipL0109
.condpart32
 jmp .Chic1

.skipL0109
.L0110 ;  if Chic_Tick  =  2 then goto Chic2

	LDA Chic_Tick
	CMP #2
     BNE .skipL0110
.condpart33
 jmp .Chic2

.skipL0110
.L0111 ;  if Chic_Tick  =  3 then goto Chic3

	LDA Chic_Tick
	CMP #3
     BNE .skipL0111
.condpart34
 jmp .Chic3

.skipL0111
.L0112 ;  if Chic_Tick  =  4 then goto Chic4

	LDA Chic_Tick
	CMP #4
     BNE .skipL0112
.condpart35
 jmp .Chic4

.skipL0112
.L0113 ;  if Chic_Tick  >=  5 then goto ChicJump

	LDA Chic_Tick
	CMP #5
     BCC .skipL0113
.condpart36
 jmp .ChicJump

.skipL0113
.L0114 ;  if Fox_Tick  =  1 then goto Fox1

	LDA Fox_Tick
	CMP #1
     BNE .skipL0114
.condpart37
 jmp .Fox1

.skipL0114
.L0115 ;  if Fox_Tick  =  2 then goto Fox2

	LDA Fox_Tick
	CMP #2
     BNE .skipL0115
.condpart38
 jmp .Fox2

.skipL0115
.L0116 ;  if Fox_Tick  =  3 then goto Fox3

	LDA Fox_Tick
	CMP #3
     BNE .skipL0116
.condpart39
 jmp .Fox3

.skipL0116
.L0117 ;  if Fox_Tick  =  4 then goto Fox4

	LDA Fox_Tick
	CMP #4
     BNE .skipL0117
.condpart40
 jmp .Fox4

.skipL0117
.L0118 ;  if Fox_Tick  >=  5 then goto FoxJump

	LDA Fox_Tick
	CMP #5
     BCC .skipL0118
.condpart41
 jmp .FoxJump

.skipL0118
.L0119 ;  goto mainloop

 jmp .mainloop

.
 ; 

.
 ; 

.
 ; 

.__6am
 ; __6am

.
 ; 

.L0120 ;  playfield:

  ifconst pfres
	  ldx #(7>pfres)*(pfres*pfwidth-1)+(7<=pfres)*27
  else
	  ldx #((7*pfwidth-1)*((7*pfwidth-1)<47))+(47*((7*pfwidth-1)>=47))
  endif
	jmp pflabel1
PF_data1
	.byte %11111111, %11100000
	if (pfwidth>2)
	.byte %11100010, %01000000
 endif
	.byte %10000000, %00010000
	if (pfwidth>2)
	.byte %00010010, %01000000
 endif
	.byte %10000000, %00010000
	if (pfwidth>2)
	.byte %00010010, %01010001
 endif
	.byte %11111111, %11110001
	if (pfwidth>2)
	.byte %11110010, %01001110
 endif
	.byte %10000001, %00010000
	if (pfwidth>2)
	.byte %00010010, %01000000
 endif
	.byte %10000001, %00010000
	if (pfwidth>2)
	.byte %00010010, %01000000
 endif
	.byte %11111111, %00010000
	if (pfwidth>2)
	.byte %00010010, %01000000
 endif
pflabel1
	lda PF_data1,x
	sta playfield,x
	dex
	bpl pflabel1
.L0121 ;  drawscreen

 jsr drawscreen
.
 ; 

.
 ; 

.
 ; 

.L0122 ;  if joy0fire then goto __NextNight

 bit INPT4
	BMI .skipL0122
.condpart42
 jmp .__NextNight

.skipL0122
.L0123 ;  goto __6am

 jmp .__6am

.
 ; 

.__NextNight
 ; __NextNight

.L0124 ;  score = score - 6

	SED
	SEC
	LDA score+2
	SBC #$06
	STA score+2
	LDA score+1
	SBC #$00
	STA score+1
	LDA score
	SBC #$00
	STA score
	CLD
.L0125 ;  score = score + 100000

	SED
	CLC
	LDA score
	ADC #$10
	STA score
	CLD
.L0126 ;  night = night + 1

	INC night
.L0127 ;  gosub __Map

 jsr .__Map

.L0128 ;  Bon_Tick = 0

	LDA #0
	STA Bon_Tick
.L0129 ;  Chic_Tick = 0

	LDA #0
	STA Chic_Tick
.L0130 ;  Fox_Tick = 0

	LDA #0
	STA Fox_Tick
.L0131 ;  player0x = 68

	LDA #68
	STA player0x
.L0132 ;  player0y = 4

	LDA #4
	STA player0y
.L0133 ;  player1x = 82

	LDA #82
	STA player1x
.L0134 ;  player1y = 4

	LDA #4
	STA player1y
.L0135 ;  ballx = 26

	LDA #26
	STA ballx
.L0136 ;  bally = 18

	LDA #18
	STA bally
.L0137 ;  doorctl = %00000000

	LDA #%00000000
	STA doorctl
.L0138 ;  input_latch = 0

	LDA #0
	STA input_latch
.L0139 ;  powertotal = 255

	LDA #255
	STA powertotal
.L0140 ;  powerloss = 1

	LDA #1
	STA powerloss
.L0141 ;  time = 0

	LDA #0
	STA time
.L0142 ;  seconds = 0

	LDA #0
	STA seconds
.L0143 ;  tick = 0

	LDA #0
	STA tick
.L0144 ;  power_tick = 0

	LDA #0
	STA power_tick
.L0145 ;  ai_second = 0

	LDA #0
	STA ai_second
.L0146 ;  blackout_tick = 0

	LDA #0
	STA blackout_tick
.L0147 ;  blackout_seconds = 0

	LDA #0
	STA blackout_seconds
.L0148 ;  pfscorecolor = $B8

	LDA #$B8
	STA pfscorecolor
.L0149 ;  scorecolor = $0E

	LDA #$0E
	STA scorecolor
.L0150 ;  pfscore1 = %10101010

	LDA #%10101010
	STA pfscore1
.L0151 ;  goto mainloop

 jmp .mainloop

.__power
 ; __power

.
 ; 

.
 ; 

.
 ; 

.L0152 ;  powerloss  =  1

	LDA #1
	STA powerloss
.L0153 ;  if doorctl{1} then powerloss  =  powerloss  +  1

	LDA doorctl
	AND #2
	BEQ .skipL0153
.condpart43
	INC powerloss
.skipL0153
.L0154 ;  if doorctl{2} then powerloss  =  powerloss  +  1

	LDA doorctl
	AND #4
	BEQ .skipL0154
.condpart44
	INC powerloss
.skipL0154
.L0155 ;  if powertotal  <=  powerloss then powertotal = 0 else powertotal = powertotal - powerloss

	LDA powerloss
	CMP powertotal
     BCC .skipL0155
.condpart45
	LDA #0
	STA powertotal
 jmp .skipelse2
.skipL0155
	LDA powertotal
	SEC
	SBC powerloss
	STA powertotal
.skipelse2
.L0156 ;  goto mainloop

 jmp .mainloop

.
 ; 

.__EnterBlackout
 ; __EnterBlackout

.
 ; 

.L0157 ;  pfscore1  =  0

	LDA #0
	STA pfscore1
.L0158 ;  pfscorecolor  =  $00

	LDA #$00
	STA pfscorecolor
.L0159 ;  scorecolor  =  $00

	LDA #$00
	STA scorecolor
.L0160 ;  COLUPF  =  $00

	LDA #$00
	STA COLUPF
.L0161 ;  COLUP0  =  $00

	LDA #$00
	STA COLUP0
.L0162 ;  COLUP1  =  $00

	LDA #$00
	STA COLUP1
.L0163 ;  AUDV0  =  0

	LDA #0
	STA AUDV0
.L0164 ;  AUDV1  =  0

	LDA #0
	STA AUDV1
.L0165 ;  blackout_tick  =  0

	LDA #0
	STA blackout_tick
.L0166 ;  blackout_seconds  =  0

	LDA #0
	STA blackout_seconds
.
 ; 

.
 ; 

.L0167 ;  playfield:

  ifconst pfres
	  ldx #(12>pfres)*(pfres*pfwidth-1)+(12<=pfres)*47
  else
	  ldx #((12*pfwidth-1)*((12*pfwidth-1)<47))+(47*((12*pfwidth-1)>=47))
  endif
	jmp pflabel2
PF_data2
	.byte %11111100, %00000000
	if (pfwidth>2)
	.byte %00000000, %11111000
 endif
	.byte %11111100, %00000000
	if (pfwidth>2)
	.byte %00000000, %11111000
 endif
	.byte %11111100, %00000000
	if (pfwidth>2)
	.byte %00000000, %11111000
 endif
	.byte %00000111, %00000001
	if (pfwidth>2)
	.byte %00000001, %00000111
 endif
	.byte %00000111, %00000001
	if (pfwidth>2)
	.byte %00000001, %00000111
 endif
	.byte %00000000, %11000000
	if (pfwidth>2)
	.byte %11000000, %00000000
 endif
	.byte %00000000, %11111110
	if (pfwidth>2)
	.byte %11111110, %00000000
 endif
	.byte %00000000, %11111110
	if (pfwidth>2)
	.byte %11111110, %00000000
 endif
	.byte %00000000, %01000010
	if (pfwidth>2)
	.byte %01000010, %00000000
 endif
	.byte %00000000, %11000000
	if (pfwidth>2)
	.byte %11000000, %00000000
 endif
	.byte %00000000, %00000111
	if (pfwidth>2)
	.byte %00000111, %00000000
 endif
	.byte %00000000, %11111111
	if (pfwidth>2)
	.byte %11111111, %00000000
 endif
pflabel2
	lda PF_data2,x
	sta playfield,x
	dex
	bpl pflabel2
.L0168 ;  goto __blackout

 jmp .__blackout

.
 ; 

.__blackout
 ; __blackout

.L0169 ;  blackout_tick  =  blackout_tick  +  1

	INC blackout_tick
.L0170 ;  if blackout_tick  =  60 then blackout_tick = 0 : blackout_seconds = blackout_seconds + 1

	LDA blackout_tick
	CMP #60
     BNE .skipL0170
.condpart46
	LDA #0
	STA blackout_tick
	INC blackout_seconds
.skipL0170
.
 ; 

.
 ; 

.
 ; 

.L0171 ;  if blackout_seconds  <  60 then COLUPF = $00 : pfscorecolor = $00

	LDA blackout_seconds
	CMP #60
     BCS .skipL0171
.condpart47
	LDA #$00
	STA COLUPF
	STA pfscorecolor
.skipL0171
.L0172 ;  if blackout_seconds  >=  60 then COLUPF = $E4 : pfscorecolor = $E4 : gosub __Sound

	LDA blackout_seconds
	CMP #60
     BCC .skipL0172
.condpart48
	LDA #$E4
	STA COLUPF
	STA pfscorecolor
 jsr .__Sound

.skipL0172
.
 ; 

.L0173 ;  drawscreen

 jsr drawscreen
.L0174 ;  if joy0fire then goto __Start

 bit INPT4
	BMI .skipL0174
.condpart49
 jmp .__Start

.skipL0174
.L0175 ;  goto __blackout

 jmp .__blackout

.
 ; 

.__Bonnie
 ; __Bonnie

.L0176 ;  Bon_Tick  =  Bon_Tick  + 1

	INC Bon_Tick
.L0177 ;  goto mainloop

 jmp .mainloop

.
 ; 

.Bon1
 ; Bon1

.
 ; 

.L0178 ;  player0x  =  54

	LDA #54
	STA player0x
.L0179 ;  player0y  =  20

	LDA #20
	STA player0y
.L0180 ;  goto mainloop

 jmp .mainloop

.Bon2
 ; Bon2

.
 ; 

.L0181 ;  player0x  =  34

	LDA #34
	STA player0x
.L0182 ;  player0y  =  38

	LDA #38
	STA player0y
.L0183 ;  goto mainloop

 jmp .mainloop

.Bon3
 ; Bon3

.
 ; 

.L0184 ;  player0x  =  44

	LDA #44
	STA player0x
.L0185 ;  player0y  =  56

	LDA #56
	STA player0y
.L0186 ;  goto mainloop

 jmp .mainloop

.Bon4
 ; Bon4

.
 ; 

.L0187 ;  player0x  =  58

	LDA #58
	STA player0x
.L0188 ;  player0y  =  72

	LDA #72
	STA player0y
.L0189 ;  goto mainloop

 jmp .mainloop

.BonJump
 ; BonJump

.
 ; 

.L0190 ;  if doorctl{1} then Bon_Tick = 0 : player0x = 68 : player0y = 4 : goto mainloop

	LDA doorctl
	AND #2
	BEQ .skipL0190
.condpart50
	LDA #0
	STA Bon_Tick
	LDA #68
	STA player0x
	LDA #4
	STA player0y
 jmp .mainloop

.skipL0190
.L0191 ;  playfield:

  ifconst pfres
	  ldx #(12>pfres)*(pfres*pfwidth-1)+(12<=pfres)*47
  else
	  ldx #((12*pfwidth-1)*((12*pfwidth-1)<47))+(47*((12*pfwidth-1)>=47))
  endif
	jmp pflabel3
PF_data3
	.byte %00011110, %00000000
	if (pfwidth>2)
	.byte %00000000, %00001111
 endif
	.byte %00011110, %00000000
	if (pfwidth>2)
	.byte %00000000, %00001111
 endif
	.byte %00011110, %00000000
	if (pfwidth>2)
	.byte %00000000, %00001111
 endif
	.byte %00001100, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000110
 endif
	.byte %00001111, %11111111
	if (pfwidth>2)
	.byte %11111111, %00000111
 endif
	.byte %00001001, %00000111
	if (pfwidth>2)
	.byte %00001111, %00000100
 endif
	.byte %00001001, %00000111
	if (pfwidth>2)
	.byte %00001111, %00000100
 endif
	.byte %00001000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000100
 endif
	.byte %00001000, %11100000
	if (pfwidth>2)
	.byte %11000000, %00000100
 endif
	.byte %00001000, %11111100
	if (pfwidth>2)
	.byte %11111000, %00000100
 endif
	.byte %00001000, %11111100
	if (pfwidth>2)
	.byte %11111000, %00000100
 endif
	.byte %00001000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000100
 endif
pflabel3
	lda PF_data3,x
	sta playfield,x
	dex
	bpl pflabel3
.L0192 ;  COLUPF = $62 : gosub __Sound : drawscreen

	LDA #$62
	STA COLUPF
 jsr .__Sound
 jsr drawscreen
.L0193 ;  if joy0fire then goto __Start else goto BonJump

 bit INPT4
	BMI .skipL0193
.condpart51
 jmp .__Start
 jmp .skipelse3
.skipL0193
 jmp .BonJump

.skipelse3
.
 ; 

.
 ; 

.__Chica
 ; __Chica

.L0194 ;  Chic_Tick  =  Chic_Tick  +  1

	INC Chic_Tick
.L0195 ;  goto mainloop

 jmp .mainloop

.Chic1
 ; Chic1

.
 ; 

.L0196 ;  player1x  =  98

	LDA #98
	STA player1x
.L0197 ;  player1y  =  20

	LDA #20
	STA player1y
.L0198 ;  goto mainloop

 jmp .mainloop

.Chic2
 ; Chic2

.
 ; 

.L0199 ;  player1x  =  118

	LDA #118
	STA player1x
.L0200 ;  player1y  =  38

	LDA #38
	STA player1y
.L0201 ;  goto mainloop

 jmp .mainloop

.Chic3
 ; Chic3

.
 ; 

.L0202 ;  player1x  =  108

	LDA #108
	STA player1x
.L0203 ;  player1y  =  56

	LDA #56
	STA player1y
.L0204 ;  goto mainloop

 jmp .mainloop

.Chic4
 ; Chic4

.
 ; 

.L0205 ;  player1x  =  90

	LDA #90
	STA player1x
.L0206 ;  player1y  =  72

	LDA #72
	STA player1y
.L0207 ;  goto mainloop

 jmp .mainloop

.ChicJump
 ; ChicJump

.
 ; 

.L0208 ;  if doorctl{2} then Chic_Tick = 0 : player1x = 82 : player1y = 4 : goto mainloop

	LDA doorctl
	AND #4
	BEQ .skipL0208
.condpart52
	LDA #0
	STA Chic_Tick
	LDA #82
	STA player1x
	LDA #4
	STA player1y
 jmp .mainloop

.skipL0208
.L0209 ;  playfield:

  ifconst pfres
	  ldx #(12>pfres)*(pfres*pfwidth-1)+(12<=pfres)*47
  else
	  ldx #((12*pfwidth-1)*((12*pfwidth-1)<47))+(47*((12*pfwidth-1)>=47))
  endif
	jmp pflabel4
PF_data4
	.byte %01111111, %11111111
	if (pfwidth>2)
	.byte %11111111, %01111111
 endif
	.byte %01000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %01000000
 endif
	.byte %01000001, %00011111
	if (pfwidth>2)
	.byte %00111111, %01000000
 endif
	.byte %01000001, %00011111
	if (pfwidth>2)
	.byte %00111111, %01000000
 endif
	.byte %01000001, %00011111
	if (pfwidth>2)
	.byte %00111111, %01000000
 endif
	.byte %01000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %01000000
 endif
	.byte %01000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %01000000
 endif
	.byte %01000000, %11110000
	if (pfwidth>2)
	.byte %11100000, %01000000
 endif
	.byte %01000000, %11000000
	if (pfwidth>2)
	.byte %10000000, %01000000
 endif
	.byte %01000000, %11110000
	if (pfwidth>2)
	.byte %11100000, %01000000
 endif
	.byte %01000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %01000000
 endif
	.byte %01111111, %11111111
	if (pfwidth>2)
	.byte %11111111, %01111111
 endif
pflabel4
	lda PF_data4,x
	sta playfield,x
	dex
	bpl pflabel4
.L0210 ;  COLUPF = $1C : gosub __Sound : drawscreen

	LDA #$1C
	STA COLUPF
 jsr .__Sound
 jsr drawscreen
.L0211 ;  if joy0fire then goto __Start else goto ChicJump

 bit INPT4
	BMI .skipL0211
.condpart53
 jmp .__Start
 jmp .skipelse4
.skipL0211
 jmp .ChicJump

.skipelse4
.
 ; 

.__Foxy
 ; __Foxy

.L0212 ;  if doorctl{1} then Fox_Tick = 0 : ballx = 26 : bally = 18 : goto mainloop else Fox_Tick = Fox_Tick + 1

	LDA doorctl
	AND #2
	BEQ .skipL0212
.condpart54
	LDA #0
	STA Fox_Tick
	LDA #26
	STA ballx
	LDA #18
	STA bally
 jmp .mainloop
 jmp .skipelse5
.skipL0212
	INC Fox_Tick
.skipelse5
.L0213 ;  goto mainloop

 jmp .mainloop

.Fox1
 ; Fox1

.L0214 ;  if doorctl{1} then Fox_Tick = 0 : ballx = 26 : bally = 18 : goto mainloop

	LDA doorctl
	AND #2
	BEQ .skipL0214
.condpart55
	LDA #0
	STA Fox_Tick
	LDA #26
	STA ballx
	LDA #18
	STA bally
 jmp .mainloop

.skipL0214
.L0215 ;  ballx  =  34

	LDA #34
	STA ballx
.L0216 ;  bally  =  28

	LDA #28
	STA bally
.L0217 ;  goto mainloop

 jmp .mainloop

.Fox2
 ; Fox2

.L0218 ;  if doorctl{1} then Fox_Tick = 0 : ballx = 26 : bally = 18 : goto mainloop

	LDA doorctl
	AND #2
	BEQ .skipL0218
.condpart56
	LDA #0
	STA Fox_Tick
	LDA #26
	STA ballx
	LDA #18
	STA bally
 jmp .mainloop

.skipL0218
.L0219 ;  ballx  =  42

	LDA #42
	STA ballx
.L0220 ;  bally  =  40

	LDA #40
	STA bally
.L0221 ;  goto mainloop

 jmp .mainloop

.Fox3
 ; Fox3

.L0222 ;  if doorctl{1} then Fox_Tick = 0 : ballx = 26 : bally = 18 : goto mainloop

	LDA doorctl
	AND #2
	BEQ .skipL0222
.condpart57
	LDA #0
	STA Fox_Tick
	LDA #26
	STA ballx
	LDA #18
	STA bally
 jmp .mainloop

.skipL0222
.L0223 ;  ballx  =  52

	LDA #52
	STA ballx
.L0224 ;  bally  =  52

	LDA #52
	STA bally
.L0225 ;  goto mainloop

 jmp .mainloop

.Fox4
 ; Fox4

.L0226 ;  if doorctl{1} then Fox_Tick = 0 : ballx = 26 : bally = 18 : goto mainloop

	LDA doorctl
	AND #2
	BEQ .skipL0226
.condpart58
	LDA #0
	STA Fox_Tick
	LDA #26
	STA ballx
	LDA #18
	STA bally
 jmp .mainloop

.skipL0226
.L0227 ;  ballx  =  60

	LDA #60
	STA ballx
.L0228 ;  bally  =  64

	LDA #64
	STA bally
.L0229 ;  goto mainloop

 jmp .mainloop

.FoxJump
 ; FoxJump

.
 ; 

.
 ; 

.
 ; 

.L0230 ;  ballx  =  68

	LDA #68
	STA ballx
.L0231 ;  bally  =  81

	LDA #81
	STA bally
.L0232 ;  if collision(ball,missile0) then Fox_Tick = 0 : ballx = 26 : bally = 18 : goto mainloop

	bit 	CXM0FB
	BVC .skipL0232
.condpart59
	LDA #0
	STA Fox_Tick
	LDA #26
	STA ballx
	LDA #18
	STA bally
 jmp .mainloop

.skipL0232
.L0233 ;  playfield:

  ifconst pfres
	  ldx #(12>pfres)*(pfres*pfwidth-1)+(12<=pfres)*47
  else
	  ldx #((12*pfwidth-1)*((12*pfwidth-1)<47))+(47*((12*pfwidth-1)>=47))
  endif
	jmp pflabel5
PF_data5
	.byte %11111000, %00000000
	if (pfwidth>2)
	.byte %00000000, %11111000
 endif
	.byte %11111000, %00000000
	if (pfwidth>2)
	.byte %00000000, %11111000
 endif
	.byte %00111000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00111000
 endif
	.byte %00011111, %11111111
	if (pfwidth>2)
	.byte %11111111, %00011111
 endif
	.byte %00010000, %00000000
	if (pfwidth>2)
	.byte %00001111, %00010001
 endif
	.byte %00010000, %00000000
	if (pfwidth>2)
	.byte %00001111, %00010001
 endif
	.byte %00100000, %11110000
	if (pfwidth>2)
	.byte %11110000, %00100000
 endif
	.byte %01000000, %10010000
	if (pfwidth>2)
	.byte %10010000, %01000000
 endif
	.byte %00100000, %11100000
	if (pfwidth>2)
	.byte %11100000, %00100000
 endif
	.byte %00010000, %00010000
	if (pfwidth>2)
	.byte %00010000, %00010000
 endif
	.byte %00010000, %11110000
	if (pfwidth>2)
	.byte %11110000, %00010000
 endif
	.byte %00011111, %11111111
	if (pfwidth>2)
	.byte %11111111, %00011111
 endif
pflabel5
	lda PF_data5,x
	sta playfield,x
	dex
	bpl pflabel5
.
 ; 

.L0234 ;  COLUPF = $34 : gosub __Sound : drawscreen

	LDA #$34
	STA COLUPF
 jsr .__Sound
 jsr drawscreen
.L0235 ;  if joy0fire then goto __Start else goto FoxJump

 bit INPT4
	BMI .skipL0235
.condpart60
 jmp .__Start
 jmp .skipelse6
.skipL0235
 jmp .FoxJump

.skipelse6
.__Sound
 ; __Sound

.
 ; 

.L0236 ;  AUDV0  =  15

	LDA #15
	STA AUDV0
.L0237 ;  AUDC0  =  8

	LDA #8
	STA AUDC0
.L0238 ;  AUDF0  =  rand  &  15

 jsr randomize
	AND #15
	STA AUDF0
.
 ; 

.L0239 ;  AUDV1  =  15

	LDA #15
	STA AUDV1
.L0240 ;  AUDC1  =  4

	LDA #4
	STA AUDC1
.L0241 ;  AUDF1  =  3

	LDA #3
	STA AUDF1
.L0242 ;  return
	RTS
 if (<*) > (<(*+15))
	repeat ($100-<*)
	.byte 0
	repend
	endif
playerL027_0
	.byte  %01101100
	.byte  %00100100
	.byte  %00111101
	.byte  %00111101
	.byte  %00111111
	.byte  %00011100
	.byte  %00001000
	.byte  %00011100
	.byte  %00010100
	.byte  %00010100
	.byte  %00110100
	.byte  %00001100
	.byte  %00000000
	.byte  %00000000
	.byte  %00000000
	.byte  %00000000
 if (<*) > (<(*+15))
	repeat ($100-<*)
	.byte 0
	repend
	endif
playerL028_1
	.byte  %01101100
	.byte  %00100100
	.byte  %00111100
	.byte  %00111101
	.byte  %00111101
	.byte  %00011111
	.byte  %00001000
	.byte  %00011100
	.byte  %00001000
	.byte  %00000000
	.byte  %00000000
	.byte  %00000000
	.byte  %00000000
	.byte  %00000000
	.byte  %00000000
	.byte  %00000000
 if ECHOFIRST
       echo "    ",[(scoretable - *)]d , "bytes of ROM space left")
 endif 
ECHOFIRST = 1
 
 
 

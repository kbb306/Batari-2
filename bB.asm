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

.L020 ;  doorctl  =  %00000000

	LDA #%00000000
	STA doorctl
.L021 ;  powertotal = 255

	LDA #255
	STA powertotal
.L022 ;  powerloss =  1

	LDA #1
	STA powerloss
.L023 ;  COLUPF = $0E

	LDA #$0E
	STA COLUPF
.L024 ;  scorecolor  =  $0E

	LDA #$0E
	STA scorecolor
.
 ; 

.L025 ;  player0:

	LDX #<playerL025_0
	STX player0pointerlo
	LDA #>playerL025_0
	STA player0pointerhi
	LDA #15
	STA player0height
.
 ; 

.L026 ;  player1:

	LDX #<playerL026_1
	STX player1pointerlo
	LDA #>playerL026_1
	STA player1pointerhi
	LDA #15
	STA player1height
.
 ; 

.
 ; 

.L027 ;  goto __Start

 jmp .__Start

.
 ; 

.__Map
 ; __Map

.
 ; 

.L028 ;  playfield:

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
.L029 ;  return

	RTS
.
 ; 

.__Start
 ; __Start

.L030 ;  gosub __Map

 jsr .__Map

.
 ; 

.
 ; 

.L031 ;  night  =  1

	LDA #1
	STA night
.L032 ;  score  =  0

	LDA #$00
	STA score+2
	LDA #$00
	STA score+1
	LDA #$00
	STA score
.L033 ;  move_rate  =  8

	LDA #8
	STA move_rate
.L034 ;  Bon_Tick  =  0

	LDA #0
	STA Bon_Tick
.L035 ;  Chic_Tick  =  0

	LDA #0
	STA Chic_Tick
.L036 ;  Fox_Tick  =  0

	LDA #0
	STA Fox_Tick
.L037 ;  doorctl  =  %00000000

	LDA #%00000000
	STA doorctl
.L038 ;  tick  =  0

	LDA #0
	STA tick
.L039 ;  seconds  =  0

	LDA #0
	STA seconds
.L040 ;  time  =  0

	LDA #0
	STA time
.L041 ;  powertotal  =  255

	LDA #255
	STA powertotal
.L042 ;  powerloss  =  1

	LDA #1
	STA powerloss
.L043 ;  power_tick  =  0

	LDA #0
	STA power_tick
.L044 ;  ai_second  =  0

	LDA #0
	STA ai_second
.L045 ;  input_latch  =  0

	LDA #0
	STA input_latch
.L046 ;  pfscore1  =  %10101010

	LDA #%10101010
	STA pfscore1
.
 ; 

.L047 ;  player0x  =  68

	LDA #68
	STA player0x
.L048 ;  player0y  =  4

	LDA #4
	STA player0y
.L049 ;  player1x  =  82

	LDA #82
	STA player1x
.L050 ;  player1y  =  4

	LDA #4
	STA player1y
.
 ; 

.L051 ;  ballx  =  26

	LDA #26
	STA ballx
.L052 ;  bally  =  18

	LDA #18
	STA bally
.L053 ;  ballheight  =  2

	LDA #2
	STA ballheight
.mainloop
 ; mainloop

.L054 ;  AUDV0  =  0

	LDA #0
	STA AUDV0
.L055 ;  AUDC0  =  0

	LDA #0
	STA AUDC0
.L056 ;  AUDF0  =  0

	LDA #0
	STA AUDF0
.L057 ;  COLUPF = $0E

	LDA #$0E
	STA COLUPF
.L058 ;  COLUP0  =  $74

	LDA #$74
	STA COLUP0
.L059 ;  COLUP1  =  $1C

	LDA #$1C
	STA COLUP1
.L060 ;  missile1x  =  84

	LDA #84
	STA missile1x
.L061 ;  if doorctl{2} then missile1y  =  81 else missile1y  =  72

	LDA doorctl
	AND #4
	BEQ .skipL061
.condpart0
	LDA #81
	STA missile1y
 jmp .skipelse0
.skipL061
	LDA #72
	STA missile1y
.skipelse0
.L062 ;  missile1height  =  9

	LDA #9
	STA missile1height
.L063 ;  missile0x  =  68

	LDA #68
	STA missile0x
.L064 ;  if doorctl{1} then missile0y  =  81 else missile0y  =  72

	LDA doorctl
	AND #2
	BEQ .skipL064
.condpart1
	LDA #81
	STA missile0y
 jmp .skipelse1
.skipL064
	LDA #72
	STA missile0y
.skipelse1
.L065 ;  missile0height  =  9

	LDA #9
	STA missile0height
.L066 ;  drawscreen

 jsr drawscreen
.
 ; 

.
 ; 

.L067 ;  if joy0left  &&  !input_latch{0} then doorctl{1}  =  !doorctl{1} : input_latch{0} = 1

 bit SWCHA
	BVS .skipL067
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
.skipL067
.L068 ;  if !joy0left then input_latch{0} = 0

 bit SWCHA
	BVC .skipL068
.condpart4
	LDA input_latch
	AND #254
	STA input_latch
.skipL068
.L069 ;  if joy0right  &&  !input_latch{1} then doorctl{2}  =  !doorctl{2} : input_latch{1} = 1

 bit SWCHA
	BMI .skipL069
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
.skipL069
.L070 ;  if !joy0right then input_latch{1} = 0

 bit SWCHA
	BPL .skipL070
.condpart7
	LDA input_latch
	AND #253
	STA input_latch
.skipL070
.L071 ;  if time  =  6 then goto __6am

	LDA time
	CMP #6
     BNE .skipL071
.condpart8
 jmp .__6am

.skipL071
.
 ; 

.
 ; 

.
 ; 

.L072 ;  if powertotal  >  75 then pfscore1  =  %10101010

	LDA #75
	CMP powertotal
     BCS .skipL072
.condpart9
	LDA #%10101010
	STA pfscore1
.skipL072
.L073 ;  if powertotal  <=  75 then pfscore1  =  %00101010

	LDA #75
	CMP powertotal
     BCC .skipL073
.condpart10
	LDA #%00101010
	STA pfscore1
.skipL073
.L074 ;  if powertotal  <=  50 then pfscore1  =  %00001010

	LDA #50
	CMP powertotal
     BCC .skipL074
.condpart11
	LDA #%00001010
	STA pfscore1
.skipL074
.L075 ;  if powertotal  <=  25 then pfscore1  =  %00000010

	LDA #25
	CMP powertotal
     BCC .skipL075
.condpart12
	LDA #%00000010
	STA pfscore1
.skipL075
.L076 ;  if powertotal  =  0 then pfscore1  =  0 : COLUPF = $00 : tick = 0 : seconds = 0 : goto __blackout

	LDA powertotal
	CMP #0
     BNE .skipL076
.condpart13
	LDA #0
	STA pfscore1
	LDA #$00
	STA COLUPF
	LDA #0
	STA tick
	STA seconds
 jmp .__blackout

.skipL076
.
 ; 

.
 ; 

.L077 ;  tick  =  tick + 1

	INC tick
.L078 ;  if tick  =  60 then seconds = seconds + 1 : tick = 0

	LDA tick
	CMP #60
     BNE .skipL078
.condpart14
	INC seconds
	LDA #0
	STA tick
.skipL078
.L079 ;  if seconds  =  90 then time = time + 1 : score = score + 1 : seconds = 0 : power_tick = 0 : ai_second = 0

	LDA seconds
	CMP #90
     BNE .skipL079
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
.skipL079
.
 ; 

.
 ; 

.
 ; 

.L080 ;  z  =  seconds  //  10

	LDA seconds
	LDY #10
 jsr div16
	STA z
.L081 ;  if temp1  =  0  &&  seconds  <>  power_tick then power_tick = seconds : goto __power

	LDA temp1
	CMP #0
     BNE .skipL081
.condpart16
	LDA seconds
	CMP power_tick
     BEQ .skip16then
.condpart17
	LDA seconds
	STA power_tick
 jmp .__power

.skip16then
.skipL081
.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L082 ;  move_rate  =  8

	LDA #8
	STA move_rate
.L083 ;  move_rate  =  move_rate  //  night

	LDA move_rate
	LDY night
 jsr div16
	STA move_rate
.L084 ;  if move_rate  =  0 then move_rate  =  1

	LDA move_rate
	CMP #0
     BNE .skipL084
.condpart18
	LDA #1
	STA move_rate
.skipL084
.L085 ;  z  =  seconds  //  move_rate

	LDA seconds
	LDY move_rate
 jsr div16
	STA z
.L086 ;  if temp1  =  0  &&  seconds  <>  ai_second then ai_second = seconds : z = rand // 32 : rand16 = temp1 : goto __AIroll

	LDA temp1
	CMP #0
     BNE .skipL086
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
.skipL086
.L087 ;  goto __AIstate

 jmp .__AIstate

.
 ; 

.__AIroll
 ; __AIroll

.
 ; 

.
 ; 

.L088 ;  if rand16  >=  20  &&  rand16  <=  21 then goto __Foxy

	LDA rand16
	CMP #20
     BCC .skipL088
.condpart21
	LDA #21
	CMP rand16
     BCC .skip21then
.condpart22
 jmp .__Foxy

.skip21then
.skipL088
.L089 ;  if rand16  >=  9  &&  rand16  <=  10 then goto __Chica

	LDA rand16
	CMP #9
     BCC .skipL089
.condpart23
	LDA #10
	CMP rand16
     BCC .skip23then
.condpart24
 jmp .__Chica

.skip23then
.skipL089
.L090 ;  if rand16  <=  1 then goto __Bonnie

	LDA #1
	CMP rand16
     BCC .skipL090
.condpart25
 jmp .__Bonnie

.skipL090
.L091 ;  goto __AIstate

 jmp .__AIstate

.
 ; 

.__AIstate
 ; __AIstate

.L092 ;  if joy1fire then goto __blackout

 bit INPT5
	BMI .skipL092
.condpart26
 jmp .__blackout

.skipL092
.
 ; 

.
 ; 

.
 ; 

.L093 ;  if Bon_Tick  =  1 then goto Bon1

	LDA Bon_Tick
	CMP #1
     BNE .skipL093
.condpart27
 jmp .Bon1

.skipL093
.L094 ;  if Bon_Tick  =  2 then goto Bon2

	LDA Bon_Tick
	CMP #2
     BNE .skipL094
.condpart28
 jmp .Bon2

.skipL094
.L095 ;  if Bon_Tick  =  3 then goto Bon3

	LDA Bon_Tick
	CMP #3
     BNE .skipL095
.condpart29
 jmp .Bon3

.skipL095
.L096 ;  if Bon_Tick  =  4 then goto Bon4

	LDA Bon_Tick
	CMP #4
     BNE .skipL096
.condpart30
 jmp .Bon4

.skipL096
.L097 ;  if Bon_Tick  >=  5 then goto BonJump

	LDA Bon_Tick
	CMP #5
     BCC .skipL097
.condpart31
 jmp .BonJump

.skipL097
.L098 ;  if Chic_Tick  =  1 then goto Chic1

	LDA Chic_Tick
	CMP #1
     BNE .skipL098
.condpart32
 jmp .Chic1

.skipL098
.L099 ;  if Chic_Tick  =  2 then goto Chic2

	LDA Chic_Tick
	CMP #2
     BNE .skipL099
.condpart33
 jmp .Chic2

.skipL099
.L0100 ;  if Chic_Tick  =  3 then goto Chic3

	LDA Chic_Tick
	CMP #3
     BNE .skipL0100
.condpart34
 jmp .Chic3

.skipL0100
.L0101 ;  if Chic_Tick  =  4 then goto Chic4

	LDA Chic_Tick
	CMP #4
     BNE .skipL0101
.condpart35
 jmp .Chic4

.skipL0101
.L0102 ;  if Chic_Tick  >=  5 then goto ChicJump

	LDA Chic_Tick
	CMP #5
     BCC .skipL0102
.condpart36
 jmp .ChicJump

.skipL0102
.L0103 ;  if Fox_Tick  =  1 then goto Fox1

	LDA Fox_Tick
	CMP #1
     BNE .skipL0103
.condpart37
 jmp .Fox1

.skipL0103
.L0104 ;  if Fox_Tick  =  2 then goto Fox2

	LDA Fox_Tick
	CMP #2
     BNE .skipL0104
.condpart38
 jmp .Fox2

.skipL0104
.L0105 ;  if Fox_Tick  =  3 then goto Fox3

	LDA Fox_Tick
	CMP #3
     BNE .skipL0105
.condpart39
 jmp .Fox3

.skipL0105
.L0106 ;  if Fox_Tick  =  4 then goto Fox4

	LDA Fox_Tick
	CMP #4
     BNE .skipL0106
.condpart40
 jmp .Fox4

.skipL0106
.L0107 ;  if Fox_Tick  >=  5 then goto FoxJump

	LDA Fox_Tick
	CMP #5
     BCC .skipL0107
.condpart41
 jmp .FoxJump

.skipL0107
.L0108 ;  goto mainloop

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

.L0109 ;  playfield:

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
.L0110 ;  drawscreen

 jsr drawscreen
.
 ; 

.
 ; 

.
 ; 

.L0111 ;  if joy0fire then goto __NextNight

 bit INPT4
	BMI .skipL0111
.condpart42
 jmp .__NextNight

.skipL0111
.L0112 ;  goto __6am

 jmp .__6am

.
 ; 

.__NextNight
 ; __NextNight

.L0113 ;  score = score - 6

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
.L0114 ;  score = score + 100000

	SED
	CLC
	LDA score
	ADC #$10
	STA score
	CLD
.L0115 ;  night = night + 1

	INC night
.L0116 ;  gosub __Map

 jsr .__Map

.L0117 ;  Bon_Tick = 0

	LDA #0
	STA Bon_Tick
.L0118 ;  Chic_Tick = 0

	LDA #0
	STA Chic_Tick
.L0119 ;  Fox_Tick = 0

	LDA #0
	STA Fox_Tick
.L0120 ;  player0x = 68

	LDA #68
	STA player0x
.L0121 ;  player0y = 4

	LDA #4
	STA player0y
.L0122 ;  player1x = 82

	LDA #82
	STA player1x
.L0123 ;  player1y = 4

	LDA #4
	STA player1y
.L0124 ;  ballx = 26

	LDA #26
	STA ballx
.L0125 ;  bally = 18

	LDA #18
	STA bally
.L0126 ;  doorctl = %00000000

	LDA #%00000000
	STA doorctl
.L0127 ;  input_latch = 0

	LDA #0
	STA input_latch
.L0128 ;  powertotal = 255

	LDA #255
	STA powertotal
.L0129 ;  powerloss = 1

	LDA #1
	STA powerloss
.L0130 ;  time = 0

	LDA #0
	STA time
.L0131 ;  seconds = 0

	LDA #0
	STA seconds
.L0132 ;  tick = 0

	LDA #0
	STA tick
.L0133 ;  power_tick = 0

	LDA #0
	STA power_tick
.L0134 ;  ai_second = 0

	LDA #0
	STA ai_second
.L0135 ;  pfscore1 = %10101010

	LDA #%10101010
	STA pfscore1
.L0136 ;  goto mainloop

 jmp .mainloop

.__power
 ; __power

.
 ; 

.
 ; 

.
 ; 

.L0137 ;  powerloss  =  1

	LDA #1
	STA powerloss
.L0138 ;  if doorctl{1} then powerloss  =  powerloss  +  1

	LDA doorctl
	AND #2
	BEQ .skipL0138
.condpart43
	INC powerloss
.skipL0138
.L0139 ;  if doorctl{2} then powerloss  =  powerloss  +  1

	LDA doorctl
	AND #4
	BEQ .skipL0139
.condpart44
	INC powerloss
.skipL0139
.L0140 ;  if powertotal  <=  powerloss then powertotal = 0 else powertotal = powertotal - powerloss

	LDA powerloss
	CMP powertotal
     BCC .skipL0140
.condpart45
	LDA #0
	STA powertotal
 jmp .skipelse2
.skipL0140
	LDA powertotal
	SEC
	SBC powerloss
	STA powertotal
.skipelse2
.L0141 ;  goto mainloop

 jmp .mainloop

.
 ; 

.__blackout
 ; __blackout

.
 ; 

.
 ; 

.L0142 ;  playfield:

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
.L0143 ;  tick  =  tick  +  1

	INC tick
.L0144 ;  if tick  =  60 then tick = 0 : seconds = seconds + 1

	LDA tick
	CMP #60
     BNE .skipL0144
.condpart46
	LDA #0
	STA tick
	INC seconds
.skipL0144
.L0145 ;  if seconds  =  60 then COLUPF  =  $E4 : gosub __Sound : seconds = 61

	LDA seconds
	CMP #60
     BNE .skipL0145
.condpart47
	LDA #$E4
	STA COLUPF
 jsr .__Sound
	LDA #61
	STA seconds
.skipL0145
.L0146 ;  drawscreen

 jsr drawscreen
.L0147 ;  if joy0fire then goto __Start else goto __blackout

 bit INPT4
	BMI .skipL0147
.condpart48
 jmp .__Start
 jmp .skipelse3
.skipL0147
 jmp .__blackout

.skipelse3
.
 ; 

.
 ; 

.__Bonnie
 ; __Bonnie

.L0148 ;  Bon_Tick  =  Bon_Tick  + 1

	INC Bon_Tick
.L0149 ;  goto mainloop

 jmp .mainloop

.
 ; 

.Bon1
 ; Bon1

.
 ; 

.L0150 ;  player0x  =  54

	LDA #54
	STA player0x
.L0151 ;  player0y  =  20

	LDA #20
	STA player0y
.L0152 ;  goto mainloop

 jmp .mainloop

.Bon2
 ; Bon2

.
 ; 

.L0153 ;  player0x  =  34

	LDA #34
	STA player0x
.L0154 ;  player0y  =  38

	LDA #38
	STA player0y
.L0155 ;  goto mainloop

 jmp .mainloop

.Bon3
 ; Bon3

.
 ; 

.L0156 ;  player0x  =  44

	LDA #44
	STA player0x
.L0157 ;  player0y  =  56

	LDA #56
	STA player0y
.L0158 ;  goto mainloop

 jmp .mainloop

.Bon4
 ; Bon4

.
 ; 

.L0159 ;  player0x  =  58

	LDA #58
	STA player0x
.L0160 ;  player0y  =  72

	LDA #72
	STA player0y
.L0161 ;  goto mainloop

 jmp .mainloop

.BonJump
 ; BonJump

.
 ; 

.L0162 ;  if doorctl{1} then Bon_Tick = 0 : player0x = 68 : player0y = 4 : goto mainloop

	LDA doorctl
	AND #2
	BEQ .skipL0162
.condpart49
	LDA #0
	STA Bon_Tick
	LDA #68
	STA player0x
	LDA #4
	STA player0y
 jmp .mainloop

.skipL0162
.L0163 ;  playfield:

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
.L0164 ;  COLUPF = $62 : gosub __Sound : drawscreen

	LDA #$62
	STA COLUPF
 jsr .__Sound
 jsr drawscreen
.L0165 ;  if joy0fire then goto __Start else goto BonJump

 bit INPT4
	BMI .skipL0165
.condpart50
 jmp .__Start
 jmp .skipelse4
.skipL0165
 jmp .BonJump

.skipelse4
.
 ; 

.
 ; 

.__Chica
 ; __Chica

.L0166 ;  Chic_Tick  =  Chic_Tick  +  1

	INC Chic_Tick
.L0167 ;  goto mainloop

 jmp .mainloop

.Chic1
 ; Chic1

.
 ; 

.L0168 ;  player1x  =  98

	LDA #98
	STA player1x
.L0169 ;  player1y  =  20

	LDA #20
	STA player1y
.L0170 ;  goto mainloop

 jmp .mainloop

.Chic2
 ; Chic2

.
 ; 

.L0171 ;  player1x  =  118

	LDA #118
	STA player1x
.L0172 ;  player1y  =  38

	LDA #38
	STA player1y
.L0173 ;  goto mainloop

 jmp .mainloop

.Chic3
 ; Chic3

.
 ; 

.L0174 ;  player1x  =  108

	LDA #108
	STA player1x
.L0175 ;  player1y  =  56

	LDA #56
	STA player1y
.L0176 ;  goto mainloop

 jmp .mainloop

.Chic4
 ; Chic4

.
 ; 

.L0177 ;  player1x  =  90

	LDA #90
	STA player1x
.L0178 ;  player1y  =  72

	LDA #72
	STA player1y
.L0179 ;  goto mainloop

 jmp .mainloop

.ChicJump
 ; ChicJump

.
 ; 

.L0180 ;  if doorctl{2} then Chic_Tick = 0 : player1x = 82 : player1y = 4 : goto mainloop

	LDA doorctl
	AND #4
	BEQ .skipL0180
.condpart51
	LDA #0
	STA Chic_Tick
	LDA #82
	STA player1x
	LDA #4
	STA player1y
 jmp .mainloop

.skipL0180
.L0181 ;  playfield:

  ifconst pfres
	  ldx #(12>pfres)*(pfres*pfwidth-1)+(12<=pfres)*47
  else
	  ldx #((12*pfwidth-1)*((12*pfwidth-1)<47))+(47*((12*pfwidth-1)>=47))
  endif
	jmp pflabel4
PF_data4
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
pflabel4
	lda PF_data4,x
	sta playfield,x
	dex
	bpl pflabel4
.L0182 ;  COLUPF = $1C : gosub __Sound : drawscreen

	LDA #$1C
	STA COLUPF
 jsr .__Sound
 jsr drawscreen
.L0183 ;  if joy0fire then goto __Start else goto ChicJump

 bit INPT4
	BMI .skipL0183
.condpart52
 jmp .__Start
 jmp .skipelse5
.skipL0183
 jmp .ChicJump

.skipelse5
.
 ; 

.__Foxy
 ; __Foxy

.L0184 ;  if doorctl{1} then Fox_Tick = 0 : ballx = 26 : bally = 18 : goto mainloop else Fox_Tick = Fox_Tick + 1

	LDA doorctl
	AND #2
	BEQ .skipL0184
.condpart53
	LDA #0
	STA Fox_Tick
	LDA #26
	STA ballx
	LDA #18
	STA bally
 jmp .mainloop
 jmp .skipelse6
.skipL0184
	INC Fox_Tick
.skipelse6
.L0185 ;  goto mainloop

 jmp .mainloop

.Fox1
 ; Fox1

.L0186 ;  if doorctl{1} then Fox_Tick = 0 : ballx = 26 : bally = 18 : goto mainloop

	LDA doorctl
	AND #2
	BEQ .skipL0186
.condpart54
	LDA #0
	STA Fox_Tick
	LDA #26
	STA ballx
	LDA #18
	STA bally
 jmp .mainloop

.skipL0186
.L0187 ;  ballx  =  34

	LDA #34
	STA ballx
.L0188 ;  bally  =  28

	LDA #28
	STA bally
.L0189 ;  goto mainloop

 jmp .mainloop

.Fox2
 ; Fox2

.L0190 ;  if doorctl{1} then Fox_Tick = 0 : ballx = 26 : bally = 18 : goto mainloop

	LDA doorctl
	AND #2
	BEQ .skipL0190
.condpart55
	LDA #0
	STA Fox_Tick
	LDA #26
	STA ballx
	LDA #18
	STA bally
 jmp .mainloop

.skipL0190
.L0191 ;  ballx  =  42

	LDA #42
	STA ballx
.L0192 ;  bally  =  40

	LDA #40
	STA bally
.L0193 ;  goto mainloop

 jmp .mainloop

.Fox3
 ; Fox3

.L0194 ;  if doorctl{1} then Fox_Tick = 0 : ballx = 26 : bally = 18 : goto mainloop

	LDA doorctl
	AND #2
	BEQ .skipL0194
.condpart56
	LDA #0
	STA Fox_Tick
	LDA #26
	STA ballx
	LDA #18
	STA bally
 jmp .mainloop

.skipL0194
.L0195 ;  ballx  =  52

	LDA #52
	STA ballx
.L0196 ;  bally  =  52

	LDA #52
	STA bally
.L0197 ;  goto mainloop

 jmp .mainloop

.Fox4
 ; Fox4

.L0198 ;  if doorctl{1} then Fox_Tick = 0 : ballx = 26 : bally = 18 : goto mainloop

	LDA doorctl
	AND #2
	BEQ .skipL0198
.condpart57
	LDA #0
	STA Fox_Tick
	LDA #26
	STA ballx
	LDA #18
	STA bally
 jmp .mainloop

.skipL0198
.L0199 ;  ballx  =  60

	LDA #60
	STA ballx
.L0200 ;  bally  =  64

	LDA #64
	STA bally
.L0201 ;  goto mainloop

 jmp .mainloop

.FoxJump
 ; FoxJump

.
 ; 

.
 ; 

.
 ; 

.L0202 ;  ballx  =  68

	LDA #68
	STA ballx
.L0203 ;  bally  =  81

	LDA #81
	STA bally
.L0204 ;  if collision(ball,missile0) then Fox_Tick = 0 : ballx = 26 : bally = 18 : goto mainloop

	bit 	CXM0FB
	BVC .skipL0204
.condpart58
	LDA #0
	STA Fox_Tick
	LDA #26
	STA ballx
	LDA #18
	STA bally
 jmp .mainloop

.skipL0204
.L0205 ;  playfield:

  ifconst pfres
	  ldx #(12>pfres)*(pfres*pfwidth-1)+(12<=pfres)*47
  else
	  ldx #((12*pfwidth-1)*((12*pfwidth-1)<47))+(47*((12*pfwidth-1)>=47))
  endif
	jmp pflabel5
PF_data5
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
pflabel5
	lda PF_data5,x
	sta playfield,x
	dex
	bpl pflabel5
.
 ; 

.L0206 ;  COLUPF = $34 : gosub __Sound : drawscreen

	LDA #$34
	STA COLUPF
 jsr .__Sound
 jsr drawscreen
.L0207 ;  if joy0fire then goto __Start else goto FoxJump

 bit INPT4
	BMI .skipL0207
.condpart59
 jmp .__Start
 jmp .skipelse7
.skipL0207
 jmp .FoxJump

.skipelse7
.__Sound
 ; __Sound

.
 ; 

.L0208 ;  return
	RTS
 if (<*) > (<(*+15))
	repeat ($100-<*)
	.byte 0
	repend
	endif
playerL025_0
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
playerL026_1
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
 
 
 

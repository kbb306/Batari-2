 set tv ntsc
 include div_mul16.asm
 const pfscore = 1
 pfscorecolor = $B8
 pfscore1 = %10101010
 dim doorctl = a
 dim tick = b
 dim seconds = c
 dim time = d
 dim night = e
 dim powertotal = f
 dim powerloss = g
 dim rand16 = h
 dim move_rate = i
 dim Bon_Tick = j
 dim Chic_Tick = k
 dim Fox_Tick = l
 dim power_tick = m
 dim ai_second = n
 dim input_latch = o
 doorctl = %00000000
 powertotal=255
 powerloss= 1
 COLUPF=$0E
 scorecolor = $0E

 player0:
 %01101100
 %00100100
 %00111101
 %00111101
 %00111111
 %00011100
 %00001000
 %00011100
 %00010100
 %00010100
 %00110100
 %00001100
 %00000000
 %00000000
 %00000000
 %00000000
end

 player1:
 %01101100
 %00100100
 %00111100
 %00111101
 %00111101
 %00011111
 %00001000
 %00011100
 %00001000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
end
; Keep the normal map in a subroutine so a restart after a face/blackout
; can put the playfield back the way it was.
 goto __Start

__Map
;This is the main map
 playfield:
   XXXX......XXXXXXXXXXX.....XXX.XX
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   XXXX..XXXXXXXXXXXXXXXXXXX.XXX...
   ......XXXXXXXXXXXXXXXXXXX.XXX...
   ..XXXXXXXXXXXXXXXXXXXXXXX.XXX.XX
   ..XXXXXXXXXXXXXXXXXXXXXXX.XXXXXX
   ..........X.......X.....X.......
   ....XXX..XXX.....XXX....XXXXXXXX
   ....XXXXXXXX.XXX.XXX....XXXXXXXX
   ....XXX..XXXXXXXXXXX....XXXXXXXX
   .........XXX.XXX.XXX............
end
 return

__Start
 gosub __Map
 ; A true new-game reset.  Night-to-night transitions do NOT use __Start,
 ; so it is safe to clear the score and return to Night 1 here.
 night = 1
 score = 0
 move_rate = 8
 Bon_Tick = 0
 Chic_Tick = 0
 Fox_Tick = 0
 doorctl = %00000000
 tick = 0
 seconds = 0
 time = 0
 powertotal = 255
 powerloss = 1
 power_tick = 0
 ai_second = 0
 input_latch = 0
 pfscore1 = %10101010
 ; Initial map positions.  The room-state handlers below move each marker.
 player0x = 68
 player0y = 4
 player1x = 82
 player1y = 4
 ; Foxy uses the TIA ball as a simple radar/map blip.
 ballx = 26
 bally = 18
 ballheight = 2
mainloop
 AUDV0 = 0
 AUDC0 = 0
 AUDF0 = 0
 COLUPF=$0E
 COLUP0 = $74
 COLUP1 = $1C
 missile1x = 84
 if doorctl{2} then missile1y = 81 else missile1y = 72
 missile1height = 9
 missile0x = 68
 if doorctl{1} then missile0y = 81 else missile0y = 72
 missile0height = 9
 drawscreen
 ; Door controls are toggles.  Latch each direction so one physical
 ; keypress changes a door once instead of toggling at ~60 Hz.
    if joy0left && !input_latch{0} then doorctl{1} = !doorctl{1}:input_latch{0}=1
    if !joy0left then input_latch{0}=0
    if joy0right && !input_latch{1} then doorctl{2} = !doorctl{2}:input_latch{1}=1
    if !joy0right then input_latch{1}=0
    if time = 6 then goto __6am

    ; Rebuild the power display from the current total instead of
    ; repeatedly dividing it every video frame.
    if powertotal > 75 then pfscore1 = %10101010
    if powertotal <= 75 then pfscore1 = %00101010
    if powertotal <= 50 then pfscore1 = %00001010
    if powertotal <= 25 then pfscore1 = %00000010
    if powertotal = 0 then pfscore1 = 0:COLUPF=$00:tick=0:seconds=0:goto __blackout

    ; 60 frames = one second.  Every 90 seconds advances the hour once.
    tick = tick+1
    if tick = 60 then seconds=seconds+1:tick=0
    if seconds = 90 then time=time+1:score=score+1:seconds=0:power_tick=0:ai_second=0

    ; Drain power once at each ten-second boundary, not once per frame
    ; for the whole boundary second.
    z = seconds // 10
    if temp1 = 0 && seconds <> power_tick then power_tick=seconds:goto __power

    ; Original difficulty idea, repaired: start from the base interval every
    ; frame, then divide by the current night.  The old code divided the
    ; already-divided value over and over until it reached zero.
    move_rate = 8
    move_rate = move_rate // night
    if move_rate = 0 then move_rate = 1
    z = seconds // move_rate
    if temp1 = 0 && seconds <> ai_second then ai_second=seconds:z=rand//32:rand16=temp1:goto __AIroll
    goto __AIstate

__AIroll
    ; rand16 is the random result.  Bon_Tick is j, so never use j here:
    ; doing so overwrites Bonnie's room/state with the random number.
    if rand16 >= 20 && rand16 <= 21 then goto __Foxy
    if rand16 >= 9 && rand16 <= 10 then goto __Chica
    if rand16 <= 1 then goto __Bonnie
    goto __AIstate

__AIstate
    if joy1fire then goto __blackout

    ; Explicit state dispatch avoids the old ON...GOTO state-0 trap and
    ; still lets the timing/random logic above run on every frame.
    if Bon_Tick = 1 then goto Bon1
    if Bon_Tick = 2 then goto Bon2
    if Bon_Tick = 3 then goto Bon3
    if Bon_Tick = 4 then goto Bon4
    if Bon_Tick >= 5 then goto BonJump
    if Chic_Tick = 1 then goto Chic1
    if Chic_Tick = 2 then goto Chic2
    if Chic_Tick = 3 then goto Chic3
    if Chic_Tick = 4 then goto Chic4
    if Chic_Tick >= 5 then goto ChicJump
    if Fox_Tick = 1 then goto Fox1
    if Fox_Tick = 2 then goto Fox2
    if Fox_Tick = 3 then goto Fox3
    if Fox_Tick = 4 then goto Fox4
    if Fox_Tick >= 5 then goto FoxJump
    goto mainloop
   
   

__6am
;This is 6 AM
 playfield:
   XXXXXXXX.....XXXXXX...X.......X.
   X...........X......X..X.......X.
   X...........X......X..X.X...X.X.
   XXXXXXXXX...XXXXXXXX..X..XXX..X.
   X......X....X......X..X.......X.
   X......X....X......X..X.......X.
   XXXXXXXX....X......X..X.......X.
end
 drawscreen
 ; Advance the night only once, when the player leaves the 6 AM screen.
 ; Restore the map and reset every per-night actor/control state so the
 ; next night cannot inherit positions or closed doors from the last one.
 if joy0fire then goto __NextNight
 goto __6am

__NextNight
 score=score-6
 score=score+100000
 night=night+1
 gosub __Map
 Bon_Tick=0
 Chic_Tick=0
 Fox_Tick=0
 player0x=68
 player0y=4
 player1x=82
 player1y=4
 ballx=26
 bally=18
 doorctl=%00000000
 input_latch=0
 powertotal=255
 powerloss=1
 time=0
 seconds=0
 tick=0
 power_tick=0
 ai_second=0
 pfscore1=%10101010
 goto mainloop
__power
 ; Base drain is one unit.  Each closed door costs one additional unit
 ; at a drain event.  The old ** 1.01 expressions were integer multiplies
 ; and therefore never increased powerloss.
 powerloss = 1
 if doorctl{1} then powerloss = powerloss + 1
 if doorctl{2} then powerloss = powerloss + 1
 if powertotal <= powerloss then powertotal=0 else powertotal=powertotal-powerloss
 goto mainloop

__blackout
;This is Freddy

 playfield:
   XXXXXX.....................XXXXX
   XXXXXX.....................XXXXX
   XXXXXX.....................XXXXX
   .....XXXX..............XXXX.....
   .....XXXX..............XXXX.....
   ..............XXXX..............
   .........XXXXXXXXXXXXXX.........
   .........XXXXXXXXXXXXXX.........
   .........X....X..X....X.........
   ..............XXXX..............
   ........XXX..........XXX........
   ........XXXXXXXXXXXXXXXX........
end
 tick = tick + 1
 if tick = 60 then tick=0:seconds=seconds+1
 if seconds = 60 then COLUPF = $E4:gosub __Sound:seconds=61
 drawscreen
 if joy0fire then goto __Start else goto __blackout
 

__Bonnie
   Bon_Tick = Bon_Tick +1
   goto mainloop

Bon1
;Bonnie's first room
   player0x = 54
   player0y = 20
   goto mainloop
Bon2
;Bonnie room 2
   player0x = 34
   player0y = 38
   goto mainloop
Bon3
;Bonnie room 3
   player0x = 44
   player0y = 56
   goto mainloop
Bon4
;Bonnie room 4 - just outside the left door
   player0x = 58
   player0y = 72
   goto mainloop
BonJump
;Bonnie
 if doorctl{1} then Bon_Tick=0:player0x=68:player0y=4:goto mainloop
 playfield:
   ...XXXX.................XXXX....
   ...XXXX.................XXXX....
   ...XXXX.................XXXX....
   ....XX...................XX.....
   ....XXXXXXXXXXXXXXXXXXXXXXX.....
   ....X..XXXX.........XXXX..X.....
   ....X..XXXX.........XXXX..X.....
   ....X.....................X.....
   ....X........XXXXX........X.....
   ....X.....XXXXXXXXXXX.....X.....
   ....X.....XXXXXXXXXXX.....X.....
   ....X.....................X.....
end
 COLUPF=$62:gosub __Sound:drawscreen
 if joy0fire then goto __Start else goto BonJump
      
   
__Chica
   Chic_Tick = Chic_Tick + 1
   goto mainloop
Chic1
    ;Room 1
   player1x = 98
   player1y = 20
   goto mainloop
Chic2
    ;Room 2
   player1x = 118
   player1y = 38
   goto mainloop
Chic3
      ;Room 3
   player1x = 108
   player1y = 56
   goto mainloop
Chic4
      ;Room 4 - just outside the right door
   player1x = 90
   player1y = 72
   goto mainloop
ChicJump 
;Chica
 if doorctl{2} then Chic_Tick=0:player1x=82:player1y=4:goto mainloop
 playfield:
   .##############################.
   .#............................#.
   .#.....######.....######......#.
   .#.....######.....######......#.
   .#.....######.....######......#.
   .#............................#.
   .#............................#.
   .#..........#######...........#.
   .#............###.............#.
   .#..........#######...........#.
   .#............................#.
   .##############################.
end
 COLUPF=$1C:gosub __Sound:drawscreen 
 if joy0fire then goto __Start else goto ChicJump

__Foxy
   if doorctl{1} then Fox_Tick=0:ballx=26:bally=18:goto mainloop else Fox_Tick=Fox_Tick+1
   goto mainloop
Fox1
   if doorctl{1} then Fox_Tick=0:ballx=26:bally=18:goto mainloop
   ballx = 34
   bally = 28
   goto mainloop
Fox2
   if doorctl{1} then Fox_Tick=0:ballx=26:bally=18:goto mainloop
   ballx = 42
   bally = 40
   goto mainloop
Fox3
   if doorctl{1} then Fox_Tick=0:ballx=26:bally=18:goto mainloop
   ballx = 52
   bally = 52
   goto mainloop
Fox4
   if doorctl{1} then Fox_Tick=0:ballx=26:bally=18:goto mainloop
   ballx = 60
   bally = 64
   goto mainloop
FoxJump
;Foxy
 ; Final charge puts the ball on the CLOSED left-door position.
 ; An open door is at y=72; a closed door is at y=81.
 ballx = 68
 bally = 81
 if collision(ball,missile0) then Fox_Tick=0:ballx=26:bally=18:goto mainloop
 playfield:
   #####......................#####
   #####......................#####
   ..###......................###..
   ...##########################...
   ...#................#####...#...
   ...#................#####...#...
   ..#.........########.........#..
   .#..........#......#..........#.
   ..#..........######..........#..
   ...#........#......#........#...
   ...#........########........#...
   ...##########################...
end
; Fast Sprite Movement Here
 COLUPF=$34:gosub __Sound:drawscreen 
 if joy0fire then goto __Start else goto FoxJump
__Sound
   ;This plays scream
   return
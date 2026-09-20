 set romsize 4k
__intro
 dim qtcontroller = a
 dim rand16 = b
 dim RowNum = c
 dim ColNum = d
 dim IsCollide = e
 dim Debug = f
 dim PlayerUpDown = player0y.p
 dim PlayerLeftRight = player0x.q
 COLUPF = $0E
 y = rand
 if y > 0 && y < 85 then goto __Room2:player0x = 79:player0y = 44:RowNum = 2:ColNum = 1
 if y > 85 && y < 170 then goto __Room4:player0x = 79:player0y = 44:RowNum = 5:ColNum = 2
 if Y > 170 then goto __Room8:player0x = 79:player0y = 44:RowNum = 2:ColNum = 4
 player0:
 %00000000
 %00000000
 %01100110
 %00100100
 %00100100
 %10111101
 %10111101
 %01111110
 %00111100
 %00101000
 %01111110
 %01100110
 %00000000
 %00000000
 %00000000
 %00000000
end
__RoomCTL 
 if RowNum = 1 && ColNum = 4 then goto __Room9
 if RowNum = 2 && ColNum = 1 then goto __Room4
 if RowNum = 2 && ColNum = 2 then goto __Room6
 if RowNum = 2 && ColNum = 3 then goto __Room5
 if RowNum = 2 && ColNum = 4 then goto __Room2
 if RowNum = 3 && ColNum = 1 then goto __Room4
 if RowNum = 3 && ColNum = 2 then goto __Room7
 if RowNum = 3 && ColNum = 3 then goto __Room11
 if RowNum = 3 && ColNum = 4 then goto __Room10
 if RowNum = 3 && ColNum = 5 then goto __Room11
 if RowNum = 4 && ColNum = 1 then goto __Room4
 if RowNum = 4 && ColNum = 2 then goto __Room7
 if RowNum = 4 && ColNum = 3 then goto __Room11
 if RowNum = 4 && ColNum = 4 then goto __Room8
 if RowNum = 5 && ColNum = 2 then goto __Room8
 if joy1fire then Debug = Debug + 1
 if Debug = 12 then Debug = 0
 on Debug goto __Room1 __Room2 __Room3 __Room4 __Room5 __Room6 __Room7 __Room8 __Room9 __Room10 __Room11 
__Room1
 COLUP0 = $F8
 playfield:
   XXXXXXXXXXX.........XXXXXXXXXXXX
   X..............................X
   X..............................X
   X..............................X
   X..............................X
   X..............................X
   X..............................X
   X..............................X
   X..............................X
   X..............................X
   X..............................X
   XXXXXXXXXXX..........XXXXXXXXXXX
end
 if collision(playfield,player0) then IsCollide = 1 else IsCollide = 0
 drawscreen
 if player0y = 0 && IsCollide = 0 then RowNum = RowNum + 1:player0y = 87:goto __RoomCTL
 if player0y = 88 && IsCollide = 0 then RowNum = RowNum - 1:player0y = 1:goto __RoomCTL
 if player0x = 0 && IsCollide = 0 then ColNum = ColNum - 1:player0x = 158:goto __RoomCTL
 if player0x = 0 && IsCollide = 159 then ColNum = ColNum + 1:player0x = 1:goto __RoomCTL
 gosub __PlayerCTRL
 goto __Room1

__Room2
 COLUP0 = $F8
 playfield:
   XXXXXXXXXXXXX........XXXXXXXXXXX
   X..............................X
   X..............................X
   X..............................X
   ...............................X
   ...............................X
   ...............................X
   X..............................X
   X..............................X
   X..............................X
   XXXXXXXXXXXX........XXXXXXXXXXXX    
end
 drawscreen
 if collision(playfield,player0) then IsCollide = 1 else IsCollide = 0
 if player0y = 0 && IsCollide = 0 then RowNum = RowNum + 1:player0y = 87:goto __RoomCTL
 if player0y = 88 && IsCollide = 0 then RowNum = RowNum - 1:player0y = 1:goto __RoomCTL
 if player0x = 0 && IsCollide = 0 then ColNum = ColNum - 1:player0x = 158:goto __RoomCTL
 if player0x = 0 && IsCollide = 159 then ColNum = ColNum + 1:player0x = 1:goto __RoomCTL
 gosub __PlayerCTRL
 goto __Room2

__Room3
 COLUP0 = $F8
 playfield:
   XXXXXXXXXXXX........XXXXXXXXXXXX
   X..............................X
   X..............................X
   X..............................X
   ...............................X
   ...............................X
   ...............................X
   X..............................X
   X..............................X
   X..............................X
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
 drawscreen
 if collision(playfield,player0) then IsCollide = 1 else IsCollide = 0
 if player0y = 0 && IsCollide = 0 then RowNum = RowNum + 1:player0y = 87:goto __RoomCTL
 if player0y = 88 && IsCollide = 0 then RowNum = RowNum - 1:player0y = 1:goto __RoomCTL
 if player0x = 0 && IsCollide = 0 then ColNum = ColNum - 1:player0x = 158:goto __RoomCTL
 if player0x = 0 && IsCollide = 159 then ColNum = ColNum + 1:player0x = 2:goto __RoomCTL
 gosub __PlayerCTRL
 goto __Room3

__Room4
 COLUP0 = $F8
 playfield:
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   X..............................X
   X..............................X
   X..............................X
   X...............................
   X...............................
   X...............................
   X..............................X
   X..............................X
   X..............................X
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
 drawscreen
 if collision(playfield,player0) then IsCollide = 1 else IsCollide = 0
 if player0y = 0 && IsCollide = 0 then RowNum = RowNum + 1:player0y = 87:goto __RoomCTL
 if player0y = 88 && IsCollide = 0 then RowNum = RowNum - 1:player0y = 1:goto __RoomCTL
 if player0x = 0 && IsCollide = 0 then ColNum = ColNum - 1:player0x = 158:goto __RoomCTL
 if player0x = 0 && IsCollide = 159 then ColNum = ColNum + 1:player0x = 1:goto __RoomCTL
 gosub __PlayerCTRL
 goto __Room4

__Room5
 COLUP0 = $F8
 playfield:
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   X..............................X
   X..............................X
   X..............................X
   ................................
   ................................
   ................................
   X..............................X
   X..............................X
   X..............................X
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
 drawscreen
 if collision(playfield,player0) then IsCollide = 1 else IsCollide = 0
 if player0y = 0 && IsCollide = 0 then RowNum = RowNum + 1:player0y = 87:goto __RoomCTL
 if player0y = 88 && IsCollide = 0 then RowNum = RowNum - 1:player0y = 1:goto __RoomCTL
 if player0x = 0 && IsCollide = 0 then ColNum = ColNum - 1:player0x = 158:goto __RoomCTL
 if player0x = 0 && IsCollide = 159 then ColNum = ColNum + 1:player0x = 1:goto __RoomCTL
 gosub __PlayerCTRL
 goto __Room5

__Room6
 COLUP0 = $F8
 playfield:
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   X..............................X
   X..............................X
   X..............................X
   ................................
   ................................
   ................................
   X..............................X
   X..............................X
   X..............................X
   XXXXXXXXXXXX........XXXXXXXXXXXX
end
  drawscreen
  if collision(playfield,player0) then IsCollide = 1 else IsCollide = 0
  if player0y = 0 && IsCollide = 0 then RowNum = RowNum + 1:player0y = 87:goto __RoomCTL
  if player0y = 88 && IsCollide = 0 then RowNum = RowNum - 1:player0y = 1:goto __RoomCTL
  if player0x = 0 && IsCollide = 0 then ColNum = ColNum - 1:player0x = 158:goto __RoomCTL
  if player0x = 0 && IsCollide = 159 then ColNum = ColNum + 1:player0x = 1:goto __RoomCTL
  gosub __PlayerCTRL
  goto __Room6

__Room7
 COLUP0 = $F8
 playfield:
   XXXXXXXXXXXX........XXXXXXXXXXXX
   X..............................X
   X..............................X
   X..............................X
   ................................
   ................................
   ................................
   X..............................X
   X..............................X
   X..............................X
   XXXXXXXXXXXX........XXXXXXXXXXXX
end
 drawscreen
 if collision(playfield,player0) then IsCollide = 1 else IsCollide = 0
 if player0y = 0 && IsCollide = 0 then RowNum = RowNum + 1:player0y = 87:goto __RoomCTL
 if player0y = 88 && IsCollide = 0 then RowNum = RowNum - 1:player0y = 1:goto __RoomCTL
 if player0x = 0 && IsCollide = 0 then ColNum = ColNum - 1:player0x = 158:goto __RoomCTL
 if player0x = 0 && IsCollide = 159 then ColNum = ColNum + 1:player0x = 1:goto __RoomCTL
 gosub __PlayerCTRL
 goto __Room7

__Room8
 COLUP0 = $F8
 playfield:
   XXXXXXXXXXXX........XXXXXXXXXXXX
   X..............................X
   X..............................X
   X..............................X
   X..............................X
   X..............................X
   X..............................X
   X..............................X
   X..............................X
   X..............................X
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
 drawscreen
 if collision(playfield,player0) then IsCollide = 1 else IsCollide = 0
 if player0y = 0 && IsCollide = 0 then RowNum = RowNum + 1:player0y = 87:goto __RoomCTL
 if player0y = 88 && IsCollide = 0 then RowNum = RowNum - 1:player0y = 1:goto __RoomCTL
 if player0x = 0 && IsCollide = 0 then ColNum = ColNum - 1:player0x = 158:goto __RoomCTL
 if player0x = 0 && IsCollide = 159 then ColNum = ColNum + 1:player0x = 1 :goto __RoomCTL
 gosub __PlayerCTRL
 goto __Room8

__Room9
 COLUP0 = $F8
 playfield:
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   X..............................X
   X..............................X
   X..............................X
   X..............................X
   X..............................X
   X..............................X
   X..............................X
   X..............................X
   X..............................X
   XXXXXXXXXXXX........XXXXXXXXXXXX
end
 drawscreen
 if collision(playfield,player0) then IsCollide = 1 else IsCollide = 0
 if player0y = 0 && IsCollide = 0 then RowNum = RowNum + 1:player0y = 87:goto __RoomCTL
 if player0y = 88 && IsCollide = 0 then RowNum = RowNum - 1:player0y = 1:goto __RoomCTL
 if player0x = 0 && IsCollide = 0 then ColNum = ColNum - 1:player0x = 158:goto __RoomCTL
 if player0x = 0 && IsCollide = 159 then ColNum = ColNum + 1:player0x = 1:goto __RoomCTL
 gosub __PlayerCTRL
 goto __Room9

__Room10
 COLUP0 = $F8
 playfield:
   XXXXXXXXXXXX........XXXXXXXXXXXX
   X..............................X
   X..............................X
   X..............................X
   X...............................
   X...............................
   X...............................
   X..............................X
   X..............................X
   X..............................X
   XXXXXXXXXXXX........XXXXXXXXXXXX
end
 if collision(playfield,player0) then IsCollide = 1 else IsCollide = 0
 if player0y = 0 && IsCollide = 0 then RowNum = RowNum + 1:player0y = 87:goto __RoomCTL
 if player0y = 88 && IsCollide = 0 then RowNum = RowNum - 1:player0y = 1:goto __RoomCTL
 if player0x = 0 && IsCollide = 0 then ColNum = ColNum - 1:player0x = 158:goto __RoomCTL
 if player0x = 0 && IsCollide = 159 then ColNum = ColNum + 1:player0x = 1:goto __RoomCTL
 drawscreen
 gosub __PlayerCTRL
 goto __Room10

__Room11
 COLUP0 = $F8
 playfield:
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   X..............................X
   X..............................X
   X..............................X
   ...............................X
   ...............................X
   ...............................X
   X..............................X
   X..............................X
   X..............................X
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
 drawscreen
 if collision(playfield,player0) then IsCollide = 1 else IsCollide = 0
 if player0y = 0 && IsCollide = 0 then RowNum = RowNum + 1:player0y = 87:goto __RoomCTL
 if player0y = 88 && IsCollide = 0 then RowNum = RowNum - 1:player0y = 1:goto __RoomCTL
 if player0x = 0 && IsCollide = 0 then ColNum = ColNum - 1:player0x = 158:goto __RoomCTL
 if player0x = 0 && IsCollide = 159 then ColNum = ColNum + 1:player0x = 1:goto __RoomCTL
 gosub __PlayerCTRL
 goto __Room11

__PlayerCTRL
 COLUP0 = $F8
 if joy0down then PlayerUpDown = PlayerUpDown + 1.83
 if joy0up then PlayerUpDown = PlayerUpDown - 1.83
 if joy0right then PlayerLeftRight = PlayerLeftRight + 1.83
 if joy0left then PlayerLeftRight = PlayerLeftRight - 1.83
 drawscreen
 return
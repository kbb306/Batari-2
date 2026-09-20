 set romsize 4k
 dim BaudByte = a
 dim index = b
 dim TextIndex = z
 dim qtcontroller = d
 const scorebkcolor = $60
 const textcolor = $0E
 const textbkcolor = $12
 const fontstyle = SQUISH
 COLUPF=$0E
 playfield:
   XXX.............................
   XXX.............................
   XXX.............................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
end
 BaudByte = %00000000
mainloop
 drawscreen
 if joy0left then BaudByte{4} = !BaudByte{4}
 if joy0right then BaudByte{3} = !BaudByte{3}
 if joy0up then BaudByte{2} = !BaudByte{2}
 if joy0down then BaudByte{1} = !BaudByte{1}
 if joy0fire then BaudByte{0} = !BaudByte{0}
 if joy1fire then index = BaudByte
 ;if index = 27 then index = index + 32
 ;if index = 31 then index = index - 32
 TextIndex = index
 goto mainloop

    data text_strings
  _sp, __T, _sp, __O, _sp, __H, __N, __M, _sp, __L, __R, __G,
  __I, __P, __C, __V, __E, __Z, __D, __B, __S, __Y, __F, __X,
  __A, __W, __J, _sp, __U, __Q, __K, _sp, _sp, _sp, _sp, _sp,
end

 inline text12a.asm
 inline text12b.asm
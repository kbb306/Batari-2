 dim BaudByte = a
 dim BaudIndex = b
 dim TextIndex = c
 dim qtcontroller = d
 dim ShiftMode = e

 COLUPF = $0E

 playfield:
XXX.....................................
XXX.....................................
XXX.....................................
........................................
........................................
........................................
........................................
........................................
........................................
........................................
........................................
........................................
end

 BaudByte = 0
 BaudIndex = 0
 TextIndex = 0
 ShiftMode = 0

mainloop
 drawscreen
 if joy0left then goto toggleleft
 if joy0right then goto toggleright
 if joy0up then goto toggleup
 if joy0down then goto toggledown
 if joy0fire then goto togglefire
 if joy1fire then goto commit
 goto mainloop

toggleleft
 BaudByte = BaudByte ^ 1
waitleft
 drawscreen
 if joy0left then goto waitleft
 goto mainloop

toggleright
 BaudByte = BaudByte ^ 2
waitright
 drawscreen
 if joy0right then goto waitright
 goto mainloop

toggleup
 BaudByte = BaudByte ^ 4
waitup
 drawscreen
 if joy0up then goto waitup
 goto mainloop

toggledown
 BaudByte = BaudByte ^ 8
waitdown
 drawscreen
 if joy0down then goto waitdown
 goto mainloop

togglefire
 BaudByte = BaudByte ^ 16
waitfire
 drawscreen
 if joy0fire then goto waitfire
 goto mainloop

commit
 BaudIndex = BaudByte
 BaudByte = 0
 if BaudIndex = 27 then goto figures
 if BaudIndex = 31 then goto letters
 goto showcode

figures
 ShiftMode = 1
 goto waitcommit

letters
 ShiftMode = 0
 goto waitcommit

showcode
 TextIndex = BaudIndex
 if ShiftMode = 1 then goto showfigure
 goto waitcommit

showfigure
 TextIndex = TextIndex + 32

waitcommit
 drawscreen
 if joy1fire then goto waitcommit
 goto mainloop

   data text_strings
   __sp, __T, __sp, __O, __sp, __H, __N, __M, __sp, __L, __R, __G
   __I, __P, __C, __V, __E, __Z, __D, __B, __S, __Y, __F, __X, __A
   __W, __J, __sp, __U, __Q, __K, __sp, __sp, __sp, __sp, __sp, __cm
   __pd, __sp, __rp, __sp, __sp, __sp, __sp, __co, __sp, __sp, __qt
   __sp, __qu, __sp, __sp, __ex, __sl, __hy, __sp, __ap, __sp, __sp
   __sp, __lp, __sp, __sp, __sp, __sp, __sp, __sp, __sp, __sp, __sp
end

 inline "text12a.asm"
 inline "text12b.asm"

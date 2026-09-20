; Reconstructed from Baudot.bas.lst
; Fixed Baudot / ITA2 controller decoder
;
; Player 0 directions + fire toggle the five Baudot bits.
; Player 1 fire commits the current 5-bit code.
; Input presses are edge/debounced so a held button toggles only once.
; ITA2 FIGS (27) and LTRS (31) change persistent shift state.

 dim BaudByte = a
 dim index = b
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
 index = 0
 TextIndex = 0
 ShiftMode = 0

mainloop
  drawscreen

; Toggle the five actual Baudot bits (0-4), once per press.
 if joy0left then BaudByte{0} = !BaudByte{0}
 if joy0left then goto waitleft
 if joy0right then BaudByte{1} = !BaudByte{1}
 if joy0right then goto waitright
 if joy0up then BaudByte{2} = !BaudByte{2}
 if joy0up then goto waitup
 if joy0down then BaudByte{3} = !BaudByte{3}
 if joy0down then goto waitdown
 if joy0fire then BaudByte{4} = !BaudByte{4}
 if joy0fire then goto waitfire

; Player 1 fire is the STROBE / commit input.
 if joy1fire then goto commit

 goto mainloop

waitleft
 drawscreen
 if joy0left then goto waitleft
 goto mainloop

waitright
 drawscreen
 if joy0right then goto waitright
 goto mainloop

waitup
 drawscreen
 if joy0up then goto waitup
 goto mainloop

waitdown
 drawscreen
 if joy0down then goto waitdown
 goto mainloop

waitfire
 drawscreen
 if joy0fire then goto waitfire
 goto mainloop

commit
 index = BaudByte
 BaudByte = 0

; ITA2 shift characters do not print; they change the active table.
 if index = 27 then ShiftMode = 1
 if index = 27 then goto waitcommit
 if index = 31 then ShiftMode = 0
 if index = 31 then goto waitcommit

; Letters occupy 0-31; figures occupy the second 32-entry half.
 if ShiftMode = 1 then index = index + 32
 TextIndex = index

waitcommit
 drawscreen
 if joy1fire then goto waitcommit
 goto mainloop

data text_strings
 __sp, __T, __sp, __O, __sp, __H, __N, __M, __sp, __L, __R, __G
 __I, __P, __C, __V, __E, __Z, __D, __B, __S, __Y, __F, __X, __A
 __W, __J, __sp, __U, __Q, __K, __sp
; FIGURES table, reconstructed from the surviving generated table.
 __sp, __sp, __sp, __sp, __cm, __pd, __sp, __rp, __sp, __sp, __sp
 __sp, __co, __sp, __sp, __qt, __sp, __qu, __sp, __sp, __ex, __sl
 __hy, __sp, __ap, __sp, __sp, __sp, __lp, __sp, __sp, __sp, __sp
end

 inline text12a.asm
 inline text12b.asm

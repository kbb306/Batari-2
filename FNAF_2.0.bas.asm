; Provided under the CC0 license. See the included LICENSE.txt for details.

 processor 6502
 include "vcs.h"
 include "macro.h"
 include "2600basic.h"
 include "2600basic_variable_redefs.h"
 ifconst bankswitch
  if bankswitch == 8
     ORG $1000
     RORG $D000
  endif
  if bankswitch == 16
     ORG $1000
     RORG $9000
  endif
  if bankswitch == 32
     ORG $1000
     RORG $1000
  endif
  if bankswitch == 64
     ORG $1000
     RORG $1000
  endif
 else
   ORG $F000
 endif

 ifconst bankswitch_hotspot
 if bankswitch_hotspot = $083F ; 0840 bankswitching hotspot
   .byte 0 ; stop unexpected bankswitches
 endif
 endif
; Provided under the CC0 license. See the included LICENSE.txt for details.

start
 sei
 cld
 ldy #0
 lda $D0
 cmp #$2C               ;check RAM location #1
 bne MachineIs2600
 lda $D1
 cmp #$A9               ;check RAM location #2
 bne MachineIs2600
 dey
MachineIs2600
 ldx #0
 txa
clearmem
 inx
 txs
 pha
 bne clearmem
 sty temp1
 ifnconst multisprite
 ifconst pfrowheight
 lda #pfrowheight
 else
 ifconst pfres
 lda #(96/pfres)
 else
 lda #8
 endif
 endif
 sta playfieldpos
 endif
 ldx #5
initscore
 lda #<scoretable
 sta scorepointers,x 
 dex
 bpl initscore
 lda #1
 sta CTRLPF
 ora INTIM
 sta rand

 ifconst multisprite
   jsr multisprite_setup
 endif

 ifnconst bankswitch
   jmp game
 else
   lda #>(game-1)
   pha
   lda #<(game-1)
   pha
   pha
   pha
   ldx #1
   jmp BS_jsr
 endif
; Provided under the CC0 license. See the included LICENSE.txt for details.

     ; This is a 2-line kernel!
     ifnconst vertical_reflect
kernel
     endif
     sta WSYNC
     lda #255
     sta TIM64T

     lda #1
     sta VDELBL
     sta VDELP0
     ldx ballheight
     inx
     inx
     stx temp4
     lda player1y
     sta temp3

     ifconst shakescreen
         jsr doshakescreen
     else
         ldx missile0height
         inx
     endif

     inx
     stx stack1

     lda bally
     sta stack2

     lda player0y
     ldx #0
     sta WSYNC
     stx GRP0
     stx GRP1
     stx PF1L
     stx PF2
     stx CXCLR
     ifconst readpaddle
         stx paddle
     else
         sleep 3
     endif

     sta temp2,x

     ;store these so they can be retrieved later
     ifnconst pfres
         ldx #128-44+(4-pfwidth)*12
     else
         ldx #132-pfres*pfwidth
     endif

     dec player0y

     lda missile0y
     sta temp5
     lda missile1y
     sta temp6

     lda playfieldpos
     sta temp1
     
     ifconst pfrowheight
         lda #pfrowheight+2
     else
         ifnconst pfres
             lda #10
         else
             lda #(96/pfres)+2 ; try to come close to the real size
         endif
     endif
     clc
     sbc playfieldpos
     sta playfieldpos
     jmp .startkernel

.skipDrawP0
     lda #0
     tay
     jmp .continueP0

.skipDrawP1
     lda #0
     tay
     jmp .continueP1

.kerloop     ; enter at cycle 59??

continuekernel
     sleep 2
continuekernel2
     lda ballheight
     
     ifconst pfres
         ldy playfield+pfres*pfwidth-132,x
         sty PF1L ;3
         ldy playfield+pfres*pfwidth-131-pfadjust,x
         sty PF2L ;3
         ldy playfield+pfres*pfwidth-129,x
         sty PF1R ; 3 too early?
         ldy playfield+pfres*pfwidth-130-pfadjust,x
         sty PF2R ;3
     else
         ldy playfield-48+pfwidth*12+44-128,x
         sty PF1L ;3
         ldy playfield-48+pfwidth*12+45-128-pfadjust,x ;4
         sty PF2L ;3
         ldy playfield-48+pfwidth*12+47-128,x ;4
         sty PF1R ; 3 too early?
         ldy playfield-48+pfwidth*12+46-128-pfadjust,x;4
         sty PF2R ;3
     endif

     ; should be playfield+$38 for width=2

     dcp bally
     rol
     rol
     ; rol
     ; rol
goback
     sta ENABL 
.startkernel
     lda player1height ;3
     dcp player1y ;5
     bcc .skipDrawP1 ;2
     ldy player1y ;3
     lda (player1pointer),y ;5; player0pointer must be selected carefully by the compiler
     ; so it doesn't cross a page boundary!

.continueP1
     sta GRP1 ;3

     ifnconst player1colors
         lda missile1height ;3
         dcp missile1y ;5
         rol;2
         rol;2
         sta ENAM1 ;3
     else
         lda (player1color),y
         sta COLUP1
         ifnconst playercolors
             sleep 7
         else
             lda.w player0colorstore
             sta COLUP0
         endif
     endif

     ifconst pfres
         lda playfield+pfres*pfwidth-132,x 
         sta PF1L ;3
         lda playfield+pfres*pfwidth-131-pfadjust,x 
         sta PF2L ;3
         lda playfield+pfres*pfwidth-129,x 
         sta PF1R ; 3 too early?
         lda playfield+pfres*pfwidth-130-pfadjust,x 
         sta PF2R ;3
     else
         lda playfield-48+pfwidth*12+44-128,x ;4
         sta PF1L ;3
         lda playfield-48+pfwidth*12+45-128-pfadjust,x ;4
         sta PF2L ;3
         lda playfield-48+pfwidth*12+47-128,x ;4
         sta PF1R ; 3 too early?
         lda playfield-48+pfwidth*12+46-128-pfadjust,x;4
         sta PF2R ;3
     endif 
     ; sleep 3

     lda player0height
     dcp player0y
     bcc .skipDrawP0
     ldy player0y
     lda (player0pointer),y
.continueP0
     sta GRP0

     ifnconst no_blank_lines
         ifnconst playercolors
             lda missile0height ;3
             dcp missile0y ;5
             sbc stack1
             sta ENAM0 ;3
         else
             lda (player0color),y
             sta player0colorstore
             sleep 6
         endif
         dec temp1
         bne continuekernel
     else
         dec temp1
         beq altkernel2
         ifconst readpaddle
             ldy currentpaddle
             lda INPT0,y
             bpl noreadpaddle
             inc paddle
             jmp continuekernel2
noreadpaddle
             sleep 2
             jmp continuekernel
         else
             ifnconst playercolors 
                 ifconst PFcolors
                     txa
                     tay
                     lda (pfcolortable),y
                     ifnconst backgroundchange
                         sta COLUPF
                     else
                         sta COLUBK
                     endif
                     jmp continuekernel
                 else
                     ifconst kernelmacrodef
                         kernelmacro
                     else
                         sleep 12
                     endif
                 endif
             else
                 lda (player0color),y
                 sta player0colorstore
                 sleep 4
             endif
             jmp continuekernel
         endif
altkernel2
         txa
         ifnconst vertical_reflect
             sbx #256-pfwidth
         else
             sbx #256-pfwidth/2
         endif
         bmi lastkernelline
         ifconst pfrowheight
             lda #pfrowheight
         else
             ifnconst pfres
                 lda #8
             else
                 lda #(96/pfres) ; try to come close to the real size
             endif
         endif
         sta temp1
         jmp continuekernel
     endif

altkernel

     ifconst PFmaskvalue
         lda #PFmaskvalue
     else
         lda #0
     endif
     sta PF1L
     sta PF2


     ;sleep 3

     ;28 cycles to fix things
     ;minus 11=17

     ; lax temp4
     ; clc
     txa
     ifnconst vertical_reflect
         sbx #256-pfwidth
     else
         sbx #256-pfwidth/2
     endif

     bmi lastkernelline

     ifconst PFcolorandheight
         ifconst pfres
             ldy playfieldcolorandheight-131+pfres*pfwidth,x
         else
             ldy playfieldcolorandheight-87,x
         endif
         ifnconst backgroundchange
             sty COLUPF
         else
             sty COLUBK
         endif
         ifconst pfres
             lda playfieldcolorandheight-132+pfres*pfwidth,x
         else
             lda playfieldcolorandheight-88,x
         endif
         sta.w temp1
     endif
     ifconst PFheights
         lsr
         lsr
         tay
         lda (pfheighttable),y
         sta.w temp1
     endif
     ifconst PFcolors
         tay
         lda (pfcolortable),y
         ifnconst backgroundchange
             sta COLUPF
         else
             sta COLUBK
         endif
         ifconst pfrowheight
             lda #pfrowheight
         else
             ifnconst pfres
                 lda #8
             else
                 lda #(96/pfres) ; try to come close to the real size
             endif
         endif
         sta temp1
     endif
     ifnconst PFcolorandheight
         ifnconst PFcolors
             ifnconst PFheights
                 ifnconst no_blank_lines
                     ; read paddle 0
                     ; lo-res paddle read
                     ; bit INPT0
                     ; bmi paddleskipread
                     ; inc paddle0
                     ;donepaddleskip
                     sleep 10
                     ifconst pfrowheight
                         lda #pfrowheight
                     else
                         ifnconst pfres
                             lda #8
                         else
                             lda #(96/pfres) ; try to come close to the real size
                         endif
                     endif
                     sta temp1
                 endif
             endif
         endif
     endif
     

     lda ballheight
     dcp bally
     sbc temp4


     jmp goback


     ifnconst no_blank_lines
lastkernelline
         ifnconst PFcolors
             sleep 10
         else
             ldy #124
             lda (pfcolortable),y
             sta COLUPF
         endif

         ifconst PFheights
             ldx #1
             ;sleep 4
             sleep 3 ; this was over 1 cycle
         else
             ldx playfieldpos
             ;sleep 3
             sleep 2 ; this was over 1 cycle
         endif

         jmp enterlastkernel

     else
lastkernelline
         
         ifconst PFheights
             ldx #1
             ;sleep 5
             sleep 4 ; this was over 1 cycle
         else
             ldx playfieldpos
             ;sleep 4
             sleep 3 ; this was over 1 cycle
         endif

         cpx #0
         bne .enterfromNBL
         jmp no_blank_lines_bailout
     endif

     if ((<*)>$d5)
         align 256
     endif
     ; this is a kludge to prevent page wrapping - fix!!!

.skipDrawlastP1
     lda #0
     tay ; added so we don't cross a page
     jmp .continuelastP1

.endkerloop     ; enter at cycle 59??
     
     nop

.enterfromNBL
     ifconst pfres
         ldy.w playfield+pfres*pfwidth-4
         sty PF1L ;3
         ldy.w playfield+pfres*pfwidth-3-pfadjust
         sty PF2L ;3
         ldy.w playfield+pfres*pfwidth-1
         sty PF1R ; possibly too early?
         ldy.w playfield+pfres*pfwidth-2-pfadjust
         sty PF2R ;3
     else
         ldy.w playfield-48+pfwidth*12+44
         sty PF1L ;3
         ldy.w playfield-48+pfwidth*12+45-pfadjust
         sty PF2L ;3
         ldy.w playfield-48+pfwidth*12+47
         sty PF1R ; possibly too early?
         ldy.w playfield-48+pfwidth*12+46-pfadjust
         sty PF2R ;3
     endif

enterlastkernel
     lda ballheight

     ; tya
     dcp bally
     ; sleep 4

     ; sbc stack3
     rol
     rol
     sta ENABL 

     lda player1height ;3
     dcp player1y ;5
     bcc .skipDrawlastP1
     ldy player1y ;3
     lda (player1pointer),y ;5; player0pointer must be selected carefully by the compiler
     ; so it doesn't cross a page boundary!

.continuelastP1
     sta GRP1 ;3

     ifnconst player1colors
         lda missile1height ;3
         dcp missile1y ;5
     else
         lda (player1color),y
         sta COLUP1
     endif

     dex
     ;dec temp4 ; might try putting this above PF writes
     beq endkernel


     ifconst pfres
         ldy.w playfield+pfres*pfwidth-4
         sty PF1L ;3
         ldy.w playfield+pfres*pfwidth-3-pfadjust
         sty PF2L ;3
         ldy.w playfield+pfres*pfwidth-1
         sty PF1R ; possibly too early?
         ldy.w playfield+pfres*pfwidth-2-pfadjust
         sty PF2R ;3
     else
         ldy.w playfield-48+pfwidth*12+44
         sty PF1L ;3
         ldy.w playfield-48+pfwidth*12+45-pfadjust
         sty PF2L ;3
         ldy.w playfield-48+pfwidth*12+47
         sty PF1R ; possibly too early?
         ldy.w playfield-48+pfwidth*12+46-pfadjust
         sty PF2R ;3
     endif

     ifnconst player1colors
         rol;2
         rol;2
         sta ENAM1 ;3
     else
         ifnconst playercolors
             sleep 7
         else
             lda.w player0colorstore
             sta COLUP0
         endif
     endif
     
     lda.w player0height
     dcp player0y
     bcc .skipDrawlastP0
     ldy player0y
     lda (player0pointer),y
.continuelastP0
     sta GRP0



     ifnconst no_blank_lines
         lda missile0height ;3
         dcp missile0y ;5
         sbc stack1
         sta ENAM0 ;3
         jmp .endkerloop
     else
         ifconst readpaddle
             ldy currentpaddle
             lda INPT0,y
             bpl noreadpaddle2
             inc paddle
             jmp .endkerloop
noreadpaddle2
             sleep 4
             jmp .endkerloop
         else ; no_blank_lines and no paddle reading
             pla
             pha ; 14 cycles in 4 bytes
             pla
             pha
             ; sleep 14
             jmp .endkerloop
         endif
     endif


     ; ifconst donepaddleskip
         ;paddleskipread
         ; this is kind of lame, since it requires 4 cycles from a page boundary crossing
         ; plus we get a lo-res paddle read
         ; bmi donepaddleskip
     ; endif

.skipDrawlastP0
     lda #0
     tay
     jmp .continuelastP0

     ifconst no_blank_lines
no_blank_lines_bailout
         ldx #0
     endif

endkernel
     ; 6 digit score routine
     stx PF1
     stx PF2
     stx PF0
     clc

     ifconst pfrowheight
         lda #pfrowheight+2
     else
         ifnconst pfres
             lda #10
         else
             lda #(96/pfres)+2 ; try to come close to the real size
         endif
     endif

     sbc playfieldpos
     sta playfieldpos
     txa

     ifconst shakescreen
         bit shakescreen
         bmi noshakescreen2
         ldx #$3D
noshakescreen2
     endif

     sta WSYNC,x

     ; STA WSYNC ;first one, need one more
     sta REFP0
     sta REFP1
     STA GRP0
     STA GRP1
     ; STA PF1
     ; STA PF2
     sta HMCLR
     sta ENAM0
     sta ENAM1
     sta ENABL

     lda temp2 ;restore variables that were obliterated by kernel
     sta player0y
     lda temp3
     sta player1y
     ifnconst player1colors
         lda temp6
         sta missile1y
     endif
     ifnconst playercolors
         ifnconst readpaddle
             lda temp5
             sta missile0y
         endif
     endif
     lda stack2
     sta bally

     ; strangely, this isn't required any more. might have
     ; resulted from the no_blank_lines score bounce fix
     ;ifconst no_blank_lines
         ;sta WSYNC
     ;endif

     lda INTIM
     clc
     ifnconst vblank_time
         adc #43+12+87
     else
         adc #vblank_time+12+87

     endif
     ; sta WSYNC
     sta TIM64T

     ifconst minikernel
         jsr minikernel
     endif

     ; now reassign temp vars for score pointers

     ; score pointers contain:
     ; score1-5: lo1,lo2,lo3,lo4,lo5,lo6
     ; swap lo2->temp1
     ; swap lo4->temp3
     ; swap lo6->temp5
     ifnconst noscore
         lda scorepointers+1
         ; ldy temp1
         sta temp1
         ; sty scorepointers+1

         lda scorepointers+3
         ; ldy temp3
         sta temp3
         ; sty scorepointers+3


         sta HMCLR
         tsx
         stx stack1 
         ldx #$E0
         stx HMP0

         LDA scorecolor 
         STA COLUP0
         STA COLUP1
         ifconst scorefade
             STA stack2
         endif
         ifconst pfscore
             lda pfscorecolor
             sta COLUPF
         endif
         sta WSYNC
         ldx #0
         STx GRP0
         STx GRP1 ; seems to be needed because of vdel

         lda scorepointers+5
         ; ldy temp5
         sta temp5,x
         ; sty scorepointers+5
         lda #>scoretable
         sta scorepointers+1
         sta scorepointers+3
         sta scorepointers+5
         sta temp2
         sta temp4
         sta temp6
         LDY #7
         STY VDELP0
         STA RESP0
         STA RESP1


         LDA #$03
         STA NUSIZ0
         STA NUSIZ1
         STA VDELP1
         LDA #$F0
         STA HMP1
         lda (scorepointers),y
         sta GRP0
         STA HMOVE ; cycle 73 ?
         jmp beginscore


         if ((<*)>$d4)
             align 256 ; kludge that potentially wastes space! should be fixed!
         endif

loop2
         lda (scorepointers),y ;+5 68 204
         sta GRP0 ;+3 71 213 D1 -- -- --
         ifconst pfscore
             lda.w pfscore1
             sta PF1
         else
             ifconst scorefade
                 sleep 2
                 dec stack2 ; decrement the temporary scorecolor
             else
                 sleep 7
             endif
         endif
         ; cycle 0
beginscore
         lda (scorepointers+$8),y ;+5 5 15
         sta GRP1 ;+3 8 24 D1 D1 D2 --
         lda (scorepointers+$6),y ;+5 13 39
         sta GRP0 ;+3 16 48 D3 D1 D2 D2
         lax (scorepointers+$2),y ;+5 29 87
         txs
         lax (scorepointers+$4),y ;+5 36 108
         ifconst scorefade
             lda stack2
         else
             sleep 3
         endif

         ifconst pfscore
             lda pfscore2
             sta PF1
         else
             ifconst scorefade
                 sta COLUP0
                 sta COLUP1
             else
                 sleep 6
             endif
         endif

         lda (scorepointers+$A),y ;+5 21 63
         stx GRP1 ;+3 44 132 D3 D3 D4 D2!
         tsx
         stx GRP0 ;+3 47 141 D5 D3! D4 D4
         sta GRP1 ;+3 50 150 D5 D5 D6 D4!
         sty GRP0 ;+3 53 159 D4* D5! D6 D6
         dey
         bpl loop2 ;+2 60 180

         ldx stack1 
         txs
         ; lda scorepointers+1
         ldy temp1
         ; sta temp1
         sty scorepointers+1

         LDA #0 
         sta PF1
         STA GRP0
         STA GRP1
         STA VDELP0
         STA VDELP1;do we need these
         STA NUSIZ0
         STA NUSIZ1

         ; lda scorepointers+3
         ldy temp3
         ; sta temp3
         sty scorepointers+3

         ; lda scorepointers+5
         ldy temp5
         ; sta temp5
         sty scorepointers+5
     endif ;noscore
    ifconst readpaddle
        lda #%11000010
    else
        ifconst qtcontroller
            lda qtcontroller
            lsr    ; bit 0 in carry
            lda #4
            ror    ; carry into top of A
        else
            lda #2
        endif ; qtcontroller
    endif ; readpaddle
 sta WSYNC
 sta VBLANK
 RETURN
     ifconst shakescreen
doshakescreen
         bit shakescreen
         bmi noshakescreen
         sta WSYNC
noshakescreen
         ldx missile0height
         inx
         rts
     endif

; Provided under the CC0 license. See the included LICENSE.txt for details.

; playfield drawing routines
; you get a 32x12 bitmapped display in a single color :)
; 0-31 and 0-11

pfclear ; clears playfield - or fill with pattern
 ifconst pfres
 ldx #pfres*pfwidth-1
 else
 ldx #47-(4-pfwidth)*12 ; will this work?
 endif
pfclear_loop
 ifnconst superchip
 sta playfield,x
 else
 sta playfield-128,x
 endif
 dex
 bpl pfclear_loop
 RETURN
 
setuppointers
 stx temp2 ; store on.off.flip value
 tax ; put x-value in x 
 lsr
 lsr
 lsr ; divide x pos by 8 
 sta temp1
 tya
 asl
 if pfwidth=4
  asl ; multiply y pos by 4
 endif ; else multiply by 2
 clc
 adc temp1 ; add them together to get actual memory location offset
 tay ; put the value in y
 lda temp2 ; restore on.off.flip value
 rts

pfread
;x=xvalue, y=yvalue
 jsr setuppointers
 lda setbyte,x
 and playfield,y
 eor setbyte,x
; beq readzero
; lda #1
; readzero
 RETURN

pfpixel
;x=xvalue, y=yvalue, a=0,1,2
 jsr setuppointers

 ifconst bankswitch
 lda temp2 ; load on.off.flip value (0,1, or 2)
 beq pixelon_r  ; if "on" go to on
 lsr
 bcs pixeloff_r ; value is 1 if true
 lda playfield,y ; if here, it's "flip"
 eor setbyte,x
 ifconst superchip
 sta playfield-128,y
 else
 sta playfield,y
 endif
 RETURN
pixelon_r
 lda playfield,y
 ora setbyte,x
 ifconst superchip
 sta playfield-128,y
 else
 sta playfield,y
 endif
 RETURN
pixeloff_r
 lda setbyte,x
 eor #$ff
 and playfield,y
 ifconst superchip
 sta playfield-128,y
 else
 sta playfield,y
 endif
 RETURN

 else
 jmp plotpoint
 endif

pfhline
;x=xvalue, y=yvalue, a=0,1,2, temp3=endx
 jsr setuppointers
 jmp noinc
keepgoing
 inx
 txa
 and #7
 bne noinc
 iny
noinc
 jsr plotpoint
 cpx temp3
 bmi keepgoing
 RETURN

pfvline
;x=xvalue, y=yvalue, a=0,1,2, temp3=endx
 jsr setuppointers
 sty temp1 ; store memory location offset
 inc temp3 ; increase final x by 1 
 lda temp3
 asl
 if pfwidth=4
   asl ; multiply by 4
 endif ; else multiply by 2
 sta temp3 ; store it
 ; Thanks to Michael Rideout for fixing a bug in this code
 ; right now, temp1=y=starting memory location, temp3=final
 ; x should equal original x value
keepgoingy
 jsr plotpoint
 iny
 iny
 if pfwidth=4
   iny
   iny
 endif
 cpy temp3
 bmi keepgoingy
 RETURN

plotpoint
 lda temp2 ; load on.off.flip value (0,1, or 2)
 beq pixelon  ; if "on" go to on
 lsr
 bcs pixeloff ; value is 1 if true
 lda playfield,y ; if here, it's "flip"
 eor setbyte,x
  ifconst superchip
 sta playfield-128,y
 else
 sta playfield,y
 endif
 rts
pixelon
 lda playfield,y
 ora setbyte,x
 ifconst superchip
 sta playfield-128,y
 else
 sta playfield,y
 endif
 rts
pixeloff
 lda setbyte,x
 eor #$ff
 and playfield,y
 ifconst superchip
 sta playfield-128,y
 else
 sta playfield,y
 endif
 rts

setbyte
 ifnconst pfcenter
 .byte $80
 .byte $40
 .byte $20
 .byte $10
 .byte $08
 .byte $04
 .byte $02
 .byte $01
 endif
 .byte $01
 .byte $02
 .byte $04
 .byte $08
 .byte $10
 .byte $20
 .byte $40
 .byte $80
 .byte $80
 .byte $40
 .byte $20
 .byte $10
 .byte $08
 .byte $04
 .byte $02
 .byte $01
 .byte $01
 .byte $02
 .byte $04
 .byte $08
 .byte $10
 .byte $20
 .byte $40
 .byte $80
; Provided under the CC0 license. See the included LICENSE.txt for details.

pfscroll ;(a=0 left, 1 right, 2 up, 4 down, 6=upup, 12=downdown)
 bne notleft
;left
 ifconst pfres
 ldx #pfres*4
 else
 ldx #48
 endif
leftloop
 lda playfield-1,x
 lsr

 ifconst superchip
 lda playfield-2,x
 rol
 sta playfield-130,x
 lda playfield-3,x
 ror
 sta playfield-131,x
 lda playfield-4,x
 rol
 sta playfield-132,x
 lda playfield-1,x
 ror
 sta playfield-129,x
 else
 rol playfield-2,x
 ror playfield-3,x
 rol playfield-4,x
 ror playfield-1,x
 endif

 txa
 sbx #4
 bne leftloop
 RETURN

notleft
 lsr
 bcc notright
;right

 ifconst pfres
 ldx #pfres*4
 else
 ldx #48
 endif
rightloop
 lda playfield-4,x
 lsr
 ifconst superchip
 lda playfield-3,x
 rol
 sta playfield-131,x
 lda playfield-2,x
 ror
 sta playfield-130,x
 lda playfield-1,x
 rol
 sta playfield-129,x
 lda playfield-4,x
 ror
 sta playfield-132,x
 else
 rol playfield-3,x
 ror playfield-2,x
 rol playfield-1,x
 ror playfield-4,x
 endif
 txa
 sbx #4
 bne rightloop
  RETURN

notright
 lsr
 bcc notup
;up
 lsr
 bcc onedecup
 dec playfieldpos
onedecup
 dec playfieldpos
 beq shiftdown 
 bpl noshiftdown2 
shiftdown
  ifconst pfrowheight
 lda #pfrowheight
 else
 ifnconst pfres
   lda #8
 else
   lda #(96/pfres) ; try to come close to the real size
 endif
 endif

 sta playfieldpos
 lda playfield+3
 sta temp4
 lda playfield+2
 sta temp3
 lda playfield+1
 sta temp2
 lda playfield
 sta temp1
 ldx #0
up2
 lda playfield+4,x
 ifconst superchip
 sta playfield-128,x
 lda playfield+5,x
 sta playfield-127,x
 lda playfield+6,x
 sta playfield-126,x
 lda playfield+7,x
 sta playfield-125,x
 else
 sta playfield,x
 lda playfield+5,x
 sta playfield+1,x
 lda playfield+6,x
 sta playfield+2,x
 lda playfield+7,x
 sta playfield+3,x
 endif
 txa
 sbx #252
 ifconst pfres
 cpx #(pfres-1)*4
 else
 cpx #44
 endif
 bne up2

 lda temp4
 
 ifconst superchip
 ifconst pfres
 sta playfield+pfres*4-129
 lda temp3
 sta playfield+pfres*4-130
 lda temp2
 sta playfield+pfres*4-131
 lda temp1
 sta playfield+pfres*4-132
 else
 sta playfield+47-128
 lda temp3
 sta playfield+46-128
 lda temp2
 sta playfield+45-128
 lda temp1
 sta playfield+44-128
 endif
 else
 ifconst pfres
 sta playfield+pfres*4-1
 lda temp3
 sta playfield+pfres*4-2
 lda temp2
 sta playfield+pfres*4-3
 lda temp1
 sta playfield+pfres*4-4
 else
 sta playfield+47
 lda temp3
 sta playfield+46
 lda temp2
 sta playfield+45
 lda temp1
 sta playfield+44
 endif
 endif
noshiftdown2
 RETURN


notup
;down
 lsr
 bcs oneincup
 inc playfieldpos
oneincup
 inc playfieldpos
 lda playfieldpos

  ifconst pfrowheight
 cmp #pfrowheight+1
 else
 ifnconst pfres
   cmp #9
 else
   cmp #(96/pfres)+1 ; try to come close to the real size
 endif
 endif

 bcc noshiftdown 
 lda #1
 sta playfieldpos

 ifconst pfres
 lda playfield+pfres*4-1
 sta temp4
 lda playfield+pfres*4-2
 sta temp3
 lda playfield+pfres*4-3
 sta temp2
 lda playfield+pfres*4-4
 else
 lda playfield+47
 sta temp4
 lda playfield+46
 sta temp3
 lda playfield+45
 sta temp2
 lda playfield+44
 endif

 sta temp1

 ifconst pfres
 ldx #(pfres-1)*4
 else
 ldx #44
 endif
down2
 lda playfield-1,x
 ifconst superchip
 sta playfield-125,x
 lda playfield-2,x
 sta playfield-126,x
 lda playfield-3,x
 sta playfield-127,x
 lda playfield-4,x
 sta playfield-128,x
 else
 sta playfield+3,x
 lda playfield-2,x
 sta playfield+2,x
 lda playfield-3,x
 sta playfield+1,x
 lda playfield-4,x
 sta playfield,x
 endif
 txa
 sbx #4
 bne down2

 lda temp4
 ifconst superchip
 sta playfield-125
 lda temp3
 sta playfield-126
 lda temp2
 sta playfield-127
 lda temp1
 sta playfield-128
 else
 sta playfield+3
 lda temp3
 sta playfield+2
 lda temp2
 sta playfield+1
 lda temp1
 sta playfield
 endif
noshiftdown
 RETURN
; Provided under the CC0 license. See the included LICENSE.txt for details.

;standard routines needed for pretty much all games
; just the random number generator is left - maybe we should remove this asm file altogether?
; repositioning code and score pointer setup moved to overscan
; read switches, joysticks now compiler generated (more efficient)

randomize
	lda rand
	lsr
 ifconst rand16
	rol rand16
 endif
	bcc noeor
	eor #$B4
noeor
	sta rand
 ifconst rand16
	eor rand16
 endif
	RETURN
; Provided under the CC0 license. See the included LICENSE.txt for details.

drawscreen
     ifconst debugscore
         ldx #14
         lda INTIM ; display # cycles left in the score

         ifconst mincycles
             lda mincycles 
             cmp INTIM
             lda mincycles
             bcc nochange
             lda INTIM
             sta mincycles
nochange
         endif

         ; cmp #$2B
         ; bcs no_cycles_left
         bmi cycles_left
         ldx #64
         eor #$ff ;make negative
cycles_left
         stx scorecolor
         and #$7f ; clear sign bit
         tax
         lda scorebcd,x
         sta score+2
         lda scorebcd1,x
         sta score+1
         jmp done_debugscore 
scorebcd
         .byte $00, $64, $28, $92, $56, $20, $84, $48, $12, $76, $40
         .byte $04, $68, $32, $96, $60, $24, $88, $52, $16, $80, $44
         .byte $08, $72, $36, $00, $64, $28, $92, $56, $20, $84, $48
         .byte $12, $76, $40, $04, $68, $32, $96, $60, $24, $88
scorebcd1
         .byte 0, 0, 1, 1, 2, 3, 3, 4, 5, 5, 6
         .byte 7, 7, 8, 8, 9, $10, $10, $11, $12, $12, $13
         .byte $14, $14, $15, $16, $16, $17, $17, $18, $19, $19, $20
         .byte $21, $21, $22, $23, $23, $24, $24, $25, $26, $26
done_debugscore
     endif

     ifconst debugcycles
         lda INTIM ; if we go over, it mucks up the background color
         ; cmp #$2B
         ; BCC overscan
         bmi overscan
         sta COLUBK
         bcs doneoverscan
     endif

overscan
     ifconst interlaced
         PHP
         PLA 
         EOR #4 ; flip interrupt bit
         PHA
         PLP
         AND #4 ; isolate the interrupt bit
         TAX ; save it for later
     endif

overscanloop
     lda INTIM ;wait for sync
     bmi overscanloop
doneoverscan

     ;do VSYNC

     ifconst interlaced
         CPX #4
         BNE oddframevsync
     endif

     lda #2
     sta WSYNC
     sta VSYNC
     STA WSYNC
     STA WSYNC
     lsr
     STA WSYNC
     STA VSYNC
     sta VBLANK
     ifnconst overscan_time
         lda #37+128
     else
         lda #overscan_time+128
     endif
     sta TIM64T

     ifconst interlaced
         jmp postsync 

oddframevsync
         sta WSYNC

         LDA ($80,X) ; 11 waste
         LDA ($80,X) ; 11 waste
         LDA ($80,X) ; 11 waste

         lda #2
         sta VSYNC
         sta WSYNC
         sta WSYNC
         sta WSYNC

         LDA ($80,X) ; 11 waste
         LDA ($80,X) ; 11 waste
         LDA ($80,X) ; 11 waste

         lda #0
         sta VSYNC
         sta VBLANK
         ifnconst overscan_time
             lda #37+128
         else
             lda #overscan_time+128
         endif
         sta TIM64T

postsync
     endif

     ifconst legacy
         if legacy < 100
             ldx #4
adjustloop
             lda player0x,x
             sec
             sbc #14 ;?
             sta player0x,x
             dex
             bpl adjustloop
         endif
     endif
     if ((<*)>$e9)&&((<*)<$fa)
         repeat ($fa-(<*))
         nop
         repend
     endif
     sta WSYNC
     ldx #4
     SLEEP 3
HorPosLoop     ; 5
     lda player0x,X ;+4 9
     sec ;+2 11
DivideLoop
     sbc #15
     bcs DivideLoop;+4 15
     sta temp1,X ;+4 19
     sta RESP0,X ;+4 23
     sta WSYNC
     dex
     bpl HorPosLoop;+5 5
     ; 4

     ldx #4
     ldy temp1,X
     lda repostable-256,Y
     sta HMP0,X ;+14 18

     dex
     ldy temp1,X
     lda repostable-256,Y
     sta HMP0,X ;+14 32

     dex
     ldy temp1,X
     lda repostable-256,Y
     sta HMP0,X ;+14 46

     dex
     ldy temp1,X
     lda repostable-256,Y
     sta HMP0,X ;+14 60

     dex
     ldy temp1,X
     lda repostable-256,Y
     sta HMP0,X ;+14 74

     sta WSYNC
     
     sta HMOVE ;+3 3


     ifconst legacy
         if legacy < 100
             ldx #4
adjustloop2
             lda player0x,x
             clc
             adc #14 ;?
             sta player0x,x
             dex
             bpl adjustloop2
         endif
     endif




     ;set score pointers
     lax score+2
     jsr scorepointerset
     sty scorepointers+5
     stx scorepointers+2
     lax score+1
     jsr scorepointerset
     sty scorepointers+4
     stx scorepointers+1
     lax score
     jsr scorepointerset
     sty scorepointers+3
     stx scorepointers

vblk
     ; run possible vblank bB code
     ifconst vblank_bB_code
         jsr vblank_bB_code
     endif
vblk2
     LDA INTIM
     bmi vblk2
     jmp kernel
     

     .byte $80,$70,$60,$50,$40,$30,$20,$10,$00
     .byte $F0,$E0,$D0,$C0,$B0,$A0,$90
repostable

scorepointerset
     and #$0F
     asl
     asl
     asl
     adc #<scoretable
     tay 
     txa
     ; and #$F0
     ; lsr
     asr #$F0
     adc #<scoretable
     tax
     rts
; Provided under the CC0 license. See the included LICENSE.txt for details.

; Compute mul1*mul2+acc -> acc:mul1 [mul2 is unchanged]
; Routine courtesy of John Payson (AtariAge member supercat)
 
 ; x and a contain multiplicands, result in a, temp1 contains any overflow

mul16
 sty temp1
 sta temp2
 ldx #8
 dec temp2
loopmul
 lsr
 ror temp1
 bcc noaddmul
 adc temp2
noaddmul
 dex
 bne loopmul
 RETURN

; div int/int
; numerator in A, denom in temp1
; returns with quotient in A, remainder in temp1

div16
 sta temp2 
 sty temp1 
 lda #0
 ldx #8
 asl temp2
div16_1
 rol
 cmp temp1
 bcc div16_2
 sbc temp1
div16_2
 rol temp2
 dex
 bne div16_1
 sta temp1
 lda temp2
 RETURN

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
 
 
 
 ; feel free to modify the score graphics - just keep each digit 8 highj
 ; and keep the conditional compilation stuff intact

scorelength = (LENDEC+LENHEX+LENSPACE+LENDOLLAR+LENPOUND+LENMRHAPPY+LENMRSAD+LENCOPYRIGHT+LENFUJI+LENHEART+LENDIAMOND+LENSPADE+LENCLUB+LENCOLON+LENBLOCK+LENUNDERLINE+LENARISIDE+LENARIFACE) 

 ifconst ROM2k
   ORG $F7FC-scorelength
 else
   ifconst bankswitch
     if bankswitch == 8
       ORG $2FE4-scorelength-bscode_length
       RORG $FFE4-scorelength-bscode_length
     endif
     if bankswitch == 16
       ORG $4FE4-scorelength-bscode_length
       RORG $FFE4-scorelength-bscode_length
     endif
     if bankswitch == 32
       ORG $8FE4-scorelength-bscode_length
       RORG $FFE4-scorelength-bscode_length
     endif
   else
     ORG $FFEC-scorelength
   endif
 endif

NOFONT = 0
STOCK = 1 	;_FONTNAME
NEWCENTURY = 2	;_FONTNAME
WHIMSEY = 3	;_FONTNAME
ALARMCLOCK = 4	;_FONTNAME
HANDWRITTEN = 5 ;_FONTNAME
INTERRUPTED = 6 ;_FONTNAME
TINY = 7	;_FONTNAME
RETROPUTER = 8	;_FONTNAME
CURVES = 9	;_FONTNAME
HUSKY = 10	;_FONTNAME
SNAKE = 11	;_FONTNAME
PLOK = 13	;_FONTNAME
SQUISH = 14  ;_FONTNAME
TINYTINY = 15  ;_FONTNAME

SYMBOLS = 0 	;_FONTNAME 

; ### setup some defaults
 ifnconst fontstyle
fontstyle = STOCK
 endif

scoretable

 if fontstyle == STOCK

LENDEC = 80

       ;byte %00000000 ; STOCK

       .byte %00111100 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %00111100 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %01111110 ; STOCK
       .byte %00011000 ; STOCK
       .byte %00011000 ; STOCK
       .byte %00011000 ; STOCK
       .byte %00011000 ; STOCK
       .byte %00111000 ; STOCK
       .byte %00011000 ; STOCK
       .byte %00001000 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %01111110 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01100000 ; STOCK
       .byte %00111100 ; STOCK
       .byte %00000110 ; STOCK
       .byte %00000110 ; STOCK
       .byte %01000110 ; STOCK
       .byte %00111100 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %00111100 ; STOCK
       .byte %01000110 ; STOCK
       .byte %00000110 ; STOCK
       .byte %00000110 ; STOCK
       .byte %00011100 ; STOCK
       .byte %00000110 ; STOCK
       .byte %01000110 ; STOCK
       .byte %00111100 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %00001100 ; STOCK
       .byte %00001100 ; STOCK
       .byte %01111110 ; STOCK
       .byte %01001100 ; STOCK
       .byte %01001100 ; STOCK
       .byte %00101100 ; STOCK
       .byte %00011100 ; STOCK
       .byte %00001100 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %00111100 ; STOCK
       .byte %01000110 ; STOCK
       .byte %00000110 ; STOCK
       .byte %00000110 ; STOCK
       .byte %00111100 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01111110 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %00111100 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01111100 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01100010 ; STOCK
       .byte %00111100 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %00110000 ; STOCK
       .byte %00110000 ; STOCK
       .byte %00110000 ; STOCK
       .byte %00011000 ; STOCK
       .byte %00001100 ; STOCK
       .byte %00000110 ; STOCK
       .byte %01000010 ; STOCK
       .byte %00111110 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %00111100 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %00111100 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %00111100 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %00111100 ; STOCK
       .byte %01000110 ; STOCK
       .byte %00000110 ; STOCK
       .byte %00111110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %00111100 ; STOCK

       ;byte %00000000 ; STOCK

 ifconst fontcharsHEX 
LENHEX = 48

       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01111110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %00111100 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %01111100 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01111100 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01111100 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %00111100 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01100110 ; STOCK
       .byte %00111100 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %01111100 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01100110 ; STOCK
       .byte %01111100 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %01111110 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01111100 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01111110 ; STOCK

       ;byte %00000000 ; STOCK

       .byte %01100000 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01111100 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01100000 ; STOCK
       .byte %01111110 ; STOCK

       ;byte %00000000 ; STOCK
       ;byte %00000000 ; STOCK
       ;byte %00000000 ; STOCK
       ;byte %00000000 ; STOCK

 else
LENHEX = 0
 endif ; fontcharsHEX 
 endif ; STOCK

 if fontstyle == NEWCENTURY
LENDEC = 80
       ;byte %00000000 ; NEWCENTURY

       .byte %00111100 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %00100100 ; NEWCENTURY
       .byte %00100100 ; NEWCENTURY
       .byte %00100100 ; NEWCENTURY
       .byte %00011000 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %00001000 ; NEWCENTURY
       .byte %00001000 ; NEWCENTURY
       .byte %00001000 ; NEWCENTURY
       .byte %00001000 ; NEWCENTURY
       .byte %00001000 ; NEWCENTURY
       .byte %00001000 ; NEWCENTURY
       .byte %00001000 ; NEWCENTURY
       .byte %00001000 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %01111110 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %00100000 ; NEWCENTURY
       .byte %00011100 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00011100 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %01111100 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00111100 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00011100 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00111110 ; NEWCENTURY
       .byte %00100010 ; NEWCENTURY
       .byte %00100010 ; NEWCENTURY
       .byte %00010010 ; NEWCENTURY
       .byte %00010010 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %01111100 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %01111100 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01111000 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %00111100 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01111100 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %00110000 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %00010000 ; NEWCENTURY
       .byte %00010000 ; NEWCENTURY
       .byte %00001000 ; NEWCENTURY
       .byte %00001000 ; NEWCENTURY
       .byte %00000100 ; NEWCENTURY
       .byte %00000100 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00011110 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %00111100 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %00111100 ; NEWCENTURY
       .byte %00100100 ; NEWCENTURY
       .byte %00100100 ; NEWCENTURY
       .byte %00011000 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %00111100 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00000010 ; NEWCENTURY
       .byte %00001110 ; NEWCENTURY
       .byte %00010010 ; NEWCENTURY
       .byte %00010010 ; NEWCENTURY
       .byte %00001100 ; NEWCENTURY

 ifconst fontcharsHEX 
LENHEX = 48

       ;byte %00000000 ; NEWCENTURY

       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01111100 ; NEWCENTURY
       .byte %01000100 ; NEWCENTURY
       .byte %01000100 ; NEWCENTURY
       .byte %00111000 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %01111100 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01111100 ; NEWCENTURY
       .byte %01000100 ; NEWCENTURY
       .byte %01000100 ; NEWCENTURY
       .byte %01111000 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %00111100 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %00111000 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %01111100 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000010 ; NEWCENTURY
       .byte %01000100 ; NEWCENTURY
       .byte %01000100 ; NEWCENTURY
       .byte %01111000 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %01111110 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01111100 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01111000 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY

       .byte %01000000 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01111100 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01000000 ; NEWCENTURY
       .byte %01111000 ; NEWCENTURY

       ;byte %00000000 ; NEWCENTURY
       ;byte %00000000 ; NEWCENTURY
       ;byte %00000000 ; NEWCENTURY
       ;byte %00000000 ; NEWCENTURY

 else
LENHEX = 0
 endif ; fontcharsHEX 
 endif ; NEWCENTURY

 if fontstyle == WHIMSEY
LENDEC = 80
       ;byte %00000000 ; WHIMSEY

       .byte %00111100 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %00111100 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %00011000 ; WHIMSEY
       .byte %00011000 ; WHIMSEY
       .byte %00011000 ; WHIMSEY
       .byte %01111000 ; WHIMSEY
       .byte %00011000 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111000 ; WHIMSEY
       .byte %00111100 ; WHIMSEY
       .byte %00001110 ; WHIMSEY
       .byte %01100110 ; WHIMSEY
       .byte %00111100 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %00111100 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01101110 ; WHIMSEY
       .byte %00001110 ; WHIMSEY
       .byte %00111100 ; WHIMSEY
       .byte %00011100 ; WHIMSEY
       .byte %01111110 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %00011100 ; WHIMSEY
       .byte %00011100 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01011100 ; WHIMSEY
       .byte %01011100 ; WHIMSEY
       .byte %00011100 ; WHIMSEY
       .byte %00011100 ; WHIMSEY
       .byte %00011100 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %00111100 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01101110 ; WHIMSEY
       .byte %00001110 ; WHIMSEY
       .byte %01111100 ; WHIMSEY
       .byte %01110000 ; WHIMSEY
       .byte %01111110 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %00111100 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %01111100 ; WHIMSEY
       .byte %01110000 ; WHIMSEY
       .byte %00111110 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %01111000 ; WHIMSEY
       .byte %01111000 ; WHIMSEY
       .byte %01111000 ; WHIMSEY
       .byte %00111100 ; WHIMSEY
       .byte %00011100 ; WHIMSEY
       .byte %00001110 ; WHIMSEY
       .byte %00001110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %00111100 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %00111100 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %00111100 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %00111100 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %00000110 ; WHIMSEY
       .byte %00111110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %00111100 ; WHIMSEY

 ifconst fontcharsHEX 
LENHEX = 48

       ;byte %00000000 ; WHIMSEY

       .byte %01110110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %00111100 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %01111100 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %01111100 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %01111100 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %00111100 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %01110000 ; WHIMSEY
       .byte %01110000 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %00111100 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %01111100 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %01110110 ; WHIMSEY
       .byte %01111100 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01111110 ; WHIMSEY
       .byte %01110000 ; WHIMSEY
       .byte %01110000 ; WHIMSEY
       .byte %01111100 ; WHIMSEY
       .byte %01110000 ; WHIMSEY
       .byte %01111100 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY

       .byte %01110000 ; WHIMSEY
       .byte %01110000 ; WHIMSEY
       .byte %01110000 ; WHIMSEY
       .byte %01110000 ; WHIMSEY
       .byte %01110000 ; WHIMSEY
       .byte %01111100 ; WHIMSEY
       .byte %01110000 ; WHIMSEY
       .byte %01111100 ; WHIMSEY

       ;byte %00000000 ; WHIMSEY
       ;byte %00000000 ; WHIMSEY
       ;byte %00000000 ; WHIMSEY
       ;byte %00000000 ; WHIMSEY

 else
LENHEX = 0
 endif ; fontcharsHEX

 endif ; WHIMSEY

 if fontstyle == ALARMCLOCK
LENDEC = 80

       ;byte %00000000 ; ALARMCLOCK

       .byte %00111100 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %00000000 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00000000 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000000 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000000 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00111100 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00111100 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00000000 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %00000000 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00111100 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00111100 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00000000 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000000 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00111100 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00111100 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK


 ifconst fontcharsHEX 
LENHEX = 48
       ;byte %00000000 ; ALARMCLOCK


       .byte %00000000 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00111100 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %00000000 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00111100 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %00000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00111100 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %01000010 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000010 ; ALARMCLOCK
       .byte %00000000 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00111100 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK

       .byte %00000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %01000000 ; ALARMCLOCK
       .byte %00111100 ; ALARMCLOCK

       ;byte %00000000 ; ALARMCLOCK
       ;byte %00000000 ; ALARMCLOCK
       ;byte %00000000 ; ALARMCLOCK
       ;byte %00000000 ; ALARMCLOCK

 else
LENHEX = 0
 endif ; fontcharsHEX
 endif ; ALARMCLOCK

 if fontstyle == HANDWRITTEN
LENDEC = 80

       ;byte %00000000 ; HANDWRITTEN

       .byte %00110000 ; HANDWRITTEN
       .byte %01001000 ; HANDWRITTEN
       .byte %01001000 ; HANDWRITTEN
       .byte %01001000 ; HANDWRITTEN
       .byte %00100100 ; HANDWRITTEN
       .byte %00100100 ; HANDWRITTEN
       .byte %00010010 ; HANDWRITTEN
       .byte %00001100 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %00010000 ; HANDWRITTEN
       .byte %00010000 ; HANDWRITTEN
       .byte %00010000 ; HANDWRITTEN
       .byte %00001000 ; HANDWRITTEN
       .byte %00001000 ; HANDWRITTEN
       .byte %00001000 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %01110000 ; HANDWRITTEN
       .byte %01001100 ; HANDWRITTEN
       .byte %01000000 ; HANDWRITTEN
       .byte %00100000 ; HANDWRITTEN
       .byte %00011000 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN
       .byte %00100010 ; HANDWRITTEN
       .byte %00011100 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %00110000 ; HANDWRITTEN
       .byte %01001000 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN
       .byte %00011000 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN
       .byte %00100010 ; HANDWRITTEN
       .byte %00011100 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %00010000 ; HANDWRITTEN
       .byte %00010000 ; HANDWRITTEN
       .byte %00001000 ; HANDWRITTEN
       .byte %01111000 ; HANDWRITTEN
       .byte %01000100 ; HANDWRITTEN
       .byte %00100100 ; HANDWRITTEN
       .byte %00010010 ; HANDWRITTEN
       .byte %00000010 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %00110000 ; HANDWRITTEN
       .byte %01001000 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN
       .byte %00011000 ; HANDWRITTEN
       .byte %00100000 ; HANDWRITTEN
       .byte %00010010 ; HANDWRITTEN
       .byte %00001100 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %00010000 ; HANDWRITTEN
       .byte %00101000 ; HANDWRITTEN
       .byte %00100100 ; HANDWRITTEN
       .byte %00100100 ; HANDWRITTEN
       .byte %00011000 ; HANDWRITTEN
       .byte %00010000 ; HANDWRITTEN
       .byte %00001000 ; HANDWRITTEN
       .byte %00000110 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %00010000 ; HANDWRITTEN
       .byte %00010000 ; HANDWRITTEN
       .byte %00010000 ; HANDWRITTEN
       .byte %00001000 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN
       .byte %00000100 ; HANDWRITTEN
       .byte %00110010 ; HANDWRITTEN
       .byte %00001110 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %00110000 ; HANDWRITTEN
       .byte %01001000 ; HANDWRITTEN
       .byte %01000100 ; HANDWRITTEN
       .byte %00100100 ; HANDWRITTEN
       .byte %00011100 ; HANDWRITTEN
       .byte %00010010 ; HANDWRITTEN
       .byte %00001010 ; HANDWRITTEN
       .byte %00000110 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %00010000 ; HANDWRITTEN
       .byte %00010000 ; HANDWRITTEN
       .byte %00001000 ; HANDWRITTEN
       .byte %00001000 ; HANDWRITTEN
       .byte %00011100 ; HANDWRITTEN
       .byte %00100100 ; HANDWRITTEN
       .byte %00010010 ; HANDWRITTEN
       .byte %00001100 ; HANDWRITTEN

 ifconst fontcharsHEX 
LENHEX = 48

       ;byte %00000000 ; HANDWRITTEN

       .byte %00110110 ; HANDWRITTEN
       .byte %01001000 ; HANDWRITTEN
       .byte %01001000 ; HANDWRITTEN
       .byte %01001000 ; HANDWRITTEN
       .byte %00100100 ; HANDWRITTEN
       .byte %00100100 ; HANDWRITTEN
       .byte %00010010 ; HANDWRITTEN
       .byte %00001110 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %11110000 ; HANDWRITTEN
       .byte %01001000 ; HANDWRITTEN
       .byte %01000100 ; HANDWRITTEN
       .byte %00100100 ; HANDWRITTEN
       .byte %00111100 ; HANDWRITTEN
       .byte %00010010 ; HANDWRITTEN
       .byte %00010010 ; HANDWRITTEN
       .byte %00001100 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %00110000 ; HANDWRITTEN
       .byte %01001000 ; HANDWRITTEN
       .byte %01001000 ; HANDWRITTEN
       .byte %01000000 ; HANDWRITTEN
       .byte %00100000 ; HANDWRITTEN
       .byte %00100100 ; HANDWRITTEN
       .byte %00010100 ; HANDWRITTEN
       .byte %00001000 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %01111000 ; HANDWRITTEN
       .byte %01000100 ; HANDWRITTEN
       .byte %01000100 ; HANDWRITTEN
       .byte %00100100 ; HANDWRITTEN
       .byte %00100010 ; HANDWRITTEN
       .byte %00010010 ; HANDWRITTEN
       .byte %00010010 ; HANDWRITTEN
       .byte %00001100 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %00110000 ; HANDWRITTEN
       .byte %01001000 ; HANDWRITTEN
       .byte %01000000 ; HANDWRITTEN
       .byte %00100000 ; HANDWRITTEN
       .byte %00011000 ; HANDWRITTEN
       .byte %00010000 ; HANDWRITTEN
       .byte %00010010 ; HANDWRITTEN
       .byte %00001100 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN

       .byte %01000000 ; HANDWRITTEN
       .byte %01000000 ; HANDWRITTEN
       .byte %01000000 ; HANDWRITTEN
       .byte %00100000 ; HANDWRITTEN
       .byte %00111000 ; HANDWRITTEN
       .byte %00010000 ; HANDWRITTEN
       .byte %00010010 ; HANDWRITTEN
       .byte %00001100 ; HANDWRITTEN

       ;byte %00000000 ; HANDWRITTEN
       ;byte %00000000 ; HANDWRITTEN
       ;byte %00000000 ; HANDWRITTEN
       ;byte %00000000 ; HANDWRITTEN

 else
LENHEX = 0
 endif ; fontcharsHEX
 endif ; HANDWRITTEN

 if fontstyle == INTERRUPTED
LENDEC = 80

       ;byte %00000000 ; INTERRUPTED

       .byte %00110100 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %00110100 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %00111100 ; INTERRUPTED
       .byte %00000000 ; INTERRUPTED
       .byte %00011000 ; INTERRUPTED
       .byte %00011000 ; INTERRUPTED
       .byte %00011000 ; INTERRUPTED
       .byte %00011000 ; INTERRUPTED
       .byte %00011000 ; INTERRUPTED
       .byte %00111000 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %01101110 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %00110000 ; INTERRUPTED
       .byte %00011000 ; INTERRUPTED
       .byte %00001100 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %01000110 ; INTERRUPTED
       .byte %00111100 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %01111100 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %01110110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %01110100 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %00000110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %01110110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %01111100 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %01111100 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %01101110 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %00101100 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01101100 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %00110000 ; INTERRUPTED
       .byte %00011100 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %00011000 ; INTERRUPTED
       .byte %00011000 ; INTERRUPTED
       .byte %00011000 ; INTERRUPTED
       .byte %00011100 ; INTERRUPTED
       .byte %00001110 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %00000000 ; INTERRUPTED
       .byte %01111110 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %00110100 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %00110100 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %00110100 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %00111000 ; INTERRUPTED
       .byte %00001100 ; INTERRUPTED
       .byte %00000110 ; INTERRUPTED
       .byte %00110110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %00110100 ; INTERRUPTED

 ifconst fontcharsHEX 
LENHEX = 48

       ;byte %00000000 ; INTERRUPTED

       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01110110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %00111100 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %01110100 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01110100 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01110100 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %00101100 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %00101100 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %01111100 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01100110 ; INTERRUPTED
       .byte %01101100 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %01111110 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %01101110 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %01101110 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED

       .byte %01100000 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %01101110 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %01100000 ; INTERRUPTED
       .byte %01101110 ; INTERRUPTED

       ;byte %00000000 ; INTERRUPTED
       ;byte %00000000 ; INTERRUPTED
       ;byte %00000000 ; INTERRUPTED
       ;byte %00000000 ; INTERRUPTED

 else
LENHEX = 0
 endif ; fontcharsHEX
 endif ; INTERRUPTED


 if fontstyle == TINY
LENDEC = 80

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00111000 ; TINY
       .byte %00101000 ; TINY
       .byte %00101000 ; TINY
       .byte %00101000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00010000 ; TINY
       .byte %00010000 ; TINY
       .byte %00010000 ; TINY
       .byte %00010000 ; TINY
       .byte %00010000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00111000 ; TINY
       .byte %00100000 ; TINY
       .byte %00111000 ; TINY
       .byte %00001000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00111000 ; TINY
       .byte %00001000 ; TINY
       .byte %00111000 ; TINY
       .byte %00001000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00001000 ; TINY
       .byte %00001000 ; TINY
       .byte %00111000 ; TINY
       .byte %00101000 ; TINY
       .byte %00101000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00111000 ; TINY
       .byte %00001000 ; TINY
       .byte %00111000 ; TINY
       .byte %00100000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00111000 ; TINY
       .byte %00101000 ; TINY
       .byte %00111000 ; TINY
       .byte %00100000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00001000 ; TINY
       .byte %00001000 ; TINY
       .byte %00001000 ; TINY
       .byte %00001000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00111000 ; TINY
       .byte %00101000 ; TINY
       .byte %00111000 ; TINY
       .byte %00101000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00001000 ; TINY
       .byte %00001000 ; TINY
       .byte %00111000 ; TINY
       .byte %00101000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

 ifconst fontcharsHEX 
LENHEX = 48

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00101000 ; TINY
       .byte %00101000 ; TINY
       .byte %00111000 ; TINY
       .byte %00101000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00110000 ; TINY
       .byte %00101000 ; TINY
       .byte %00110000 ; TINY
       .byte %00101000 ; TINY
       .byte %00110000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00111000 ; TINY
       .byte %00100000 ; TINY
       .byte %00100000 ; TINY
       .byte %00100000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00110000 ; TINY
       .byte %00101000 ; TINY
       .byte %00101000 ; TINY
       .byte %00101000 ; TINY
       .byte %00110000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00111000 ; TINY
       .byte %00100000 ; TINY
       .byte %00111000 ; TINY
       .byte %00100000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY

       .byte %00000000 ; TINY
       .byte %00100000 ; TINY
       .byte %00100000 ; TINY
       .byte %00111000 ; TINY
       .byte %00100000 ; TINY
       .byte %00111000 ; TINY
       .byte %00000000 ; TINY
       .byte %00000000 ; TINY

       ;byte %00000000 ; TINY
       ;byte %00000000 ; TINY
       ;byte %00000000 ; TINY
       ;byte %00000000 ; TINY

 else
LENHEX = 0

 endif ; fontcharsHEX
 endif ; TINY

 if fontstyle == RETROPUTER
LENDEC = 80

       ;byte %00000000 ; RETROPUTER

       .byte %01111110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %01100010 ; RETROPUTER
       .byte %01100010 ; RETROPUTER
       .byte %01100010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %00111000 ; RETROPUTER
       .byte %00111000 ; RETROPUTER
       .byte %00111000 ; RETROPUTER
       .byte %00111000 ; RETROPUTER
       .byte %00011000 ; RETROPUTER
       .byte %00011000 ; RETROPUTER
       .byte %00011000 ; RETROPUTER
       .byte %00011000 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %01111110 ; RETROPUTER
       .byte %01100000 ; RETROPUTER
       .byte %01100000 ; RETROPUTER
       .byte %01100000 ; RETROPUTER
       .byte %00111110 ; RETROPUTER
       .byte %00000010 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %01111110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %00000110 ; RETROPUTER
       .byte %00000110 ; RETROPUTER
       .byte %00111110 ; RETROPUTER
       .byte %00000010 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %00001100 ; RETROPUTER
       .byte %00001100 ; RETROPUTER
       .byte %00001100 ; RETROPUTER
       .byte %01111110 ; RETROPUTER
       .byte %01000100 ; RETROPUTER
       .byte %01000100 ; RETROPUTER
       .byte %01000100 ; RETROPUTER
       .byte %00000100 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %01111110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %00000110 ; RETROPUTER
       .byte %00000110 ; RETROPUTER
       .byte %01111100 ; RETROPUTER
       .byte %01000000 ; RETROPUTER
       .byte %01000000 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %01111110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %01111100 ; RETROPUTER
       .byte %01000000 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %00001100 ; RETROPUTER
       .byte %00001100 ; RETROPUTER
       .byte %00001100 ; RETROPUTER
       .byte %00001100 ; RETROPUTER
       .byte %00000100 ; RETROPUTER
       .byte %00000010 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %01111110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %01000110 ; RETROPUTER
       .byte %01111110 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %00000110 ; RETROPUTER
       .byte %00000110 ; RETROPUTER
       .byte %00000110 ; RETROPUTER
       .byte %00000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

 ifconst fontcharsHEX 
LENHEX = 48

       ;byte %00000000  ; RETROPUTER

       .byte %01100010 ; RETROPUTER
       .byte %01100010 ; RETROPUTER
       .byte %01100010 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %01111110 ; RETROPUTER
       .byte %01100010 ; RETROPUTER
       .byte %01100010 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111100 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %01111110 ; RETROPUTER
       .byte %01100010 ; RETROPUTER
       .byte %01100010 ; RETROPUTER
       .byte %01100000 ; RETROPUTER
       .byte %01000000 ; RETROPUTER
       .byte %01000000 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %01111100 ; RETROPUTER
       .byte %01100010 ; RETROPUTER
       .byte %01100010 ; RETROPUTER
       .byte %01100010 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111100 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %01111110 ; RETROPUTER
       .byte %01100010 ; RETROPUTER
       .byte %01100000 ; RETROPUTER
       .byte %01000000 ; RETROPUTER
       .byte %01111100 ; RETROPUTER
       .byte %01000000 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER

       .byte %01100000 ; RETROPUTER
       .byte %01100000 ; RETROPUTER
       .byte %01100000 ; RETROPUTER
       .byte %01000000 ; RETROPUTER
       .byte %01111100 ; RETROPUTER
       .byte %01000000 ; RETROPUTER
       .byte %01000010 ; RETROPUTER
       .byte %01111110 ; RETROPUTER

       ;byte %00000000 ; RETROPUTER
       ;byte %00000000 ; RETROPUTER
       ;byte %00000000 ; RETROPUTER
       ;byte %00000000 ; RETROPUTER

 else
LENHEX = 0
 endif ; fontcharsHEX
 endif ; RETROPUTER

 if fontstyle == CURVES

LENDEC = 80

       ;byte %00000000 ; CURVES

       .byte %00111100 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00111100 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %00011000 ; CURVES
       .byte %00011000 ; CURVES
       .byte %00011000 ; CURVES
       .byte %00011000 ; CURVES
       .byte %00011000 ; CURVES
       .byte %00011000 ; CURVES
       .byte %01111000 ; CURVES
       .byte %01110000 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %01111110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01100000 ; CURVES
       .byte %01111100 ; CURVES
       .byte %00111110 ; CURVES
       .byte %00000110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01111100 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %01111100 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00001110 ; CURVES
       .byte %00111100 ; CURVES
       .byte %00111100 ; CURVES
       .byte %00001110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01111100 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %00000110 ; CURVES
       .byte %00000110 ; CURVES
       .byte %00111110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01100110 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %01111100 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00000110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01111100 ; CURVES
       .byte %01100000 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01111110 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %00111100 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01111100 ; CURVES
       .byte %01100000 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00111110 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %00000110 ; CURVES
       .byte %00000110 ; CURVES
       .byte %00000110 ; CURVES
       .byte %00000110 ; CURVES
       .byte %00000110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00111100 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %00111100 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00111100 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00111100 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %01111100 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00000110 ; CURVES
       .byte %00111110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00111100 ; CURVES

 ifconst fontcharsHEX 
LENHEX = 48

       ;byte %00000000 ; CURVES

       .byte %01100110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00111100 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %01111100 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01111100 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01111100 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %00111110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01100000 ; CURVES
       .byte %01100000 ; CURVES
       .byte %01100000 ; CURVES
       .byte %01100000 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00111110 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %01111100 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01100110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01111100 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %00111110 ; CURVES
       .byte %01111110 ; CURVES
       .byte %01100000 ; CURVES
       .byte %01111100 ; CURVES
       .byte %01111100 ; CURVES
       .byte %01100000 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00111110 ; CURVES

       ;byte %00000000 ; CURVES

       .byte %01100000 ; CURVES
       .byte %01100000 ; CURVES
       .byte %01100000 ; CURVES
       .byte %01111100 ; CURVES
       .byte %01111100 ; CURVES
       .byte %01100000 ; CURVES
       .byte %01111110 ; CURVES
       .byte %00111110 ; CURVES

       ;byte %00000000 ; CURVES
       ;byte %00000000 ; CURVES
       ;byte %00000000 ; CURVES
       ;byte %00000000 ; CURVES

 else
LENHEX = 0
 endif ; fontcharsHEX 
 endif ; CURVES


 if fontstyle == HUSKY

LENDEC = 80

       ;byte %00000000 ; HUSKY

       .byte %01111100 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %01111100 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %11111110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11100000 ; HUSKY
       .byte %11111100 ; HUSKY
       .byte %01111110 ; HUSKY
       .byte %00001110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111100 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %11111100 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %00001110 ; HUSKY
       .byte %11111100 ; HUSKY
       .byte %11111100 ; HUSKY
       .byte %00001110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111100 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %00011100 ; HUSKY
       .byte %00011100 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11011100 ; HUSKY
       .byte %11011100 ; HUSKY
       .byte %00011100 ; HUSKY
       .byte %00011100 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %11111100 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %00001110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111100 ; HUSKY
       .byte %11100000 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111110 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %01111100 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111100 ; HUSKY
       .byte %11100000 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %01111110 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY
       .byte %00111000 ; HUSKY
       .byte %00011100 ; HUSKY
       .byte %00001110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111110 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %01111100 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %01111100 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %01111100 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %11111100 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %00001110 ; HUSKY
       .byte %01111110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %01111100 ; HUSKY

 ifconst fontcharsHEX 
LENHEX = 48

       ;byte %00000000 ; HUSKY

       .byte %11101110 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %01111100 ; HUSKY
       .byte %00111000 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %11111100 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111100 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111100 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %01111110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11110000 ; HUSKY
       .byte %11100000 ; HUSKY
       .byte %11100000 ; HUSKY
       .byte %11110000 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %01111110 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %11111000 ; HUSKY
       .byte %11111100 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11101110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111100 ; HUSKY
       .byte %11111000 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %11111110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11100000 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11100000 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111110 ; HUSKY

       ;byte %00000000 ; HUSKY

       .byte %11100000 ; HUSKY
       .byte %11100000 ; HUSKY
       .byte %11100000 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11100000 ; HUSKY
       .byte %11111110 ; HUSKY
       .byte %11111110 ; HUSKY

       ;byte %00000000 ; HUSKY
       ;byte %00000000 ; HUSKY
       ;byte %00000000 ; HUSKY
       ;byte %00000000 ; HUSKY

 else
LENHEX = 0
 endif ; fontcharsHEX 
 endif ; HUSKY


 if fontstyle == SNAKE

LENDEC = 80

       ;byte %00000000 ; SNAKE

       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %00111000 ; SNAKE
       .byte %00101000 ; SNAKE
       .byte %00001000 ; SNAKE
       .byte %00001000 ; SNAKE
       .byte %00001000 ; SNAKE
       .byte %00001000 ; SNAKE
       .byte %00001000 ; SNAKE
       .byte %00111000 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000110 ; SNAKE
       .byte %01000000 ; SNAKE
       .byte %01111110 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01100010 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %01111110 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %00001110 ; SNAKE
       .byte %00001010 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01100110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01100010 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %01111110 ; SNAKE
       .byte %01000000 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE
       .byte %01000000 ; SNAKE
       .byte %01000110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %00000110 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %01100010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %00001110 ; SNAKE
       .byte %00001010 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %00000010 ; SNAKE
       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE


 ifconst fontcharsHEX 
LENHEX = 48

       ;byte %00000000 ; SNAKE

       .byte %01100110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000110 ; SNAKE
       .byte %01111100 ; SNAKE
       .byte %01000110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000110 ; SNAKE
       .byte %01000000 ; SNAKE
       .byte %01000000 ; SNAKE
       .byte %01000110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %01111100 ; SNAKE
       .byte %01000110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000110 ; SNAKE
       .byte %01111100 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %01111110 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01000110 ; SNAKE
       .byte %01000000 ; SNAKE
       .byte %01111000 ; SNAKE
       .byte %01000000 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE

       ;byte %00000000 ; SNAKE

       .byte %01000000 ; SNAKE
       .byte %01000000 ; SNAKE
       .byte %01000000 ; SNAKE
       .byte %01000000 ; SNAKE
       .byte %01111000 ; SNAKE
       .byte %01000000 ; SNAKE
       .byte %01000010 ; SNAKE
       .byte %01111110 ; SNAKE

       ;byte %00000000 ; SNAKE
       ;byte %00000000 ; SNAKE
       ;byte %00000000 ; SNAKE
       ;byte %00000000 ; SNAKE

 else
LENHEX = 0
 endif ; fontcharsHEX 
 endif ; SNAKE

 if fontstyle == PLOK
LENDEC = 80

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00111000 ; PLOK
       .byte %01100100 ; PLOK
       .byte %01100010 ; PLOK
       .byte %01100010 ; PLOK
       .byte %00110110 ; PLOK
       .byte %00011100 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00010000 ; PLOK
       .byte %00011100 ; PLOK
       .byte %00011100 ; PLOK
       .byte %00011000 ; PLOK
       .byte %00111000 ; PLOK
       .byte %00011000 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00001110 ; PLOK
       .byte %01111110 ; PLOK
       .byte %00011000 ; PLOK
       .byte %00001100 ; PLOK
       .byte %00000110 ; PLOK
       .byte %00111100 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00111100 ; PLOK
       .byte %01101110 ; PLOK
       .byte %00001110 ; PLOK
       .byte %00011100 ; PLOK
       .byte %00000110 ; PLOK
       .byte %01111100 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00011000 ; PLOK
       .byte %01111110 ; PLOK
       .byte %01101100 ; PLOK
       .byte %00100100 ; PLOK
       .byte %00110000 ; PLOK
       .byte %00110000 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00111100 ; PLOK
       .byte %01001110 ; PLOK
       .byte %00011100 ; PLOK
       .byte %01100000 ; PLOK
       .byte %01111100 ; PLOK
       .byte %00011100 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00111100 ; PLOK
       .byte %01000110 ; PLOK
       .byte %01101100 ; PLOK
       .byte %01110000 ; PLOK
       .byte %00111000 ; PLOK
       .byte %00010000 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00111100 ; PLOK
       .byte %00011100 ; PLOK
       .byte %00001100 ; PLOK
       .byte %00000110 ; PLOK
       .byte %01111110 ; PLOK
       .byte %00110000 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00111100 ; PLOK
       .byte %01001110 ; PLOK
       .byte %01101110 ; PLOK
       .byte %00111100 ; PLOK
       .byte %01100100 ; PLOK
       .byte %00111000 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00011000 ; PLOK
       .byte %00001100 ; PLOK
       .byte %00011100 ; PLOK
       .byte %00100110 ; PLOK
       .byte %01001110 ; PLOK
       .byte %00111100 ; PLOK
       .byte %00000000 ; PLOK

 ifconst fontcharsHEX 
LENHEX = 48

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %01100010 ; PLOK
       .byte %01100110 ; PLOK
       .byte %01111110 ; PLOK
       .byte %00101100 ; PLOK
       .byte %00101000 ; PLOK
       .byte %00110000 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %01111100 ; PLOK
       .byte %00110010 ; PLOK
       .byte %00110110 ; PLOK
       .byte %00111100 ; PLOK
       .byte %00110110 ; PLOK
       .byte %01111100 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %00111100 ; PLOK
       .byte %01100110 ; PLOK
       .byte %01100000 ; PLOK
       .byte %01100100 ; PLOK
       .byte %00101110 ; PLOK
       .byte %00011100 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %01111100 ; PLOK
       .byte %00110010 ; PLOK
       .byte %00110010 ; PLOK
       .byte %00110110 ; PLOK
       .byte %01111100 ; PLOK
       .byte %01111000 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %01111110 ; PLOK
       .byte %00110000 ; PLOK
       .byte %00111000 ; PLOK
       .byte %00111100 ; PLOK
       .byte %00110000 ; PLOK
       .byte %01111110 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK

       .byte %00000000 ; PLOK
       .byte %01100000 ; PLOK
       .byte %01100000 ; PLOK
       .byte %00111000 ; PLOK
       .byte %00100000 ; PLOK
       .byte %01111110 ; PLOK
       .byte %00011100 ; PLOK
       .byte %00000000 ; PLOK

       ;byte %00000000 ; PLOK
       ;byte %00000000 ; PLOK
       ;byte %00000000 ; PLOK
       ;byte %00000000 ; PLOK


 else
LENHEX = 0
 endif ; fontcharsHEX
 endif ; PLOK



 if fontstyle == SQUISH

LENDEC = 80

       ;byte %00000000 ; SQUISH

       .byte %00111100 ; SQUISH
       .byte %01100110 ; SQUISH
       .byte %01100110 ; SQUISH
       .byte %01100110 ; SQUISH
       .byte %00111100 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH

       ;byte %00000000 ; SQUISH

       .byte %01111110 ; SQUISH
       .byte %00011000 ; SQUISH
       .byte %00011000 ; SQUISH
       .byte %00111000 ; SQUISH
       .byte %00011000 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH

       ;byte %00000000 ; SQUISH

       .byte %01111110 ; SQUISH
       .byte %01100000 ; SQUISH
       .byte %00111100 ; SQUISH
       .byte %00000110 ; SQUISH
       .byte %01111100 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH

       ;byte %00000000 ; SQUISH

       .byte %01111100 ; SQUISH
       .byte %00000110 ; SQUISH
       .byte %00011100 ; SQUISH
       .byte %00000110 ; SQUISH
       .byte %01111100 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH

       ;byte %00000000 ; SQUISH

       .byte %00001100 ; SQUISH
       .byte %01111110 ; SQUISH
       .byte %01001100 ; SQUISH
       .byte %00101100 ; SQUISH
       .byte %00011100 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH

       ;byte %00000000 ; SQUISH

       .byte %01111100 ; SQUISH
       .byte %00000110 ; SQUISH
       .byte %00111100 ; SQUISH
       .byte %01100000 ; SQUISH
       .byte %01111110 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH

       ;byte %00000000 ; SQUISH

       .byte %00111100 ; SQUISH
       .byte %01100110 ; SQUISH
       .byte %01111100 ; SQUISH
       .byte %01100000 ; SQUISH
       .byte %00111100 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH

       ;byte %00000000 ; SQUISH

       .byte %00110000 ; SQUISH
       .byte %00011000 ; SQUISH
       .byte %00001100 ; SQUISH
       .byte %00000110 ; SQUISH
       .byte %01111110 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH

       ;byte %00000000 ; SQUISH

       .byte %00111100 ; SQUISH
       .byte %01100110 ; SQUISH
       .byte %00111100 ; SQUISH
       .byte %01100110 ; SQUISH
       .byte %00111100 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH

       ;byte %00000000 ; SQUISH

       .byte %00111100 ; SQUISH
       .byte %00000110 ; SQUISH
       .byte %00111110 ; SQUISH
       .byte %01100110 ; SQUISH
       .byte %00111100 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH

       ;byte %00000000 ; SQUISH

 ifconst fontcharsHEX 
LENHEX = 48

       .byte %01100110 ; SQUISH
       .byte %01100110 ; SQUISH
       .byte %01111110 ; SQUISH
       .byte %01100110 ; SQUISH
       .byte %00111100 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH

       ;byte %00000000 ; SQUISH

       .byte %01111100 ; SQUISH
       .byte %01100110 ; SQUISH
       .byte %01111100 ; SQUISH
       .byte %01100110 ; SQUISH
       .byte %01111100 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH

       ;byte %00000000 ; SQUISH

       .byte %00111100 ; SQUISH
       .byte %01100110 ; SQUISH
       .byte %01100000 ; SQUISH
       .byte %01100110 ; SQUISH
       .byte %00111100 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH

       ;byte %00000000 ; SQUISH

       .byte %01111100 ; SQUISH
       .byte %01100110 ; SQUISH
       .byte %01100110 ; SQUISH
       .byte %01100110 ; SQUISH
       .byte %01111100 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH

       ;byte %00000000 ; SQUISH

       .byte %01111110 ; SQUISH
       .byte %01100000 ; SQUISH
       .byte %01111100 ; SQUISH
       .byte %01100000 ; SQUISH
       .byte %01111110 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH

       ;byte %00000000 ; SQUISH

       .byte %01100000 ; SQUISH
       .byte %01100000 ; SQUISH
       .byte %01111100 ; SQUISH
       .byte %01100000 ; SQUISH
       .byte %01111110 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH
       .byte %00000000 ; SQUISH

       ;byte %00000000 ; SQUISH
       ;byte %00000000 ; SQUISH
       ;byte %00000000 ; SQUISH
       ;byte %00000000 ; SQUISH

 else
LENHEX = 0
 endif ; fontcharsHEX 
 endif ; SQUISH






 if fontstyle == NOFONT
LENDEC = 0
LENHEX = 0
 endif ; NOFONT


; ### any characters that aren't font specific follow... 

 ifconst fontcharSPACE
LENSPACE = 8
       ;byte %00000000 ; SYMBOLS

       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS
 else
LENSPACE = 0
 endif ; fontcharSPACE

 ifconst fontcharDOLLAR
LENDOLLAR = 8
       ;byte %00000000 ; SYMBOLS

       .byte %00000000 ; SYMBOLS
       .byte %00010000 ; SYMBOLS
       .byte %01111100 ; SYMBOLS
       .byte %00010010 ; SYMBOLS
       .byte %01111100 ; SYMBOLS
       .byte %10010000 ; SYMBOLS
       .byte %01111100 ; SYMBOLS
       .byte %00010000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 else
LENDOLLAR = 0
 endif ; fontcharDOLLAR

 ifconst fontcharPOUND
LENPOUND = 8
       ;byte %00000000 ; SYMBOLS

       .byte %01111110 ; SYMBOLS
       .byte %01000000 ; SYMBOLS
       .byte %00100000 ; SYMBOLS
       .byte %00100000 ; SYMBOLS
       .byte %01111000 ; SYMBOLS
       .byte %00100000 ; SYMBOLS
       .byte %00100010 ; SYMBOLS
       .byte %00011100 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 else
LENPOUND = 0
 endif ; fontcharPOUND


 ifconst fontcharMRHAPPY
LENMRHAPPY = 8
       ;byte %00000000 ; SYMBOLS

       .byte %00111100 ; SYMBOLS
       .byte %01100110 ; SYMBOLS
       .byte %01011010 ; SYMBOLS
       .byte %01111110 ; SYMBOLS
       .byte %01111110 ; SYMBOLS
       .byte %01011010 ; SYMBOLS
       .byte %01111110 ; SYMBOLS
       .byte %00111100 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 else
LENMRHAPPY = 0
 endif ; fontcharMRHAPPY

 ifconst fontcharMRSAD
LENMRSAD = 8
       ;byte %00000000 ; SYMBOLS

       .byte %00111100 ; SYMBOLS
       .byte %01011010 ; SYMBOLS
       .byte %01100110 ; SYMBOLS
       .byte %01111110 ; SYMBOLS
       .byte %01111110 ; SYMBOLS
       .byte %01011010 ; SYMBOLS
       .byte %01111110 ; SYMBOLS
       .byte %00111100 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 else
LENMRSAD = 0
 endif ; fontcharMRSAD


 ifconst fontcharCOPYRIGHT
LENCOPYRIGHT = 8
       ;byte %00000000 ; SYMBOLS

       .byte %00000000 ; SYMBOLS
       .byte %00111000 ; SYMBOLS
       .byte %01000100 ; SYMBOLS
       .byte %10111010 ; SYMBOLS
       .byte %10100010 ; SYMBOLS
       .byte %10111010 ; SYMBOLS
       .byte %01000100 ; SYMBOLS
       .byte %00111000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 else
LENCOPYRIGHT = 0
 endif ; fontcharCOPYRIGHT


 ifconst fontcharFUJI
LENFUJI = 16

       ;byte %00000000 ; ** these commented-out blanks are for the preview generation program

       .byte %01110000 ; SYMBOLS
       .byte %01111001 ; SYMBOLS
       .byte %00011101 ; SYMBOLS
       .byte %00001101 ; SYMBOLS
       .byte %00001101 ; SYMBOLS
       .byte %00001101 ; SYMBOLS
       .byte %00001101 ; SYMBOLS
       .byte %00000000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

       .byte %00001110 ; SYMBOLS
       .byte %10011110 ; SYMBOLS
       .byte %10111000 ; SYMBOLS
       .byte %10110000 ; SYMBOLS
       .byte %10110000 ; SYMBOLS
       .byte %10110000 ; SYMBOLS
       .byte %10110000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 else
LENFUJI = 0
 endif ; fontcharFUJI


 ifconst fontcharHEART
LENHEART = 8
       ;byte %00000000 ; SYMBOLS

       .byte %00010000 ; SYMBOLS
       .byte %00111000 ; SYMBOLS
       .byte %01111100 ; SYMBOLS
       .byte %01111100 ; SYMBOLS
       .byte %11111110 ; SYMBOLS
       .byte %11111110 ; SYMBOLS
       .byte %11101110 ; SYMBOLS
       .byte %01000100 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 else
LENHEART = 0
 endif ; fontcharHEART

 ifconst fontcharDIAMOND
LENDIAMOND = 8
       ;byte %00000000 ; SYMBOLS

       .byte %00010000 ; SYMBOLS
       .byte %00111000 ; SYMBOLS
       .byte %01111100 ; SYMBOLS
       .byte %11111110 ; SYMBOLS
       .byte %11111110 ; SYMBOLS
       .byte %01111100 ; SYMBOLS
       .byte %00111000 ; SYMBOLS
       .byte %00010000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 else
LENDIAMOND = 0
 endif ; fontcharDIAMOND

 ifconst fontcharSPADE
LENSPADE = 8
       ;byte %00000000 ; SYMBOLS

       .byte %00111000 ; SYMBOLS
       .byte %00010000 ; SYMBOLS
       .byte %01010100 ; SYMBOLS
       .byte %11111110 ; SYMBOLS
       .byte %11111110 ; SYMBOLS
       .byte %01111100 ; SYMBOLS
       .byte %00111000 ; SYMBOLS
       .byte %00010000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 else
LENSPADE = 0
 endif ; fontcharSPADE

 ifconst fontcharCLUB
LENCLUB = 8
       ;byte %00000000 ; SYMBOLS

       .byte %00111000 ; SYMBOLS
       .byte %00010000 ; SYMBOLS
       .byte %11010110 ; SYMBOLS
       .byte %11111110 ; SYMBOLS
       .byte %11010110 ; SYMBOLS
       .byte %00111000 ; SYMBOLS
       .byte %00111000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 else
LENCLUB = 0
 endif ; fontcharCLUB


 ifconst fontcharCOLON
LENCOLON = 8
       ;byte %00000000 ; SYMBOLS

       .byte %00000000 ; SYMBOLS
       .byte %00011000 ; SYMBOLS
       .byte %00011000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00011000 ; SYMBOLS
       .byte %00011000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 else
LENCOLON = 0
 endif ; fontcharCOLON


 ifconst fontcharBLOCK
LENBLOCK = 8

       ;byte %00000000 ; SYMBOLS

       .byte %11111111 ; SYMBOLS
       .byte %11111111 ; SYMBOLS
       .byte %11111111 ; SYMBOLS
       .byte %11111111 ; SYMBOLS
       .byte %11111111 ; SYMBOLS
       .byte %11111111 ; SYMBOLS
       .byte %11111111 ; SYMBOLS
       .byte %11111111 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 else
LENBLOCK = 0
 endif ; fontcharBLOCK

 ifconst fontcharUNDERLINE
LENUNDERLINE = 8

       ;byte %00000000 ; SYMBOLS

       .byte %11111111 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS
       .byte %00000000 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 else
LENUNDERLINE = 0
 endif ; fontcharUNDERLINE

 ifconst fontcharARISIDE
LENARISIDE = 8
       ;byte %00000000 ; SYMBOLS

       .byte %00000000 ; SYMBOLS
       .byte %00101010 ; SYMBOLS
       .byte %00101010 ; SYMBOLS
       .byte %00101100 ; SYMBOLS
       .byte %01111111 ; SYMBOLS
       .byte %00110111 ; SYMBOLS
       .byte %00000010 ; SYMBOLS
       .byte %00000001 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS

 else
LENARISIDE = 0
 endif ; fontcharARISIDE

 ifconst fontcharARIFACE
LENARIFACE = 8
       ;byte %00000000 ; SYMBOLS

       .byte %00001000 ; SYMBOLS
       .byte %00011100 ; SYMBOLS
       .byte %00111110 ; SYMBOLS
       .byte %00101010 ; SYMBOLS
       .byte %00011100 ; SYMBOLS
       .byte %01010100 ; SYMBOLS
       .byte %00100100 ; SYMBOLS
       .byte %00000010 ; SYMBOLS

       ;byte %00000000 ; SYMBOLS


 else
LENARIFACE = 0
 endif ; fontcharARIRACE

       ;byte %00000000 ; SYMBOLS
       ;byte %00000000 ; SYMBOLS
       ;byte %00000000 ; SYMBOLS
       ;byte %00000000 ; SYMBOLS

scoretableend

 ifconst ROM2k
   ORG $F7FC
 else
   ifconst bankswitch
     if bankswitch == 8
       ORG $2FF4-bscode_length
       RORG $FFF4-bscode_length
     endif
     if bankswitch == 16
       ORG $4FF4-bscode_length
       RORG $FFF4-bscode_length
     endif
     if bankswitch == 32
       ORG $8FF4-bscode_length
       RORG $FFF4-bscode_length
     endif
   else
     ORG $FFFC
   endif
 endif
; Provided under the CC0 license. See the included LICENSE.txt for details.

 ifconst bankswitch
   if bankswitch == 8
     ORG $2FFC
     RORG $FFFC
   endif
   if bankswitch == 16
     ORG $4FFC
     RORG $FFFC
   endif
   if bankswitch == 32
     ORG $8FFC
     RORG $FFFC
   endif
   if bankswitch == 64
     ORG  $10FF0
     RORG $1FFF0
     lda $ffe0 ; we use wasted space to assist stella with EF format auto-detection
     ORG  $10FF8
     RORG $1FFF8
     ifconst superchip 
       .byte "E","F","S","C"
     else
       .byte "E","F","E","F"
     endif
     ORG  $10FFC
     RORG $1FFFC
   endif
 else
   ifconst ROM2k
     ORG $F7FC
   else
     ORG $FFFC
   endif
 endif
 .word (start & $ffff)
 .word (start & $ffff)

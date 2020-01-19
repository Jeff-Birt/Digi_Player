;-------------------------------------------------------------------------------
; NMI handler routine, plays one 4bit sample per pass
; let's do the bare minimum in the interrupt handler as it fires at 8kHz so
; any ocde here is run 8,000 times/second and uses a LOT of processor cycles

NMI_HANDLER        
         ; save state, could save to ZP save 1 cycle on PLA, 2 on TXA
         PHA                    ; 3- will restore when returning
         TXA                    ; 2-
         PHA                    ; 2-

         ; play 4-bit sample, should be low nibble only and fully processed
         OutBufRead             ; (20) value returned in A
         STA SID+$18            ; 4- save to SID volume regsiter
         STA $D020              ; 4- change border color for something to look at
         LDA $DD0D              ; 4- clear NMI

         PLA                    ; 4- restore state
         TAX                    ; 2-
         PLA                    ; 4-
         RTI                    ; 6- return from this pass of NMI
                                ; 53 total clock cycles
;-------------------------------------------------------------------------------
; NMI handler routine, plays one 4bit sample per pass
; let's do the bare minimum in the interrupt handler as it fires at 8kHz so
; any ocde here is run 8,000 times/second and uses a LOT of processor cycles

NMI_HANDLER        
         ; start with saving state, could save to ZP save 1 cycle on PLA
         PHA                    ; 3- will restore when returning

         ; play 4-bit sample, should be low nibble only and fully processed
         LDA sample             ; 4- load sample byte
         STA SID+$18            ; 4- save to SID volume regsiter
         STA $D020              ; 4- change border color for something to look at
         LDA $DD0D              ; 4- clear NMI

        ; here we need to move the tail pointer of circular buffer
         INC ptr                ; 6- inc point to next sample byte
         BNE @skip              ; 2- did we roll low byte over to zero?
         INC ptr+1              ; 6- if so inc the high byte of pointer too
   
@skip 
         PLA                    ; 4- restore state
         RTI                    ; 6- return from this pass of NMI
                                ; 39 total clock cycles
LIST P=16F628A
#include "p16f628a.inc"

; CONFIG
; __config 0x3F1D
 __CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_ON & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF
 
 CBLOCK	20H
 Reg_Tiempos;
 Reg_Ciclos;
 ENDC
 
 
 Periodo_4ms	EQU d'180'; 
 Periodo_ms	EQU d'1'
 Columnas	EQU d'16' 

 #DEFINE LED PORTB,0
 #DEFINE CLOCK PORTB,1
 #DEFINE LATCH PORTB,2
 
 #DEFINE F1 PORTB,3
 #DEFINE F2 PORTB,4
 #DEFINE F3 PORTB,5
 #DEFINE F4 PORTB,6
 #DEFINE F5 PORTB,7
 
    
 ORG    0
 GOTO   INICIO
 ORG    4; HABILITA LAS INTERRUPCIONES
 GOTO   TMR0_INT
 
 INICIO
    BSF	    STATUS,RP0
    BCF	    LED
    bcf	    LATCH
    bcf	    CLOCK
    bcf	    F1
    bcf	    F2
    bcf	    F3
    BCF	    F4
    BCF	    F5
    MOVLW   B'00000011'; 16 PRESCALER TRM0
    MOVWF   OPTION_REG
    BCF	    STATUS,RP0
    MOVLW   Periodo_4ms
    MOVWF   TMR0
    MOVLW   Periodo_ms
    MOVWF   Reg_Tiempos
    movlw   Columnas
    movwf   Reg_Ciclos
    MOVLW   b'10100000'
    MOVWF   INTCON; habilitando el T0IE - GIE
    
START
    GOTO    $; bucle infinito
;interrupcion
TMR0_INT
    movlw   Periodo_4ms
    movwf   TMR0
    bcf	    LATCH
    decfsz  Reg_Tiempos,F ; decrementa en 1 y si es cero salta, sino conitnua a siguiente linea
    GOTO    FIN_INIT    
    goto    CICLO 
CICLO
    MOVLW   Periodo_ms
    MOVWF   Reg_Tiempos
    decfsz  Reg_Ciclos,F
    goto    APAGA
    bcf	    CLOCK
    bsf	    LED
    bsf	    CLOCK
    bcf	    CLOCK
    bsf	    LATCH
    CALL    LETRA_A
    movlw   Columnas
    movwf   Reg_Ciclos
    goto    FIN_INIT
LETRA_A
    bcf	    F1
    bcf	    F2
    bcf	    F3
    BCF	    F4
    BCF	    F5
    RETURN
APAGA
    bcf	    CLOCK
    bcf	    LED
    bsf	    CLOCK
    bcf	    CLOCK
    bsf	    LATCH
FIN_INIT
    bcf	    INTCON,T0IF
    retfie ;gie a cero
    
    END
    



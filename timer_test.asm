LIST P=16F628A
#include "p16f628a.inc"

; CONFIG
; __config 0x3F1D
 __CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_ON & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF
 
 CBLOCK	20H
 Reg_Tiempos;
 ENDC
 
 
 Periodo_4ms	EQU d'6'; 
 Periodo_ms	EQU d'250'

 #DEFINE LED PORTB,3
   
 ORG    0
 GOTO   INICIO
 ORG    4; HABILITA LAS INTERRUPCIONES
 GOTO   TMR0_INT
 
 INICIO
    BSF	    STATUS,RP0
    BCF	    LED
    MOVLW   B'00000011'; 16 PRESCALER TRM0
    MOVWF   OPTION_REG
    BCF	    STATUS,RP0
    MOVLW   Periodo_4ms
    MOVWF   TMR0
    MOVLW   Periodo_ms
    MOVWF   Reg_Tiempos
    MOVLW   b'10100000'
    MOVWF   INTCON; habilitando el T0IE - GIE
    
START
    GOTO    $; bucle infinito
;interrupcion
TMR0_INT
    movlw   Periodo_4ms
    movwf   TMR0
    decfsz  Reg_Tiempos,F ; decrementa en 1 y si es cero salta, sino conitnua a siguiente linea
    GOTO    FIN_INIT    
    goto    CICLO 
CICLO
    MOVLW   Periodo_ms
    MOVWF   Reg_Tiempos
    decfsz  LED,F
    goto    FIN_INIT
    bcf	    LED
FIN_INIT
    bcf	    INTCON,T0IF
    retfie ;gie a cero
    
    END
    






 LIST P=16F628A
 #include "p16f628a.inc"

; CONFIG
; __config 0x3F1D
 __CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_ON & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF
 
 CBLOCK	0X0C
 Reg_Tiempos
 ENDC
 
 Periodo_50ms EQU d'195'; 195*256 = 49920us = 50ms
 Periodo_600ms EQU d'12'
 Periodo_300ms EQU d'6'
 #DEFINE LED PORTB,0
 
    ORG	    0
    GOTO    INICIO
    ORG	    4; HABILITA LAS INTERRUPCIONES
    GOTO    TMR0_INT
    
INICIO
    BSF	    STATUS,RP0
    BCF	    LED
    MOVLW   B'00000111'; 256 PRESCALER TRM0
    MOVWF   OPTION_REG
    BCF	    STATUS,RP0
    MOVLW   Periodo_50ms
    MOVWF   TMR0
    MOVLW   Periodo_300ms
    MOVWF   Reg_Tiempos
    MOVLW   b'10100000'
    MOVWF   INTCON; habilitando el T0IE - GIE
    
START
    GOTO    $; bucle infinito
;interrupcion
TMR0_INT
    movlw   Periodo_50ms
    movwf   TMR0
    decfsz  Reg_Tiempos,F ; decrementa en 1 y si es cero salta, sino conitnua a siguiente linea
    GOTO    FIN_INIT
    btfsc   LED; estado de led
    goto    ENCENDIDO
APAGADO
    bsf	    LED
    movlw   Periodo_600ms
    goto    VAR_TIEMPOS
ENCENDIDO
    bcf	    LED
    movlw   Periodo_300ms
    goto    VAR_TIEMPOS
VAR_TIEMPOS
    movwf   Reg_Tiempos
FIN_INIT
    bcf	    INTCON,T0IF
    retfie ;gie a cero
    
    END
 

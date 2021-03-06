
;================================================
; ��������� � ������������ ����������������
;================================================
	#include <p16F877a.inc>  
	__CONFIG _HS_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_ON & _LVP_OFF & _CPD_OFF& _CP_OFF
;================================================
; ������������� ��������� ������������ ����������
;================================================

INTCON			equ 0x0B
STATUS			equ 0x03
PORTD			equ 0x08
TRISD			equ 0x88
PORTB			equ 0x06
TRISB			equ 0x86

;================================================
; ������������� ��������
;================================================

RP0			equ 0x05
C           equ 0x00
Z           equ 0x02

;================================================
; ������������� ���������� � ������ ������
;================================================
LIGHTS_FULL   equ 0x20
count0 equ 25h	; ����� ���������� ����������� ����� ������, ������������� �� ������� 25h, 26h, 27h 
count1 equ 26h
count2 equ 27h
;================================================
; ������ ���������
;================================================
	ORG 0x00
	goto Start

Start:
	clrf INTCON			;��������� ��� ����������
;===============================================
; ����������� ����� ����� PORTD �� �����
;===============================================

	bsf STATUS,RP0			;��������� � ���� 1
	CLRF TRISD
;	CLRF TRISB	
	BSF TRISB,.6 ;������				
	BCF STATUS,RP0		;��������� � ���� 0	
		
;===============================================
; ��������� ���������
;===============================================
LOOP:

	BSF STATUS,C
	CLRF PORTD
	CLRF PORTB
	CLRF LIGHTS_FULL	

RUNNING_LIGHTS:

	RLF PORTD,1
	GOTO XOR0
XOR0_FALSE:
	BTFSS PORTB,.6 ;������� ������
	GOTO BUTTON_CLICK
GOTO delay

BUTTON_CLICK:

	BTFSS PORTD,.0 ;�������� ����� �� ������ ���������
	GOTO RUNNING_LIGHTS
	BTFSC STATUS,C
	GOTO RUNNING_LIGHTS
	GOTO XOR255

MODIFICATION_LIGHTS:

	BTFSC LIGHTS_FULL,.0
	GOTO LDEC
	BSF STATUS,C
	GOTO delay
	
LDEC:

	BCF PORTD,C
	GOTO delay
	

 XOR255:

    MOVF PORTD,W   ; ���������� �� PORTD � W
    BCF  STATUS,Z ; ������� ���� Z � ����
    XORLW .255     ; �������� ��������� � ������ 255(��� ���������� �����)
    BTFSC  STATUS,Z ; ������ ���-�������� Z-�����
	GOTO DEC_LIGHTS
	GOTO MODIFICATION_LIGHTS

; ���� Z=1, �� ����������� ��������� ����������, ����� � ������������

 XOR0:

    MOVF  PORTD,W   ; ���������� �� PORTD � W
    BCF   STATUS,Z ; ������� ���� Z � ����
    XORLW .0     ; �������� ��������� � ������ 0(��� ���������� �������)
    BTFSC STATUS,Z ; ������ ���-�������� Z-�����
	GOTO LOOP
	GOTO XOR0_FALSE

DEC_LIGHTS:

BSF LIGHTS_FULL,.0
GOTO MODIFICATION_LIGHTS

delay:				;������������ ��������
	MOVLW 0xd
	MOVWF count0
	MOVLW 0xff
loop0:
		MOVWF count1
	loop1:
			MOVWF count2
		loop2:
			DECFSZ count2,F
			GOTO loop2 ; ������� �� ����� loop2

		DECFSZ count1,F
		GOTO loop1
	DECFSZ count0,F
	GOTO loop0
GOTO RUNNING_LIGHTS


End
; Dang Manh Truong (MSSV 20134209)
; Chuong trinh thuc hien "dual slope ADC" 
; Tham khao: 
; [1] Microprocessor Interfacing Techniques - Austin Lesea, Rodnay Zaks
; [2] http://www.hardwaresecrets.com/how-analog-to-digital-converter-adc-works/8/
SOC				EQU			P3.0 ; Start of conversion (bat dau chuyen doi)
EOC				EQU			P3.1 ; End of conversion (ket thuc chuyen doi)
SELECT			EQU			P3.4 ; Chon tin hieu V_in hay -V_ref
HEXA_OUTPUT 	EQU			P0

ORG				0h
LJMP			MAIN

MAIN:
MOV				TMOD,#00000011B
_loop:
; Thuc hien chuyen doi theo nguyen ly "dual slope"
; 8051 dong vai tro nhu 1 bo dem (free running counter)
MOV				TL0,#0
CLR				SELECT ; Chon V_in
SETB			SOC	; Bat dau chuyen doi (giai doan 1)
CLR				SOC	
SETB			TR0	; Start Timer 0
JNB				TF0,$
CLR				TR0
SETB			SELECT ; Chon -V_ref
MOV				TL0,#0
SETB			SOC	; Bat dau chuyen doi (giai doan 2)
CLR				SOC
SETB			TR0	; Start Timer 0
JB				EOC,$
CLR				TR0
MOV				A,TL0 ; Luu ket qua
MOV				HEXA_OUTPUT,A

; Quy doi tu hexa ve so thap phan
MOV				A,TL0
MOV				B,#10 ; Chia cho 10
DIV				AB
MOV				R5,B  ; Cat chu so hang don vi
MOV				B,#10
DIV				AB
MOV				R4,B  ; Cat chu so hang chuc
MOV				B,#10
DIV				AB
MOV				R3,B  ; Cat chu so hang tram

; Hien thi tren LED  
MOV				A,R4 
SWAP			A
ADD				A,R5 
MOV				P2,A  ; Hien thi ca chu so hang chuc va don vi bang cong P2
MOV				A,R3 
MOV				P1,A ; Hien thi chu so hang tram

JMP				_loop  
RET

END

PROGRAM PLC_PRG
VAR
	Desliga AT %IX0.0 : BOOL; (* Botão B2 - NF: Desliga o controle de produção *)
	Liga AT %IX0.1 : BOOL;	(* Botão B3 - NA: Liga o controle de produção *)
	Estado : BOOL := FALSE; (* Variável para armazenar o estado do sistema *)

	AI0 : REAL; (* Entrada analógica 0: Nível do tanque de leite *)
	AI1 : REAL; (* Entrada analógica 1: Nível do tanque de essência *)
	AI2	: REAL; (* Entrada analógica 2: Nível do tanque de mistura *)

	VL AT %QX1.4 : BOOL := FALSE; (* Válvula de Leite *)
	VE AT %QX1.3 : BOOL := FALSE; (* Válvula de Essência *)
	VS AT %QX1.5 : BOOL := FALSE; (* Válvula de Saída *)
	M  AT %QX1.6 : BOOL := FALSE; (* Motor do tanque de mistura *)

	LG AT %QX1.0 : BOOL; (* Lâmpada verde: Controle ligado *)
	LR AT %QX1.2 : BOOL; (* Lâmpada vermelha: Controle desligado *)

	Leite		: DINT := 10000; (* Volume do tanque de leite em litros *)
	Essencia	: DINT := 10000; (* Volume do tanque de essência em litros *)
	Mistura		: DINT := 20000; (* Volume do tanque de mistura em litros *)
	Proporcao	: REAL := 0.1;	 (* Proporção de essência para leite *)

	TL : TP; (* Temporizador para abrir a válvula de leite por 5 segundos *)
	TM : TP; (* Temporizador para ligar o motor por 10 segundos *)

	DTL : TIME := T#5s;	(* Tempo para abrir a válvula de leite *)
	DTM : TIME := T#10s;(* Tempo para ligar o motor *)
END_VAR

(* Rede 1: Ligar e desligar o controle de produção *)
|Desliga|----|/|Liga|----|Estado|----(L1)|
|Estado|----|/|Desliga|----(L2)|

(* Rede 2: Abrir a válvula de leite por 5 segundos *)
|Estado|----|TL|----(VL)|

(* Rede 3: Abrir a válvula de essência até atingir a proporção adequada *)
|Estado|----|/|VL|----|AI1|/|AI0|<=|Proporcao|----(VE)|

(* Rede 4: Ligar o motor por 10 segundos *)
|Estado|----|VL|----|/|M|----|TM|----(M)|
|TM|----|/|M|----(TM.IN)|

(* Rede 6: Abrir a válvula de saída até esvaziar o tanque de mistura *)
|Estado|----|/|M|----|AI2|>=|0|----(VS)|

(* Rede 7: Desligar o motor e fechar as válvulas *)
|/|M|----|/|VL|----|/|VE|----|/|VS|----|/(Estado)|

(* Rede 8: Ligar a lâmpada verde quando o controle estiver ligado *)
|Estado|----(LG)|

(* Rede 9: Ligar a lâmpada vermelha quando o controle estiver desligado *)
|/|Estado|----(LR)|

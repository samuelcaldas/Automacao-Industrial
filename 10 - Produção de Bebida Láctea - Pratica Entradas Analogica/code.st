PROGRAM PLC_PRG
VAR
	Desliga AT %IX0.0 : BOOL; (* Botão B2 - NF: Desliga o controle de produção *)
	Liga AT %IX0.1 : BOOL; (* Botão B3 - NA: Liga o controle de produção *)
	Estado : BOOL := FALSE; (* Variável para armazenar o estado do sistema *)
	
	AI0 : REAL; (* Entrada analógica 0: Nível do tanque de leite *)
	AI1 : REAL; (* Entrada analógica 1: Nível do tanque de essência *)

	VL AT %QX1.4 : BOOL; (* Válvula de Leite *)
	VE AT %QX1.3 : BOOL; (* Válvula de Essência *)
	VS AT %QX1.5 : BOOL; (* Válvula de Saída *)
	M  AT %QX1.6 : BOOL; (* Motor do tanque de mistura *)

	L1 AT %QX1.0 : BOOL; (* Lâmpada verde: Controle ligado *)
	L2 AT %QX1.2 : BOOL; (* Lâmpada vermelha: Controle desligado *)

	Leite		: DINT := 10000; (* Volume do tanque de leite em litros *)
	Essencia	: DINT := 10000; (* Volume do tanque de essência em litros *)
	Mistura		: DINT := 20000; (* Volume do tanque de mistura em litros *)
	Proporcao	: REAL := 0.1;	 (* Proporção de essência para leite *)

	TL : TON; (* Temporizador para abrir a válvula de leite por 5 segundos *)
	TM : TON; (* Temporizador para ligar o motor por 10 segundos *)

	TL : TIME := T#5s; (* Tempo para abrir a válvula de leite *)
	TE : TIME := T#1s; (* Tempo para abrir a válvula de essência *)
	TM : TIME := T#10s; (* Tempo para ligar o motor *)
END_VAR

(* Rede 1: Ligar e desligar o controle de produção *)
|Desliga|----|/|Liga|----|Estado|----(L1)|
|Estado|----|/|Desliga|----(L2)|

(* Rede 2: Abrir a válvula de leite por 5 segundos *)
|Estado|----|TL|----(VL)|
|TL|----|/|TL.Q|----(TL.IN)|

(* Rede 3: Abrir a válvula de essência até atingir a proporção adequada *)
|Estado|----|/|TL.Q|----|AI1|<=|AI0|*|Proporcao|----(VE)|

(* Rede 4: Ligar o motor por 10 segundos *)
|Estado|----|TL.Q|----|/|TM.Q|----|TM|----(M)|
|TM|----|/|TM.Q|----(TM.IN)|

(* Rede 5: Abrir a válvula de saída quando o tanque de mistura estiver cheio *)
|Estado|----|TM.Q|----|AI0|>=|Mistura|----(VS)|

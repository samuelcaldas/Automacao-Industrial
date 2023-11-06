PROGRAM PLC_PRG
VAR
	Desliga AT %IX0.0 : BOOL; (* Botão B2 - NF: Desliga o controle *)
	Liga AT %IX0.1 : BOOL; (* Botão B3 - NA: Liga o controle *)
	Canal0 AT %IW0 : INT;  (* Nível do tanque de leite *)
	Canal1 AT %IW1 : INT;  (* Nível do tanque de essência *)
	Canal2 AT %IW2 : INT;  (* Nível do tanque de mistura *)

	L1 AT %QX1.0 : BOOL; (* Lâmpada verde: Controle ligado *)
	L2 AT %QX1.2 : BOOL; (* Lâmpada vermelha: Controle desligado *)
	
    VL AT %QX1.4 : BOOL; (* Válvula de leite *)
	VE AT %QX1.3 : BOOL; (* Válvula de essência *)
	VS AT %QX1.5 : BOOL; (* Válvula de saída *)
	M  AT %QX1.6 : BOOL; (* Motor do tanque de mistura *)

	Leite : INT := 10000; (* Capacidade do tanque de leite em litros *)
	Essencia : INT := 1000; (* Capacidade do tanque de essência em litros *)
	Mistura : INT := 20000; (* Capacidade do tanque de mistura em litros *)
	Proporcao : INT := 10; (* Proporção de leite para essência *)

	T1 : TON; (* Temporizador para abrir a válvula de leite por 5 segundos *)
	T2 : TON; (* Temporizador para ligar o motor por 10 segundos *)

	Estado : BOOL; 		(* Variável para armazenar o estado do sistema *)
	Emergencia : BOOL;  (* Variável para armazenar o estado de emergência *)
END_VAR

(* Lógica para ligar e desligar o controle *)
L1 := Liga AND NOT Desliga;
L2 := NOT L1;

(* Lógica para abrir a válvula de leite por 5 segundos *)
VL := T1.IN;
T1(IN := L1, PT := T#5s);

(* Lógica para abrir a válvula de essência até atingir a proporção adequada *)
VE := L1 AND (Canal0 * Proporcao > Canal1);

(* Lógica para ligar o motor por 10 segundos *)
M := T2.IN;
T2(IN := L1 AND NOT VE, PT := T#10s);

(* Lógica para abrir a válvula de saída quando o tanque de mistura estiver cheio *)
VS := L1 AND (Canal2 >= Mistura);

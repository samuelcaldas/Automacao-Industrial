PROGRAM PLC_PRG
VAR
	Desliga AT %IX0.0: BOOL; 	(* Botao de desligar *)
	Liga AT %IX0.4: BOOL; 		(* Botao de ligar *)
	Emergencia AT %IX0.1: BOOL; (* Botao de emergencia *)
	RT1 AT %IX0.2: BOOL; 		(* Contato auxiliar do rele termico *)

	K1 AT %QX0.0: BOOL; (* Bobina do contator K1 *)
	K3 AT %QX0.1: BOOL; (* Bobina do contator K3 *)
	K6 AT %QX0.2: BOOL; (* Bobina do contator K6 *)
	L1 AT %QX0.3: BOOL; (* Lampada verde *)
	L2 AT %QX0.4: BOOL; (* Lampada amarela *)
	L3 AT %QX0.5: BOOL; (* Lampada vermelha *)
	T : TIME := T#3s; 	(* Tempo de comutacao de estrela para triangulo *)
	TON1: TON; (* Temporizador para comutacao *)
	TON2: TON; (* Temporizador para piscar lampada vermelha *)
END_VAR
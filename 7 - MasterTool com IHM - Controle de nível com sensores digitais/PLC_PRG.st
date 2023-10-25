PROGRAM PLC_PRG
VAR
	Emergencia AT %IX0.2: BOOL; (* Botão de emergência para desligar a bomba *)
	Desliga AT %IX0.0: BOOL; 	(* Botão para desligar a bomba em modo manual *)
	Liga AT %IX0.1: BOOL; 		(* Botão para ligar a bomba em modo manual *)
	ReleTermico AT %IX0.3: BOOL;(* Sinal de relé térmico atuado *)
	Seletora AT %IX0.4: BOOL; 	(* Chave seletora para escolher o modo de funcionamento *)
	SensorNivelBaixo AT %IX0.5: BOOL; (* Sensor de nível baixo do tanque *)
	SensorNivelAlto AT %IX0.6: BOOL;  (* Sensor de nível alto do tanque *)

	Bomba AT %QX1.6: BOOL; (* Saída para acionar a bomba *)

	L1 AT %QX1.0: BOOL; (* Saída para acender a lâmpada verde de bomba desligada *)
	L2 AT %QX1.1: BOOL; (* Saída para acender a lâmpada amarela de relé térmico atuado *)
	L3 AT %QX1.2: BOOL; (* Saída para acender a lâmpada vermelha de bomba ligada *)
	L4 AT %QX1.3: BOOL; (* Saída para acender a lâmpada verde de nível alto *)
	L5 AT %QX1.4: BOOL; (* Saída para acender a lâmpada amarela piscando de erro *)
	L6 AT %QX1.5: BOOL; (* Saída para acender a lâmpada vermelha de nível baixo *)

	Estado: BOOL; 	(* Variável auxiliar para armazenar o estado da bomba *)
	Erro: BOOL; 	(* Variável auxiliar para indicar erro de sensor *)
	T1 : TIME := T#2s; 	(* Constante de tempo de 2 segundos *)
	T2 : TIME := T#500ms; 	(* Constante de tempo de 2 segundos *)
	TON1: TON; 	 (* Temporizador para ligar a bomba em modo automático *)
	TON2: TON; 	 (* Temporizador para desligar a bomba em modo automático *)
	TErroA: TON; (* Temporizador para piscar a lâmpada de erro *)
	TErroB: TON; (* Temporizador para piscar a lâmpada de erro *)
END_VAR
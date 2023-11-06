PROGRAM PLC_PRG
VAR
	Desliga AT %IX0.0: BOOL; (* Botão B0 - NF: Desliga o controle de nível *)
	Liga AT %IX0.1: BOOL; (* Botão B1 - NA: Liga o controle de nível *)
	RT1 AT %IX0.2: BOOL;  (* Relé térmico RT1 - NF *)
	RT2 AT %IX0.3: BOOL;  (* Relé térmico RT2 - NF *)

	LG AT %QX1.0: BOOL; (* Lâmpada verde: Bomba desligada *)
	LY AT %QX1.1: BOOL; (* Lâmpada amarela: Térmico atuado ou nível alto *)
	LR AT %QX1.2: BOOL; (* Lâmpada vermelha: Bomba ligada em baixa ou alta rotação *)

	K1 AT %QX1.3: BOOL; (* Contator K1: Liga o motor em baixa rotação *)
	K2 AT %QX1.4: BOOL; (* Contator K2: Liga o motor em alta rotação *)
	K3 AT %QX1.5: BOOL; (* Contator K3: Liga o motor em alta rotação *)

	NivelBaixo: INT := 50; 	 (* Variável para armazenar o valor do nível baixo em litros *)
	NivelAlto: INT := 90; 	 (* Variável para armazenar o valor do nível alto em litros *)
	Overflow: BOOL := FALSE; (* Variável para armazenar o estado de transbordamento do tanque *)

	(* Variável para armazenar o nivel de rotação da bomba *)
	Slow : BOOL := FALSE;	(* Variável para armazenar o estado de baixa rotação do motor *)
	Fast : BOOL := FALSE;	(* Variável para armazenar o estado de alta rotação do motor *)
	Hot: BOOL := FALSE; 	(* Variável para armazenar o estado de superaquecimento do motor *)

	T : TIME := T#500ms; (* Tempo para piscar as lâmpadas *)
	TLY1 : TON; (* Temporizador para piscar a lâmpada amarela *)
	TLY2 : TON;
	TLR1 : TON; (* Temporizador para piscar a lâmpada vermelha *)
	TLR2 : TON;

	Estado : BOOL; 		(* Variável para armazenar o estado do sistema *)
	Emergencia : BOOL;  (* Variável para armazenar o estado de emergência *)
END_VAR

(* Lógica principal do controle de nível *)

(* Verifica se há falha nos relés térmicos *)
IF NOT RT1 OR NOT RT2 THEN
	Emergencia := TRUE;
ELSE
	Emergencia := FALSE;
END_IF

(* Verifica se o botão Liga foi pressionado e se não há emergência *)
IF Liga AND NOT Emergencia THEN
	Estado := TRUE;
END_IF

(* Verifica se o botão Desliga foi pressionado ou se há emergência *)
IF Desliga OR Emergencia THEN
	Estado := FALSE;
END_IF

(* Verifica se o sistema está ligado e qual é o nível do tanque *)
IF Estado THEN
	(* Se o nível for menor que NivelBaixo, liga a bomba em alta rotação *)
	IF Nivel < NivelBaixo THEN
		K1 := FALSE;
		K2 := TRUE;
		K3 := TRUE;
	(* Se o nível for maior que NivelBaixo e menor que NivelAlto, liga a bomba em baixa rotação *)
	ELSIF Nivel >= NivelBaixo AND Nivel < NivelAlto THEN
		K1 := TRUE;
		K2 := FALSE;
		K3 := FALSE;
	(* Se o nível for maior que NivelAlto, desliga a bomba e sinaliza transbordamento *)
	ELSE
		K1 := FALSE;
		K2 := FALSE;
		K3 := FALSE;
		Emergencia := TRUE;
	END_IF
ELSE
	(* Se o sistema estiver desligado, desliga a bomba *)
	K1 := FALSE;
	K2 := FALSE;
	K3 := FALSE;
END_IF

(* Lógica de sinalização das lâmpadas *)

(* Se a bomba estiver desligada, acende a lâmpada verde *)
IF NOT K1 AND NOT K2 AND NOT K3 THEN
	LV := TRUE;
ELSE
	LV := FALSE;
END_IF

(* Se houver emergência, acende ou pisca a lâmpada amarela dependendo da causa *)
IF Emergencia THEN
	(* Se for por falha nos relés térmicos, acende a lâmpada amarela *)
	IF NOT RT1 OR NOT RT2 THEN
		LY := TRUE;
	(* Se for por nível alto, pisca a lâmpada amarela *)
	ELSE
		TLY1(IN := NOT TLY2.Q, PT := T);
		TLY2(IN := TLY1.Q, PT := T);
		LY := TLY1.Q;
	END_IF
ELSE
	LY := FALSE;
END_IF

(* Se a bomba estiver ligada, acende ou pisca a lâmpada vermelha dependendo da velocidade *)
IF K1 OR K2 OR K3 THEN
	(* Se for em baixa rotação, acende a lâmpada vermelha *)
	IF K1 AND NOT K2 AND NOT K3 THEN
		LR := TRUE;
	(* Se for em alta rotação, pisca a lâmpada vermelha *)
	ELSE
		TLR1(IN := NOT TLR2.Q, PT := T);
		TLR2(IN := TLR1.Q, PT := T);
		LR := TLR1.Q;
	END_IF
ELSE
	LR := FALSE;
END_IF

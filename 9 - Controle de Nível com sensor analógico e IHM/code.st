PROGRAM PLC_PRG
VAR
	Desliga AT %IX0.0: BOOL; (* Botão B0 - NF: Desliga o controle de nível *)
	Liga AT %IX0.1: BOOL; (* Botão B1 - NA: Liga o controle de nível *)
	RT1 AT %IX0.2: BOOL; (* Relé térmico RT1 - NF *)
	RT2 AT %IX0.3: BOOL; (* Relé térmico RT2 - NF *)

	LV AT %QX1.0: BOOL; (* Lâmpada verde: Bomba desligada *)
	LY AT %QX1.1: BOOL; (* Lâmpada amarela: Térmico atuado ou nível alto *)
	LR AT %QX1.2: BOOL; (* Lâmpada vermelha: Bomba ligada em baixa ou alta rotação *)

	K1 AT %QX1.3: BOOL; (* Contator K1: Liga o motor em baixa rotação *)
	K2 AT %QX1.4: BOOL; (* Contator K2: Liga o motor em alta rotação *)
	K3 AT %QX1.5: BOOL; (* Contator K3: Liga o motor em alta rotação *)

	Nivel AT %IW0: INT; (* Variável para armazenar o valor do sensor de nível *)
	NivelBaixo: INT := 50000; (* Variável para armazenar o valor do nível baixo em litros *)
	NivelAlto: INT := 90000; (* Variável para armazenar o valor do nível alto em litros *)

	T : TIME := T#500ms; (* Tempo para piscar as lâmpadas *)
	TLY1 : TON; (* Temporizador para piscar a lâmpada amarela *)
	TLY2 : TON;
	TLR1 : TON; (* Temporizador para piscar a lâmpada vermelha *)
	TLR2 : TON;

	Estado : BOOL; (* Variável para armazenar o estado do sistema *)
END_VAR
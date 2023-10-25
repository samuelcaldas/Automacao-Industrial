PROGRAM PLC_PRG
VAR
	Liga AT %IX0.0: BOOL; (* Chave 1 - NA: Inicia partida do motor com fechamento em estrela *)
	Desliga AT %IX0.1: BOOL; (* Chave de Desligar (NF) *)
	Emergencia AT %IX0.2: BOOL; (* Chave de Emergência (NF) *)
	RT1 AT %IX0.3: BOOL; (* Contato auxiliar do rele termico (NF) *)

	K1 AT %QX1.0: BOOL; (* Bobina do contator K1 *)
	K3 AT %QX1.1: BOOL; (* Bobina do contator K3 *)
	K6 AT %QX1.2: BOOL; (* Bobina do contator K6 *)

	L1 AT %QX1.3: BOOL; (* Lampada verde: Pronto para operar (motor desligado) *)
	L2 AT %QX1.4: BOOL; (* Lampada amarela: Emergência acionada ou RT1 atuado *)
	L3 AT %QX1.5: BOOL; (* Lampada vermelha: Lâmpada piscando durante partida em estrela e lâmpada acesa continuamente com motor fechado em triângulo *)

	Estado: BOOL; (* Variável auxiliar para indicar o início da partida *)
	Triangulo: BOOL; (* Variável auxiliar para indicar o fechamento em triângulo *)
	Erro: BOOL; (* Variável auxiliar para indicar o início da partida *)

	T1 : TIME := T#3s; (* Tempo de comutacao de estrela para triangulo *)
	TPartida: TON; (* Temporizador para comutar o fechamento do motor para triângulo *)
	T2 : TIME := T#500ms; (* Tempo piscar o LED de comutação estrela triangulo *)
	TLED1: TON; (* Temporizador para piscar lampada vermelha *)
	TLED2: TON; (* Temporizador para piscar lampada vermelha *)
END_VAR
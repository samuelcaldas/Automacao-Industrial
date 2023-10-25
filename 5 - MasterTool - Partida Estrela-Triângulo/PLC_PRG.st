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

	Partida: BOOL; (* Variável auxiliar para indicar o início da partida *)
	Estrela: BOOL; (* Variável auxiliar para indicar o fechamento em estrela *)
	Triangulo: BOOL; (* Variável auxiliar para indicar o fechamento em triângulo *)

	T : TIME := T#3s; (* Tempo de comutacao de estrela para triangulo *)
	TPartida: TON; (* Temporizador para comutar o fechamento do motor para triângulo *)
	TLED: TON; (* Temporizador para piscar lampada vermelha *)
END_VAR

(* Fazer o selo de acionamento do botão de partida *)
Partida := Liga OR (Partida AND NOT Desliga AND NOT Emergencia AND NOT RT1);

(* Fazer o intertravamento entre os contatores K3 e K6 *)
Estrela := Partida AND NOT Triangulo;
Triangulo := TPartida.Q;

(* Acionar os contatores conforme as condições de partida *)
K1 := Estrela OR Triangulo;
K3 := Triangulo;
K6 := Estrela;

(* Acionar o temporizador para comutar o fechamento do motor para triângulo após 3 segundos *)
TPartida(IN := Estrela, PT := T);

(* Acionar as lâmpadas conforme as condições de sinalização *)
L1 := NOT Partida;
L2 := Emergencia OR RT1;
L3 := Partida;

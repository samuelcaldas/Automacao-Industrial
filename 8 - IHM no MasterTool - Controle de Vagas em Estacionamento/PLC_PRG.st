PROGRAM PLC_PRG
VAR
	Habilita AT %IX0.0: BOOL; (* Chave 1 - NA: Habilita o sistema de controle de vagas no estacionamento *)
	Incrementa AT %IX0.1: BOOL; (* Chave 2 - NA: Incrementa a contagem de veículos *)
	Decrementa AT %IX0.2: BOOL; (* Chave 3 - NA: Decrementa a contagem de veículos *)

	Q1 AT %QX1.0: BOOL; (* Bobina do relé Q1 *)
	Q2 AT %QX1.1: BOOL; (* Bobina do relé Q2 *)
	Q3 AT %QX1.2: BOOL; (* Bobina do relé Q3 *)

	L1 AT %QX1.3: BOOL; (* Lampada verde: Controle de estacionamento desabilitado *)
	L2 AT %QX1.4: BOOL; (* Lampada vermelha: Não há vagas *)
	L3 AT %QX1.5: BOOL; (* Lampada amarela: Há vagas *)

	Vagas: INT := 10; (* Variável para armazenar o número de vagas disponíveis *)
	VagasMax: INT := 10; (* Variável para armazenar o número máximo de vagas *)
	VagasMin: INT := 0; (* Variável para armazenar o número mínimo de vagas *)

	T1 : TIME := T#500ms; (* Tempo para piscar a lampada verde *)
	TPiscaL1: TON; (* Temporizador para piscar a lampada verde *)
END_VAR

(* Lógica para habilitar o sistema de controle de vagas no estacionamento *)
Habilita -> Q1;

(* Lógica para incrementar a contagem de veículos *)
Q1 AND Incrementa AND Vagas < VagasMax -> Vagas := Vagas + 1;

(* Lógica para decrementar a contagem de veículos *)
Q1 AND Decrementa AND Vagas > VagasMin -> Vagas := Vagas - 1;

(* Lógica para indicar se há ou não vagas no estacionamento *)
IF Q1 THEN
	IF Vagas = VagasMin THEN
		L2 := TRUE;
		L3 := FALSE;
	ELSE
		L2 := FALSE;
		L3 := TRUE;
	END_IF;
ELSE
	L2 := FALSE;
	L3 := FALSE;
END_IF;

(* Lógica para piscar a lampada verde quando o sistema está habilitado *)
TPiscaL1(IN:=Q1, PT:=T1);
L1 := TPiscaL1.Q;

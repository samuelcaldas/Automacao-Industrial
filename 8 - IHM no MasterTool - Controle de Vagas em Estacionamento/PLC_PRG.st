PROGRAM PLC_PRG
VAR_INPUT
	Habilita AT %IX0.0: BOOL; (*Habilita o sistema de controle de vagas no estacionamento*)
	Incrementa AT %IX0.1: BOOL; (*Incrementa a contagem de veículos*)
	Decrementa AT %IX0.2: BOOL; (*Decrementa a contagem de veículos*)
END_VAR

VAR
	Contador: INT; (*Armazena o número de veículos no estacionamento*)
	Limite: INT := 100; (*Define o limite máximo de vagas no estacionamento*)
	Habilitado AT %QX1.0: BOOL; (*Indica que o controle de estacionamento está habilitado*)
	NaoHaVagas AT %QX1.1: BOOL; (*Indica que não há vagas disponíveis*)
	HaVagas AT %QX1.2: BOOL; (*Indica que há vagas disponíveis*)
END_VAR
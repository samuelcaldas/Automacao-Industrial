# Atividade: Partida Estrela-Triângulo
Faça o diagrama ladder para acionamento de um motor trifásico em partida estrela-triangulo, sem reversão, funcionando da seguinte forma:
- Condições para acionamento: 
   B1 NA: Inicia partida do motor com fechamento em estrela (energizando K1 e K6) e após 3 segundos comuta o fechamento do motor para triângulo (energizando K1 e K3);
- Condições de desligamento: 
   Contato Auxiliar NF de RT1; 
   Botão de Emergência (EM NF);
   Botão de Desligar (B0 NF).
- Sinalização: 
   L1 (verde): Motor desligado;
   L2 (amarela): Emergência acionada ou RT1 atuado; 
   L3 (vermelha): Lâmpada piscando durante partida em estrela e lâmpada acesa continuamente com motor fechado em triângulo.
- Fazer o intertravamento entre os contatores K3 e K6;
- Fazer o selo de acionamento do botão de partida.

ATAGs
- I0.0: Desliga (B0 NF); 
- I0.1: Emergência (EM NF); 
- I0.2: RT1 NF;
- I0.4: Liga (B1 NA);
- Q0.0: Bobina de K1;
- Q0.1: Bobina de K3;
- Q0.2: Bobina de K6;
- Q0.3: L1 (verde);
- Q0.4: L2 (amarela);
- Q0.5: L3 (vermelha);


exemplo:
```ladder
|----[I0.0]---[I0.1]---[I0.2]---(Q0.0)----|
|                                         |
|----[I0.4]---[Q0.0]--|--[TON]---(Q0.2)---|
|                     |                   |
|                     |-------(Q0.5)------|
|                                         |
|----[I0.4]---[Q0.2]---[TON]---(Q0.1)-----|
|                                         |
|----[Q0.1]---[Q0.2]---(Q0.3)-------------|
|                                         |
|----[/Q0.1]---[/Q0.2]---(Q0.4)-----------|
```
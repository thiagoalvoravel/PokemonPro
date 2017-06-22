% Autores: Fillipe Campos e Thiago Alvoravel

%FATOS
%objeto(coordx, coordy, tipo)

%Fatos dinâmicos
:- dynamic pokemon/3.
:- dynamic objeto/3.
:- dynamic pokebolas/1.

%Direção que o agente pode andar
direcao('sul',0,-1).
direcao('norte',0,1).
direcao('leste',1,0).
direcao('oeste',-1,0).

%Terrenos presentes no mapa
terreno('grama').
terreno('montanha').
terreno('agua').
terreno('vulcao').
terreno('caverna').

%Relação de tipos de pokemon e terrenos que eles podem andar
tipop('voador', 'montanha').
tipop('fogo', 'vulcao').
tipop('agua', 'agua').
tipop('eletrico', 'caverna').

%Estrutura dos fatos
%pokemon(nome, numero, energia)
%pokemon_tipo(nome, tipo, numero_tipo)
%treinador(resultado_batalha)
%lojap(qtd_pokebolas)
%objeto(objeto, coordx, coordy)

%Exemplos de fatos
%pokemon('sparow', '30', 'cheia').
%pokemon_tipo('sparow', 'normal', 1).
%pokemon_tipo('sparow', 'voador', 2).
%objeto('pokemon', 33, 35)
%objeto('treinador', 20, 21)
%objeto('centro', 30, 40)
%pokemon('sparow', '30', 'cheia').


%REGRAS

get_pokebolas(Quantidade) :- pokebolas(Quantidade).

get_pokemon(Pokemon, Numero, Energia) :- pokemon(Pokemon, Numero, Energia).

andar(Direcao, Coordx, Coordy) :- direcao(Direcao, Coordx, Coordy).

tem_pokemon(Nome, Tem) :- pokemon(Nome, _, _) -> Tem = 'sim'
						; Tem = 'nao'.

total_pokemon(Count) :- aggregate_all(count, pokemon(_, _, _), Count).

pode_mover(Terreno, Pode) :- (tipop(Tipo, Terreno), pokemon(_, Tipo, 1)) -> Pode = 'sim'
							; (tipop(Tipo, Terreno), pokemon(_, Tipo, 2)) -> Pode = 'sim'
							; Terreno == 'grama' -> Pode = 'sim'
							; Pode = 'parado'.

verificar_treinador_enfrentado(Objeto, Coordx, Coordy, Luta) :- objeto(Objeto, Coordx, Coordy) -> Luta = 'nao'
																; Luta = 'sim'.

verificar_loja(Objeto, Coordx, Coordy, Pegar) :- objeto(Objeto, Coordx, Coordy) -> Pegar = 'nao'
																; Pegar = 'sim'.

enfrentar_treinador(Resultado) :- total_pokemon(Total), Total =< 0 -> Resultado = 'derrota'
								  ; pokemon(_, _, 'vazia') -> Resultado = 'derrota'
								  ; Resultado = 'vitoria'.

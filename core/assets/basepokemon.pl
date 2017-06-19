% Autores: Fillipe Campos e Thiago Alvoravel

%FATOS
%objeto(coordx, coordy, tipo)

direcao('sul',0,-1).
direcao('norte',0,1).
direcao('leste',1,0).
direcao('oeste',-1,0).

terreno('grama').
terreno('montanha').

terreno('agua').
terreno('vulcao').
terreno('caverna').

tipop('voador', 'montanha').
tipop('fogo', 'vulcao').
tipop('agua', 'agua').
tipop('eletrico', 'caverna').

:- dynamic pokemon/3.
:- dynamic objeto/3.

%pokemon(nome, tipo, numero, coordx, coordy)
%treinador(resultado_batalha, coordx, coordy)
%centrop(coordx, coordy)
%lojap(qtd_pokebolas, coordx, coordy)

%pokemon('sparow', 'voador', 30).

%pokemon('sparow', 30, 'energia').
%pokemon_tipo('sparow', 'normal', 1).
%pokemon_tipo('sparow', 'voador', 2).

%objeto('pokemon', 33, 35)
%objeto('treinador', 20, 21)

%REGRAS

%Ações que faltam
%Recarregar as pokebolas
%Curar os pokemons
%Integrar as ações e tomada de decisão

get_pokemon(Pokemon, Numero, Energia) :- pokemon(Pokemon, Numero, Energia).

andar(Direcao, Coordx, Coordy) :- direcao(Direcao, Coordx, Coordy).

tem_pokemon(Nome, Tem) :- pokemon(Nome, _, _) -> Tem = 'sim'
						; Tem = 'nao'.

pode_mover(Terreno, Pode) :- (tipop(Tipo, Terreno), pokemon(_, Tipo, 1)) -> Pode = 'sim'
							; (tipop(Tipo, Terreno), pokemon(_, Tipo, 2)) -> Pode = 'sim'
							; Terreno == 'grama' -> Pode = 'sim'
							; Pode = 'parado'.

verificar_treinador_enfrentado(Objeto, Coordx, Coordy, Luta) :- objeto(Objeto, Coordx, Coordy) -> Luta = 'nao'
																; Luta = 'sim'.

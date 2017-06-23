% Autores: Fillipe Campos e Thiago Alvoravel

%FATOS
%objeto(coordx, coordy, tipo)

%Fatos dinâmicos
:- dynamic pokemon/3.
:- dynamic objeto/3.
:- dynamic pokebolas/1.

%Direções que o agente pode andar
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

%Criar regra para verificar pokebolas antes de capturar pokemons

%Retorna quantidade de pokebolas
get_pokebolas(Quantidade) :- pokebolas(Quantidade).

%Retorna pokemon
get_pokemon(Pokemon, Numero, Energia) :- pokemon(Pokemon, Numero, Energia).

%Andar para uma determinada direção
andar(Direcao, Coordx, Coordy) :- direcao(Direcao, Coordx, Coordy).

%Verificar se tem um pokemon pelo nome
tem_pokemon(Nome, Tem) :- pokemon(Nome, _, _) -> Tem = 'sim'
						; Tem = 'nao'.

%Contar total de pokemons capturados
total_pokemon(Count) :- aggregate_all(count, pokemon(_, _, _), Count).

%Verificar se o agente pode se mover em um determinado terreno
pode_mover(Terreno, Pode) :- (tipop(Tipo, Terreno), pokemon(_, Tipo, 1)) -> Pode = 'sim'
							; (tipop(Tipo, Terreno), pokemon(_, Tipo, 2)) -> Pode = 'sim'
							; Terreno == 'grama' -> Pode = 'sim'
							; Pode = 'parado'.

%Verificar se o agente já batalhou com um determinado treinador
verificar_treinador_enfrentado(Objeto, Coordx, Coordy, Luta) :- objeto(Objeto, Coordx, Coordy) -> Luta = 'nao'
																; Luta = 'sim'.

%Verificar se o agente já pegou as pokebolas de uma determinada loja
verificar_loja(Objeto, Coordx, Coordy, Pegar) :- objeto(Objeto, Coordx, Coordy) -> Pegar = 'nao'
																; Pegar = 'sim'.

%Batalhar com um treinador
enfrentar_treinador(Resultado) :- total_pokemon(Total), Total =< 0 -> Resultado = 'derrota'
								  ; pokemon(_, _, 'vazia') -> Resultado = 'derrota'
								  ; Resultado = 'vitoria'.



/**
- Conhecimento do agente -
O terreno ao redor
Pokemons capturados
Quantidade pokebolas
A energia dos pokemons
Quantidade de pokemons

- Prioridades -
1 - Quantos pokemons eu tenho? 
         150 = Termina o jogo
         < 150 = Continua jogando  

2 - Qual direção posso prosseguir?
         Norte? Sul? Leste? Oeste?

3 - Como tá a energia dos meus pokémons?
         Cheia = Prosseguir Jornada Pokémon
         Vazia = Ir ao Centro Pokémon

4 - Quantas pokébolas eu tenho?
         Se (quantidade de pokébolas + quantidade de pokémons >= 150)  Não Priorizar Carregar
         Senão se (Quantidade_Pokebolas > 0 e Tem pokémon nas posições adjacentes?) Capturar Pokémon
         Senão se (Quantidade_Pokebolas == 0) Recarrega
         Senão Explorar      


%Regra para tomada de decisão
regra_geral(ObjetoNorte, ObjetoSul, ObjetoOeste, ObjetoLeste, 
			TerrenoNorte, TerrenoSul, TerrenoOeste, TerrenoLeste, PodeNorte, PodeSul, PodeOeste, PodeLeste
			TotalPokemons, QtdPokebolas,
			Direcao) :-
	
	total_pokemon(TotalPokemons), TotalPokemons = 150 -> Direcao = 'fim'; 

	/**get_pokemon(_, _, 'vazia') , (pode_mover(TerrenoNorte, PodeNorte) -> Direcao = 'norte'; 
								  pode_mover(TerrenoSul, PodeSul) -> Direcao = 'sul'; 
								  pode_mover(TerrenoOeste, PodeOeste) -> Direcao = 'oeste'; 
								  pode_mover(TerrenoLeste, PodeLeste)) -> Direcao = 'leste';*/

	total_pokemon(TotalPokemons) + get_pokebolas(QtdPokebolas)
*/
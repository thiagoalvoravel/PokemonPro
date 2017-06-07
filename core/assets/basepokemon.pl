% Autores: Fillipe Campos e Thiago Alvoravel

%FATOS
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

%pokemon(nome, tipo, numero, coordx, coordy)
%treinador(resultado_batalha, coordx, coordy)
%centrop(coordx, coordy)
%lojap(qtd_pokebolas, coordx, coordy)

pokemon('sparow', 'voador', 30, 33, 35).

%REGRAS
andar(Direcao, Coordx, Coordy) :- direcao(Direcao, Coordx, Coordy).

pode_mover(Terreno, Pode) :- (tipop(Tipo, Terreno), pokemon(_, Tipo, _, _, _)) -> Pode = 'sim'
                       		; Terreno == 'grama' -> Pode = 'sim'
                       		; Pode = 'parado'.

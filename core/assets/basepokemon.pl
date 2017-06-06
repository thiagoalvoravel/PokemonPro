% Autores: Fillipe Campos e Thiago Alvoravel

%FATOS
direcao('sul',0,-1).
direcao('norte',0,1).
direcao('leste',1,0).
direcao('oeste',-1,0).

terreno('grama').
terreno('montanha').

%pokemon(nome, tipo, numero, coordx, coordy)
%treinador(resultado_batalha, coordx, coordy)
%centrop(coordx, coordy)
%lojap(qtd_pokebolas, coordx, coordy)

pokemon('sparow', 'voador', 30, 33, 35).

tipop('voador', 'montanha').

%REGRAS
andar(Direcao, Coordx, Coordy) :- direcao(Direcao, Coordx, Coordy).

pode_mover(Terreno) :- (tipop(Tipo, Terreno), pokemon(_, Tipo, _, _, _)) ; Terreno =:= terreno('grama').
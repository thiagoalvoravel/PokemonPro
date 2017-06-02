% Autor:

%FATOS
coordenada('sul',0,-1).
coordenada('norte',0,1).
correr('sim').

%REGRAS
andar(Direcao, Coordx,Coordy) :- coordenada(Direcao,Coordx,Coordy).
addcorrer(Direcao) :- correr(Direcao).



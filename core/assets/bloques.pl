% Autor:
% Fecha: 15/01/2013

bloque(a).
bloque(b).
bloque(c).
bloque(d).
bloque(e).
encima_de(a,b).
encima_de(b,c).
encima_de(d,e).
libre(a).
libre(d).
abajo(c).
abajo(e).
mas_arriba_de(X,Y):-encima_de(X,Y).
mas_arriba_de(X,Y):-encima_de(X,Z),mas_arriba_de(Z,Y).


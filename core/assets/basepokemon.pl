% Autores: Fillipe Campos e Thiago Alvoravel

%FATOS
%objeto(coordx, coordy, tipo)

%Fatos dinâmicos
:- dynamic pokemon/3.
:- dynamic pokemon_tipo/3.
:- dynamic objeto/3.
:- dynamic pokebolas/1.
:- dynamic quadrado/4.
:- dynamic first_n/3.

pokemon('sparow', '30', 'cheia').
pokemon_tipo('sparow', 'voador', 2).
pokemon_tipo('sparow', 'normal', 1).
objeto('pokemon', 33, 35).
objeto('centroP', 11, 9).

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
%pokemon(nome, numero, energia).
%pokemon_tipo(nome, tipo, numero_tipo).
%treinador(resultado_batalha).
%lojap(qtd_pokebolas).
%objeto(objeto, coordx, coordy).

%Exemplos de fatos
%objeto('treinador', 20, 21).
%objeto('centro', 30, 40).
%pokemon('sparow', '30', 'cheia').


%REGRAS

%Criar regra para verificar pokebolas antes de capturar pokemons

%Retorna o quadrado do mapa
get_quadrado(Quadrado, Coordx, Coordy, Terreno) :- quadrado(Quadrado, Coordx, Coordy, Terreno).

%Retorna quantidade de pokebolas
get_pokebolas(Quantidade) :- pokebolas(Quantidade).

%Retorna pokemon
get_pokemon(Pokemon, Numero, Energia) :- pokemon(Pokemon, Numero, Energia).

%Retorna o objeto presente em uma posição
get_objeto(Objeto, Coordx, Coordy) :- objeto(Objeto, Coordx, Coordy).

%Andar para uma determinada direção
andar(Direcao, Coordx, Coordy) :- direcao(Direcao, Coordx, Coordy).

%Verificar se tem um pokemon pelo nome
tem_pokemon(Nome, Tem) :- pokemon(Nome, _, _) -> Tem = 'sim'
						; Tem = 'nao'.

%Contar total de pokemons capturados
total_pokemon(Count) :- aggregate_all(count, pokemon(_, _, _), Count).

%Verificar se o agente pode se mover em um determinado terreno
pode_mover(Terreno, Pode) :- (tipop(Tipo, Terreno), pokemon_tipo(_, Tipo, 1)) -> Pode = 'sim'
							; (tipop(Tipo, Terreno), pokemon_tipo(_, Tipo, 2)) -> Pode = 'sim'
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

get_quadrados(Quadrado, Coordx, Coordy, Terreno) :- quadrado(Quadrado, Coordx, Coordy, Terreno).

get_quadrado_norte(Quadrado, Norte, Resultado, _) :- 	quadrado(Quadrado, Coordx, Coordy, _) ,
														Xnovo is Coordx + 1 ,
														quadrado(Norte, Xnovo, Coordy, _) -> Resultado is Norte ;
														Resultado is 0.

get_quadrado_sul(Quadrado, Sul, Resultado, _) :- 	quadrado(Quadrado, Coordx, Coordy, _) ,
													Xnovo is Coordx - 1 ,
													quadrado(Sul, Xnovo, Coordy, _) -> Resultado is Sul ;
													Resultado is 0.

get_quadrado_leste(Quadrado, Leste, Resultado, _) :- 	quadrado(Quadrado, Coordx, Coordy, _) ,
														Ynovo is Coordy + 1 ,
														quadrado(Leste, Coordx, Ynovo, _) -> Resultado is Leste ;
														Resultado is 0.

get_quadrado_oeste(Quadrado, Oeste, Resultado, _) :- 	quadrado(Quadrado, Coordx, Coordy, _) ,
														Ynovo is Coordy - 1 ,
														quadrado(Oeste, Coordx, Ynovo, _) -> Resultado is Oeste ;
														Resultado is 0.

get_quadrados_adjacentes(QuadradoAtual, Norte, Sul, Leste, Oeste) :- 	get_quadrado_norte(QuadradoAtual, _, Norte, _) ,
																		get_quadrado_sul(QuadradoAtual, _, Sul, _) ,
																		get_quadrado_oeste(QuadradoAtual, _, Oeste, _) ,
																		get_quadrado_leste(QuadradoAtual, _, Leste, _).

get_terreno(Quadrado, Terreno) :- quadrado(Quadrado, _, _, Terreno).


astar(Start,Final,_,Tp, Caminho):-	estimation(Start,Final,E),
      								astar1([(E,E,0,[Start])],Final,_,Tp,Caminho).

astar1([(_,_,Tp,[Final|R])|_],Final,[Final|R],Tp,Caminho):- 	reverse([Final|R],L3),
																write('Path = '),
																write(L3),
																Caminho = L3.

astar1([(_,_,P,[X|R1])|R2],Final,C,Tp,Caminho):-	findall(
														(NewSum,E1,NP,[Z,X|R1]),
															(
																caminho(X,Z,V),
																get_terreno(Z, TerrenoZ) ,
																pode_mover(TerrenoZ, Pode) , Pode = 'sim' ,
												               	not(member(Z,R1)),
												               	NP is P+V,
												               	estimation(Z,Final,E1),
												               	NewSum is E1+NP
												            ),
												        L),
													append(R2,L,R3),
													sort(R3,R4),
													astar1(R4,Final,C,Tp,Caminho).

estimation(C1,C2,Est):- 	quadrado(C1,X1,Y1, _),
							quadrado(C2,X2,Y2, _), 
							DX is X1-X2,
							DY is Y1-Y2, 
	                     	Est is sqrt(DX*DX+DY*DY).


quadrado(1, 0, 0, 'montanha').
quadrado(2, 0, 1, 'montanha').
quadrado(3, 0, 2, 'montanha').
quadrado(4, 0, 3, 'montanha').
quadrado(5, 0, 4, 'grama').
quadrado(6, 0, 5, 'grama').
quadrado(7, 0, 6, 'grama').
quadrado(8, 0, 7, 'grama').
quadrado(9, 0, 8, 'grama').
quadrado(10, 0, 9, 'montanha').
quadrado(11, 0, 10, 'montanha').
quadrado(12, 0, 11, 'montanha').
quadrado(13, 0, 12, 'montanha').
quadrado(14, 0, 13, 'grama').
quadrado(15, 0, 14, 'grama').
quadrado(16, 0, 15, 'grama').
quadrado(17, 0, 16, 'grama').
quadrado(18, 0, 17, 'grama').
quadrado(19, 0, 18, 'grama').
quadrado(20, 0, 19, 'grama').
quadrado(21, 0, 20, 'montanha').
quadrado(22, 0, 21, 'montanha').
quadrado(23, 0, 22, 'montanha').
quadrado(24, 0, 23, 'montanha').
quadrado(25, 0, 24, 'montanha').
quadrado(26, 0, 25, 'grama').
quadrado(27, 0, 26, 'grama').
quadrado(28, 0, 27, 'montanha').
quadrado(29, 0, 28, 'grama').
quadrado(30, 0, 29, 'grama').
quadrado(31, 0, 30, 'grama').
quadrado(32, 0, 31, 'grama').
quadrado(33, 0, 32, 'grama').
quadrado(34, 0, 33, 'grama').
quadrado(35, 0, 34, 'grama').
quadrado(36, 0, 35, 'grama').
quadrado(37, 0, 36, 'montanha').
quadrado(38, 0, 37, 'montanha').
quadrado(39, 0, 38, 'montanha').
quadrado(40, 0, 39, 'montanha').
quadrado(41, 0, 40, 'montanha').
quadrado(42, 0, 41, 'montanha').
quadrado(43, 1, 0, 'grama').
quadrado(44, 1, 1, 'grama').
quadrado(45, 1, 2, 'grama').
quadrado(46, 1, 3, 'montanha').
quadrado(47, 1, 4, 'montanha').
quadrado(48, 1, 5, 'montanha').
quadrado(49, 1, 6, 'montanha').
quadrado(50, 1, 7, 'montanha').
quadrado(51, 1, 8, 'grama').
quadrado(52, 1, 9, 'grama').
quadrado(53, 1, 10, 'montanha').
quadrado(54, 1, 11, 'montanha').
quadrado(55, 1, 12, 'grama').
quadrado(56, 1, 13, 'grama').
quadrado(57, 1, 14, 'montanha').
quadrado(58, 1, 15, 'montanha').
quadrado(59, 1, 16, 'montanha').
quadrado(60, 1, 17, 'grama').
quadrado(61, 1, 18, 'grama').
quadrado(62, 1, 19, 'grama').
quadrado(63, 1, 20, 'montanha').
quadrado(64, 1, 21, 'grama').
quadrado(65, 1, 22, 'grama').
quadrado(66, 1, 23, 'grama').
quadrado(67, 1, 24, 'grama').
quadrado(68, 1, 25, 'grama').
quadrado(69, 1, 26, 'grama').
quadrado(70, 1, 27, 'montanha').
quadrado(71, 1, 28, 'grama').
quadrado(72, 1, 29, 'grama').
quadrado(73, 1, 30, 'grama').
quadrado(74, 1, 31, 'grama').
quadrado(75, 1, 32, 'grama').
quadrado(76, 1, 33, 'grama').
quadrado(77, 1, 34, 'montanha').
quadrado(78, 1, 35, 'montanha').
quadrado(79, 1, 36, 'montanha').
quadrado(80, 1, 37, 'grama').
quadrado(81, 1, 38, 'grama').
quadrado(82, 1, 39, 'grama').
quadrado(83, 1, 40, 'grama').
quadrado(84, 1, 41, 'grama').
quadrado(85, 2, 0, 'grama').
quadrado(86, 2, 1, 'montanha').
quadrado(87, 2, 2, 'grama').
quadrado(88, 2, 3, 'grama').
quadrado(89, 2, 4, 'grama').
quadrado(90, 2, 5, 'montanha').
quadrado(91, 2, 6, 'grama').
quadrado(92, 2, 7, 'grama').
quadrado(93, 2, 8, 'grama').
quadrado(94, 2, 9, 'grama').
quadrado(95, 2, 10, 'grama').
quadrado(96, 2, 11, 'grama').
quadrado(97, 2, 12, 'grama').
quadrado(98, 2, 13, 'montanha').
quadrado(99, 2, 14, 'montanha').
quadrado(100, 2, 15, 'montanha').
quadrado(101, 2, 16, 'montanha').
quadrado(102, 2, 17, 'montanha').
quadrado(103, 2, 18, 'grama').
quadrado(104, 2, 19, 'grama').
quadrado(105, 2, 20, 'montanha').
quadrado(106, 2, 21, 'grama').
quadrado(107, 2, 22, 'montanha').
quadrado(108, 2, 23, 'montanha').
quadrado(109, 2, 24, 'montanha').
quadrado(110, 2, 25, 'montanha').
quadrado(111, 2, 26, 'grama').
quadrado(112, 2, 27, 'montanha').
quadrado(113, 2, 28, 'grama').
quadrado(114, 2, 29, 'montanha').
quadrado(115, 2, 30, 'montanha').
quadrado(116, 2, 31, 'montanha').
quadrado(117, 2, 32, 'montanha').
quadrado(118, 2, 33, 'grama').
quadrado(119, 2, 34, 'grama').
quadrado(120, 2, 35, 'grama').
quadrado(121, 2, 36, 'montanha').
quadrado(122, 2, 37, 'grama').
quadrado(123, 2, 38, 'montanha').
quadrado(124, 2, 39, 'grama').
quadrado(125, 2, 40, 'montanha').
quadrado(126, 2, 41, 'grama').
quadrado(127, 3, 0, 'grama').
quadrado(128, 3, 1, 'montanha').
quadrado(129, 3, 2, 'grama').
quadrado(130, 3, 3, 'montanha').
quadrado(131, 3, 4, 'grama').
quadrado(132, 3, 5, 'montanha').
quadrado(133, 3, 6, 'grama').
quadrado(134, 3, 7, 'montanha').
quadrado(135, 3, 8, 'grama').
quadrado(136, 3, 9, 'grama').
quadrado(137, 3, 10, 'montanha').
quadrado(138, 3, 11, 'montanha').
quadrado(139, 3, 12, 'grama').
quadrado(140, 3, 13, 'grama').
quadrado(141, 3, 14, 'montanha').
quadrado(142, 3, 15, 'montanha').
quadrado(143, 3, 16, 'montanha').
quadrado(144, 3, 17, 'grama').
quadrado(145, 3, 18, 'grama').
quadrado(146, 3, 19, 'grama').
quadrado(147, 3, 20, 'montanha').
quadrado(148, 3, 21, 'grama').
quadrado(149, 3, 22, 'grama').
quadrado(150, 3, 23, 'grama').
quadrado(151, 3, 24, 'grama').
quadrado(152, 3, 25, 'grama').
quadrado(153, 3, 26, 'grama').
quadrado(154, 3, 27, 'montanha').
quadrado(155, 3, 28, 'grama').
quadrado(156, 3, 29, 'grama').
quadrado(157, 3, 30, 'grama').
quadrado(158, 3, 31, 'grama').
quadrado(159, 3, 32, 'grama').
quadrado(160, 3, 33, 'grama').
quadrado(161, 3, 34, 'grama').
quadrado(162, 3, 35, 'grama').
quadrado(163, 3, 36, 'montanha').
quadrado(164, 3, 37, 'grama').
quadrado(165, 3, 38, 'montanha').
quadrado(166, 3, 39, 'grama').
quadrado(167, 3, 40, 'montanha').
quadrado(168, 3, 41, 'grama').
quadrado(169, 4, 0, 'grama').
quadrado(170, 4, 1, 'montanha').
quadrado(171, 4, 2, 'grama').
quadrado(172, 4, 3, 'montanha').
quadrado(173, 4, 4, 'grama').
quadrado(174, 4, 5, 'grama').
quadrado(175, 4, 6, 'grama').
quadrado(176, 4, 7, 'montanha').
quadrado(177, 4, 8, 'grama').
quadrado(178, 4, 9, 'montanha').
quadrado(179, 4, 10, 'montanha').
quadrado(180, 4, 11, 'montanha').
quadrado(181, 4, 12, 'montanha').
quadrado(182, 4, 13, 'grama').
quadrado(183, 4, 14, 'grama').
quadrado(184, 4, 15, 'grama').
quadrado(185, 4, 16, 'grama').
quadrado(186, 4, 17, 'grama').
quadrado(187, 4, 18, 'montanha').
quadrado(188, 4, 19, 'montanha').
quadrado(189, 4, 20, 'montanha').
quadrado(190, 4, 21, 'grama').
quadrado(191, 4, 22, 'montanha').
quadrado(192, 4, 23, 'grama').
quadrado(193, 4, 24, 'grama').
quadrado(194, 4, 25, 'grama').
quadrado(195, 4, 26, 'grama').
quadrado(196, 4, 27, 'grama').
quadrado(197, 4, 28, 'grama').
quadrado(198, 4, 29, 'grama').
quadrado(199, 4, 30, 'grama').
quadrado(200, 4, 31, 'montanha').
quadrado(201, 4, 32, 'grama').
quadrado(202, 4, 33, 'montanha').
quadrado(203, 4, 34, 'grama').
quadrado(204, 4, 35, 'grama').
quadrado(205, 4, 36, 'grama').
quadrado(206, 4, 37, 'grama').
quadrado(207, 4, 38, 'montanha').
quadrado(208, 4, 39, 'grama').
quadrado(209, 4, 40, 'montanha').
quadrado(210, 4, 41, 'grama').
quadrado(211, 5, 0, 'grama').
quadrado(212, 5, 1, 'grama').
quadrado(213, 5, 2, 'grama').
quadrado(214, 5, 3, 'montanha').
quadrado(215, 5, 4, 'grama').
quadrado(216, 5, 5, 'grama').
quadrado(217, 5, 6, 'grama').
quadrado(218, 5, 7, 'montanha').
quadrado(219, 5, 8, 'grama').
quadrado(220, 5, 9, 'grama').
quadrado(221, 5, 10, 'montanha').
quadrado(222, 5, 11, 'montanha').
quadrado(223, 5, 12, 'grama').
quadrado(224, 5, 13, 'grama').
quadrado(225, 5, 14, 'grama').
quadrado(226, 5, 15, 'montanha').
quadrado(227, 5, 16, 'grama').
quadrado(228, 5, 17, 'grama').
quadrado(229, 5, 18, 'grama').
quadrado(230, 5, 19, 'grama').
quadrado(231, 5, 20, 'grama').
quadrado(232, 5, 21, 'grama').
quadrado(233, 5, 22, 'montanha').
quadrado(234, 5, 23, 'montanha').
quadrado(235, 5, 24, 'montanha').
quadrado(236, 5, 25, 'montanha').
quadrado(237, 5, 26, 'montanha').
quadrado(238, 5, 27, 'montanha').
quadrado(239, 5, 28, 'grama').
quadrado(240, 5, 29, 'grama').
quadrado(241, 5, 30, 'grama').
quadrado(242, 5, 31, 'montanha').
quadrado(243, 5, 32, 'grama').
quadrado(244, 5, 33, 'grama').
quadrado(245, 5, 34, 'grama').
quadrado(246, 5, 35, 'grama').
quadrado(247, 5, 36, 'montanha').
quadrado(248, 5, 37, 'montanha').
quadrado(249, 5, 38, 'montanha').
quadrado(250, 5, 39, 'montanha').
quadrado(251, 5, 40, 'montanha').
quadrado(252, 5, 41, 'montanha').
quadrado(253, 6, 0, 'montanha').
quadrado(254, 6, 1, 'montanha').
quadrado(255, 6, 2, 'montanha').
quadrado(256, 6, 3, 'montanha').
quadrado(257, 6, 4, 'montanha').
quadrado(258, 6, 5, 'montanha').
quadrado(259, 6, 6, 'montanha').
quadrado(260, 6, 7, 'montanha').
quadrado(261, 6, 8, 'grama').
quadrado(262, 6, 9, 'grama').
quadrado(263, 6, 10, 'grama').
quadrado(264, 6, 11, 'grama').
quadrado(265, 6, 12, 'grama').
quadrado(266, 6, 13, 'grama').
quadrado(267, 6, 14, 'grama').
quadrado(268, 6, 15, 'montanha').
quadrado(269, 6, 16, 'montanha').
quadrado(270, 6, 17, 'montanha').
quadrado(271, 6, 18, 'montanha').
quadrado(272, 6, 19, 'montanha').
quadrado(273, 6, 20, 'grama').
quadrado(274, 6, 21, 'grama').
quadrado(275, 6, 22, 'montanha').
quadrado(276, 6, 23, 'grama').
quadrado(277, 6, 24, 'grama').
quadrado(278, 6, 25, 'grama').
quadrado(279, 6, 26, 'grama').
quadrado(280, 6, 27, 'grama').
quadrado(281, 6, 28, 'grama').
quadrado(282, 6, 29, 'grama').
quadrado(283, 6, 30, 'grama').
quadrado(284, 6, 31, 'montanha').
quadrado(285, 6, 32, 'grama').
quadrado(286, 6, 33, 'grama').
quadrado(287, 6, 34, 'montanha').
quadrado(288, 6, 35, 'grama').
quadrado(289, 6, 36, 'grama').
quadrado(290, 6, 37, 'grama').
quadrado(291, 6, 38, 'grama').
quadrado(292, 6, 39, 'grama').
quadrado(293, 6, 40, 'grama').
quadrado(294, 6, 41, 'grama').
quadrado(295, 7, 0, 'grama').
quadrado(296, 7, 1, 'grama').
quadrado(297, 7, 2, 'grama').
quadrado(298, 7, 3, 'grama').
quadrado(299, 7, 4, 'grama').
quadrado(300, 7, 5, 'grama').
quadrado(301, 7, 6, 'grama').
quadrado(302, 7, 7, 'grama').
quadrado(303, 7, 8, 'grama').
quadrado(304, 7, 9, 'grama').
quadrado(305, 7, 10, 'grama').
quadrado(306, 7, 11, 'grama').
quadrado(307, 7, 12, 'montanha').
quadrado(308, 7, 13, 'grama').
quadrado(309, 7, 14, 'grama').
quadrado(310, 7, 15, 'grama').
quadrado(311, 7, 16, 'grama').
quadrado(312, 7, 17, 'grama').
quadrado(313, 7, 18, 'grama').
quadrado(314, 7, 19, 'grama').
quadrado(315, 7, 20, 'grama').
quadrado(316, 7, 21, 'grama').
quadrado(317, 7, 22, 'grama').
quadrado(318, 7, 23, 'grama').
quadrado(319, 7, 24, 'grama').
quadrado(320, 7, 25, 'grama').
quadrado(321, 7, 26, 'montanha').
quadrado(322, 7, 27, 'montanha').
quadrado(323, 7, 28, 'grama').
quadrado(324, 7, 29, 'grama').
quadrado(325, 7, 30, 'grama').
quadrado(326, 7, 31, 'grama').
quadrado(327, 7, 32, 'grama').
quadrado(328, 7, 33, 'grama').
quadrado(329, 7, 34, 'montanha').
quadrado(330, 7, 35, 'grama').
quadrado(331, 7, 36, 'agua').
quadrado(332, 7, 37, 'agua').
quadrado(333, 7, 38, 'agua').
quadrado(334, 7, 39, 'agua').
quadrado(335, 7, 40, 'agua').
quadrado(336, 7, 41, 'agua').
quadrado(337, 8, 0, 'grama').
quadrado(338, 8, 1, 'grama').
quadrado(339, 8, 2, 'grama').
quadrado(340, 8, 3, 'agua').
quadrado(341, 8, 4, 'agua').
quadrado(342, 8, 5, 'agua').
quadrado(343, 8, 6, 'agua').
quadrado(344, 8, 7, 'agua').
quadrado(345, 8, 8, 'grama').
quadrado(346, 8, 9, 'agua').
quadrado(347, 8, 10, 'agua').
quadrado(348, 8, 11, 'agua').
quadrado(349, 8, 12, 'agua').
quadrado(350, 8, 13, 'grama').
quadrado(351, 8, 14, 'montanha').
quadrado(352, 8, 15, 'grama').
quadrado(353, 8, 16, 'montanha').
quadrado(354, 8, 17, 'montanha').
quadrado(355, 8, 18, 'grama').
quadrado(356, 8, 19, 'grama').
quadrado(357, 8, 20, 'grama').
quadrado(358, 8, 21, 'grama').
quadrado(359, 8, 22, 'grama').
quadrado(360, 8, 23, 'grama').
quadrado(361, 8, 24, 'grama').
quadrado(362, 8, 25, 'montanha').
quadrado(363, 8, 26, 'montanha').
quadrado(364, 8, 27, 'montanha').
quadrado(365, 8, 28, 'montanha').
quadrado(366, 8, 29, 'grama').
quadrado(367, 8, 30, 'grama').
quadrado(368, 8, 31, 'montanha').
quadrado(369, 8, 32, 'montanha').
quadrado(370, 8, 33, 'grama').
quadrado(371, 8, 34, 'montanha').
quadrado(372, 8, 35, 'grama').
quadrado(373, 8, 36, 'agua').
quadrado(374, 8, 37, 'grama').
quadrado(375, 8, 38, 'grama').
quadrado(376, 8, 39, 'grama').
quadrado(377, 8, 40, 'grama').
quadrado(378, 8, 41, 'grama').
quadrado(379, 9, 0, 'grama').
quadrado(380, 9, 1, 'grama').
quadrado(381, 9, 2, 'grama').
quadrado(382, 9, 3, 'agua').
quadrado(383, 9, 4, 'grama').
quadrado(384, 9, 5, 'grama').
quadrado(385, 9, 6, 'grama').
quadrado(386, 9, 7, 'grama').
quadrado(387, 9, 8, 'grama').
quadrado(388, 9, 9, 'grama').
quadrado(389, 9, 10, 'grama').
quadrado(390, 9, 11, 'grama').
quadrado(391, 9, 12, 'agua').
quadrado(392, 9, 13, 'grama').
quadrado(393, 9, 14, 'montanha').
quadrado(394, 9, 15, 'grama').
quadrado(395, 9, 16, 'montanha').
quadrado(396, 9, 17, 'montanha').
quadrado(397, 9, 18, 'grama').
quadrado(398, 9, 19, 'grama').
quadrado(399, 9, 20, 'grama').
quadrado(400, 9, 21, 'grama').
quadrado(401, 9, 22, 'grama').
quadrado(402, 9, 23, 'grama').
quadrado(403, 9, 24, 'grama').
quadrado(404, 9, 25, 'grama').
quadrado(405, 9, 26, 'montanha').
quadrado(406, 9, 27, 'montanha').
quadrado(407, 9, 28, 'grama').
quadrado(408, 9, 29, 'grama').
quadrado(409, 9, 30, 'grama').
quadrado(410, 9, 31, 'montanha').
quadrado(411, 9, 32, 'montanha').
quadrado(412, 9, 33, 'grama').
quadrado(413, 9, 34, 'montanha').
quadrado(414, 9, 35, 'grama').
quadrado(415, 9, 36, 'agua').
quadrado(416, 9, 37, 'grama').
quadrado(417, 9, 38, 'montanha').
quadrado(418, 9, 39, 'montanha').
quadrado(419, 9, 40, 'montanha').
quadrado(420, 9, 41, 'grama').
quadrado(421, 10, 0, 'grama').
quadrado(422, 10, 1, 'grama').
quadrado(423, 10, 2, 'grama').
quadrado(424, 10, 3, 'agua').
quadrado(425, 10, 4, 'grama').
quadrado(426, 10, 5, 'grama').
quadrado(427, 10, 6, 'grama').
quadrado(428, 10, 7, 'montanha').
quadrado(429, 10, 8, 'grama').
quadrado(430, 10, 9, 'montanha').
quadrado(431, 10, 10, 'grama').
quadrado(432, 10, 11, 'grama').
quadrado(433, 10, 12, 'agua').
quadrado(434, 10, 13, 'grama').
quadrado(435, 10, 14, 'montanha').
quadrado(436, 10, 15, 'grama').
quadrado(437, 10, 16, 'montanha').
quadrado(438, 10, 17, 'grama').
quadrado(439, 10, 18, 'grama').
quadrado(440, 10, 19, 'grama').
quadrado(441, 10, 20, 'agua').
quadrado(442, 10, 21, 'agua').
quadrado(443, 10, 22, 'agua').
quadrado(444, 10, 23, 'agua').
quadrado(445, 10, 24, 'agua').
quadrado(446, 10, 25, 'grama').
quadrado(447, 10, 26, 'grama').
quadrado(448, 10, 27, 'grama').
quadrado(449, 10, 28, 'grama').
quadrado(450, 10, 29, 'grama').
quadrado(451, 10, 30, 'grama').
quadrado(452, 10, 31, 'grama').
quadrado(453, 10, 32, 'grama').
quadrado(454, 10, 33, 'grama').
quadrado(455, 10, 34, 'grama').
quadrado(456, 10, 35, 'grama').
quadrado(457, 10, 36, 'agua').
quadrado(458, 10, 37, 'grama').
quadrado(459, 10, 38, 'grama').
quadrado(460, 10, 39, 'grama').
quadrado(461, 10, 40, 'montanha').
quadrado(462, 10, 41, 'grama').
quadrado(463, 11, 0, 'agua').
quadrado(464, 11, 1, 'agua').
quadrado(465, 11, 2, 'agua').
quadrado(466, 11, 3, 'agua').
quadrado(467, 11, 4, 'grama').
quadrado(468, 11, 5, 'montanha').
quadrado(469, 11, 6, 'montanha').
quadrado(470, 11, 7, 'montanha').
quadrado(471, 11, 8, 'grama').
quadrado(472, 11, 9, 'montanha').
quadrado(473, 11, 10, 'grama').
quadrado(474, 11, 11, 'grama').
quadrado(475, 11, 12, 'agua').
quadrado(476, 11, 13, 'grama').
quadrado(477, 11, 14, 'grama').
quadrado(478, 11, 15, 'grama').
quadrado(479, 11, 16, 'montanha').
quadrado(480, 11, 17, 'grama').
quadrado(481, 11, 18, 'grama').
quadrado(482, 11, 19, 'agua').
quadrado(483, 11, 20, 'agua').
quadrado(484, 11, 21, 'agua').
quadrado(485, 11, 22, 'agua').
quadrado(486, 11, 23, 'agua').
quadrado(487, 11, 24, 'agua').
quadrado(488, 11, 25, 'agua').
quadrado(489, 11, 26, 'grama').
quadrado(490, 11, 27, 'grama').
quadrado(491, 11, 28, 'grama').
quadrado(492, 11, 29, 'agua').
quadrado(493, 11, 30, 'agua').
quadrado(494, 11, 31, 'agua').
quadrado(495, 11, 32, 'agua').
quadrado(496, 11, 33, 'grama').
quadrado(497, 11, 34, 'agua').
quadrado(498, 11, 35, 'agua').
quadrado(499, 11, 36, 'agua').
quadrado(500, 11, 37, 'grama').
quadrado(501, 11, 38, 'grama').
quadrado(502, 11, 39, 'grama').
quadrado(503, 11, 40, 'montanha').
quadrado(504, 11, 41, 'grama').
quadrado(505, 12, 0, 'grama').
quadrado(506, 12, 1, 'grama').
quadrado(507, 12, 2, 'grama').
quadrado(508, 12, 3, 'grama').
quadrado(509, 12, 4, 'grama').
quadrado(510, 12, 5, 'grama').
quadrado(511, 12, 6, 'grama').
quadrado(512, 12, 7, 'montanha').
quadrado(513, 12, 8, 'grama').
quadrado(514, 12, 9, 'montanha').
quadrado(515, 12, 10, 'grama').
quadrado(516, 12, 11, 'grama').
quadrado(517, 12, 12, 'agua').
quadrado(518, 12, 13, 'grama').
quadrado(519, 12, 14, 'grama').
quadrado(520, 12, 15, 'grama').
quadrado(521, 12, 16, 'grama').
quadrado(522, 12, 17, 'grama').
quadrado(523, 12, 18, 'agua').
quadrado(524, 12, 19, 'agua').
quadrado(525, 12, 20, 'agua').
quadrado(526, 12, 21, 'agua').
quadrado(527, 12, 22, 'agua').
quadrado(528, 12, 23, 'agua').
quadrado(529, 12, 24, 'agua').
quadrado(530, 12, 25, 'agua').
quadrado(531, 12, 26, 'agua').
quadrado(532, 12, 27, 'grama').
quadrado(533, 12, 28, 'grama').
quadrado(534, 12, 29, 'agua').
quadrado(535, 12, 30, 'grama').
quadrado(536, 12, 31, 'grama').
quadrado(537, 12, 32, 'grama').
quadrado(538, 12, 33, 'grama').
quadrado(539, 12, 34, 'grama').
quadrado(540, 12, 35, 'grama').
quadrado(541, 12, 36, 'grama').
quadrado(542, 12, 37, 'grama').
quadrado(543, 12, 38, 'montanha').
quadrado(544, 12, 39, 'montanha').
quadrado(545, 12, 40, 'montanha').
quadrado(546, 12, 41, 'grama').
quadrado(547, 13, 0, 'grama').
quadrado(548, 13, 1, 'grama').
quadrado(549, 13, 2, 'grama').
quadrado(550, 13, 3, 'grama').
quadrado(551, 13, 4, 'grama').
quadrado(552, 13, 5, 'grama').
quadrado(553, 13, 6, 'grama').
quadrado(554, 13, 7, 'grama').
quadrado(555, 13, 8, 'grama').
quadrado(556, 13, 9, 'montanha').
quadrado(557, 13, 10, 'grama').
quadrado(558, 13, 11, 'grama').
quadrado(559, 13, 12, 'agua').
quadrado(560, 13, 13, 'grama').
quadrado(561, 13, 14, 'grama').
quadrado(562, 13, 15, 'grama').
quadrado(563, 13, 16, 'grama').
quadrado(564, 13, 17, 'grama').
quadrado(565, 13, 18, 'agua').
quadrado(566, 13, 19, 'agua').
quadrado(567, 13, 20, 'agua').
quadrado(568, 13, 21, 'grama').
quadrado(569, 13, 22, 'grama').
quadrado(570, 13, 23, 'grama').
quadrado(571, 13, 24, 'agua').
quadrado(572, 13, 25, 'agua').
quadrado(573, 13, 26, 'agua').
quadrado(574, 13, 27, 'grama').
quadrado(575, 13, 28, 'grama').
quadrado(576, 13, 29, 'agua').
quadrado(577, 13, 30, 'grama').
quadrado(578, 13, 31, 'montanha').
quadrado(579, 13, 32, 'montanha').
quadrado(580, 13, 33, 'grama').
quadrado(581, 13, 34, 'montanha').
quadrado(582, 13, 35, 'montanha').
quadrado(583, 13, 36, 'grama').
quadrado(584, 13, 37, 'grama').
quadrado(585, 13, 38, 'grama').
quadrado(586, 13, 39, 'grama').
quadrado(587, 13, 40, 'grama').
quadrado(588, 13, 41, 'grama').
quadrado(589, 14, 0, 'montanha').
quadrado(590, 14, 1, 'grama').
quadrado(591, 14, 2, 'montanha').
quadrado(592, 14, 3, 'montanha').
quadrado(593, 14, 4, 'montanha').
quadrado(594, 14, 5, 'montanha').
quadrado(595, 14, 6, 'montanha').
quadrado(596, 14, 7, 'montanha').
quadrado(597, 14, 8, 'grama').
quadrado(598, 14, 9, 'montanha').
quadrado(599, 14, 10, 'montanha').
quadrado(600, 14, 11, 'montanha').
quadrado(601, 14, 12, 'agua').
quadrado(602, 14, 13, 'agua').
quadrado(603, 14, 14, 'agua').
quadrado(604, 14, 15, 'agua').
quadrado(605, 14, 16, 'agua').
quadrado(606, 14, 17, 'agua').
quadrado(607, 14, 18, 'agua').
quadrado(608, 14, 19, 'agua').
quadrado(609, 14, 20, 'agua').
quadrado(610, 14, 21, 'grama').
quadrado(611, 14, 22, 'grama').
quadrado(612, 14, 23, 'grama').
quadrado(613, 14, 24, 'agua').
quadrado(614, 14, 25, 'agua').
quadrado(615, 14, 26, 'agua').
quadrado(616, 14, 27, 'agua').
quadrado(617, 14, 28, 'agua').
quadrado(618, 14, 29, 'agua').
quadrado(619, 14, 30, 'grama').
quadrado(620, 14, 31, 'montanha').
quadrado(621, 14, 32, 'montanha').
quadrado(622, 14, 33, 'grama').
quadrado(623, 14, 34, 'montanha').
quadrado(624, 14, 35, 'montanha').
quadrado(625, 14, 36, 'grama').
quadrado(626, 14, 37, 'grama').
quadrado(627, 14, 38, 'montanha').
quadrado(628, 14, 39, 'montanha').
quadrado(629, 14, 40, 'grama').
quadrado(630, 14, 41, 'grama').
quadrado(631, 15, 0, 'montanha').
quadrado(632, 15, 1, 'grama').
quadrado(633, 15, 2, 'montanha').
quadrado(634, 15, 3, 'grama').
quadrado(635, 15, 4, 'grama').
quadrado(636, 15, 5, 'grama').
quadrado(637, 15, 6, 'grama').
quadrado(638, 15, 7, 'montanha').
quadrado(639, 15, 8, 'grama').
quadrado(640, 15, 9, 'grama').
quadrado(641, 15, 10, 'grama').
quadrado(642, 15, 11, 'grama').
quadrado(643, 15, 12, 'grama').
quadrado(644, 15, 13, 'grama').
quadrado(645, 15, 14, 'grama').
quadrado(646, 15, 15, 'grama').
quadrado(647, 15, 16, 'grama').
quadrado(648, 15, 17, 'grama').
quadrado(649, 15, 18, 'agua').
quadrado(650, 15, 19, 'agua').
quadrado(651, 15, 20, 'agua').
quadrado(652, 15, 21, 'grama').
quadrado(653, 15, 22, 'grama').
quadrado(654, 15, 23, 'grama').
quadrado(655, 15, 24, 'agua').
quadrado(656, 15, 25, 'agua').
quadrado(657, 15, 26, 'agua').
quadrado(658, 15, 27, 'grama').
quadrado(659, 15, 28, 'grama').
quadrado(660, 15, 29, 'grama').
quadrado(661, 15, 30, 'grama').
quadrado(662, 15, 31, 'grama').
quadrado(663, 15, 32, 'grama').
quadrado(664, 15, 33, 'grama').
quadrado(665, 15, 34, 'grama').
quadrado(666, 15, 35, 'grama').
quadrado(667, 15, 36, 'grama').
quadrado(668, 15, 37, 'montanha').
quadrado(669, 15, 38, 'montanha').
quadrado(670, 15, 39, 'montanha').
quadrado(671, 15, 40, 'montanha').
quadrado(672, 15, 41, 'grama').
quadrado(673, 16, 0, 'montanha').
quadrado(674, 16, 1, 'grama').
quadrado(675, 16, 2, 'montanha').
quadrado(676, 16, 3, 'grama').
quadrado(677, 16, 4, 'montanha').
quadrado(678, 16, 5, 'montanha').
quadrado(679, 16, 6, 'grama').
quadrado(680, 16, 7, 'montanha').
quadrado(681, 16, 8, 'grama').
quadrado(682, 16, 9, 'montanha').
quadrado(683, 16, 10, 'montanha').
quadrado(684, 16, 11, 'grama').
quadrado(685, 16, 12, 'grama').
quadrado(686, 16, 13, 'montanha').
quadrado(687, 16, 14, 'montanha').
quadrado(688, 16, 15, 'grama').
quadrado(689, 16, 16, 'grama').
quadrado(690, 16, 17, 'grama').
quadrado(691, 16, 18, 'agua').
quadrado(692, 16, 19, 'agua').
quadrado(693, 16, 20, 'agua').
quadrado(694, 16, 21, 'agua').
quadrado(695, 16, 22, 'agua').
quadrado(696, 16, 23, 'agua').
quadrado(697, 16, 24, 'agua').
quadrado(698, 16, 25, 'agua').
quadrado(699, 16, 26, 'agua').
quadrado(700, 16, 27, 'grama').
quadrado(701, 16, 28, 'montanha').
quadrado(702, 16, 29, 'montanha').
quadrado(703, 16, 30, 'montanha').
quadrado(704, 16, 31, 'montanha').
quadrado(705, 16, 32, 'montanha').
quadrado(706, 16, 33, 'grama').
quadrado(707, 16, 34, 'grama').
quadrado(708, 16, 35, 'grama').
quadrado(709, 16, 36, 'grama').
quadrado(710, 16, 37, 'montanha').
quadrado(711, 16, 38, 'montanha').
quadrado(712, 16, 39, 'montanha').
quadrado(713, 16, 40, 'montanha').
quadrado(714, 16, 41, 'montanha').
quadrado(715, 17, 0, 'montanha').
quadrado(716, 17, 1, 'grama').
quadrado(717, 17, 2, 'montanha').
quadrado(718, 17, 3, 'grama').
quadrado(719, 17, 4, 'grama').
quadrado(720, 17, 5, 'montanha').
quadrado(721, 17, 6, 'grama').
quadrado(722, 17, 7, 'montanha').
quadrado(723, 17, 8, 'grama').
quadrado(724, 17, 9, 'montanha').
quadrado(725, 17, 10, 'grama').
quadrado(726, 17, 11, 'grama').
quadrado(727, 17, 12, 'montanha').
quadrado(728, 17, 13, 'montanha').
quadrado(729, 17, 14, 'montanha').
quadrado(730, 17, 15, 'montanha').
quadrado(731, 17, 16, 'grama').
quadrado(732, 17, 17, 'grama').
quadrado(733, 17, 18, 'grama').
quadrado(734, 17, 19, 'agua').
quadrado(735, 17, 20, 'agua').
quadrado(736, 17, 21, 'agua').
quadrado(737, 17, 22, 'agua').
quadrado(738, 17, 23, 'agua').
quadrado(739, 17, 24, 'agua').
quadrado(740, 17, 25, 'agua').
quadrado(741, 17, 26, 'grama').
quadrado(742, 17, 27, 'grama').
quadrado(743, 17, 28, 'grama').
quadrado(744, 17, 29, 'grama').
quadrado(745, 17, 30, 'montanha').
quadrado(746, 17, 31, 'grama').
quadrado(747, 17, 32, 'grama').
quadrado(748, 17, 33, 'grama').
quadrado(749, 17, 34, 'grama').
quadrado(750, 17, 35, 'grama').
quadrado(751, 17, 36, 'montanha').
quadrado(752, 17, 37, 'montanha').
quadrado(753, 17, 38, 'montanha').
quadrado(754, 17, 39, 'montanha').
quadrado(755, 17, 40, 'montanha').
quadrado(756, 17, 41, 'montanha').
quadrado(757, 18, 0, 'montanha').
quadrado(758, 18, 1, 'grama').
quadrado(759, 18, 2, 'montanha').
quadrado(760, 18, 3, 'grama').
quadrado(761, 18, 4, 'grama').
quadrado(762, 18, 5, 'montanha').
quadrado(763, 18, 6, 'grama').
quadrado(764, 18, 7, 'montanha').
quadrado(765, 18, 8, 'grama').
quadrado(766, 18, 9, 'montanha').
quadrado(767, 18, 10, 'grama').
quadrado(768, 18, 11, 'montanha').
quadrado(769, 18, 12, 'montanha').
quadrado(770, 18, 13, 'montanha').
quadrado(771, 18, 14, 'montanha').
quadrado(772, 18, 15, 'montanha').
quadrado(773, 18, 16, 'montanha').
quadrado(774, 18, 17, 'grama').
quadrado(775, 18, 18, 'grama').
quadrado(776, 18, 19, 'grama').
quadrado(777, 18, 20, 'agua').
quadrado(778, 18, 21, 'agua').
quadrado(779, 18, 22, 'agua').
quadrado(780, 18, 23, 'agua').
quadrado(781, 18, 24, 'agua').
quadrado(782, 18, 25, 'grama').
quadrado(783, 18, 26, 'grama').
quadrado(784, 18, 27, 'grama').
quadrado(785, 18, 28, 'grama').
quadrado(786, 18, 29, 'grama').
quadrado(787, 18, 30, 'montanha').
quadrado(788, 18, 31, 'grama').
quadrado(789, 18, 32, 'grama').
quadrado(790, 18, 33, 'montanha').
quadrado(791, 18, 34, 'grama').
quadrado(792, 18, 35, 'grama').
quadrado(793, 18, 36, 'montanha').
quadrado(794, 18, 37, 'montanha').
quadrado(795, 18, 38, 'montanha').
quadrado(796, 18, 39, 'montanha').
quadrado(797, 18, 40, 'montanha').
quadrado(798, 18, 41, 'montanha').
quadrado(799, 19, 0, 'montanha').
quadrado(800, 19, 1, 'grama').
quadrado(801, 19, 2, 'montanha').
quadrado(802, 19, 3, 'grama').
quadrado(803, 19, 4, 'grama').
quadrado(804, 19, 5, 'montanha').
quadrado(805, 19, 6, 'grama').
quadrado(806, 19, 7, 'montanha').
quadrado(807, 19, 8, 'grama').
quadrado(808, 19, 9, 'montanha').
quadrado(809, 19, 10, 'grama').
quadrado(810, 19, 11, 'montanha').
quadrado(811, 19, 12, 'montanha').
quadrado(812, 19, 13, 'montanha').
quadrado(813, 19, 14, 'montanha').
quadrado(814, 19, 15, 'montanha').
quadrado(815, 19, 16, 'montanha').
quadrado(816, 19, 17, 'grama').
quadrado(817, 19, 18, 'grama').
quadrado(818, 19, 19, 'grama').
quadrado(819, 19, 20, 'grama').
quadrado(820, 19, 21, 'grama').
quadrado(821, 19, 22, 'grama').
quadrado(822, 19, 23, 'grama').
quadrado(823, 19, 24, 'grama').
quadrado(824, 19, 25, 'grama').
quadrado(825, 19, 26, 'montanha').
quadrado(826, 19, 27, 'montanha').
quadrado(827, 19, 28, 'montanha').
quadrado(828, 19, 29, 'montanha').
quadrado(829, 19, 30, 'montanha').
quadrado(830, 19, 31, 'grama').
quadrado(831, 19, 32, 'montanha').
quadrado(832, 19, 33, 'montanha').
quadrado(833, 19, 34, 'montanha').
quadrado(834, 19, 35, 'grama').
quadrado(835, 19, 36, 'montanha').
quadrado(836, 19, 37, 'montanha').
quadrado(837, 19, 38, 'montanha').
quadrado(838, 19, 39, 'montanha').
quadrado(839, 19, 40, 'montanha').
quadrado(840, 19, 41, 'montanha').
quadrado(841, 20, 0, 'montanha').
quadrado(842, 20, 1, 'grama').
quadrado(843, 20, 2, 'montanha').
quadrado(844, 20, 3, 'grama').
quadrado(845, 20, 4, 'grama').
quadrado(846, 20, 5, 'montanha').
quadrado(847, 20, 6, 'grama').
quadrado(848, 20, 7, 'montanha').
quadrado(849, 20, 8, 'grama').
quadrado(850, 20, 9, 'grama').
quadrado(851, 20, 10, 'grama').
quadrado(852, 20, 11, 'grama').
quadrado(853, 20, 12, 'montanha').
quadrado(854, 20, 13, 'montanha').
quadrado(855, 20, 14, 'montanha').
quadrado(856, 20, 15, 'montanha').
quadrado(857, 20, 16, 'grama').
quadrado(858, 20, 17, 'grama').
quadrado(859, 20, 18, 'grama').
quadrado(860, 20, 19, 'grama').
quadrado(861, 20, 20, 'montanha').
quadrado(862, 20, 21, 'montanha').
quadrado(863, 20, 22, 'montanha').
quadrado(864, 20, 23, 'grama').
quadrado(865, 20, 24, 'grama').
quadrado(866, 20, 25, 'grama').
quadrado(867, 20, 26, 'grama').
quadrado(868, 20, 27, 'grama').
quadrado(869, 20, 28, 'grama').
quadrado(870, 20, 29, 'grama').
quadrado(871, 20, 30, 'montanha').
quadrado(872, 20, 31, 'grama').
quadrado(873, 20, 32, 'grama').
quadrado(874, 20, 33, 'montanha').
quadrado(875, 20, 34, 'grama').
quadrado(876, 20, 35, 'grama').
quadrado(877, 20, 36, 'montanha').
quadrado(878, 20, 37, 'montanha').
quadrado(879, 20, 38, 'montanha').
quadrado(880, 20, 39, 'montanha').
quadrado(881, 20, 40, 'montanha').
quadrado(882, 20, 41, 'montanha').
quadrado(883, 21, 0, 'montanha').
quadrado(884, 21, 1, 'grama').
quadrado(885, 21, 2, 'montanha').
quadrado(886, 21, 3, 'montanha').
quadrado(887, 21, 4, 'montanha').
quadrado(888, 21, 5, 'montanha').
quadrado(889, 21, 6, 'grama').
quadrado(890, 21, 7, 'montanha').
quadrado(891, 21, 8, 'grama').
quadrado(892, 21, 9, 'montanha').
quadrado(893, 21, 10, 'grama').
quadrado(894, 21, 11, 'grama').
quadrado(895, 21, 12, 'grama').
quadrado(896, 21, 13, 'montanha').
quadrado(897, 21, 14, 'montanha').
quadrado(898, 21, 15, 'grama').
quadrado(899, 21, 16, 'grama').
quadrado(900, 21, 17, 'montanha').
quadrado(901, 21, 18, 'grama').
quadrado(902, 21, 19, 'montanha').
quadrado(903, 21, 20, 'montanha').
quadrado(904, 21, 21, 'montanha').
quadrado(905, 21, 22, 'montanha').
quadrado(906, 21, 23, 'montanha').
quadrado(907, 21, 24, 'grama').
quadrado(908, 21, 25, 'montanha').
quadrado(909, 21, 26, 'grama').
quadrado(910, 21, 27, 'grama').
quadrado(911, 21, 28, 'grama').
quadrado(912, 21, 29, 'grama').
quadrado(913, 21, 30, 'grama').
quadrado(914, 21, 31, 'grama').
quadrado(915, 21, 32, 'grama').
quadrado(916, 21, 33, 'grama').
quadrado(917, 21, 34, 'grama').
quadrado(918, 21, 35, 'grama').
quadrado(919, 21, 36, 'montanha').
quadrado(920, 21, 37, 'montanha').
quadrado(921, 21, 38, 'montanha').
quadrado(922, 21, 39, 'montanha').
quadrado(923, 21, 40, 'montanha').
quadrado(924, 21, 41, 'montanha').
quadrado(925, 22, 0, 'montanha').
quadrado(926, 22, 1, 'grama').
quadrado(927, 22, 2, 'grama').
quadrado(928, 22, 3, 'grama').
quadrado(929, 22, 4, 'grama').
quadrado(930, 22, 5, 'grama').
quadrado(931, 22, 6, 'grama').
quadrado(932, 22, 7, 'montanha').
quadrado(933, 22, 8, 'grama').
quadrado(934, 22, 9, 'montanha').
quadrado(935, 22, 10, 'grama').
quadrado(936, 22, 11, 'montanha').
quadrado(937, 22, 12, 'grama').
quadrado(938, 22, 13, 'grama').
quadrado(939, 22, 14, 'grama').
quadrado(940, 22, 15, 'grama').
quadrado(941, 22, 16, 'grama').
quadrado(942, 22, 17, 'montanha').
quadrado(943, 22, 18, 'grama').
quadrado(944, 22, 19, 'grama').
quadrado(945, 22, 20, 'montanha').
quadrado(946, 22, 21, 'montanha').
quadrado(947, 22, 22, 'montanha').
quadrado(948, 22, 23, 'grama').
quadrado(949, 22, 24, 'grama').
quadrado(950, 22, 25, 'montanha').
quadrado(951, 22, 26, 'grama').
quadrado(952, 22, 27, 'grama').
quadrado(953, 22, 28, 'montanha').
quadrado(954, 22, 29, 'montanha').
quadrado(955, 22, 30, 'grama').
quadrado(956, 22, 31, 'grama').
quadrado(957, 22, 32, 'grama').
quadrado(958, 22, 33, 'grama').
quadrado(959, 22, 34, 'montanha').
quadrado(960, 22, 35, 'grama').
quadrado(961, 22, 36, 'grama').
quadrado(962, 22, 37, 'montanha').
quadrado(963, 22, 38, 'montanha').
quadrado(964, 22, 39, 'montanha').
quadrado(965, 22, 40, 'montanha').
quadrado(966, 22, 41, 'montanha').
quadrado(967, 23, 0, 'montanha').
quadrado(968, 23, 1, 'grama').
quadrado(969, 23, 2, 'montanha').
quadrado(970, 23, 3, 'montanha').
quadrado(971, 23, 4, 'montanha').
quadrado(972, 23, 5, 'montanha').
quadrado(973, 23, 6, 'montanha').
quadrado(974, 23, 7, 'montanha').
quadrado(975, 23, 8, 'grama').
quadrado(976, 23, 9, 'montanha').
quadrado(977, 23, 10, 'grama').
quadrado(978, 23, 11, 'montanha').
quadrado(979, 23, 12, 'grama').
quadrado(980, 23, 13, 'grama').
quadrado(981, 23, 14, 'grama').
quadrado(982, 23, 15, 'grama').
quadrado(983, 23, 16, 'grama').
quadrado(984, 23, 17, 'montanha').
quadrado(985, 23, 18, 'grama').
quadrado(986, 23, 19, 'grama').
quadrado(987, 23, 20, 'grama').
quadrado(988, 23, 21, 'grama').
quadrado(989, 23, 22, 'grama').
quadrado(990, 23, 23, 'grama').
quadrado(991, 23, 24, 'grama').
quadrado(992, 23, 25, 'montanha').
quadrado(993, 23, 26, 'grama').
quadrado(994, 23, 27, 'montanha').
quadrado(995, 23, 28, 'montanha').
quadrado(996, 23, 29, 'montanha').
quadrado(997, 23, 30, 'montanha').
quadrado(998, 23, 31, 'grama').
quadrado(999, 23, 32, 'grama').
quadrado(1000, 23, 33, 'grama').
quadrado(1001, 23, 34, 'grama').
quadrado(1002, 23, 35, 'grama').
quadrado(1003, 23, 36, 'grama').
quadrado(1004, 23, 37, 'montanha').
quadrado(1005, 23, 38, 'montanha').
quadrado(1006, 23, 39, 'montanha').
quadrado(1007, 23, 40, 'montanha').
quadrado(1008, 23, 41, 'grama').
quadrado(1009, 24, 0, 'grama').
quadrado(1010, 24, 1, 'grama').
quadrado(1011, 24, 2, 'grama').
quadrado(1012, 24, 3, 'grama').
quadrado(1013, 24, 4, 'grama').
quadrado(1014, 24, 5, 'grama').
quadrado(1015, 24, 6, 'grama').
quadrado(1016, 24, 7, 'grama').
quadrado(1017, 24, 8, 'grama').
quadrado(1018, 24, 9, 'montanha').
quadrado(1019, 24, 10, 'grama').
quadrado(1020, 24, 11, 'montanha').
quadrado(1021, 24, 12, 'montanha').
quadrado(1022, 24, 13, 'montanha').
quadrado(1023, 24, 14, 'montanha').
quadrado(1024, 24, 15, 'montanha').
quadrado(1025, 24, 16, 'grama').
quadrado(1026, 24, 17, 'grama').
quadrado(1027, 24, 18, 'grama').
quadrado(1028, 24, 19, 'grama').
quadrado(1029, 24, 20, 'grama').
quadrado(1030, 24, 21, 'grama').
quadrado(1031, 24, 22, 'grama').
quadrado(1032, 24, 23, 'grama').
quadrado(1033, 24, 24, 'grama').
quadrado(1034, 24, 25, 'grama').
quadrado(1035, 24, 26, 'grama').
quadrado(1036, 24, 27, 'montanha').
quadrado(1037, 24, 28, 'montanha').
quadrado(1038, 24, 29, 'montanha').
quadrado(1039, 24, 30, 'montanha').
quadrado(1040, 24, 31, 'montanha').
quadrado(1041, 24, 32, 'grama').
quadrado(1042, 24, 33, 'montanha').
quadrado(1043, 24, 34, 'grama').
quadrado(1044, 24, 35, 'grama').
quadrado(1045, 24, 36, 'grama').
quadrado(1046, 24, 37, 'grama').
quadrado(1047, 24, 38, 'montanha').
quadrado(1048, 24, 39, 'montanha').
quadrado(1049, 24, 40, 'grama').
quadrado(1050, 24, 41, 'grama').
quadrado(1051, 25, 0, 'montanha').
quadrado(1052, 25, 1, 'montanha').
quadrado(1053, 25, 2, 'montanha').
quadrado(1054, 25, 3, 'grama').
quadrado(1055, 25, 4, 'grama').
quadrado(1056, 25, 5, 'grama').
quadrado(1057, 25, 6, 'montanha').
quadrado(1058, 25, 7, 'montanha').
quadrado(1059, 25, 8, 'grama').
quadrado(1060, 25, 9, 'montanha').
quadrado(1061, 25, 10, 'grama').
quadrado(1062, 25, 11, 'montanha').
quadrado(1063, 25, 12, 'grama').
quadrado(1064, 25, 13, 'grama').
quadrado(1065, 25, 14, 'grama').
quadrado(1066, 25, 15, 'grama').
quadrado(1067, 25, 16, 'grama').
quadrado(1068, 25, 17, 'grama').
quadrado(1069, 25, 18, 'montanha').
quadrado(1070, 25, 19, 'montanha').
quadrado(1071, 25, 20, 'grama').
quadrado(1072, 25, 21, 'agua').
quadrado(1073, 25, 22, 'agua').
quadrado(1074, 25, 23, 'agua').
quadrado(1075, 25, 24, 'agua').
quadrado(1076, 25, 25, 'agua').
quadrado(1077, 25, 26, 'agua').
quadrado(1078, 25, 27, 'agua').
quadrado(1079, 25, 28, 'agua').
quadrado(1080, 25, 29, 'montanha').
quadrado(1081, 25, 30, 'montanha').
quadrado(1082, 25, 31, 'montanha').
quadrado(1083, 25, 32, 'grama').
quadrado(1084, 25, 33, 'montanha').
quadrado(1085, 25, 34, 'grama').
quadrado(1086, 25, 35, 'montanha').
quadrado(1087, 25, 36, 'montanha').
quadrado(1088, 25, 37, 'grama').
quadrado(1089, 25, 38, 'grama').
quadrado(1090, 25, 39, 'grama').
quadrado(1091, 25, 40, 'grama').
quadrado(1092, 25, 41, 'grama').
quadrado(1093, 26, 0, 'montanha').
quadrado(1094, 26, 1, 'montanha').
quadrado(1095, 26, 2, 'montanha').
quadrado(1096, 26, 3, 'montanha').
quadrado(1097, 26, 4, 'montanha').
quadrado(1098, 26, 5, 'grama').
quadrado(1099, 26, 6, 'grama').
quadrado(1100, 26, 7, 'montanha').
quadrado(1101, 26, 8, 'montanha').
quadrado(1102, 26, 9, 'montanha').
quadrado(1103, 26, 10, 'grama').
quadrado(1104, 26, 11, 'grama').
quadrado(1105, 26, 12, 'grama').
quadrado(1106, 26, 13, 'grama').
quadrado(1107, 26, 14, 'grama').
quadrado(1108, 26, 15, 'montanha').
quadrado(1109, 26, 16, 'montanha').
quadrado(1110, 26, 17, 'grama').
quadrado(1111, 26, 18, 'montanha').
quadrado(1112, 26, 19, 'montanha').
quadrado(1113, 26, 20, 'grama').
quadrado(1114, 26, 21, 'agua').
quadrado(1115, 26, 22, 'grama').
quadrado(1116, 26, 23, 'grama').
quadrado(1117, 26, 24, 'grama').
quadrado(1118, 26, 25, 'grama').
quadrado(1119, 26, 26, 'grama').
quadrado(1120, 26, 27, 'montanha').
quadrado(1121, 26, 28, 'montanha').
quadrado(1122, 26, 29, 'montanha').
quadrado(1123, 26, 30, 'montanha').
quadrado(1124, 26, 31, 'montanha').
quadrado(1125, 26, 32, 'grama').
quadrado(1126, 26, 33, 'montanha').
quadrado(1127, 26, 34, 'grama').
quadrado(1128, 26, 35, 'grama').
quadrado(1129, 26, 36, 'grama').
quadrado(1130, 26, 37, 'grama').
quadrado(1131, 26, 38, 'grama').
quadrado(1132, 26, 39, 'montanha').
quadrado(1133, 26, 40, 'montanha').
quadrado(1134, 26, 41, 'montanha').
quadrado(1135, 27, 0, 'vulcao').
quadrado(1136, 27, 1, 'vulcao').
quadrado(1137, 27, 2, 'vulcao').
quadrado(1138, 27, 3, 'montanha').
quadrado(1139, 27, 4, 'montanha').
quadrado(1140, 27, 5, 'montanha').
quadrado(1141, 27, 6, 'grama').
quadrado(1142, 27, 7, 'grama').
quadrado(1143, 27, 8, 'grama').
quadrado(1144, 27, 9, 'grama').
quadrado(1145, 27, 10, 'grama').
quadrado(1146, 27, 11, 'grama').
quadrado(1147, 27, 12, 'grama').
quadrado(1148, 27, 13, 'agua').
quadrado(1149, 27, 14, 'grama').
quadrado(1150, 27, 15, 'grama').
quadrado(1151, 27, 16, 'grama').
quadrado(1152, 27, 17, 'grama').
quadrado(1153, 27, 18, 'montanha').
quadrado(1154, 27, 19, 'montanha').
quadrado(1155, 27, 20, 'grama').
quadrado(1156, 27, 21, 'agua').
quadrado(1157, 27, 22, 'grama').
quadrado(1158, 27, 23, 'grama').
quadrado(1159, 27, 24, 'montanha').
quadrado(1160, 27, 25, 'grama').
quadrado(1161, 27, 26, 'grama').
quadrado(1162, 27, 27, 'montanha').
quadrado(1163, 27, 28, 'montanha').
quadrado(1164, 27, 29, 'montanha').
quadrado(1165, 27, 30, 'montanha').
quadrado(1166, 27, 31, 'grama').
quadrado(1167, 27, 32, 'grama').
quadrado(1168, 27, 33, 'montanha').
quadrado(1169, 27, 34, 'grama').
quadrado(1170, 27, 35, 'montanha').
quadrado(1171, 27, 36, 'montanha').
quadrado(1172, 27, 37, 'montanha').
quadrado(1173, 27, 38, 'montanha').
quadrado(1174, 27, 39, 'montanha').
quadrado(1175, 27, 40, 'grama').
quadrado(1176, 27, 41, 'montanha').
quadrado(1177, 28, 0, 'vulcao').
quadrado(1178, 28, 1, 'vulcao').
quadrado(1179, 28, 2, 'vulcao').
quadrado(1180, 28, 3, 'vulcao').
quadrado(1181, 28, 4, 'vulcao').
quadrado(1182, 28, 5, 'montanha').
quadrado(1183, 28, 6, 'montanha').
quadrado(1184, 28, 7, 'grama').
quadrado(1185, 28, 8, 'grama').
quadrado(1186, 28, 9, 'grama').
quadrado(1187, 28, 10, 'grama').
quadrado(1188, 28, 11, 'grama').
quadrado(1189, 28, 12, 'agua').
quadrado(1190, 28, 13, 'agua').
quadrado(1191, 28, 14, 'agua').
quadrado(1192, 28, 15, 'grama').
quadrado(1193, 28, 16, 'grama').
quadrado(1194, 28, 17, 'grama').
quadrado(1195, 28, 18, 'grama').
quadrado(1196, 28, 19, 'grama').
quadrado(1197, 28, 20, 'grama').
quadrado(1198, 28, 21, 'agua').
quadrado(1199, 28, 22, 'grama').
quadrado(1200, 28, 23, 'grama').
quadrado(1201, 28, 24, 'montanha').
quadrado(1202, 28, 25, 'grama').
quadrado(1203, 28, 26, 'grama').
quadrado(1204, 28, 27, 'grama').
quadrado(1205, 28, 28, 'montanha').
quadrado(1206, 28, 29, 'montanha').
quadrado(1207, 28, 30, 'grama').
quadrado(1208, 28, 31, 'grama').
quadrado(1209, 28, 32, 'grama').
quadrado(1210, 28, 33, 'montanha').
quadrado(1211, 28, 34, 'grama').
quadrado(1212, 28, 35, 'grama').
quadrado(1213, 28, 36, 'grama').
quadrado(1214, 28, 37, 'grama').
quadrado(1215, 28, 38, 'grama').
quadrado(1216, 28, 39, 'grama').
quadrado(1217, 28, 40, 'grama').
quadrado(1218, 28, 41, 'montanha').
quadrado(1219, 29, 0, 'vulcao').
quadrado(1220, 29, 1, 'vulcao').
quadrado(1221, 29, 2, 'vulcao').
quadrado(1222, 29, 3, 'vulcao').
quadrado(1223, 29, 4, 'vulcao').
quadrado(1224, 29, 5, 'montanha').
quadrado(1225, 29, 6, 'montanha').
quadrado(1226, 29, 7, 'grama').
quadrado(1227, 29, 8, 'montanha').
quadrado(1228, 29, 9, 'grama').
quadrado(1229, 29, 10, 'grama').
quadrado(1230, 29, 11, 'agua').
quadrado(1231, 29, 12, 'agua').
quadrado(1232, 29, 13, 'agua').
quadrado(1233, 29, 14, 'agua').
quadrado(1234, 29, 15, 'agua').
quadrado(1235, 29, 16, 'grama').
quadrado(1236, 29, 17, 'grama').
quadrado(1237, 29, 18, 'grama').
quadrado(1238, 29, 19, 'grama').
quadrado(1239, 29, 20, 'grama').
quadrado(1240, 29, 21, 'agua').
quadrado(1241, 29, 22, 'grama').
quadrado(1242, 29, 23, 'montanha').
quadrado(1243, 29, 24, 'montanha').
quadrado(1244, 29, 25, 'montanha').
quadrado(1245, 29, 26, 'grama').
quadrado(1246, 29, 27, 'grama').
quadrado(1247, 29, 28, 'grama').
quadrado(1248, 29, 29, 'grama').
quadrado(1249, 29, 30, 'grama').
quadrado(1250, 29, 31, 'grama').
quadrado(1251, 29, 32, 'grama').
quadrado(1252, 29, 33, 'montanha').
quadrado(1253, 29, 34, 'grama').
quadrado(1254, 29, 35, 'montanha').
quadrado(1255, 29, 36, 'montanha').
quadrado(1256, 29, 37, 'montanha').
quadrado(1257, 29, 38, 'montanha').
quadrado(1258, 29, 39, 'montanha').
quadrado(1259, 29, 40, 'grama').
quadrado(1260, 29, 41, 'montanha').
quadrado(1261, 30, 0, 'vulcao').
quadrado(1262, 30, 1, 'vulcao').
quadrado(1263, 30, 2, 'vulcao').
quadrado(1264, 30, 3, 'vulcao').
quadrado(1265, 30, 4, 'vulcao').
quadrado(1266, 30, 5, 'vulcao').
quadrado(1267, 30, 6, 'montanha').
quadrado(1268, 30, 7, 'grama').
quadrado(1269, 30, 8, 'montanha').
quadrado(1270, 30, 9, 'grama').
quadrado(1271, 30, 10, 'grama').
quadrado(1272, 30, 11, 'agua').
quadrado(1273, 30, 12, 'agua').
quadrado(1274, 30, 13, 'agua').
quadrado(1275, 30, 14, 'agua').
quadrado(1276, 30, 15, 'agua').
quadrado(1277, 30, 16, 'agua').
quadrado(1278, 30, 17, 'agua').
quadrado(1279, 30, 18, 'agua').
quadrado(1280, 30, 19, 'agua').
quadrado(1281, 30, 20, 'agua').
quadrado(1282, 30, 21, 'agua').
quadrado(1283, 30, 22, 'grama').
quadrado(1284, 30, 23, 'grama').
quadrado(1285, 30, 24, 'montanha').
quadrado(1286, 30, 25, 'grama').
quadrado(1287, 30, 26, 'grama').
quadrado(1288, 30, 27, 'grama').
quadrado(1289, 30, 28, 'grama').
quadrado(1290, 30, 29, 'grama').
quadrado(1291, 30, 30, 'montanha').
quadrado(1292, 30, 31, 'montanha').
quadrado(1293, 30, 32, 'grama').
quadrado(1294, 30, 33, 'montanha').
quadrado(1295, 30, 34, 'grama').
quadrado(1296, 30, 35, 'grama').
quadrado(1297, 30, 36, 'grama').
quadrado(1298, 30, 37, 'grama').
quadrado(1299, 30, 38, 'grama').
quadrado(1300, 30, 39, 'montanha').
quadrado(1301, 30, 40, 'montanha').
quadrado(1302, 30, 41, 'montanha').
quadrado(1303, 31, 0, 'vulcao').
quadrado(1304, 31, 1, 'vulcao').
quadrado(1305, 31, 2, 'vulcao').
quadrado(1306, 31, 3, 'vulcao').
quadrado(1307, 31, 4, 'vulcao').
quadrado(1308, 31, 5, 'vulcao').
quadrado(1309, 31, 6, 'montanha').
quadrado(1310, 31, 7, 'grama').
quadrado(1311, 31, 8, 'montanha').
quadrado(1312, 31, 9, 'montanha').
quadrado(1313, 31, 10, 'grama').
quadrado(1314, 31, 11, 'agua').
quadrado(1315, 31, 12, 'agua').
quadrado(1316, 31, 13, 'agua').
quadrado(1317, 31, 14, 'agua').
quadrado(1318, 31, 15, 'agua').
quadrado(1319, 31, 16, 'grama').
quadrado(1320, 31, 17, 'grama').
quadrado(1321, 31, 18, 'grama').
quadrado(1322, 31, 19, 'grama').
quadrado(1323, 31, 20, 'grama').
quadrado(1324, 31, 21, 'grama').
quadrado(1325, 31, 22, 'grama').
quadrado(1326, 31, 23, 'grama').
quadrado(1327, 31, 24, 'grama').
quadrado(1328, 31, 25, 'grama').
quadrado(1329, 31, 26, 'grama').
quadrado(1330, 31, 27, 'grama').
quadrado(1331, 31, 28, 'grama').
quadrado(1332, 31, 29, 'grama').
quadrado(1333, 31, 30, 'montanha').
quadrado(1334, 31, 31, 'montanha').
quadrado(1335, 31, 32, 'grama').
quadrado(1336, 31, 33, 'grama').
quadrado(1337, 31, 34, 'grama').
quadrado(1338, 31, 35, 'grama').
quadrado(1339, 31, 36, 'montanha').
quadrado(1340, 31, 37, 'montanha').
quadrado(1341, 31, 38, 'montanha').
quadrado(1342, 31, 39, 'grama').
quadrado(1343, 31, 40, 'grama').
quadrado(1344, 31, 41, 'grama').
quadrado(1345, 32, 0, 'vulcao').
quadrado(1346, 32, 1, 'caverna').
quadrado(1347, 32, 2, 'caverna').
quadrado(1348, 32, 3, 'caverna').
quadrado(1349, 32, 4, 'caverna').
quadrado(1350, 32, 5, 'caverna').
quadrado(1351, 32, 6, 'caverna').
quadrado(1352, 32, 7, 'grama').
quadrado(1353, 32, 8, 'montanha').
quadrado(1354, 32, 9, 'grama').
quadrado(1355, 32, 10, 'grama').
quadrado(1356, 32, 11, 'grama').
quadrado(1357, 32, 12, 'agua').
quadrado(1358, 32, 13, 'agua').
quadrado(1359, 32, 14, 'agua').
quadrado(1360, 32, 15, 'grama').
quadrado(1361, 32, 16, 'grama').
quadrado(1362, 32, 17, 'montanha').
quadrado(1363, 32, 18, 'montanha').
quadrado(1364, 32, 19, 'montanha').
quadrado(1365, 32, 20, 'montanha').
quadrado(1366, 32, 21, 'grama').
quadrado(1367, 32, 22, 'montanha').
quadrado(1368, 32, 23, 'montanha').
quadrado(1369, 32, 24, 'montanha').
quadrado(1370, 32, 25, 'montanha').
quadrado(1371, 32, 26, 'grama').
quadrado(1372, 32, 27, 'montanha').
quadrado(1373, 32, 28, 'grama').
quadrado(1374, 32, 29, 'grama').
quadrado(1375, 32, 30, 'montanha').
quadrado(1376, 32, 31, 'montanha').
quadrado(1377, 32, 32, 'grama').
quadrado(1378, 32, 33, 'grama').
quadrado(1379, 32, 34, 'grama').
quadrado(1380, 32, 35, 'montanha').
quadrado(1381, 32, 36, 'montanha').
quadrado(1382, 32, 37, 'montanha').
quadrado(1383, 32, 38, 'montanha').
quadrado(1384, 32, 39, 'montanha').
quadrado(1385, 32, 40, 'grama').
quadrado(1386, 32, 41, 'grama').
quadrado(1387, 33, 0, 'vulcao').
quadrado(1388, 33, 1, 'vulcao').
quadrado(1389, 33, 2, 'vulcao').
quadrado(1390, 33, 3, 'vulcao').
quadrado(1391, 33, 4, 'vulcao').
quadrado(1392, 33, 5, 'vulcao').
quadrado(1393, 33, 6, 'montanha').
quadrado(1394, 33, 7, 'grama').
quadrado(1395, 33, 8, 'montanha').
quadrado(1396, 33, 9, 'grama').
quadrado(1397, 33, 10, 'montanha').
quadrado(1398, 33, 11, 'grama').
quadrado(1399, 33, 12, 'grama').
quadrado(1400, 33, 13, 'agua').
quadrado(1401, 33, 14, 'grama').
quadrado(1402, 33, 15, 'grama').
quadrado(1403, 33, 16, 'grama').
quadrado(1404, 33, 17, 'grama').
quadrado(1405, 33, 18, 'grama').
quadrado(1406, 33, 19, 'grama').
quadrado(1407, 33, 20, 'montanha').
quadrado(1408, 33, 21, 'grama').
quadrado(1409, 33, 22, 'montanha').
quadrado(1410, 33, 23, 'grama').
quadrado(1411, 33, 24, 'grama').
quadrado(1412, 33, 25, 'grama').
quadrado(1413, 33, 26, 'grama').
quadrado(1414, 33, 27, 'montanha').
quadrado(1415, 33, 28, 'grama').
quadrado(1416, 33, 29, 'grama').
quadrado(1417, 33, 30, 'grama').
quadrado(1418, 33, 31, 'grama').
quadrado(1419, 33, 32, 'grama').
quadrado(1420, 33, 33, 'grama').
quadrado(1421, 33, 34, 'montanha').
quadrado(1422, 33, 35, 'montanha').
quadrado(1423, 33, 36, 'montanha').
quadrado(1424, 33, 37, 'montanha').
quadrado(1425, 33, 38, 'montanha').
quadrado(1426, 33, 39, 'montanha').
quadrado(1427, 33, 40, 'montanha').
quadrado(1428, 33, 41, 'grama').
quadrado(1429, 34, 0, 'vulcao').
quadrado(1430, 34, 1, 'vulcao').
quadrado(1431, 34, 2, 'vulcao').
quadrado(1432, 34, 3, 'vulcao').
quadrado(1433, 34, 4, 'vulcao').
quadrado(1434, 34, 5, 'vulcao').
quadrado(1435, 34, 6, 'montanha').
quadrado(1436, 34, 7, 'grama').
quadrado(1437, 34, 8, 'grama').
quadrado(1438, 34, 9, 'grama').
quadrado(1439, 34, 10, 'montanha').
quadrado(1440, 34, 11, 'grama').
quadrado(1441, 34, 12, 'grama').
quadrado(1442, 34, 13, 'grama').
quadrado(1443, 34, 14, 'grama').
quadrado(1444, 34, 15, 'grama').
quadrado(1445, 34, 16, 'montanha').
quadrado(1446, 34, 17, 'montanha').
quadrado(1447, 34, 18, 'montanha').
quadrado(1448, 34, 19, 'grama').
quadrado(1449, 34, 20, 'montanha').
quadrado(1450, 34, 21, 'grama').
quadrado(1451, 34, 22, 'montanha').
quadrado(1452, 34, 23, 'grama').
quadrado(1453, 34, 24, 'grama').
quadrado(1454, 34, 25, 'grama').
quadrado(1455, 34, 26, 'grama').
quadrado(1456, 34, 27, 'montanha').
quadrado(1457, 34, 28, 'montanha').
quadrado(1458, 34, 29, 'montanha').
quadrado(1459, 34, 30, 'grama').
quadrado(1460, 34, 31, 'montanha').
quadrado(1461, 34, 32, 'grama').
quadrado(1462, 34, 33, 'grama').
quadrado(1463, 34, 34, 'montanha').
quadrado(1464, 34, 35, 'montanha').
quadrado(1465, 34, 36, 'montanha').
quadrado(1466, 34, 37, 'vulcao').
quadrado(1467, 34, 38, 'montanha').
quadrado(1468, 34, 39, 'montanha').
quadrado(1469, 34, 40, 'montanha').
quadrado(1470, 34, 41, 'grama').
quadrado(1471, 35, 0, 'vulcao').
quadrado(1472, 35, 1, 'vulcao').
quadrado(1473, 35, 2, 'vulcao').
quadrado(1474, 35, 3, 'vulcao').
quadrado(1475, 35, 4, 'vulcao').
quadrado(1476, 35, 5, 'montanha').
quadrado(1477, 35, 6, 'montanha').
quadrado(1478, 35, 7, 'grama').
quadrado(1479, 35, 8, 'montanha').
quadrado(1480, 35, 9, 'montanha').
quadrado(1481, 35, 10, 'montanha').
quadrado(1482, 35, 11, 'grama').
quadrado(1483, 35, 12, 'grama').
quadrado(1484, 35, 13, 'grama').
quadrado(1485, 35, 14, 'grama').
quadrado(1486, 35, 15, 'montanha').
quadrado(1487, 35, 16, 'montanha').
quadrado(1488, 35, 17, 'grama').
quadrado(1489, 35, 18, 'montanha').
quadrado(1490, 35, 19, 'grama').
quadrado(1491, 35, 20, 'grama').
quadrado(1492, 35, 21, 'grama').
quadrado(1493, 35, 22, 'grama').
quadrado(1494, 35, 23, 'grama').
quadrado(1495, 35, 24, 'montanha').
quadrado(1496, 35, 25, 'montanha').
quadrado(1497, 35, 26, 'montanha').
quadrado(1498, 35, 27, 'montanha').
quadrado(1499, 35, 28, 'grama').
quadrado(1500, 35, 29, 'grama').
quadrado(1501, 35, 30, 'grama').
quadrado(1502, 35, 31, 'montanha').
quadrado(1503, 35, 32, 'grama').
quadrado(1504, 35, 33, 'montanha').
quadrado(1505, 35, 34, 'montanha').
quadrado(1506, 35, 35, 'montanha').
quadrado(1507, 35, 36, 'vulcao').
quadrado(1508, 35, 37, 'vulcao').
quadrado(1509, 35, 38, 'vulcao').
quadrado(1510, 35, 39, 'montanha').
quadrado(1511, 35, 40, 'montanha').
quadrado(1512, 35, 41, 'montanha').
quadrado(1513, 36, 0, 'vulcao').
quadrado(1514, 36, 1, 'vulcao').
quadrado(1515, 36, 2, 'vulcao').
quadrado(1516, 36, 3, 'vulcao').
quadrado(1517, 36, 4, 'vulcao').
quadrado(1518, 36, 5, 'montanha').
quadrado(1519, 36, 6, 'montanha').
quadrado(1520, 36, 7, 'grama').
quadrado(1521, 36, 8, 'grama').
quadrado(1522, 36, 9, 'grama').
quadrado(1523, 36, 10, 'montanha').
quadrado(1524, 36, 11, 'grama').
quadrado(1525, 36, 12, 'montanha').
quadrado(1526, 36, 13, 'montanha').
quadrado(1527, 36, 14, 'grama').
quadrado(1528, 36, 15, 'montanha').
quadrado(1529, 36, 16, 'montanha').
quadrado(1530, 36, 17, 'grama').
quadrado(1531, 36, 18, 'grama').
quadrado(1532, 36, 19, 'grama').
quadrado(1533, 36, 20, 'montanha').
quadrado(1534, 36, 21, 'grama').
quadrado(1535, 36, 22, 'montanha').
quadrado(1536, 36, 23, 'grama').
quadrado(1537, 36, 24, 'grama').
quadrado(1538, 36, 25, 'grama').
quadrado(1539, 36, 26, 'grama').
quadrado(1540, 36, 27, 'montanha').
quadrado(1541, 36, 28, 'grama').
quadrado(1542, 36, 29, 'grama').
quadrado(1543, 36, 30, 'grama').
quadrado(1544, 36, 31, 'montanha').
quadrado(1545, 36, 32, 'grama').
quadrado(1546, 36, 33, 'montanha').
quadrado(1547, 36, 34, 'montanha').
quadrado(1548, 36, 35, 'vulcao').
quadrado(1549, 36, 36, 'vulcao').
quadrado(1550, 36, 37, 'vulcao').
quadrado(1551, 36, 38, 'vulcao').
quadrado(1552, 36, 39, 'vulcao').
quadrado(1553, 36, 40, 'montanha').
quadrado(1554, 36, 41, 'montanha').
quadrado(1555, 37, 0, 'vulcao').
quadrado(1556, 37, 1, 'vulcao').
quadrado(1557, 37, 2, 'vulcao').
quadrado(1558, 37, 3, 'montanha').
quadrado(1559, 37, 4, 'montanha').
quadrado(1560, 37, 5, 'montanha').
quadrado(1561, 37, 6, 'grama').
quadrado(1562, 37, 7, 'grama').
quadrado(1563, 37, 8, 'montanha').
quadrado(1564, 37, 9, 'grama').
quadrado(1565, 37, 10, 'grama').
quadrado(1566, 37, 11, 'grama').
quadrado(1567, 37, 12, 'grama').
quadrado(1568, 37, 13, 'montanha').
quadrado(1569, 37, 14, 'grama').
quadrado(1570, 37, 15, 'montanha').
quadrado(1571, 37, 16, 'montanha').
quadrado(1572, 37, 17, 'grama').
quadrado(1573, 37, 18, 'grama').
quadrado(1574, 37, 19, 'montanha').
quadrado(1575, 37, 20, 'montanha').
quadrado(1576, 37, 21, 'grama').
quadrado(1577, 37, 22, 'montanha').
quadrado(1578, 37, 23, 'montanha').
quadrado(1579, 37, 24, 'grama').
quadrado(1580, 37, 25, 'grama').
quadrado(1581, 37, 26, 'grama').
quadrado(1582, 37, 27, 'montanha').
quadrado(1583, 37, 28, 'grama').
quadrado(1584, 37, 29, 'montanha').
quadrado(1585, 37, 30, 'grama').
quadrado(1586, 37, 31, 'montanha').
quadrado(1587, 37, 32, 'grama').
quadrado(1588, 37, 33, 'montanha').
quadrado(1589, 37, 34, 'montanha').
quadrado(1590, 37, 35, 'montanha').
quadrado(1591, 37, 36, 'vulcao').
quadrado(1592, 37, 37, 'vulcao').
quadrado(1593, 37, 38, 'vulcao').
quadrado(1594, 37, 39, 'montanha').
quadrado(1595, 37, 40, 'montanha').
quadrado(1596, 37, 41, 'montanha').
quadrado(1597, 38, 0, 'montanha').
quadrado(1598, 38, 1, 'montanha').
quadrado(1599, 38, 2, 'montanha').
quadrado(1600, 38, 3, 'montanha').
quadrado(1601, 38, 4, 'montanha').
quadrado(1602, 38, 5, 'grama').
quadrado(1603, 38, 6, 'grama').
quadrado(1604, 38, 7, 'grama').
quadrado(1605, 38, 8, 'grama').
quadrado(1606, 38, 9, 'grama').
quadrado(1607, 38, 10, 'montanha').
quadrado(1608, 38, 11, 'grama').
quadrado(1609, 38, 12, 'grama').
quadrado(1610, 38, 13, 'montanha').
quadrado(1611, 38, 14, 'grama').
quadrado(1612, 38, 15, 'grama').
quadrado(1613, 38, 16, 'grama').
quadrado(1614, 38, 17, 'grama').
quadrado(1615, 38, 18, 'grama').
quadrado(1616, 38, 19, 'montanha').
quadrado(1617, 38, 20, 'montanha').
quadrado(1618, 38, 21, 'grama').
quadrado(1619, 38, 22, 'montanha').
quadrado(1620, 38, 23, 'montanha').
quadrado(1621, 38, 24, 'grama').
quadrado(1622, 38, 25, 'grama').
quadrado(1623, 38, 26, 'grama').
quadrado(1624, 38, 27, 'montanha').
quadrado(1625, 38, 28, 'grama').
quadrado(1626, 38, 29, 'montanha').
quadrado(1627, 38, 30, 'grama').
quadrado(1628, 38, 31, 'grama').
quadrado(1629, 38, 32, 'grama').
quadrado(1630, 38, 33, 'grama').
quadrado(1631, 38, 34, 'montanha').
quadrado(1632, 38, 35, 'montanha').
quadrado(1633, 38, 36, 'montanha').
quadrado(1634, 38, 37, 'vulcao').
quadrado(1635, 38, 38, 'montanha').
quadrado(1636, 38, 39, 'montanha').
quadrado(1637, 38, 40, 'montanha').
quadrado(1638, 38, 41, 'grama').
quadrado(1639, 39, 0, 'montanha').
quadrado(1640, 39, 1, 'montanha').
quadrado(1641, 39, 2, 'montanha').
quadrado(1642, 39, 3, 'grama').
quadrado(1643, 39, 4, 'grama').
quadrado(1644, 39, 5, 'grama').
quadrado(1645, 39, 6, 'montanha').
quadrado(1646, 39, 7, 'montanha').
quadrado(1647, 39, 8, 'montanha').
quadrado(1648, 39, 9, 'montanha').
quadrado(1649, 39, 10, 'montanha').
quadrado(1650, 39, 11, 'grama').
quadrado(1651, 39, 12, 'grama').
quadrado(1652, 39, 13, 'montanha').
quadrado(1653, 39, 14, 'grama').
quadrado(1654, 39, 15, 'grama').
quadrado(1655, 39, 16, 'grama').
quadrado(1656, 39, 17, 'grama').
quadrado(1657, 39, 18, 'grama').
quadrado(1658, 39, 19, 'montanha').
quadrado(1659, 39, 20, 'montanha').
quadrado(1660, 39, 21, 'grama').
quadrado(1661, 39, 22, 'montanha').
quadrado(1662, 39, 23, 'montanha').
quadrado(1663, 39, 24, 'grama').
quadrado(1664, 39, 25, 'grama').
quadrado(1665, 39, 26, 'grama').
quadrado(1666, 39, 27, 'grama').
quadrado(1667, 39, 28, 'grama').
quadrado(1668, 39, 29, 'montanha').
quadrado(1669, 39, 30, 'grama').
quadrado(1670, 39, 31, 'grama').
quadrado(1671, 39, 32, 'grama').
quadrado(1672, 39, 33, 'grama').
quadrado(1673, 39, 34, 'montanha').
quadrado(1674, 39, 35, 'montanha').
quadrado(1675, 39, 36, 'montanha').
quadrado(1676, 39, 37, 'montanha').
quadrado(1677, 39, 38, 'montanha').
quadrado(1678, 39, 39, 'montanha').
quadrado(1679, 39, 40, 'montanha').
quadrado(1680, 39, 41, 'grama').
quadrado(1681, 40, 0, 'grama').
quadrado(1682, 40, 1, 'grama').
quadrado(1683, 40, 2, 'grama').
quadrado(1684, 40, 3, 'grama').
quadrado(1685, 40, 4, 'grama').
quadrado(1686, 40, 5, 'grama').
quadrado(1687, 40, 6, 'grama').
quadrado(1688, 40, 7, 'grama').
quadrado(1689, 40, 8, 'grama').
quadrado(1690, 40, 9, 'grama').
quadrado(1691, 40, 10, 'montanha').
quadrado(1692, 40, 11, 'grama').
quadrado(1693, 40, 12, 'montanha').
quadrado(1694, 40, 13, 'montanha').
quadrado(1695, 40, 14, 'montanha').
quadrado(1696, 40, 15, 'montanha').
quadrado(1697, 40, 16, 'grama').
quadrado(1698, 40, 17, 'grama').
quadrado(1699, 40, 18, 'montanha').
quadrado(1700, 40, 19, 'montanha').
quadrado(1701, 40, 20, 'montanha').
quadrado(1702, 40, 21, 'montanha').
quadrado(1703, 40, 22, 'montanha').
quadrado(1704, 40, 23, 'montanha').
quadrado(1705, 40, 24, 'montanha').
quadrado(1706, 40, 25, 'grama').
quadrado(1707, 40, 26, 'grama').
quadrado(1708, 40, 27, 'grama').
quadrado(1709, 40, 28, 'grama').
quadrado(1710, 40, 29, 'montanha').
quadrado(1711, 40, 30, 'grama').
quadrado(1712, 40, 31, 'montanha').
quadrado(1713, 40, 32, 'montanha').
quadrado(1714, 40, 33, 'grama').
quadrado(1715, 40, 34, 'grama').
quadrado(1716, 40, 35, 'montanha').
quadrado(1717, 40, 36, 'montanha').
quadrado(1718, 40, 37, 'montanha').
quadrado(1719, 40, 38, 'montanha').
quadrado(1720, 40, 39, 'montanha').
quadrado(1721, 40, 40, 'grama').
quadrado(1722, 40, 41, 'grama').
quadrado(1723, 41, 0, 'grama').
quadrado(1724, 41, 1, 'grama').
quadrado(1725, 41, 2, 'grama').
quadrado(1726, 41, 3, 'grama').
quadrado(1727, 41, 4, 'montanha').
quadrado(1728, 41, 5, 'montanha').
quadrado(1729, 41, 6, 'montanha').
quadrado(1730, 41, 7, 'montanha').
quadrado(1731, 41, 8, 'montanha').
quadrado(1732, 41, 9, 'grama').
quadrado(1733, 41, 10, 'grama').
quadrado(1734, 41, 11, 'grama').
quadrado(1735, 41, 12, 'grama').
quadrado(1736, 41, 13, 'grama').
quadrado(1737, 41, 14, 'grama').
quadrado(1738, 41, 15, 'grama').
quadrado(1739, 41, 16, 'grama').
quadrado(1740, 41, 17, 'grama').
quadrado(1741, 41, 18, 'montanha').
quadrado(1742, 41, 19, 'montanha').
quadrado(1743, 41, 20, 'montanha').
quadrado(1744, 41, 21, 'montanha').
quadrado(1745, 41, 22, 'montanha').
quadrado(1746, 41, 23, 'montanha').
quadrado(1747, 41, 24, 'montanha').
quadrado(1748, 41, 25, 'grama').
quadrado(1749, 41, 26, 'grama').
quadrado(1750, 41, 27, 'grama').
quadrado(1751, 41, 28, 'grama').
quadrado(1752, 41, 29, 'grama').
quadrado(1753, 41, 30, 'grama').
quadrado(1754, 41, 31, 'grama').
quadrado(1755, 41, 32, 'grama').
quadrado(1756, 41, 33, 'grama').
quadrado(1757, 41, 34, 'grama').
quadrado(1758, 41, 35, 'grama').
quadrado(1759, 41, 36, 'montanha').
quadrado(1760, 41, 37, 'montanha').
quadrado(1761, 41, 38, 'montanha').
quadrado(1762, 41, 39, 'grama').
quadrado(1763, 41, 40, 'grama').
quadrado(1764, 41, 41, 'grama').

caminho(1, 43, 1). caminho(1, 2, 1). 
caminho(2, 44, 1). caminho(2, 1, 1). caminho(2, 3, 1). 
caminho(3, 45, 1). caminho(3, 2, 1). caminho(3, 4, 1). 
caminho(4, 46, 1). caminho(4, 3, 1). caminho(4, 5, 1). 
caminho(5, 47, 1). caminho(5, 4, 1). caminho(5, 6, 1). 
caminho(6, 48, 1). caminho(6, 5, 1). caminho(6, 7, 1). 
caminho(7, 49, 1). caminho(7, 6, 1). caminho(7, 8, 1). 
caminho(8, 50, 1). caminho(8, 7, 1). caminho(8, 9, 1). 
caminho(9, 51, 1). caminho(9, 8, 1). caminho(9, 10, 1). 
caminho(10, 52, 1). caminho(10, 9, 1). caminho(10, 11, 1). 
caminho(11, 53, 1). caminho(11, 10, 1). caminho(11, 12, 1). 
caminho(12, 54, 1). caminho(12, 11, 1). caminho(12, 13, 1). 
caminho(13, 55, 1). caminho(13, 12, 1). caminho(13, 14, 1). 
caminho(14, 56, 1). caminho(14, 13, 1). caminho(14, 15, 1). 
caminho(15, 57, 1). caminho(15, 14, 1). caminho(15, 16, 1). 
caminho(16, 58, 1). caminho(16, 15, 1). caminho(16, 17, 1). 
caminho(17, 59, 1). caminho(17, 16, 1). caminho(17, 18, 1). 
caminho(18, 60, 1). caminho(18, 17, 1). caminho(18, 19, 1). 
caminho(19, 61, 1). caminho(19, 18, 1). caminho(19, 20, 1). 
caminho(20, 62, 1). caminho(20, 19, 1). caminho(20, 21, 1). 
caminho(21, 63, 1). caminho(21, 20, 1). caminho(21, 22, 1). 
caminho(22, 64, 1). caminho(22, 21, 1). caminho(22, 23, 1). 
caminho(23, 65, 1). caminho(23, 22, 1). caminho(23, 24, 1). 
caminho(24, 66, 1). caminho(24, 23, 1). caminho(24, 25, 1). 
caminho(25, 67, 1). caminho(25, 24, 1). caminho(25, 26, 1). 
caminho(26, 68, 1). caminho(26, 25, 1). caminho(26, 27, 1). 
caminho(27, 69, 1). caminho(27, 26, 1). caminho(27, 28, 1). 
caminho(28, 70, 1). caminho(28, 27, 1). caminho(28, 29, 1). 
caminho(29, 71, 1). caminho(29, 28, 1). caminho(29, 30, 1). 
caminho(30, 72, 1). caminho(30, 29, 1). caminho(30, 31, 1). 
caminho(31, 73, 1). caminho(31, 30, 1). caminho(31, 32, 1). 
caminho(32, 74, 1). caminho(32, 31, 1). caminho(32, 33, 1). 
caminho(33, 75, 1). caminho(33, 32, 1). caminho(33, 34, 1). 
caminho(34, 76, 1). caminho(34, 33, 1). caminho(34, 35, 1). 
caminho(35, 77, 1). caminho(35, 34, 1). caminho(35, 36, 1). 
caminho(36, 78, 1). caminho(36, 35, 1). caminho(36, 37, 1). 
caminho(37, 79, 1). caminho(37, 36, 1). caminho(37, 38, 1). 
caminho(38, 80, 1). caminho(38, 37, 1). caminho(38, 39, 1). 
caminho(39, 81, 1). caminho(39, 38, 1). caminho(39, 40, 1). 
caminho(40, 82, 1). caminho(40, 39, 1). caminho(40, 41, 1). 
caminho(41, 83, 1). caminho(41, 40, 1). caminho(41, 42, 1). 
caminho(42, 84, 1). caminho(42, 41, 1). 
caminho(43, 85, 1). caminho(43, 1, 1). caminho(43, 44, 1). 
caminho(44, 86, 1). caminho(44, 2, 1). caminho(44, 43, 1). caminho(44, 45, 1). 
caminho(45, 87, 1). caminho(45, 3, 1). caminho(45, 44, 1). caminho(45, 46, 1). 
caminho(46, 88, 1). caminho(46, 4, 1). caminho(46, 45, 1). caminho(46, 47, 1). 
caminho(47, 89, 1). caminho(47, 5, 1). caminho(47, 46, 1). caminho(47, 48, 1). 
caminho(48, 90, 1). caminho(48, 6, 1). caminho(48, 47, 1). caminho(48, 49, 1). 
caminho(49, 91, 1). caminho(49, 7, 1). caminho(49, 48, 1). caminho(49, 50, 1). 
caminho(50, 92, 1). caminho(50, 8, 1). caminho(50, 49, 1). caminho(50, 51, 1). 
caminho(51, 93, 1). caminho(51, 9, 1). caminho(51, 50, 1). caminho(51, 52, 1). 
caminho(52, 94, 1). caminho(52, 10, 1). caminho(52, 51, 1). caminho(52, 53, 1). 
caminho(53, 95, 1). caminho(53, 11, 1). caminho(53, 52, 1). caminho(53, 54, 1). 
caminho(54, 96, 1). caminho(54, 12, 1). caminho(54, 53, 1). caminho(54, 55, 1). 
caminho(55, 97, 1). caminho(55, 13, 1). caminho(55, 54, 1). caminho(55, 56, 1). 
caminho(56, 98, 1). caminho(56, 14, 1). caminho(56, 55, 1). caminho(56, 57, 1). 
caminho(57, 99, 1). caminho(57, 15, 1). caminho(57, 56, 1). caminho(57, 58, 1). 
caminho(58, 100, 1). caminho(58, 16, 1). caminho(58, 57, 1). caminho(58, 59, 1). 
caminho(59, 101, 1). caminho(59, 17, 1). caminho(59, 58, 1). caminho(59, 60, 1). 
caminho(60, 102, 1). caminho(60, 18, 1). caminho(60, 59, 1). caminho(60, 61, 1). 
caminho(61, 103, 1). caminho(61, 19, 1). caminho(61, 60, 1). caminho(61, 62, 1). 
caminho(62, 104, 1). caminho(62, 20, 1). caminho(62, 61, 1). caminho(62, 63, 1). 
caminho(63, 105, 1). caminho(63, 21, 1). caminho(63, 62, 1). caminho(63, 64, 1). 
caminho(64, 106, 1). caminho(64, 22, 1). caminho(64, 63, 1). caminho(64, 65, 1). 
caminho(65, 107, 1). caminho(65, 23, 1). caminho(65, 64, 1). caminho(65, 66, 1). 
caminho(66, 108, 1). caminho(66, 24, 1). caminho(66, 65, 1). caminho(66, 67, 1). 
caminho(67, 109, 1). caminho(67, 25, 1). caminho(67, 66, 1). caminho(67, 68, 1). 
caminho(68, 110, 1). caminho(68, 26, 1). caminho(68, 67, 1). caminho(68, 69, 1). 
caminho(69, 111, 1). caminho(69, 27, 1). caminho(69, 68, 1). caminho(69, 70, 1). 
caminho(70, 112, 1). caminho(70, 28, 1). caminho(70, 69, 1). caminho(70, 71, 1). 
caminho(71, 113, 1). caminho(71, 29, 1). caminho(71, 70, 1). caminho(71, 72, 1). 
caminho(72, 114, 1). caminho(72, 30, 1). caminho(72, 71, 1). caminho(72, 73, 1). 
caminho(73, 115, 1). caminho(73, 31, 1). caminho(73, 72, 1). caminho(73, 74, 1). 
caminho(74, 116, 1). caminho(74, 32, 1). caminho(74, 73, 1). caminho(74, 75, 1). 
caminho(75, 117, 1). caminho(75, 33, 1). caminho(75, 74, 1). caminho(75, 76, 1). 
caminho(76, 118, 1). caminho(76, 34, 1). caminho(76, 75, 1). caminho(76, 77, 1). 
caminho(77, 119, 1). caminho(77, 35, 1). caminho(77, 76, 1). caminho(77, 78, 1). 
caminho(78, 120, 1). caminho(78, 36, 1). caminho(78, 77, 1). caminho(78, 79, 1). 
caminho(79, 121, 1). caminho(79, 37, 1). caminho(79, 78, 1). caminho(79, 80, 1). 
caminho(80, 122, 1). caminho(80, 38, 1). caminho(80, 79, 1). caminho(80, 81, 1). 
caminho(81, 123, 1). caminho(81, 39, 1). caminho(81, 80, 1). caminho(81, 82, 1). 
caminho(82, 124, 1). caminho(82, 40, 1). caminho(82, 81, 1). caminho(82, 83, 1). 
caminho(83, 125, 1). caminho(83, 41, 1). caminho(83, 82, 1). caminho(83, 84, 1). 
caminho(84, 126, 1). caminho(84, 42, 1). caminho(84, 83, 1). 
caminho(85, 127, 1). caminho(85, 43, 1). caminho(85, 86, 1). 
caminho(86, 128, 1). caminho(86, 44, 1). caminho(86, 85, 1). caminho(86, 87, 1). 
caminho(87, 129, 1). caminho(87, 45, 1). caminho(87, 86, 1). caminho(87, 88, 1). 
caminho(88, 130, 1). caminho(88, 46, 1). caminho(88, 87, 1). caminho(88, 89, 1). 
caminho(89, 131, 1). caminho(89, 47, 1). caminho(89, 88, 1). caminho(89, 90, 1). 
caminho(90, 132, 1). caminho(90, 48, 1). caminho(90, 89, 1). caminho(90, 91, 1). 
caminho(91, 133, 1). caminho(91, 49, 1). caminho(91, 90, 1). caminho(91, 92, 1). 
caminho(92, 134, 1). caminho(92, 50, 1). caminho(92, 91, 1). caminho(92, 93, 1). 
caminho(93, 135, 1). caminho(93, 51, 1). caminho(93, 92, 1). caminho(93, 94, 1). 
caminho(94, 136, 1). caminho(94, 52, 1). caminho(94, 93, 1). caminho(94, 95, 1). 
caminho(95, 137, 1). caminho(95, 53, 1). caminho(95, 94, 1). caminho(95, 96, 1). 
caminho(96, 138, 1). caminho(96, 54, 1). caminho(96, 95, 1). caminho(96, 97, 1). 
caminho(97, 139, 1). caminho(97, 55, 1). caminho(97, 96, 1). caminho(97, 98, 1). 
caminho(98, 140, 1). caminho(98, 56, 1). caminho(98, 97, 1). caminho(98, 99, 1). 
caminho(99, 141, 1). caminho(99, 57, 1). caminho(99, 98, 1). caminho(99, 100, 1). 
caminho(100, 142, 1). caminho(100, 58, 1). caminho(100, 99, 1). caminho(100, 101, 1). 
caminho(101, 143, 1). caminho(101, 59, 1). caminho(101, 100, 1). caminho(101, 102, 1). 
caminho(102, 144, 1). caminho(102, 60, 1). caminho(102, 101, 1). caminho(102, 103, 1). 
caminho(103, 145, 1). caminho(103, 61, 1). caminho(103, 102, 1). caminho(103, 104, 1). 
caminho(104, 146, 1). caminho(104, 62, 1). caminho(104, 103, 1). caminho(104, 105, 1). 
caminho(105, 147, 1). caminho(105, 63, 1). caminho(105, 104, 1). caminho(105, 106, 1). 
caminho(106, 148, 1). caminho(106, 64, 1). caminho(106, 105, 1). caminho(106, 107, 1). 
caminho(107, 149, 1). caminho(107, 65, 1). caminho(107, 106, 1). caminho(107, 108, 1). 
caminho(108, 150, 1). caminho(108, 66, 1). caminho(108, 107, 1). caminho(108, 109, 1). 
caminho(109, 151, 1). caminho(109, 67, 1). caminho(109, 108, 1). caminho(109, 110, 1). 
caminho(110, 152, 1). caminho(110, 68, 1). caminho(110, 109, 1). caminho(110, 111, 1). 
caminho(111, 153, 1). caminho(111, 69, 1). caminho(111, 110, 1). caminho(111, 112, 1). 
caminho(112, 154, 1). caminho(112, 70, 1). caminho(112, 111, 1). caminho(112, 113, 1). 
caminho(113, 155, 1). caminho(113, 71, 1). caminho(113, 112, 1). caminho(113, 114, 1). 
caminho(114, 156, 1). caminho(114, 72, 1). caminho(114, 113, 1). caminho(114, 115, 1). 
caminho(115, 157, 1). caminho(115, 73, 1). caminho(115, 114, 1). caminho(115, 116, 1). 
caminho(116, 158, 1). caminho(116, 74, 1). caminho(116, 115, 1). caminho(116, 117, 1). 
caminho(117, 159, 1). caminho(117, 75, 1). caminho(117, 116, 1). caminho(117, 118, 1). 
caminho(118, 160, 1). caminho(118, 76, 1). caminho(118, 117, 1). caminho(118, 119, 1). 
caminho(119, 161, 1). caminho(119, 77, 1). caminho(119, 118, 1). caminho(119, 120, 1). 
caminho(120, 162, 1). caminho(120, 78, 1). caminho(120, 119, 1). caminho(120, 121, 1). 
caminho(121, 163, 1). caminho(121, 79, 1). caminho(121, 120, 1). caminho(121, 122, 1). 
caminho(122, 164, 1). caminho(122, 80, 1). caminho(122, 121, 1). caminho(122, 123, 1). 
caminho(123, 165, 1). caminho(123, 81, 1). caminho(123, 122, 1). caminho(123, 124, 1). 
caminho(124, 166, 1). caminho(124, 82, 1). caminho(124, 123, 1). caminho(124, 125, 1). 
caminho(125, 167, 1). caminho(125, 83, 1). caminho(125, 124, 1). caminho(125, 126, 1). 
caminho(126, 168, 1). caminho(126, 84, 1). caminho(126, 125, 1). 
caminho(127, 169, 1). caminho(127, 85, 1). caminho(127, 128, 1). 
caminho(128, 170, 1). caminho(128, 86, 1). caminho(128, 127, 1). caminho(128, 129, 1). 
caminho(129, 171, 1). caminho(129, 87, 1). caminho(129, 128, 1). caminho(129, 130, 1). 
caminho(130, 172, 1). caminho(130, 88, 1). caminho(130, 129, 1). caminho(130, 131, 1). 
caminho(131, 173, 1). caminho(131, 89, 1). caminho(131, 130, 1). caminho(131, 132, 1). 
caminho(132, 174, 1). caminho(132, 90, 1). caminho(132, 131, 1). caminho(132, 133, 1). 
caminho(133, 175, 1). caminho(133, 91, 1). caminho(133, 132, 1). caminho(133, 134, 1). 
caminho(134, 176, 1). caminho(134, 92, 1). caminho(134, 133, 1). caminho(134, 135, 1). 
caminho(135, 177, 1). caminho(135, 93, 1). caminho(135, 134, 1). caminho(135, 136, 1). 
caminho(136, 178, 1). caminho(136, 94, 1). caminho(136, 135, 1). caminho(136, 137, 1). 
caminho(137, 179, 1). caminho(137, 95, 1). caminho(137, 136, 1). caminho(137, 138, 1). 
caminho(138, 180, 1). caminho(138, 96, 1). caminho(138, 137, 1). caminho(138, 139, 1). 
caminho(139, 181, 1). caminho(139, 97, 1). caminho(139, 138, 1). caminho(139, 140, 1). 
caminho(140, 182, 1). caminho(140, 98, 1). caminho(140, 139, 1). caminho(140, 141, 1). 
caminho(141, 183, 1). caminho(141, 99, 1). caminho(141, 140, 1). caminho(141, 142, 1). 
caminho(142, 184, 1). caminho(142, 100, 1). caminho(142, 141, 1). caminho(142, 143, 1). 
caminho(143, 185, 1). caminho(143, 101, 1). caminho(143, 142, 1). caminho(143, 144, 1). 
caminho(144, 186, 1). caminho(144, 102, 1). caminho(144, 143, 1). caminho(144, 145, 1). 
caminho(145, 187, 1). caminho(145, 103, 1). caminho(145, 144, 1). caminho(145, 146, 1). 
caminho(146, 188, 1). caminho(146, 104, 1). caminho(146, 145, 1). caminho(146, 147, 1). 
caminho(147, 189, 1). caminho(147, 105, 1). caminho(147, 146, 1). caminho(147, 148, 1). 
caminho(148, 190, 1). caminho(148, 106, 1). caminho(148, 147, 1). caminho(148, 149, 1). 
caminho(149, 191, 1). caminho(149, 107, 1). caminho(149, 148, 1). caminho(149, 150, 1). 
caminho(150, 192, 1). caminho(150, 108, 1). caminho(150, 149, 1). caminho(150, 151, 1). 
caminho(151, 193, 1). caminho(151, 109, 1). caminho(151, 150, 1). caminho(151, 152, 1). 
caminho(152, 194, 1). caminho(152, 110, 1). caminho(152, 151, 1). caminho(152, 153, 1). 
caminho(153, 195, 1). caminho(153, 111, 1). caminho(153, 152, 1). caminho(153, 154, 1). 
caminho(154, 196, 1). caminho(154, 112, 1). caminho(154, 153, 1). caminho(154, 155, 1). 
caminho(155, 197, 1). caminho(155, 113, 1). caminho(155, 154, 1). caminho(155, 156, 1). 
caminho(156, 198, 1). caminho(156, 114, 1). caminho(156, 155, 1). caminho(156, 157, 1). 
caminho(157, 199, 1). caminho(157, 115, 1). caminho(157, 156, 1). caminho(157, 158, 1). 
caminho(158, 200, 1). caminho(158, 116, 1). caminho(158, 157, 1). caminho(158, 159, 1). 
caminho(159, 201, 1). caminho(159, 117, 1). caminho(159, 158, 1). caminho(159, 160, 1). 
caminho(160, 202, 1). caminho(160, 118, 1). caminho(160, 159, 1). caminho(160, 161, 1). 
caminho(161, 203, 1). caminho(161, 119, 1). caminho(161, 160, 1). caminho(161, 162, 1). 
caminho(162, 204, 1). caminho(162, 120, 1). caminho(162, 161, 1). caminho(162, 163, 1). 
caminho(163, 205, 1). caminho(163, 121, 1). caminho(163, 162, 1). caminho(163, 164, 1). 
caminho(164, 206, 1). caminho(164, 122, 1). caminho(164, 163, 1). caminho(164, 165, 1). 
caminho(165, 207, 1). caminho(165, 123, 1). caminho(165, 164, 1). caminho(165, 166, 1). 
caminho(166, 208, 1). caminho(166, 124, 1). caminho(166, 165, 1). caminho(166, 167, 1). 
caminho(167, 209, 1). caminho(167, 125, 1). caminho(167, 166, 1). caminho(167, 168, 1). 
caminho(168, 210, 1). caminho(168, 126, 1). caminho(168, 167, 1). 
caminho(169, 211, 1). caminho(169, 127, 1). caminho(169, 170, 1). 
caminho(170, 212, 1). caminho(170, 128, 1). caminho(170, 169, 1). caminho(170, 171, 1). 
caminho(171, 213, 1). caminho(171, 129, 1). caminho(171, 170, 1). caminho(171, 172, 1). 
caminho(172, 214, 1). caminho(172, 130, 1). caminho(172, 171, 1). caminho(172, 173, 1). 
caminho(173, 215, 1). caminho(173, 131, 1). caminho(173, 172, 1). caminho(173, 174, 1). 
caminho(174, 216, 1). caminho(174, 132, 1). caminho(174, 173, 1). caminho(174, 175, 1). 
caminho(175, 217, 1). caminho(175, 133, 1). caminho(175, 174, 1). caminho(175, 176, 1). 
caminho(176, 218, 1). caminho(176, 134, 1). caminho(176, 175, 1). caminho(176, 177, 1). 
caminho(177, 219, 1). caminho(177, 135, 1). caminho(177, 176, 1). caminho(177, 178, 1). 
caminho(178, 220, 1). caminho(178, 136, 1). caminho(178, 177, 1). caminho(178, 179, 1). 
caminho(179, 221, 1). caminho(179, 137, 1). caminho(179, 178, 1). caminho(179, 180, 1). 
caminho(180, 222, 1). caminho(180, 138, 1). caminho(180, 179, 1). caminho(180, 181, 1). 
caminho(181, 223, 1). caminho(181, 139, 1). caminho(181, 180, 1). caminho(181, 182, 1). 
caminho(182, 224, 1). caminho(182, 140, 1). caminho(182, 181, 1). caminho(182, 183, 1). 
caminho(183, 225, 1). caminho(183, 141, 1). caminho(183, 182, 1). caminho(183, 184, 1). 
caminho(184, 226, 1). caminho(184, 142, 1). caminho(184, 183, 1). caminho(184, 185, 1). 
caminho(185, 227, 1). caminho(185, 143, 1). caminho(185, 184, 1). caminho(185, 186, 1). 
caminho(186, 228, 1). caminho(186, 144, 1). caminho(186, 185, 1). caminho(186, 187, 1). 
caminho(187, 229, 1). caminho(187, 145, 1). caminho(187, 186, 1). caminho(187, 188, 1). 
caminho(188, 230, 1). caminho(188, 146, 1). caminho(188, 187, 1). caminho(188, 189, 1). 
caminho(189, 231, 1). caminho(189, 147, 1). caminho(189, 188, 1). caminho(189, 190, 1). 
caminho(190, 232, 1). caminho(190, 148, 1). caminho(190, 189, 1). caminho(190, 191, 1). 
caminho(191, 233, 1). caminho(191, 149, 1). caminho(191, 190, 1). caminho(191, 192, 1). 
caminho(192, 234, 1). caminho(192, 150, 1). caminho(192, 191, 1). caminho(192, 193, 1). 
caminho(193, 235, 1). caminho(193, 151, 1). caminho(193, 192, 1). caminho(193, 194, 1). 
caminho(194, 236, 1). caminho(194, 152, 1). caminho(194, 193, 1). caminho(194, 195, 1). 
caminho(195, 237, 1). caminho(195, 153, 1). caminho(195, 194, 1). caminho(195, 196, 1). 
caminho(196, 238, 1). caminho(196, 154, 1). caminho(196, 195, 1). caminho(196, 197, 1). 
caminho(197, 239, 1). caminho(197, 155, 1). caminho(197, 196, 1). caminho(197, 198, 1). 
caminho(198, 240, 1). caminho(198, 156, 1). caminho(198, 197, 1). caminho(198, 199, 1). 
caminho(199, 241, 1). caminho(199, 157, 1). caminho(199, 198, 1). caminho(199, 200, 1). 
caminho(200, 242, 1). caminho(200, 158, 1). caminho(200, 199, 1). caminho(200, 201, 1). 
caminho(201, 243, 1). caminho(201, 159, 1). caminho(201, 200, 1). caminho(201, 202, 1). 
caminho(202, 244, 1). caminho(202, 160, 1). caminho(202, 201, 1). caminho(202, 203, 1). 
caminho(203, 245, 1). caminho(203, 161, 1). caminho(203, 202, 1). caminho(203, 204, 1). 
caminho(204, 246, 1). caminho(204, 162, 1). caminho(204, 203, 1). caminho(204, 205, 1). 
caminho(205, 247, 1). caminho(205, 163, 1). caminho(205, 204, 1). caminho(205, 206, 1). 
caminho(206, 248, 1). caminho(206, 164, 1). caminho(206, 205, 1). caminho(206, 207, 1). 
caminho(207, 249, 1). caminho(207, 165, 1). caminho(207, 206, 1). caminho(207, 208, 1). 
caminho(208, 250, 1). caminho(208, 166, 1). caminho(208, 207, 1). caminho(208, 209, 1). 
caminho(209, 251, 1). caminho(209, 167, 1). caminho(209, 208, 1). caminho(209, 210, 1). 
caminho(210, 252, 1). caminho(210, 168, 1). caminho(210, 209, 1). 
caminho(211, 253, 1). caminho(211, 169, 1). caminho(211, 212, 1). 
caminho(212, 254, 1). caminho(212, 170, 1). caminho(212, 211, 1). caminho(212, 213, 1). 
caminho(213, 255, 1). caminho(213, 171, 1). caminho(213, 212, 1). caminho(213, 214, 1). 
caminho(214, 256, 1). caminho(214, 172, 1). caminho(214, 213, 1). caminho(214, 215, 1). 
caminho(215, 257, 1). caminho(215, 173, 1). caminho(215, 214, 1). caminho(215, 216, 1). 
caminho(216, 258, 1). caminho(216, 174, 1). caminho(216, 215, 1). caminho(216, 217, 1). 
caminho(217, 259, 1). caminho(217, 175, 1). caminho(217, 216, 1). caminho(217, 218, 1). 
caminho(218, 260, 1). caminho(218, 176, 1). caminho(218, 217, 1). caminho(218, 219, 1). 
caminho(219, 261, 1). caminho(219, 177, 1). caminho(219, 218, 1). caminho(219, 220, 1). 
caminho(220, 262, 1). caminho(220, 178, 1). caminho(220, 219, 1). caminho(220, 221, 1). 
caminho(221, 263, 1). caminho(221, 179, 1). caminho(221, 220, 1). caminho(221, 222, 1). 
caminho(222, 264, 1). caminho(222, 180, 1). caminho(222, 221, 1). caminho(222, 223, 1). 
caminho(223, 265, 1). caminho(223, 181, 1). caminho(223, 222, 1). caminho(223, 224, 1). 
caminho(224, 266, 1). caminho(224, 182, 1). caminho(224, 223, 1). caminho(224, 225, 1). 
caminho(225, 267, 1). caminho(225, 183, 1). caminho(225, 224, 1). caminho(225, 226, 1). 
caminho(226, 268, 1). caminho(226, 184, 1). caminho(226, 225, 1). caminho(226, 227, 1). 
caminho(227, 269, 1). caminho(227, 185, 1). caminho(227, 226, 1). caminho(227, 228, 1). 
caminho(228, 270, 1). caminho(228, 186, 1). caminho(228, 227, 1). caminho(228, 229, 1). 
caminho(229, 271, 1). caminho(229, 187, 1). caminho(229, 228, 1). caminho(229, 230, 1). 
caminho(230, 272, 1). caminho(230, 188, 1). caminho(230, 229, 1). caminho(230, 231, 1). 
caminho(231, 273, 1). caminho(231, 189, 1). caminho(231, 230, 1). caminho(231, 232, 1). 
caminho(232, 274, 1). caminho(232, 190, 1). caminho(232, 231, 1). caminho(232, 233, 1). 
caminho(233, 275, 1). caminho(233, 191, 1). caminho(233, 232, 1). caminho(233, 234, 1). 
caminho(234, 276, 1). caminho(234, 192, 1). caminho(234, 233, 1). caminho(234, 235, 1). 
caminho(235, 277, 1). caminho(235, 193, 1). caminho(235, 234, 1). caminho(235, 236, 1). 
caminho(236, 278, 1). caminho(236, 194, 1). caminho(236, 235, 1). caminho(236, 237, 1). 
caminho(237, 279, 1). caminho(237, 195, 1). caminho(237, 236, 1). caminho(237, 238, 1). 
caminho(238, 280, 1). caminho(238, 196, 1). caminho(238, 237, 1). caminho(238, 239, 1). 
caminho(239, 281, 1). caminho(239, 197, 1). caminho(239, 238, 1). caminho(239, 240, 1). 
caminho(240, 282, 1). caminho(240, 198, 1). caminho(240, 239, 1). caminho(240, 241, 1). 
caminho(241, 283, 1). caminho(241, 199, 1). caminho(241, 240, 1). caminho(241, 242, 1). 
caminho(242, 284, 1). caminho(242, 200, 1). caminho(242, 241, 1). caminho(242, 243, 1). 
caminho(243, 285, 1). caminho(243, 201, 1). caminho(243, 242, 1). caminho(243, 244, 1). 
caminho(244, 286, 1). caminho(244, 202, 1). caminho(244, 243, 1). caminho(244, 245, 1). 
caminho(245, 287, 1). caminho(245, 203, 1). caminho(245, 244, 1). caminho(245, 246, 1). 
caminho(246, 288, 1). caminho(246, 204, 1). caminho(246, 245, 1). caminho(246, 247, 1). 
caminho(247, 289, 1). caminho(247, 205, 1). caminho(247, 246, 1). caminho(247, 248, 1). 
caminho(248, 290, 1). caminho(248, 206, 1). caminho(248, 247, 1). caminho(248, 249, 1). 
caminho(249, 291, 1). caminho(249, 207, 1). caminho(249, 248, 1). caminho(249, 250, 1). 
caminho(250, 292, 1). caminho(250, 208, 1). caminho(250, 249, 1). caminho(250, 251, 1). 
caminho(251, 293, 1). caminho(251, 209, 1). caminho(251, 250, 1). caminho(251, 252, 1). 
caminho(252, 294, 1). caminho(252, 210, 1). caminho(252, 251, 1). 
caminho(253, 295, 1). caminho(253, 211, 1). caminho(253, 254, 1). 
caminho(254, 296, 1). caminho(254, 212, 1). caminho(254, 253, 1). caminho(254, 255, 1). 
caminho(255, 297, 1). caminho(255, 213, 1). caminho(255, 254, 1). caminho(255, 256, 1). 
caminho(256, 298, 1). caminho(256, 214, 1). caminho(256, 255, 1). caminho(256, 257, 1). 
caminho(257, 299, 1). caminho(257, 215, 1). caminho(257, 256, 1). caminho(257, 258, 1). 
caminho(258, 300, 1). caminho(258, 216, 1). caminho(258, 257, 1). caminho(258, 259, 1). 
caminho(259, 301, 1). caminho(259, 217, 1). caminho(259, 258, 1). caminho(259, 260, 1). 
caminho(260, 302, 1). caminho(260, 218, 1). caminho(260, 259, 1). caminho(260, 261, 1). 
caminho(261, 303, 1). caminho(261, 219, 1). caminho(261, 260, 1). caminho(261, 262, 1). 
caminho(262, 304, 1). caminho(262, 220, 1). caminho(262, 261, 1). caminho(262, 263, 1). 
caminho(263, 305, 1). caminho(263, 221, 1). caminho(263, 262, 1). caminho(263, 264, 1). 
caminho(264, 306, 1). caminho(264, 222, 1). caminho(264, 263, 1). caminho(264, 265, 1). 
caminho(265, 307, 1). caminho(265, 223, 1). caminho(265, 264, 1). caminho(265, 266, 1). 
caminho(266, 308, 1). caminho(266, 224, 1). caminho(266, 265, 1). caminho(266, 267, 1). 
caminho(267, 309, 1). caminho(267, 225, 1). caminho(267, 266, 1). caminho(267, 268, 1). 
caminho(268, 310, 1). caminho(268, 226, 1). caminho(268, 267, 1). caminho(268, 269, 1). 
caminho(269, 311, 1). caminho(269, 227, 1). caminho(269, 268, 1). caminho(269, 270, 1). 
caminho(270, 312, 1). caminho(270, 228, 1). caminho(270, 269, 1). caminho(270, 271, 1). 
caminho(271, 313, 1). caminho(271, 229, 1). caminho(271, 270, 1). caminho(271, 272, 1). 
caminho(272, 314, 1). caminho(272, 230, 1). caminho(272, 271, 1). caminho(272, 273, 1). 
caminho(273, 315, 1). caminho(273, 231, 1). caminho(273, 272, 1). caminho(273, 274, 1). 
caminho(274, 316, 1). caminho(274, 232, 1). caminho(274, 273, 1). caminho(274, 275, 1). 
caminho(275, 317, 1). caminho(275, 233, 1). caminho(275, 274, 1). caminho(275, 276, 1). 
caminho(276, 318, 1). caminho(276, 234, 1). caminho(276, 275, 1). caminho(276, 277, 1). 
caminho(277, 319, 1). caminho(277, 235, 1). caminho(277, 276, 1). caminho(277, 278, 1). 
caminho(278, 320, 1). caminho(278, 236, 1). caminho(278, 277, 1). caminho(278, 279, 1). 
caminho(279, 321, 1). caminho(279, 237, 1). caminho(279, 278, 1). caminho(279, 280, 1). 
caminho(280, 322, 1). caminho(280, 238, 1). caminho(280, 279, 1). caminho(280, 281, 1). 
caminho(281, 323, 1). caminho(281, 239, 1). caminho(281, 280, 1). caminho(281, 282, 1). 
caminho(282, 324, 1). caminho(282, 240, 1). caminho(282, 281, 1). caminho(282, 283, 1). 
caminho(283, 325, 1). caminho(283, 241, 1). caminho(283, 282, 1). caminho(283, 284, 1). 
caminho(284, 326, 1). caminho(284, 242, 1). caminho(284, 283, 1). caminho(284, 285, 1). 
caminho(285, 327, 1). caminho(285, 243, 1). caminho(285, 284, 1). caminho(285, 286, 1). 
caminho(286, 328, 1). caminho(286, 244, 1). caminho(286, 285, 1). caminho(286, 287, 1). 
caminho(287, 329, 1). caminho(287, 245, 1). caminho(287, 286, 1). caminho(287, 288, 1). 
caminho(288, 330, 1). caminho(288, 246, 1). caminho(288, 287, 1). caminho(288, 289, 1). 
caminho(289, 331, 1). caminho(289, 247, 1). caminho(289, 288, 1). caminho(289, 290, 1). 
caminho(290, 332, 1). caminho(290, 248, 1). caminho(290, 289, 1). caminho(290, 291, 1). 
caminho(291, 333, 1). caminho(291, 249, 1). caminho(291, 290, 1). caminho(291, 292, 1). 
caminho(292, 334, 1). caminho(292, 250, 1). caminho(292, 291, 1). caminho(292, 293, 1). 
caminho(293, 335, 1). caminho(293, 251, 1). caminho(293, 292, 1). caminho(293, 294, 1). 
caminho(294, 336, 1). caminho(294, 252, 1). caminho(294, 293, 1). 
caminho(295, 337, 1). caminho(295, 253, 1). caminho(295, 296, 1). 
caminho(296, 338, 1). caminho(296, 254, 1). caminho(296, 295, 1). caminho(296, 297, 1). 
caminho(297, 339, 1). caminho(297, 255, 1). caminho(297, 296, 1). caminho(297, 298, 1). 
caminho(298, 340, 1). caminho(298, 256, 1). caminho(298, 297, 1). caminho(298, 299, 1). 
caminho(299, 341, 1). caminho(299, 257, 1). caminho(299, 298, 1). caminho(299, 300, 1). 
caminho(300, 342, 1). caminho(300, 258, 1). caminho(300, 299, 1). caminho(300, 301, 1). 
caminho(301, 343, 1). caminho(301, 259, 1). caminho(301, 300, 1). caminho(301, 302, 1). 
caminho(302, 344, 1). caminho(302, 260, 1). caminho(302, 301, 1). caminho(302, 303, 1). 
caminho(303, 345, 1). caminho(303, 261, 1). caminho(303, 302, 1). caminho(303, 304, 1). 
caminho(304, 346, 1). caminho(304, 262, 1). caminho(304, 303, 1). caminho(304, 305, 1). 
caminho(305, 347, 1). caminho(305, 263, 1). caminho(305, 304, 1). caminho(305, 306, 1). 
caminho(306, 348, 1). caminho(306, 264, 1). caminho(306, 305, 1). caminho(306, 307, 1). 
caminho(307, 349, 1). caminho(307, 265, 1). caminho(307, 306, 1). caminho(307, 308, 1). 
caminho(308, 350, 1). caminho(308, 266, 1). caminho(308, 307, 1). caminho(308, 309, 1). 
caminho(309, 351, 1). caminho(309, 267, 1). caminho(309, 308, 1). caminho(309, 310, 1). 
caminho(310, 352, 1). caminho(310, 268, 1). caminho(310, 309, 1). caminho(310, 311, 1). 
caminho(311, 353, 1). caminho(311, 269, 1). caminho(311, 310, 1). caminho(311, 312, 1). 
caminho(312, 354, 1). caminho(312, 270, 1). caminho(312, 311, 1). caminho(312, 313, 1). 
caminho(313, 355, 1). caminho(313, 271, 1). caminho(313, 312, 1). caminho(313, 314, 1). 
caminho(314, 356, 1). caminho(314, 272, 1). caminho(314, 313, 1). caminho(314, 315, 1). 
caminho(315, 357, 1). caminho(315, 273, 1). caminho(315, 314, 1). caminho(315, 316, 1). 
caminho(316, 358, 1). caminho(316, 274, 1). caminho(316, 315, 1). caminho(316, 317, 1). 
caminho(317, 359, 1). caminho(317, 275, 1). caminho(317, 316, 1). caminho(317, 318, 1). 
caminho(318, 360, 1). caminho(318, 276, 1). caminho(318, 317, 1). caminho(318, 319, 1). 
caminho(319, 361, 1). caminho(319, 277, 1). caminho(319, 318, 1). caminho(319, 320, 1). 
caminho(320, 362, 1). caminho(320, 278, 1). caminho(320, 319, 1). caminho(320, 321, 1). 
caminho(321, 363, 1). caminho(321, 279, 1). caminho(321, 320, 1). caminho(321, 322, 1). 
caminho(322, 364, 1). caminho(322, 280, 1). caminho(322, 321, 1). caminho(322, 323, 1). 
caminho(323, 365, 1). caminho(323, 281, 1). caminho(323, 322, 1). caminho(323, 324, 1). 
caminho(324, 366, 1). caminho(324, 282, 1). caminho(324, 323, 1). caminho(324, 325, 1). 
caminho(325, 367, 1). caminho(325, 283, 1). caminho(325, 324, 1). caminho(325, 326, 1). 
caminho(326, 368, 1). caminho(326, 284, 1). caminho(326, 325, 1). caminho(326, 327, 1). 
caminho(327, 369, 1). caminho(327, 285, 1). caminho(327, 326, 1). caminho(327, 328, 1). 
caminho(328, 370, 1). caminho(328, 286, 1). caminho(328, 327, 1). caminho(328, 329, 1). 
caminho(329, 371, 1). caminho(329, 287, 1). caminho(329, 328, 1). caminho(329, 330, 1). 
caminho(330, 372, 1). caminho(330, 288, 1). caminho(330, 329, 1). caminho(330, 331, 1). 
caminho(331, 373, 1). caminho(331, 289, 1). caminho(331, 330, 1). caminho(331, 332, 1). 
caminho(332, 374, 1). caminho(332, 290, 1). caminho(332, 331, 1). caminho(332, 333, 1). 
caminho(333, 375, 1). caminho(333, 291, 1). caminho(333, 332, 1). caminho(333, 334, 1). 
caminho(334, 376, 1). caminho(334, 292, 1). caminho(334, 333, 1). caminho(334, 335, 1). 
caminho(335, 377, 1). caminho(335, 293, 1). caminho(335, 334, 1). caminho(335, 336, 1). 
caminho(336, 378, 1). caminho(336, 294, 1). caminho(336, 335, 1). 
caminho(337, 379, 1). caminho(337, 295, 1). caminho(337, 338, 1). 
caminho(338, 380, 1). caminho(338, 296, 1). caminho(338, 337, 1). caminho(338, 339, 1). 
caminho(339, 381, 1). caminho(339, 297, 1). caminho(339, 338, 1). caminho(339, 340, 1). 
caminho(340, 382, 1). caminho(340, 298, 1). caminho(340, 339, 1). caminho(340, 341, 1). 
caminho(341, 383, 1). caminho(341, 299, 1). caminho(341, 340, 1). caminho(341, 342, 1). 
caminho(342, 384, 1). caminho(342, 300, 1). caminho(342, 341, 1). caminho(342, 343, 1). 
caminho(343, 385, 1). caminho(343, 301, 1). caminho(343, 342, 1). caminho(343, 344, 1). 
caminho(344, 386, 1). caminho(344, 302, 1). caminho(344, 343, 1). caminho(344, 345, 1). 
caminho(345, 387, 1). caminho(345, 303, 1). caminho(345, 344, 1). caminho(345, 346, 1). 
caminho(346, 388, 1). caminho(346, 304, 1). caminho(346, 345, 1). caminho(346, 347, 1). 
caminho(347, 389, 1). caminho(347, 305, 1). caminho(347, 346, 1). caminho(347, 348, 1). 
caminho(348, 390, 1). caminho(348, 306, 1). caminho(348, 347, 1). caminho(348, 349, 1). 
caminho(349, 391, 1). caminho(349, 307, 1). caminho(349, 348, 1). caminho(349, 350, 1). 
caminho(350, 392, 1). caminho(350, 308, 1). caminho(350, 349, 1). caminho(350, 351, 1). 
caminho(351, 393, 1). caminho(351, 309, 1). caminho(351, 350, 1). caminho(351, 352, 1). 
caminho(352, 394, 1). caminho(352, 310, 1). caminho(352, 351, 1). caminho(352, 353, 1). 
caminho(353, 395, 1). caminho(353, 311, 1). caminho(353, 352, 1). caminho(353, 354, 1). 
caminho(354, 396, 1). caminho(354, 312, 1). caminho(354, 353, 1). caminho(354, 355, 1). 
caminho(355, 397, 1). caminho(355, 313, 1). caminho(355, 354, 1). caminho(355, 356, 1). 
caminho(356, 398, 1). caminho(356, 314, 1). caminho(356, 355, 1). caminho(356, 357, 1). 
caminho(357, 399, 1). caminho(357, 315, 1). caminho(357, 356, 1). caminho(357, 358, 1). 
caminho(358, 400, 1). caminho(358, 316, 1). caminho(358, 357, 1). caminho(358, 359, 1). 
caminho(359, 401, 1). caminho(359, 317, 1). caminho(359, 358, 1). caminho(359, 360, 1). 
caminho(360, 402, 1). caminho(360, 318, 1). caminho(360, 359, 1). caminho(360, 361, 1). 
caminho(361, 403, 1). caminho(361, 319, 1). caminho(361, 360, 1). caminho(361, 362, 1). 
caminho(362, 404, 1). caminho(362, 320, 1). caminho(362, 361, 1). caminho(362, 363, 1). 
caminho(363, 405, 1). caminho(363, 321, 1). caminho(363, 362, 1). caminho(363, 364, 1). 
caminho(364, 406, 1). caminho(364, 322, 1). caminho(364, 363, 1). caminho(364, 365, 1). 
caminho(365, 407, 1). caminho(365, 323, 1). caminho(365, 364, 1). caminho(365, 366, 1). 
caminho(366, 408, 1). caminho(366, 324, 1). caminho(366, 365, 1). caminho(366, 367, 1). 
caminho(367, 409, 1). caminho(367, 325, 1). caminho(367, 366, 1). caminho(367, 368, 1). 
caminho(368, 410, 1). caminho(368, 326, 1). caminho(368, 367, 1). caminho(368, 369, 1). 
caminho(369, 411, 1). caminho(369, 327, 1). caminho(369, 368, 1). caminho(369, 370, 1). 
caminho(370, 412, 1). caminho(370, 328, 1). caminho(370, 369, 1). caminho(370, 371, 1). 
caminho(371, 413, 1). caminho(371, 329, 1). caminho(371, 370, 1). caminho(371, 372, 1). 
caminho(372, 414, 1). caminho(372, 330, 1). caminho(372, 371, 1). caminho(372, 373, 1). 
caminho(373, 415, 1). caminho(373, 331, 1). caminho(373, 372, 1). caminho(373, 374, 1). 
caminho(374, 416, 1). caminho(374, 332, 1). caminho(374, 373, 1). caminho(374, 375, 1). 
caminho(375, 417, 1). caminho(375, 333, 1). caminho(375, 374, 1). caminho(375, 376, 1). 
caminho(376, 418, 1). caminho(376, 334, 1). caminho(376, 375, 1). caminho(376, 377, 1). 
caminho(377, 419, 1). caminho(377, 335, 1). caminho(377, 376, 1). caminho(377, 378, 1). 
caminho(378, 420, 1). caminho(378, 336, 1). caminho(378, 377, 1). 
caminho(379, 421, 1). caminho(379, 337, 1). caminho(379, 380, 1). 
caminho(380, 422, 1). caminho(380, 338, 1). caminho(380, 379, 1). caminho(380, 381, 1). 
caminho(381, 423, 1). caminho(381, 339, 1). caminho(381, 380, 1). caminho(381, 382, 1). 
caminho(382, 424, 1). caminho(382, 340, 1). caminho(382, 381, 1). caminho(382, 383, 1). 
caminho(383, 425, 1). caminho(383, 341, 1). caminho(383, 382, 1). caminho(383, 384, 1). 
caminho(384, 426, 1). caminho(384, 342, 1). caminho(384, 383, 1). caminho(384, 385, 1). 
caminho(385, 427, 1). caminho(385, 343, 1). caminho(385, 384, 1). caminho(385, 386, 1). 
caminho(386, 428, 1). caminho(386, 344, 1). caminho(386, 385, 1). caminho(386, 387, 1). 
caminho(387, 429, 1). caminho(387, 345, 1). caminho(387, 386, 1). caminho(387, 388, 1). 
caminho(388, 430, 1). caminho(388, 346, 1). caminho(388, 387, 1). caminho(388, 389, 1). 
caminho(389, 431, 1). caminho(389, 347, 1). caminho(389, 388, 1). caminho(389, 390, 1). 
caminho(390, 432, 1). caminho(390, 348, 1). caminho(390, 389, 1). caminho(390, 391, 1). 
caminho(391, 433, 1). caminho(391, 349, 1). caminho(391, 390, 1). caminho(391, 392, 1). 
caminho(392, 434, 1). caminho(392, 350, 1). caminho(392, 391, 1). caminho(392, 393, 1). 
caminho(393, 435, 1). caminho(393, 351, 1). caminho(393, 392, 1). caminho(393, 394, 1). 
caminho(394, 436, 1). caminho(394, 352, 1). caminho(394, 393, 1). caminho(394, 395, 1). 
caminho(395, 437, 1). caminho(395, 353, 1). caminho(395, 394, 1). caminho(395, 396, 1). 
caminho(396, 438, 1). caminho(396, 354, 1). caminho(396, 395, 1). caminho(396, 397, 1). 
caminho(397, 439, 1). caminho(397, 355, 1). caminho(397, 396, 1). caminho(397, 398, 1). 
caminho(398, 440, 1). caminho(398, 356, 1). caminho(398, 397, 1). caminho(398, 399, 1). 
caminho(399, 441, 1). caminho(399, 357, 1). caminho(399, 398, 1). caminho(399, 400, 1). 
caminho(400, 442, 1). caminho(400, 358, 1). caminho(400, 399, 1). caminho(400, 401, 1). 
caminho(401, 443, 1). caminho(401, 359, 1). caminho(401, 400, 1). caminho(401, 402, 1). 
caminho(402, 444, 1). caminho(402, 360, 1). caminho(402, 401, 1). caminho(402, 403, 1). 
caminho(403, 445, 1). caminho(403, 361, 1). caminho(403, 402, 1). caminho(403, 404, 1). 
caminho(404, 446, 1). caminho(404, 362, 1). caminho(404, 403, 1). caminho(404, 405, 1). 
caminho(405, 447, 1). caminho(405, 363, 1). caminho(405, 404, 1). caminho(405, 406, 1). 
caminho(406, 448, 1). caminho(406, 364, 1). caminho(406, 405, 1). caminho(406, 407, 1). 
caminho(407, 449, 1). caminho(407, 365, 1). caminho(407, 406, 1). caminho(407, 408, 1). 
caminho(408, 450, 1). caminho(408, 366, 1). caminho(408, 407, 1). caminho(408, 409, 1). 
caminho(409, 451, 1). caminho(409, 367, 1). caminho(409, 408, 1). caminho(409, 410, 1). 
caminho(410, 452, 1). caminho(410, 368, 1). caminho(410, 409, 1). caminho(410, 411, 1). 
caminho(411, 453, 1). caminho(411, 369, 1). caminho(411, 410, 1). caminho(411, 412, 1). 
caminho(412, 454, 1). caminho(412, 370, 1). caminho(412, 411, 1). caminho(412, 413, 1). 
caminho(413, 455, 1). caminho(413, 371, 1). caminho(413, 412, 1). caminho(413, 414, 1). 
caminho(414, 456, 1). caminho(414, 372, 1). caminho(414, 413, 1). caminho(414, 415, 1). 
caminho(415, 457, 1). caminho(415, 373, 1). caminho(415, 414, 1). caminho(415, 416, 1). 
caminho(416, 458, 1). caminho(416, 374, 1). caminho(416, 415, 1). caminho(416, 417, 1). 
caminho(417, 459, 1). caminho(417, 375, 1). caminho(417, 416, 1). caminho(417, 418, 1). 
caminho(418, 460, 1). caminho(418, 376, 1). caminho(418, 417, 1). caminho(418, 419, 1). 
caminho(419, 461, 1). caminho(419, 377, 1). caminho(419, 418, 1). caminho(419, 420, 1). 
caminho(420, 462, 1). caminho(420, 378, 1). caminho(420, 419, 1). 
caminho(421, 463, 1). caminho(421, 379, 1). caminho(421, 422, 1). 
caminho(422, 464, 1). caminho(422, 380, 1). caminho(422, 421, 1). caminho(422, 423, 1). 
caminho(423, 465, 1). caminho(423, 381, 1). caminho(423, 422, 1). caminho(423, 424, 1). 
caminho(424, 466, 1). caminho(424, 382, 1). caminho(424, 423, 1). caminho(424, 425, 1). 
caminho(425, 467, 1). caminho(425, 383, 1). caminho(425, 424, 1). caminho(425, 426, 1). 
caminho(426, 468, 1). caminho(426, 384, 1). caminho(426, 425, 1). caminho(426, 427, 1). 
caminho(427, 469, 1). caminho(427, 385, 1). caminho(427, 426, 1). caminho(427, 428, 1). 
caminho(428, 470, 1). caminho(428, 386, 1). caminho(428, 427, 1). caminho(428, 429, 1). 
caminho(429, 471, 1). caminho(429, 387, 1). caminho(429, 428, 1). caminho(429, 430, 1). 
caminho(430, 472, 1). caminho(430, 388, 1). caminho(430, 429, 1). caminho(430, 431, 1). 
caminho(431, 473, 1). caminho(431, 389, 1). caminho(431, 430, 1). caminho(431, 432, 1). 
caminho(432, 474, 1). caminho(432, 390, 1). caminho(432, 431, 1). caminho(432, 433, 1). 
caminho(433, 475, 1). caminho(433, 391, 1). caminho(433, 432, 1). caminho(433, 434, 1). 
caminho(434, 476, 1). caminho(434, 392, 1). caminho(434, 433, 1). caminho(434, 435, 1). 
caminho(435, 477, 1). caminho(435, 393, 1). caminho(435, 434, 1). caminho(435, 436, 1). 
caminho(436, 478, 1). caminho(436, 394, 1). caminho(436, 435, 1). caminho(436, 437, 1). 
caminho(437, 479, 1). caminho(437, 395, 1). caminho(437, 436, 1). caminho(437, 438, 1). 
caminho(438, 480, 1). caminho(438, 396, 1). caminho(438, 437, 1). caminho(438, 439, 1). 
caminho(439, 481, 1). caminho(439, 397, 1). caminho(439, 438, 1). caminho(439, 440, 1). 
caminho(440, 482, 1). caminho(440, 398, 1). caminho(440, 439, 1). caminho(440, 441, 1). 
caminho(441, 483, 1). caminho(441, 399, 1). caminho(441, 440, 1). caminho(441, 442, 1). 
caminho(442, 484, 1). caminho(442, 400, 1). caminho(442, 441, 1). caminho(442, 443, 1). 
caminho(443, 485, 1). caminho(443, 401, 1). caminho(443, 442, 1). caminho(443, 444, 1). 
caminho(444, 486, 1). caminho(444, 402, 1). caminho(444, 443, 1). caminho(444, 445, 1). 
caminho(445, 487, 1). caminho(445, 403, 1). caminho(445, 444, 1). caminho(445, 446, 1). 
caminho(446, 488, 1). caminho(446, 404, 1). caminho(446, 445, 1). caminho(446, 447, 1). 
caminho(447, 489, 1). caminho(447, 405, 1). caminho(447, 446, 1). caminho(447, 448, 1). 
caminho(448, 490, 1). caminho(448, 406, 1). caminho(448, 447, 1). caminho(448, 449, 1). 
caminho(449, 491, 1). caminho(449, 407, 1). caminho(449, 448, 1). caminho(449, 450, 1). 
caminho(450, 492, 1). caminho(450, 408, 1). caminho(450, 449, 1). caminho(450, 451, 1). 
caminho(451, 493, 1). caminho(451, 409, 1). caminho(451, 450, 1). caminho(451, 452, 1). 
caminho(452, 494, 1). caminho(452, 410, 1). caminho(452, 451, 1). caminho(452, 453, 1). 
caminho(453, 495, 1). caminho(453, 411, 1). caminho(453, 452, 1). caminho(453, 454, 1). 
caminho(454, 496, 1). caminho(454, 412, 1). caminho(454, 453, 1). caminho(454, 455, 1). 
caminho(455, 497, 1). caminho(455, 413, 1). caminho(455, 454, 1). caminho(455, 456, 1). 
caminho(456, 498, 1). caminho(456, 414, 1). caminho(456, 455, 1). caminho(456, 457, 1). 
caminho(457, 499, 1). caminho(457, 415, 1). caminho(457, 456, 1). caminho(457, 458, 1). 
caminho(458, 500, 1). caminho(458, 416, 1). caminho(458, 457, 1). caminho(458, 459, 1). 
caminho(459, 501, 1). caminho(459, 417, 1). caminho(459, 458, 1). caminho(459, 460, 1). 
caminho(460, 502, 1). caminho(460, 418, 1). caminho(460, 459, 1). caminho(460, 461, 1). 
caminho(461, 503, 1). caminho(461, 419, 1). caminho(461, 460, 1). caminho(461, 462, 1). 
caminho(462, 504, 1). caminho(462, 420, 1). caminho(462, 461, 1). 
caminho(463, 505, 1). caminho(463, 421, 1). caminho(463, 464, 1). 
caminho(464, 506, 1). caminho(464, 422, 1). caminho(464, 463, 1). caminho(464, 465, 1). 
caminho(465, 507, 1). caminho(465, 423, 1). caminho(465, 464, 1). caminho(465, 466, 1). 
caminho(466, 508, 1). caminho(466, 424, 1). caminho(466, 465, 1). caminho(466, 467, 1). 
caminho(467, 509, 1). caminho(467, 425, 1). caminho(467, 466, 1). caminho(467, 468, 1). 
caminho(468, 510, 1). caminho(468, 426, 1). caminho(468, 467, 1). caminho(468, 469, 1). 
caminho(469, 511, 1). caminho(469, 427, 1). caminho(469, 468, 1). caminho(469, 470, 1). 
caminho(470, 512, 1). caminho(470, 428, 1). caminho(470, 469, 1). caminho(470, 471, 1). 
caminho(471, 513, 1). caminho(471, 429, 1). caminho(471, 470, 1). caminho(471, 472, 1). 
caminho(472, 514, 1). caminho(472, 430, 1). caminho(472, 471, 1). caminho(472, 473, 1). 
caminho(473, 515, 1). caminho(473, 431, 1). caminho(473, 472, 1). caminho(473, 474, 1). 
caminho(474, 516, 1). caminho(474, 432, 1). caminho(474, 473, 1). caminho(474, 475, 1). 
caminho(475, 517, 1). caminho(475, 433, 1). caminho(475, 474, 1). caminho(475, 476, 1). 
caminho(476, 518, 1). caminho(476, 434, 1). caminho(476, 475, 1). caminho(476, 477, 1). 
caminho(477, 519, 1). caminho(477, 435, 1). caminho(477, 476, 1). caminho(477, 478, 1). 
caminho(478, 520, 1). caminho(478, 436, 1). caminho(478, 477, 1). caminho(478, 479, 1). 
caminho(479, 521, 1). caminho(479, 437, 1). caminho(479, 478, 1). caminho(479, 480, 1). 
caminho(480, 522, 1). caminho(480, 438, 1). caminho(480, 479, 1). caminho(480, 481, 1). 
caminho(481, 523, 1). caminho(481, 439, 1). caminho(481, 480, 1). caminho(481, 482, 1). 
caminho(482, 524, 1). caminho(482, 440, 1). caminho(482, 481, 1). caminho(482, 483, 1). 
caminho(483, 525, 1). caminho(483, 441, 1). caminho(483, 482, 1). caminho(483, 484, 1). 
caminho(484, 526, 1). caminho(484, 442, 1). caminho(484, 483, 1). caminho(484, 485, 1). 
caminho(485, 527, 1). caminho(485, 443, 1). caminho(485, 484, 1). caminho(485, 486, 1). 
caminho(486, 528, 1). caminho(486, 444, 1). caminho(486, 485, 1). caminho(486, 487, 1). 
caminho(487, 529, 1). caminho(487, 445, 1). caminho(487, 486, 1). caminho(487, 488, 1). 
caminho(488, 530, 1). caminho(488, 446, 1). caminho(488, 487, 1). caminho(488, 489, 1). 
caminho(489, 531, 1). caminho(489, 447, 1). caminho(489, 488, 1). caminho(489, 490, 1). 
caminho(490, 532, 1). caminho(490, 448, 1). caminho(490, 489, 1). caminho(490, 491, 1). 
caminho(491, 533, 1). caminho(491, 449, 1). caminho(491, 490, 1). caminho(491, 492, 1). 
caminho(492, 534, 1). caminho(492, 450, 1). caminho(492, 491, 1). caminho(492, 493, 1). 
caminho(493, 535, 1). caminho(493, 451, 1). caminho(493, 492, 1). caminho(493, 494, 1). 
caminho(494, 536, 1). caminho(494, 452, 1). caminho(494, 493, 1). caminho(494, 495, 1). 
caminho(495, 537, 1). caminho(495, 453, 1). caminho(495, 494, 1). caminho(495, 496, 1). 
caminho(496, 538, 1). caminho(496, 454, 1). caminho(496, 495, 1). caminho(496, 497, 1). 
caminho(497, 539, 1). caminho(497, 455, 1). caminho(497, 496, 1). caminho(497, 498, 1). 
caminho(498, 540, 1). caminho(498, 456, 1). caminho(498, 497, 1). caminho(498, 499, 1). 
caminho(499, 541, 1). caminho(499, 457, 1). caminho(499, 498, 1). caminho(499, 500, 1). 
caminho(500, 542, 1). caminho(500, 458, 1). caminho(500, 499, 1). caminho(500, 501, 1). 
caminho(501, 543, 1). caminho(501, 459, 1). caminho(501, 500, 1). caminho(501, 502, 1). 
caminho(502, 544, 1). caminho(502, 460, 1). caminho(502, 501, 1). caminho(502, 503, 1). 
caminho(503, 545, 1). caminho(503, 461, 1). caminho(503, 502, 1). caminho(503, 504, 1). 
caminho(504, 546, 1). caminho(504, 462, 1). caminho(504, 503, 1). 
caminho(505, 547, 1). caminho(505, 463, 1). caminho(505, 506, 1). 
caminho(506, 548, 1). caminho(506, 464, 1). caminho(506, 505, 1). caminho(506, 507, 1). 
caminho(507, 549, 1). caminho(507, 465, 1). caminho(507, 506, 1). caminho(507, 508, 1). 
caminho(508, 550, 1). caminho(508, 466, 1). caminho(508, 507, 1). caminho(508, 509, 1). 
caminho(509, 551, 1). caminho(509, 467, 1). caminho(509, 508, 1). caminho(509, 510, 1). 
caminho(510, 552, 1). caminho(510, 468, 1). caminho(510, 509, 1). caminho(510, 511, 1). 
caminho(511, 553, 1). caminho(511, 469, 1). caminho(511, 510, 1). caminho(511, 512, 1). 
caminho(512, 554, 1). caminho(512, 470, 1). caminho(512, 511, 1). caminho(512, 513, 1). 
caminho(513, 555, 1). caminho(513, 471, 1). caminho(513, 512, 1). caminho(513, 514, 1). 
caminho(514, 556, 1). caminho(514, 472, 1). caminho(514, 513, 1). caminho(514, 515, 1). 
caminho(515, 557, 1). caminho(515, 473, 1). caminho(515, 514, 1). caminho(515, 516, 1). 
caminho(516, 558, 1). caminho(516, 474, 1). caminho(516, 515, 1). caminho(516, 517, 1). 
caminho(517, 559, 1). caminho(517, 475, 1). caminho(517, 516, 1). caminho(517, 518, 1). 
caminho(518, 560, 1). caminho(518, 476, 1). caminho(518, 517, 1). caminho(518, 519, 1). 
caminho(519, 561, 1). caminho(519, 477, 1). caminho(519, 518, 1). caminho(519, 520, 1). 
caminho(520, 562, 1). caminho(520, 478, 1). caminho(520, 519, 1). caminho(520, 521, 1). 
caminho(521, 563, 1). caminho(521, 479, 1). caminho(521, 520, 1). caminho(521, 522, 1). 
caminho(522, 564, 1). caminho(522, 480, 1). caminho(522, 521, 1). caminho(522, 523, 1). 
caminho(523, 565, 1). caminho(523, 481, 1). caminho(523, 522, 1). caminho(523, 524, 1). 
caminho(524, 566, 1). caminho(524, 482, 1). caminho(524, 523, 1). caminho(524, 525, 1). 
caminho(525, 567, 1). caminho(525, 483, 1). caminho(525, 524, 1). caminho(525, 526, 1). 
caminho(526, 568, 1). caminho(526, 484, 1). caminho(526, 525, 1). caminho(526, 527, 1). 
caminho(527, 569, 1). caminho(527, 485, 1). caminho(527, 526, 1). caminho(527, 528, 1). 
caminho(528, 570, 1). caminho(528, 486, 1). caminho(528, 527, 1). caminho(528, 529, 1). 
caminho(529, 571, 1). caminho(529, 487, 1). caminho(529, 528, 1). caminho(529, 530, 1). 
caminho(530, 572, 1). caminho(530, 488, 1). caminho(530, 529, 1). caminho(530, 531, 1). 
caminho(531, 573, 1). caminho(531, 489, 1). caminho(531, 530, 1). caminho(531, 532, 1). 
caminho(532, 574, 1). caminho(532, 490, 1). caminho(532, 531, 1). caminho(532, 533, 1). 
caminho(533, 575, 1). caminho(533, 491, 1). caminho(533, 532, 1). caminho(533, 534, 1). 
caminho(534, 576, 1). caminho(534, 492, 1). caminho(534, 533, 1). caminho(534, 535, 1). 
caminho(535, 577, 1). caminho(535, 493, 1). caminho(535, 534, 1). caminho(535, 536, 1). 
caminho(536, 578, 1). caminho(536, 494, 1). caminho(536, 535, 1). caminho(536, 537, 1). 
caminho(537, 579, 1). caminho(537, 495, 1). caminho(537, 536, 1). caminho(537, 538, 1). 
caminho(538, 580, 1). caminho(538, 496, 1). caminho(538, 537, 1). caminho(538, 539, 1). 
caminho(539, 581, 1). caminho(539, 497, 1). caminho(539, 538, 1). caminho(539, 540, 1). 
caminho(540, 582, 1). caminho(540, 498, 1). caminho(540, 539, 1). caminho(540, 541, 1). 
caminho(541, 583, 1). caminho(541, 499, 1). caminho(541, 540, 1). caminho(541, 542, 1). 
caminho(542, 584, 1). caminho(542, 500, 1). caminho(542, 541, 1). caminho(542, 543, 1). 
caminho(543, 585, 1). caminho(543, 501, 1). caminho(543, 542, 1). caminho(543, 544, 1). 
caminho(544, 586, 1). caminho(544, 502, 1). caminho(544, 543, 1). caminho(544, 545, 1). 
caminho(545, 587, 1). caminho(545, 503, 1). caminho(545, 544, 1). caminho(545, 546, 1). 
caminho(546, 588, 1). caminho(546, 504, 1). caminho(546, 545, 1). 
caminho(547, 589, 1). caminho(547, 505, 1). caminho(547, 548, 1). 
caminho(548, 590, 1). caminho(548, 506, 1). caminho(548, 547, 1). caminho(548, 549, 1). 
caminho(549, 591, 1). caminho(549, 507, 1). caminho(549, 548, 1). caminho(549, 550, 1). 
caminho(550, 592, 1). caminho(550, 508, 1). caminho(550, 549, 1). caminho(550, 551, 1). 
caminho(551, 593, 1). caminho(551, 509, 1). caminho(551, 550, 1). caminho(551, 552, 1). 
caminho(552, 594, 1). caminho(552, 510, 1). caminho(552, 551, 1). caminho(552, 553, 1). 
caminho(553, 595, 1). caminho(553, 511, 1). caminho(553, 552, 1). caminho(553, 554, 1). 
caminho(554, 596, 1). caminho(554, 512, 1). caminho(554, 553, 1). caminho(554, 555, 1). 
caminho(555, 597, 1). caminho(555, 513, 1). caminho(555, 554, 1). caminho(555, 556, 1). 
caminho(556, 598, 1). caminho(556, 514, 1). caminho(556, 555, 1). caminho(556, 557, 1). 
caminho(557, 599, 1). caminho(557, 515, 1). caminho(557, 556, 1). caminho(557, 558, 1). 
caminho(558, 600, 1). caminho(558, 516, 1). caminho(558, 557, 1). caminho(558, 559, 1). 
caminho(559, 601, 1). caminho(559, 517, 1). caminho(559, 558, 1). caminho(559, 560, 1). 
caminho(560, 602, 1). caminho(560, 518, 1). caminho(560, 559, 1). caminho(560, 561, 1). 
caminho(561, 603, 1). caminho(561, 519, 1). caminho(561, 560, 1). caminho(561, 562, 1). 
caminho(562, 604, 1). caminho(562, 520, 1). caminho(562, 561, 1). caminho(562, 563, 1). 
caminho(563, 605, 1). caminho(563, 521, 1). caminho(563, 562, 1). caminho(563, 564, 1). 
caminho(564, 606, 1). caminho(564, 522, 1). caminho(564, 563, 1). caminho(564, 565, 1). 
caminho(565, 607, 1). caminho(565, 523, 1). caminho(565, 564, 1). caminho(565, 566, 1). 
caminho(566, 608, 1). caminho(566, 524, 1). caminho(566, 565, 1). caminho(566, 567, 1). 
caminho(567, 609, 1). caminho(567, 525, 1). caminho(567, 566, 1). caminho(567, 568, 1). 
caminho(568, 610, 1). caminho(568, 526, 1). caminho(568, 567, 1). caminho(568, 569, 1). 
caminho(569, 611, 1). caminho(569, 527, 1). caminho(569, 568, 1). caminho(569, 570, 1). 
caminho(570, 612, 1). caminho(570, 528, 1). caminho(570, 569, 1). caminho(570, 571, 1). 
caminho(571, 613, 1). caminho(571, 529, 1). caminho(571, 570, 1). caminho(571, 572, 1). 
caminho(572, 614, 1). caminho(572, 530, 1). caminho(572, 571, 1). caminho(572, 573, 1). 
caminho(573, 615, 1). caminho(573, 531, 1). caminho(573, 572, 1). caminho(573, 574, 1). 
caminho(574, 616, 1). caminho(574, 532, 1). caminho(574, 573, 1). caminho(574, 575, 1). 
caminho(575, 617, 1). caminho(575, 533, 1). caminho(575, 574, 1). caminho(575, 576, 1). 
caminho(576, 618, 1). caminho(576, 534, 1). caminho(576, 575, 1). caminho(576, 577, 1). 
caminho(577, 619, 1). caminho(577, 535, 1). caminho(577, 576, 1). caminho(577, 578, 1). 
caminho(578, 620, 1). caminho(578, 536, 1). caminho(578, 577, 1). caminho(578, 579, 1). 
caminho(579, 621, 1). caminho(579, 537, 1). caminho(579, 578, 1). caminho(579, 580, 1). 
caminho(580, 622, 1). caminho(580, 538, 1). caminho(580, 579, 1). caminho(580, 581, 1). 
caminho(581, 623, 1). caminho(581, 539, 1). caminho(581, 580, 1). caminho(581, 582, 1). 
caminho(582, 624, 1). caminho(582, 540, 1). caminho(582, 581, 1). caminho(582, 583, 1). 
caminho(583, 625, 1). caminho(583, 541, 1). caminho(583, 582, 1). caminho(583, 584, 1). 
caminho(584, 626, 1). caminho(584, 542, 1). caminho(584, 583, 1). caminho(584, 585, 1). 
caminho(585, 627, 1). caminho(585, 543, 1). caminho(585, 584, 1). caminho(585, 586, 1). 
caminho(586, 628, 1). caminho(586, 544, 1). caminho(586, 585, 1). caminho(586, 587, 1). 
caminho(587, 629, 1). caminho(587, 545, 1). caminho(587, 586, 1). caminho(587, 588, 1). 
caminho(588, 630, 1). caminho(588, 546, 1). caminho(588, 587, 1). 
caminho(589, 631, 1). caminho(589, 547, 1). caminho(589, 590, 1). 
caminho(590, 632, 1). caminho(590, 548, 1). caminho(590, 589, 1). caminho(590, 591, 1). 
caminho(591, 633, 1). caminho(591, 549, 1). caminho(591, 590, 1). caminho(591, 592, 1). 
caminho(592, 634, 1). caminho(592, 550, 1). caminho(592, 591, 1). caminho(592, 593, 1). 
caminho(593, 635, 1). caminho(593, 551, 1). caminho(593, 592, 1). caminho(593, 594, 1). 
caminho(594, 636, 1). caminho(594, 552, 1). caminho(594, 593, 1). caminho(594, 595, 1). 
caminho(595, 637, 1). caminho(595, 553, 1). caminho(595, 594, 1). caminho(595, 596, 1). 
caminho(596, 638, 1). caminho(596, 554, 1). caminho(596, 595, 1). caminho(596, 597, 1). 
caminho(597, 639, 1). caminho(597, 555, 1). caminho(597, 596, 1). caminho(597, 598, 1). 
caminho(598, 640, 1). caminho(598, 556, 1). caminho(598, 597, 1). caminho(598, 599, 1). 
caminho(599, 641, 1). caminho(599, 557, 1). caminho(599, 598, 1). caminho(599, 600, 1). 
caminho(600, 642, 1). caminho(600, 558, 1). caminho(600, 599, 1). caminho(600, 601, 1). 
caminho(601, 643, 1). caminho(601, 559, 1). caminho(601, 600, 1). caminho(601, 602, 1). 
caminho(602, 644, 1). caminho(602, 560, 1). caminho(602, 601, 1). caminho(602, 603, 1). 
caminho(603, 645, 1). caminho(603, 561, 1). caminho(603, 602, 1). caminho(603, 604, 1). 
caminho(604, 646, 1). caminho(604, 562, 1). caminho(604, 603, 1). caminho(604, 605, 1). 
caminho(605, 647, 1). caminho(605, 563, 1). caminho(605, 604, 1). caminho(605, 606, 1). 
caminho(606, 648, 1). caminho(606, 564, 1). caminho(606, 605, 1). caminho(606, 607, 1). 
caminho(607, 649, 1). caminho(607, 565, 1). caminho(607, 606, 1). caminho(607, 608, 1). 
caminho(608, 650, 1). caminho(608, 566, 1). caminho(608, 607, 1). caminho(608, 609, 1). 
caminho(609, 651, 1). caminho(609, 567, 1). caminho(609, 608, 1). caminho(609, 610, 1). 
caminho(610, 652, 1). caminho(610, 568, 1). caminho(610, 609, 1). caminho(610, 611, 1). 
caminho(611, 653, 1). caminho(611, 569, 1). caminho(611, 610, 1). caminho(611, 612, 1). 
caminho(612, 654, 1). caminho(612, 570, 1). caminho(612, 611, 1). caminho(612, 613, 1). 
caminho(613, 655, 1). caminho(613, 571, 1). caminho(613, 612, 1). caminho(613, 614, 1). 
caminho(614, 656, 1). caminho(614, 572, 1). caminho(614, 613, 1). caminho(614, 615, 1). 
caminho(615, 657, 1). caminho(615, 573, 1). caminho(615, 614, 1). caminho(615, 616, 1). 
caminho(616, 658, 1). caminho(616, 574, 1). caminho(616, 615, 1). caminho(616, 617, 1). 
caminho(617, 659, 1). caminho(617, 575, 1). caminho(617, 616, 1). caminho(617, 618, 1). 
caminho(618, 660, 1). caminho(618, 576, 1). caminho(618, 617, 1). caminho(618, 619, 1). 
caminho(619, 661, 1). caminho(619, 577, 1). caminho(619, 618, 1). caminho(619, 620, 1). 
caminho(620, 662, 1). caminho(620, 578, 1). caminho(620, 619, 1). caminho(620, 621, 1). 
caminho(621, 663, 1). caminho(621, 579, 1). caminho(621, 620, 1). caminho(621, 622, 1). 
caminho(622, 664, 1). caminho(622, 580, 1). caminho(622, 621, 1). caminho(622, 623, 1). 
caminho(623, 665, 1). caminho(623, 581, 1). caminho(623, 622, 1). caminho(623, 624, 1). 
caminho(624, 666, 1). caminho(624, 582, 1). caminho(624, 623, 1). caminho(624, 625, 1). 
caminho(625, 667, 1). caminho(625, 583, 1). caminho(625, 624, 1). caminho(625, 626, 1). 
caminho(626, 668, 1). caminho(626, 584, 1). caminho(626, 625, 1). caminho(626, 627, 1). 
caminho(627, 669, 1). caminho(627, 585, 1). caminho(627, 626, 1). caminho(627, 628, 1). 
caminho(628, 670, 1). caminho(628, 586, 1). caminho(628, 627, 1). caminho(628, 629, 1). 
caminho(629, 671, 1). caminho(629, 587, 1). caminho(629, 628, 1). caminho(629, 630, 1). 
caminho(630, 672, 1). caminho(630, 588, 1). caminho(630, 629, 1). 
caminho(631, 673, 1). caminho(631, 589, 1). caminho(631, 632, 1). 
caminho(632, 674, 1). caminho(632, 590, 1). caminho(632, 631, 1). caminho(632, 633, 1). 
caminho(633, 675, 1). caminho(633, 591, 1). caminho(633, 632, 1). caminho(633, 634, 1). 
caminho(634, 676, 1). caminho(634, 592, 1). caminho(634, 633, 1). caminho(634, 635, 1). 
caminho(635, 677, 1). caminho(635, 593, 1). caminho(635, 634, 1). caminho(635, 636, 1). 
caminho(636, 678, 1). caminho(636, 594, 1). caminho(636, 635, 1). caminho(636, 637, 1). 
caminho(637, 679, 1). caminho(637, 595, 1). caminho(637, 636, 1). caminho(637, 638, 1). 
caminho(638, 680, 1). caminho(638, 596, 1). caminho(638, 637, 1). caminho(638, 639, 1). 
caminho(639, 681, 1). caminho(639, 597, 1). caminho(639, 638, 1). caminho(639, 640, 1). 
caminho(640, 682, 1). caminho(640, 598, 1). caminho(640, 639, 1). caminho(640, 641, 1). 
caminho(641, 683, 1). caminho(641, 599, 1). caminho(641, 640, 1). caminho(641, 642, 1). 
caminho(642, 684, 1). caminho(642, 600, 1). caminho(642, 641, 1). caminho(642, 643, 1). 
caminho(643, 685, 1). caminho(643, 601, 1). caminho(643, 642, 1). caminho(643, 644, 1). 
caminho(644, 686, 1). caminho(644, 602, 1). caminho(644, 643, 1). caminho(644, 645, 1). 
caminho(645, 687, 1). caminho(645, 603, 1). caminho(645, 644, 1). caminho(645, 646, 1). 
caminho(646, 688, 1). caminho(646, 604, 1). caminho(646, 645, 1). caminho(646, 647, 1). 
caminho(647, 689, 1). caminho(647, 605, 1). caminho(647, 646, 1). caminho(647, 648, 1). 
caminho(648, 690, 1). caminho(648, 606, 1). caminho(648, 647, 1). caminho(648, 649, 1). 
caminho(649, 691, 1). caminho(649, 607, 1). caminho(649, 648, 1). caminho(649, 650, 1). 
caminho(650, 692, 1). caminho(650, 608, 1). caminho(650, 649, 1). caminho(650, 651, 1). 
caminho(651, 693, 1). caminho(651, 609, 1). caminho(651, 650, 1). caminho(651, 652, 1). 
caminho(652, 694, 1). caminho(652, 610, 1). caminho(652, 651, 1). caminho(652, 653, 1). 
caminho(653, 695, 1). caminho(653, 611, 1). caminho(653, 652, 1). caminho(653, 654, 1). 
caminho(654, 696, 1). caminho(654, 612, 1). caminho(654, 653, 1). caminho(654, 655, 1). 
caminho(655, 697, 1). caminho(655, 613, 1). caminho(655, 654, 1). caminho(655, 656, 1). 
caminho(656, 698, 1). caminho(656, 614, 1). caminho(656, 655, 1). caminho(656, 657, 1). 
caminho(657, 699, 1). caminho(657, 615, 1). caminho(657, 656, 1). caminho(657, 658, 1). 
caminho(658, 700, 1). caminho(658, 616, 1). caminho(658, 657, 1). caminho(658, 659, 1). 
caminho(659, 701, 1). caminho(659, 617, 1). caminho(659, 658, 1). caminho(659, 660, 1). 
caminho(660, 702, 1). caminho(660, 618, 1). caminho(660, 659, 1). caminho(660, 661, 1). 
caminho(661, 703, 1). caminho(661, 619, 1). caminho(661, 660, 1). caminho(661, 662, 1). 
caminho(662, 704, 1). caminho(662, 620, 1). caminho(662, 661, 1). caminho(662, 663, 1). 
caminho(663, 705, 1). caminho(663, 621, 1). caminho(663, 662, 1). caminho(663, 664, 1). 
caminho(664, 706, 1). caminho(664, 622, 1). caminho(664, 663, 1). caminho(664, 665, 1). 
caminho(665, 707, 1). caminho(665, 623, 1). caminho(665, 664, 1). caminho(665, 666, 1). 
caminho(666, 708, 1). caminho(666, 624, 1). caminho(666, 665, 1). caminho(666, 667, 1). 
caminho(667, 709, 1). caminho(667, 625, 1). caminho(667, 666, 1). caminho(667, 668, 1). 
caminho(668, 710, 1). caminho(668, 626, 1). caminho(668, 667, 1). caminho(668, 669, 1). 
caminho(669, 711, 1). caminho(669, 627, 1). caminho(669, 668, 1). caminho(669, 670, 1). 
caminho(670, 712, 1). caminho(670, 628, 1). caminho(670, 669, 1). caminho(670, 671, 1). 
caminho(671, 713, 1). caminho(671, 629, 1). caminho(671, 670, 1). caminho(671, 672, 1). 
caminho(672, 714, 1). caminho(672, 630, 1). caminho(672, 671, 1). 
caminho(673, 715, 1). caminho(673, 631, 1). caminho(673, 674, 1). 
caminho(674, 716, 1). caminho(674, 632, 1). caminho(674, 673, 1). caminho(674, 675, 1). 
caminho(675, 717, 1). caminho(675, 633, 1). caminho(675, 674, 1). caminho(675, 676, 1). 
caminho(676, 718, 1). caminho(676, 634, 1). caminho(676, 675, 1). caminho(676, 677, 1). 
caminho(677, 719, 1). caminho(677, 635, 1). caminho(677, 676, 1). caminho(677, 678, 1). 
caminho(678, 720, 1). caminho(678, 636, 1). caminho(678, 677, 1). caminho(678, 679, 1). 
caminho(679, 721, 1). caminho(679, 637, 1). caminho(679, 678, 1). caminho(679, 680, 1). 
caminho(680, 722, 1). caminho(680, 638, 1). caminho(680, 679, 1). caminho(680, 681, 1). 
caminho(681, 723, 1). caminho(681, 639, 1). caminho(681, 680, 1). caminho(681, 682, 1). 
caminho(682, 724, 1). caminho(682, 640, 1). caminho(682, 681, 1). caminho(682, 683, 1). 
caminho(683, 725, 1). caminho(683, 641, 1). caminho(683, 682, 1). caminho(683, 684, 1). 
caminho(684, 726, 1). caminho(684, 642, 1). caminho(684, 683, 1). caminho(684, 685, 1). 
caminho(685, 727, 1). caminho(685, 643, 1). caminho(685, 684, 1). caminho(685, 686, 1). 
caminho(686, 728, 1). caminho(686, 644, 1). caminho(686, 685, 1). caminho(686, 687, 1). 
caminho(687, 729, 1). caminho(687, 645, 1). caminho(687, 686, 1). caminho(687, 688, 1). 
caminho(688, 730, 1). caminho(688, 646, 1). caminho(688, 687, 1). caminho(688, 689, 1). 
caminho(689, 731, 1). caminho(689, 647, 1). caminho(689, 688, 1). caminho(689, 690, 1). 
caminho(690, 732, 1). caminho(690, 648, 1). caminho(690, 689, 1). caminho(690, 691, 1). 
caminho(691, 733, 1). caminho(691, 649, 1). caminho(691, 690, 1). caminho(691, 692, 1). 
caminho(692, 734, 1). caminho(692, 650, 1). caminho(692, 691, 1). caminho(692, 693, 1). 
caminho(693, 735, 1). caminho(693, 651, 1). caminho(693, 692, 1). caminho(693, 694, 1). 
caminho(694, 736, 1). caminho(694, 652, 1). caminho(694, 693, 1). caminho(694, 695, 1). 
caminho(695, 737, 1). caminho(695, 653, 1). caminho(695, 694, 1). caminho(695, 696, 1). 
caminho(696, 738, 1). caminho(696, 654, 1). caminho(696, 695, 1). caminho(696, 697, 1). 
caminho(697, 739, 1). caminho(697, 655, 1). caminho(697, 696, 1). caminho(697, 698, 1). 
caminho(698, 740, 1). caminho(698, 656, 1). caminho(698, 697, 1). caminho(698, 699, 1). 
caminho(699, 741, 1). caminho(699, 657, 1). caminho(699, 698, 1). caminho(699, 700, 1). 
caminho(700, 742, 1). caminho(700, 658, 1). caminho(700, 699, 1). caminho(700, 701, 1). 
caminho(701, 743, 1). caminho(701, 659, 1). caminho(701, 700, 1). caminho(701, 702, 1). 
caminho(702, 744, 1). caminho(702, 660, 1). caminho(702, 701, 1). caminho(702, 703, 1). 
caminho(703, 745, 1). caminho(703, 661, 1). caminho(703, 702, 1). caminho(703, 704, 1). 
caminho(704, 746, 1). caminho(704, 662, 1). caminho(704, 703, 1). caminho(704, 705, 1). 
caminho(705, 747, 1). caminho(705, 663, 1). caminho(705, 704, 1). caminho(705, 706, 1). 
caminho(706, 748, 1). caminho(706, 664, 1). caminho(706, 705, 1). caminho(706, 707, 1). 
caminho(707, 749, 1). caminho(707, 665, 1). caminho(707, 706, 1). caminho(707, 708, 1). 
caminho(708, 750, 1). caminho(708, 666, 1). caminho(708, 707, 1). caminho(708, 709, 1). 
caminho(709, 751, 1). caminho(709, 667, 1). caminho(709, 708, 1). caminho(709, 710, 1). 
caminho(710, 752, 1). caminho(710, 668, 1). caminho(710, 709, 1). caminho(710, 711, 1). 
caminho(711, 753, 1). caminho(711, 669, 1). caminho(711, 710, 1). caminho(711, 712, 1). 
caminho(712, 754, 1). caminho(712, 670, 1). caminho(712, 711, 1). caminho(712, 713, 1). 
caminho(713, 755, 1). caminho(713, 671, 1). caminho(713, 712, 1). caminho(713, 714, 1). 
caminho(714, 756, 1). caminho(714, 672, 1). caminho(714, 713, 1). 
caminho(715, 757, 1). caminho(715, 673, 1). caminho(715, 716, 1). 
caminho(716, 758, 1). caminho(716, 674, 1). caminho(716, 715, 1). caminho(716, 717, 1). 
caminho(717, 759, 1). caminho(717, 675, 1). caminho(717, 716, 1). caminho(717, 718, 1). 
caminho(718, 760, 1). caminho(718, 676, 1). caminho(718, 717, 1). caminho(718, 719, 1). 
caminho(719, 761, 1). caminho(719, 677, 1). caminho(719, 718, 1). caminho(719, 720, 1). 
caminho(720, 762, 1). caminho(720, 678, 1). caminho(720, 719, 1). caminho(720, 721, 1). 
caminho(721, 763, 1). caminho(721, 679, 1). caminho(721, 720, 1). caminho(721, 722, 1). 
caminho(722, 764, 1). caminho(722, 680, 1). caminho(722, 721, 1). caminho(722, 723, 1). 
caminho(723, 765, 1). caminho(723, 681, 1). caminho(723, 722, 1). caminho(723, 724, 1). 
caminho(724, 766, 1). caminho(724, 682, 1). caminho(724, 723, 1). caminho(724, 725, 1). 
caminho(725, 767, 1). caminho(725, 683, 1). caminho(725, 724, 1). caminho(725, 726, 1). 
caminho(726, 768, 1). caminho(726, 684, 1). caminho(726, 725, 1). caminho(726, 727, 1). 
caminho(727, 769, 1). caminho(727, 685, 1). caminho(727, 726, 1). caminho(727, 728, 1). 
caminho(728, 770, 1). caminho(728, 686, 1). caminho(728, 727, 1). caminho(728, 729, 1). 
caminho(729, 771, 1). caminho(729, 687, 1). caminho(729, 728, 1). caminho(729, 730, 1). 
caminho(730, 772, 1). caminho(730, 688, 1). caminho(730, 729, 1). caminho(730, 731, 1). 
caminho(731, 773, 1). caminho(731, 689, 1). caminho(731, 730, 1). caminho(731, 732, 1). 
caminho(732, 774, 1). caminho(732, 690, 1). caminho(732, 731, 1). caminho(732, 733, 1). 
caminho(733, 775, 1). caminho(733, 691, 1). caminho(733, 732, 1). caminho(733, 734, 1). 
caminho(734, 776, 1). caminho(734, 692, 1). caminho(734, 733, 1). caminho(734, 735, 1). 
caminho(735, 777, 1). caminho(735, 693, 1). caminho(735, 734, 1). caminho(735, 736, 1). 
caminho(736, 778, 1). caminho(736, 694, 1). caminho(736, 735, 1). caminho(736, 737, 1). 
caminho(737, 779, 1). caminho(737, 695, 1). caminho(737, 736, 1). caminho(737, 738, 1). 
caminho(738, 780, 1). caminho(738, 696, 1). caminho(738, 737, 1). caminho(738, 739, 1). 
caminho(739, 781, 1). caminho(739, 697, 1). caminho(739, 738, 1). caminho(739, 740, 1). 
caminho(740, 782, 1). caminho(740, 698, 1). caminho(740, 739, 1). caminho(740, 741, 1). 
caminho(741, 783, 1). caminho(741, 699, 1). caminho(741, 740, 1). caminho(741, 742, 1). 
caminho(742, 784, 1). caminho(742, 700, 1). caminho(742, 741, 1). caminho(742, 743, 1). 
caminho(743, 785, 1). caminho(743, 701, 1). caminho(743, 742, 1). caminho(743, 744, 1). 
caminho(744, 786, 1). caminho(744, 702, 1). caminho(744, 743, 1). caminho(744, 745, 1). 
caminho(745, 787, 1). caminho(745, 703, 1). caminho(745, 744, 1). caminho(745, 746, 1). 
caminho(746, 788, 1). caminho(746, 704, 1). caminho(746, 745, 1). caminho(746, 747, 1). 
caminho(747, 789, 1). caminho(747, 705, 1). caminho(747, 746, 1). caminho(747, 748, 1). 
caminho(748, 790, 1). caminho(748, 706, 1). caminho(748, 747, 1). caminho(748, 749, 1). 
caminho(749, 791, 1). caminho(749, 707, 1). caminho(749, 748, 1). caminho(749, 750, 1). 
caminho(750, 792, 1). caminho(750, 708, 1). caminho(750, 749, 1). caminho(750, 751, 1). 
caminho(751, 793, 1). caminho(751, 709, 1). caminho(751, 750, 1). caminho(751, 752, 1). 
caminho(752, 794, 1). caminho(752, 710, 1). caminho(752, 751, 1). caminho(752, 753, 1). 
caminho(753, 795, 1). caminho(753, 711, 1). caminho(753, 752, 1). caminho(753, 754, 1). 
caminho(754, 796, 1). caminho(754, 712, 1). caminho(754, 753, 1). caminho(754, 755, 1). 
caminho(755, 797, 1). caminho(755, 713, 1). caminho(755, 754, 1). caminho(755, 756, 1). 
caminho(756, 798, 1). caminho(756, 714, 1). caminho(756, 755, 1). 
caminho(757, 799, 1). caminho(757, 715, 1). caminho(757, 758, 1). 
caminho(758, 800, 1). caminho(758, 716, 1). caminho(758, 757, 1). caminho(758, 759, 1). 
caminho(759, 801, 1). caminho(759, 717, 1). caminho(759, 758, 1). caminho(759, 760, 1). 
caminho(760, 802, 1). caminho(760, 718, 1). caminho(760, 759, 1). caminho(760, 761, 1). 
caminho(761, 803, 1). caminho(761, 719, 1). caminho(761, 760, 1). caminho(761, 762, 1). 
caminho(762, 804, 1). caminho(762, 720, 1). caminho(762, 761, 1). caminho(762, 763, 1). 
caminho(763, 805, 1). caminho(763, 721, 1). caminho(763, 762, 1). caminho(763, 764, 1). 
caminho(764, 806, 1). caminho(764, 722, 1). caminho(764, 763, 1). caminho(764, 765, 1). 
caminho(765, 807, 1). caminho(765, 723, 1). caminho(765, 764, 1). caminho(765, 766, 1). 
caminho(766, 808, 1). caminho(766, 724, 1). caminho(766, 765, 1). caminho(766, 767, 1). 
caminho(767, 809, 1). caminho(767, 725, 1). caminho(767, 766, 1). caminho(767, 768, 1). 
caminho(768, 810, 1). caminho(768, 726, 1). caminho(768, 767, 1). caminho(768, 769, 1). 
caminho(769, 811, 1). caminho(769, 727, 1). caminho(769, 768, 1). caminho(769, 770, 1). 
caminho(770, 812, 1). caminho(770, 728, 1). caminho(770, 769, 1). caminho(770, 771, 1). 
caminho(771, 813, 1). caminho(771, 729, 1). caminho(771, 770, 1). caminho(771, 772, 1). 
caminho(772, 814, 1). caminho(772, 730, 1). caminho(772, 771, 1). caminho(772, 773, 1). 
caminho(773, 815, 1). caminho(773, 731, 1). caminho(773, 772, 1). caminho(773, 774, 1). 
caminho(774, 816, 1). caminho(774, 732, 1). caminho(774, 773, 1). caminho(774, 775, 1). 
caminho(775, 817, 1). caminho(775, 733, 1). caminho(775, 774, 1). caminho(775, 776, 1). 
caminho(776, 818, 1). caminho(776, 734, 1). caminho(776, 775, 1). caminho(776, 777, 1). 
caminho(777, 819, 1). caminho(777, 735, 1). caminho(777, 776, 1). caminho(777, 778, 1). 
caminho(778, 820, 1). caminho(778, 736, 1). caminho(778, 777, 1). caminho(778, 779, 1). 
caminho(779, 821, 1). caminho(779, 737, 1). caminho(779, 778, 1). caminho(779, 780, 1). 
caminho(780, 822, 1). caminho(780, 738, 1). caminho(780, 779, 1). caminho(780, 781, 1). 
caminho(781, 823, 1). caminho(781, 739, 1). caminho(781, 780, 1). caminho(781, 782, 1). 
caminho(782, 824, 1). caminho(782, 740, 1). caminho(782, 781, 1). caminho(782, 783, 1). 
caminho(783, 825, 1). caminho(783, 741, 1). caminho(783, 782, 1). caminho(783, 784, 1). 
caminho(784, 826, 1). caminho(784, 742, 1). caminho(784, 783, 1). caminho(784, 785, 1). 
caminho(785, 827, 1). caminho(785, 743, 1). caminho(785, 784, 1). caminho(785, 786, 1). 
caminho(786, 828, 1). caminho(786, 744, 1). caminho(786, 785, 1). caminho(786, 787, 1). 
caminho(787, 829, 1). caminho(787, 745, 1). caminho(787, 786, 1). caminho(787, 788, 1). 
caminho(788, 830, 1). caminho(788, 746, 1). caminho(788, 787, 1). caminho(788, 789, 1). 
caminho(789, 831, 1). caminho(789, 747, 1). caminho(789, 788, 1). caminho(789, 790, 1). 
caminho(790, 832, 1). caminho(790, 748, 1). caminho(790, 789, 1). caminho(790, 791, 1). 
caminho(791, 833, 1). caminho(791, 749, 1). caminho(791, 790, 1). caminho(791, 792, 1). 
caminho(792, 834, 1). caminho(792, 750, 1). caminho(792, 791, 1). caminho(792, 793, 1). 
caminho(793, 835, 1). caminho(793, 751, 1). caminho(793, 792, 1). caminho(793, 794, 1). 
caminho(794, 836, 1). caminho(794, 752, 1). caminho(794, 793, 1). caminho(794, 795, 1). 
caminho(795, 837, 1). caminho(795, 753, 1). caminho(795, 794, 1). caminho(795, 796, 1). 
caminho(796, 838, 1). caminho(796, 754, 1). caminho(796, 795, 1). caminho(796, 797, 1). 
caminho(797, 839, 1). caminho(797, 755, 1). caminho(797, 796, 1). caminho(797, 798, 1). 
caminho(798, 840, 1). caminho(798, 756, 1). caminho(798, 797, 1). 
caminho(799, 841, 1). caminho(799, 757, 1). caminho(799, 800, 1). 
caminho(800, 842, 1). caminho(800, 758, 1). caminho(800, 799, 1). caminho(800, 801, 1). 
caminho(801, 843, 1). caminho(801, 759, 1). caminho(801, 800, 1). caminho(801, 802, 1). 
caminho(802, 844, 1). caminho(802, 760, 1). caminho(802, 801, 1). caminho(802, 803, 1). 
caminho(803, 845, 1). caminho(803, 761, 1). caminho(803, 802, 1). caminho(803, 804, 1). 
caminho(804, 846, 1). caminho(804, 762, 1). caminho(804, 803, 1). caminho(804, 805, 1). 
caminho(805, 847, 1). caminho(805, 763, 1). caminho(805, 804, 1). caminho(805, 806, 1). 
caminho(806, 848, 1). caminho(806, 764, 1). caminho(806, 805, 1). caminho(806, 807, 1). 
caminho(807, 849, 1). caminho(807, 765, 1). caminho(807, 806, 1). caminho(807, 808, 1). 
caminho(808, 850, 1). caminho(808, 766, 1). caminho(808, 807, 1). caminho(808, 809, 1). 
caminho(809, 851, 1). caminho(809, 767, 1). caminho(809, 808, 1). caminho(809, 810, 1). 
caminho(810, 852, 1). caminho(810, 768, 1). caminho(810, 809, 1). caminho(810, 811, 1). 
caminho(811, 853, 1). caminho(811, 769, 1). caminho(811, 810, 1). caminho(811, 812, 1). 
caminho(812, 854, 1). caminho(812, 770, 1). caminho(812, 811, 1). caminho(812, 813, 1). 
caminho(813, 855, 1). caminho(813, 771, 1). caminho(813, 812, 1). caminho(813, 814, 1). 
caminho(814, 856, 1). caminho(814, 772, 1). caminho(814, 813, 1). caminho(814, 815, 1). 
caminho(815, 857, 1). caminho(815, 773, 1). caminho(815, 814, 1). caminho(815, 816, 1). 
caminho(816, 858, 1). caminho(816, 774, 1). caminho(816, 815, 1). caminho(816, 817, 1). 
caminho(817, 859, 1). caminho(817, 775, 1). caminho(817, 816, 1). caminho(817, 818, 1). 
caminho(818, 860, 1). caminho(818, 776, 1). caminho(818, 817, 1). caminho(818, 819, 1). 
caminho(819, 861, 1). caminho(819, 777, 1). caminho(819, 818, 1). caminho(819, 820, 1). 
caminho(820, 862, 1). caminho(820, 778, 1). caminho(820, 819, 1). caminho(820, 821, 1). 
caminho(821, 863, 1). caminho(821, 779, 1). caminho(821, 820, 1). caminho(821, 822, 1). 
caminho(822, 864, 1). caminho(822, 780, 1). caminho(822, 821, 1). caminho(822, 823, 1). 
caminho(823, 865, 1). caminho(823, 781, 1). caminho(823, 822, 1). caminho(823, 824, 1). 
caminho(824, 866, 1). caminho(824, 782, 1). caminho(824, 823, 1). caminho(824, 825, 1). 
caminho(825, 867, 1). caminho(825, 783, 1). caminho(825, 824, 1). caminho(825, 826, 1). 
caminho(826, 868, 1). caminho(826, 784, 1). caminho(826, 825, 1). caminho(826, 827, 1). 
caminho(827, 869, 1). caminho(827, 785, 1). caminho(827, 826, 1). caminho(827, 828, 1). 
caminho(828, 870, 1). caminho(828, 786, 1). caminho(828, 827, 1). caminho(828, 829, 1). 
caminho(829, 871, 1). caminho(829, 787, 1). caminho(829, 828, 1). caminho(829, 830, 1). 
caminho(830, 872, 1). caminho(830, 788, 1). caminho(830, 829, 1). caminho(830, 831, 1). 
caminho(831, 873, 1). caminho(831, 789, 1). caminho(831, 830, 1). caminho(831, 832, 1). 
caminho(832, 874, 1). caminho(832, 790, 1). caminho(832, 831, 1). caminho(832, 833, 1). 
caminho(833, 875, 1). caminho(833, 791, 1). caminho(833, 832, 1). caminho(833, 834, 1). 
caminho(834, 876, 1). caminho(834, 792, 1). caminho(834, 833, 1). caminho(834, 835, 1). 
caminho(835, 877, 1). caminho(835, 793, 1). caminho(835, 834, 1). caminho(835, 836, 1). 
caminho(836, 878, 1). caminho(836, 794, 1). caminho(836, 835, 1). caminho(836, 837, 1). 
caminho(837, 879, 1). caminho(837, 795, 1). caminho(837, 836, 1). caminho(837, 838, 1). 
caminho(838, 880, 1). caminho(838, 796, 1). caminho(838, 837, 1). caminho(838, 839, 1). 
caminho(839, 881, 1). caminho(839, 797, 1). caminho(839, 838, 1). caminho(839, 840, 1). 
caminho(840, 882, 1). caminho(840, 798, 1). caminho(840, 839, 1). 
caminho(841, 883, 1). caminho(841, 799, 1). caminho(841, 842, 1). 
caminho(842, 884, 1). caminho(842, 800, 1). caminho(842, 841, 1). caminho(842, 843, 1). 
caminho(843, 885, 1). caminho(843, 801, 1). caminho(843, 842, 1). caminho(843, 844, 1). 
caminho(844, 886, 1). caminho(844, 802, 1). caminho(844, 843, 1). caminho(844, 845, 1). 
caminho(845, 887, 1). caminho(845, 803, 1). caminho(845, 844, 1). caminho(845, 846, 1). 
caminho(846, 888, 1). caminho(846, 804, 1). caminho(846, 845, 1). caminho(846, 847, 1). 
caminho(847, 889, 1). caminho(847, 805, 1). caminho(847, 846, 1). caminho(847, 848, 1). 
caminho(848, 890, 1). caminho(848, 806, 1). caminho(848, 847, 1). caminho(848, 849, 1). 
caminho(849, 891, 1). caminho(849, 807, 1). caminho(849, 848, 1). caminho(849, 850, 1). 
caminho(850, 892, 1). caminho(850, 808, 1). caminho(850, 849, 1). caminho(850, 851, 1). 
caminho(851, 893, 1). caminho(851, 809, 1). caminho(851, 850, 1). caminho(851, 852, 1). 
caminho(852, 894, 1). caminho(852, 810, 1). caminho(852, 851, 1). caminho(852, 853, 1). 
caminho(853, 895, 1). caminho(853, 811, 1). caminho(853, 852, 1). caminho(853, 854, 1). 
caminho(854, 896, 1). caminho(854, 812, 1). caminho(854, 853, 1). caminho(854, 855, 1). 
caminho(855, 897, 1). caminho(855, 813, 1). caminho(855, 854, 1). caminho(855, 856, 1). 
caminho(856, 898, 1). caminho(856, 814, 1). caminho(856, 855, 1). caminho(856, 857, 1). 
caminho(857, 899, 1). caminho(857, 815, 1). caminho(857, 856, 1). caminho(857, 858, 1). 
caminho(858, 900, 1). caminho(858, 816, 1). caminho(858, 857, 1). caminho(858, 859, 1). 
caminho(859, 901, 1). caminho(859, 817, 1). caminho(859, 858, 1). caminho(859, 860, 1). 
caminho(860, 902, 1). caminho(860, 818, 1). caminho(860, 859, 1). caminho(860, 861, 1). 
caminho(861, 903, 1). caminho(861, 819, 1). caminho(861, 860, 1). caminho(861, 862, 1). 
caminho(862, 904, 1). caminho(862, 820, 1). caminho(862, 861, 1). caminho(862, 863, 1). 
caminho(863, 905, 1). caminho(863, 821, 1). caminho(863, 862, 1). caminho(863, 864, 1). 
caminho(864, 906, 1). caminho(864, 822, 1). caminho(864, 863, 1). caminho(864, 865, 1). 
caminho(865, 907, 1). caminho(865, 823, 1). caminho(865, 864, 1). caminho(865, 866, 1). 
caminho(866, 908, 1). caminho(866, 824, 1). caminho(866, 865, 1). caminho(866, 867, 1). 
caminho(867, 909, 1). caminho(867, 825, 1). caminho(867, 866, 1). caminho(867, 868, 1). 
caminho(868, 910, 1). caminho(868, 826, 1). caminho(868, 867, 1). caminho(868, 869, 1). 
caminho(869, 911, 1). caminho(869, 827, 1). caminho(869, 868, 1). caminho(869, 870, 1). 
caminho(870, 912, 1). caminho(870, 828, 1). caminho(870, 869, 1). caminho(870, 871, 1). 
caminho(871, 913, 1). caminho(871, 829, 1). caminho(871, 870, 1). caminho(871, 872, 1). 
caminho(872, 914, 1). caminho(872, 830, 1). caminho(872, 871, 1). caminho(872, 873, 1). 
caminho(873, 915, 1). caminho(873, 831, 1). caminho(873, 872, 1). caminho(873, 874, 1). 
caminho(874, 916, 1). caminho(874, 832, 1). caminho(874, 873, 1). caminho(874, 875, 1). 
caminho(875, 917, 1). caminho(875, 833, 1). caminho(875, 874, 1). caminho(875, 876, 1). 
caminho(876, 918, 1). caminho(876, 834, 1). caminho(876, 875, 1). caminho(876, 877, 1). 
caminho(877, 919, 1). caminho(877, 835, 1). caminho(877, 876, 1). caminho(877, 878, 1). 
caminho(878, 920, 1). caminho(878, 836, 1). caminho(878, 877, 1). caminho(878, 879, 1). 
caminho(879, 921, 1). caminho(879, 837, 1). caminho(879, 878, 1). caminho(879, 880, 1). 
caminho(880, 922, 1). caminho(880, 838, 1). caminho(880, 879, 1). caminho(880, 881, 1). 
caminho(881, 923, 1). caminho(881, 839, 1). caminho(881, 880, 1). caminho(881, 882, 1). 
caminho(882, 924, 1). caminho(882, 840, 1). caminho(882, 881, 1). 
caminho(883, 925, 1). caminho(883, 841, 1). caminho(883, 884, 1). 
caminho(884, 926, 1). caminho(884, 842, 1). caminho(884, 883, 1). caminho(884, 885, 1). 
caminho(885, 927, 1). caminho(885, 843, 1). caminho(885, 884, 1). caminho(885, 886, 1). 
caminho(886, 928, 1). caminho(886, 844, 1). caminho(886, 885, 1). caminho(886, 887, 1). 
caminho(887, 929, 1). caminho(887, 845, 1). caminho(887, 886, 1). caminho(887, 888, 1). 
caminho(888, 930, 1). caminho(888, 846, 1). caminho(888, 887, 1). caminho(888, 889, 1). 
caminho(889, 931, 1). caminho(889, 847, 1). caminho(889, 888, 1). caminho(889, 890, 1). 
caminho(890, 932, 1). caminho(890, 848, 1). caminho(890, 889, 1). caminho(890, 891, 1). 
caminho(891, 933, 1). caminho(891, 849, 1). caminho(891, 890, 1). caminho(891, 892, 1). 
caminho(892, 934, 1). caminho(892, 850, 1). caminho(892, 891, 1). caminho(892, 893, 1). 
caminho(893, 935, 1). caminho(893, 851, 1). caminho(893, 892, 1). caminho(893, 894, 1). 
caminho(894, 936, 1). caminho(894, 852, 1). caminho(894, 893, 1). caminho(894, 895, 1). 
caminho(895, 937, 1). caminho(895, 853, 1). caminho(895, 894, 1). caminho(895, 896, 1). 
caminho(896, 938, 1). caminho(896, 854, 1). caminho(896, 895, 1). caminho(896, 897, 1). 
caminho(897, 939, 1). caminho(897, 855, 1). caminho(897, 896, 1). caminho(897, 898, 1). 
caminho(898, 940, 1). caminho(898, 856, 1). caminho(898, 897, 1). caminho(898, 899, 1). 
caminho(899, 941, 1). caminho(899, 857, 1). caminho(899, 898, 1). caminho(899, 900, 1). 
caminho(900, 942, 1). caminho(900, 858, 1). caminho(900, 899, 1). caminho(900, 901, 1). 
caminho(901, 943, 1). caminho(901, 859, 1). caminho(901, 900, 1). caminho(901, 902, 1). 
caminho(902, 944, 1). caminho(902, 860, 1). caminho(902, 901, 1). caminho(902, 903, 1). 
caminho(903, 945, 1). caminho(903, 861, 1). caminho(903, 902, 1). caminho(903, 904, 1). 
caminho(904, 946, 1). caminho(904, 862, 1). caminho(904, 903, 1). caminho(904, 905, 1). 
caminho(905, 947, 1). caminho(905, 863, 1). caminho(905, 904, 1). caminho(905, 906, 1). 
caminho(906, 948, 1). caminho(906, 864, 1). caminho(906, 905, 1). caminho(906, 907, 1). 
caminho(907, 949, 1). caminho(907, 865, 1). caminho(907, 906, 1). caminho(907, 908, 1). 
caminho(908, 950, 1). caminho(908, 866, 1). caminho(908, 907, 1). caminho(908, 909, 1). 
caminho(909, 951, 1). caminho(909, 867, 1). caminho(909, 908, 1). caminho(909, 910, 1). 
caminho(910, 952, 1). caminho(910, 868, 1). caminho(910, 909, 1). caminho(910, 911, 1). 
caminho(911, 953, 1). caminho(911, 869, 1). caminho(911, 910, 1). caminho(911, 912, 1). 
caminho(912, 954, 1). caminho(912, 870, 1). caminho(912, 911, 1). caminho(912, 913, 1). 
caminho(913, 955, 1). caminho(913, 871, 1). caminho(913, 912, 1). caminho(913, 914, 1). 
caminho(914, 956, 1). caminho(914, 872, 1). caminho(914, 913, 1). caminho(914, 915, 1). 
caminho(915, 957, 1). caminho(915, 873, 1). caminho(915, 914, 1). caminho(915, 916, 1). 
caminho(916, 958, 1). caminho(916, 874, 1). caminho(916, 915, 1). caminho(916, 917, 1). 
caminho(917, 959, 1). caminho(917, 875, 1). caminho(917, 916, 1). caminho(917, 918, 1). 
caminho(918, 960, 1). caminho(918, 876, 1). caminho(918, 917, 1). caminho(918, 919, 1). 
caminho(919, 961, 1). caminho(919, 877, 1). caminho(919, 918, 1). caminho(919, 920, 1). 
caminho(920, 962, 1). caminho(920, 878, 1). caminho(920, 919, 1). caminho(920, 921, 1). 
caminho(921, 963, 1). caminho(921, 879, 1). caminho(921, 920, 1). caminho(921, 922, 1). 
caminho(922, 964, 1). caminho(922, 880, 1). caminho(922, 921, 1). caminho(922, 923, 1). 
caminho(923, 965, 1). caminho(923, 881, 1). caminho(923, 922, 1). caminho(923, 924, 1). 
caminho(924, 966, 1). caminho(924, 882, 1). caminho(924, 923, 1). 
caminho(925, 967, 1). caminho(925, 883, 1). caminho(925, 926, 1). 
caminho(926, 968, 1). caminho(926, 884, 1). caminho(926, 925, 1). caminho(926, 927, 1). 
caminho(927, 969, 1). caminho(927, 885, 1). caminho(927, 926, 1). caminho(927, 928, 1). 
caminho(928, 970, 1). caminho(928, 886, 1). caminho(928, 927, 1). caminho(928, 929, 1). 
caminho(929, 971, 1). caminho(929, 887, 1). caminho(929, 928, 1). caminho(929, 930, 1). 
caminho(930, 972, 1). caminho(930, 888, 1). caminho(930, 929, 1). caminho(930, 931, 1). 
caminho(931, 973, 1). caminho(931, 889, 1). caminho(931, 930, 1). caminho(931, 932, 1). 
caminho(932, 974, 1). caminho(932, 890, 1). caminho(932, 931, 1). caminho(932, 933, 1). 
caminho(933, 975, 1). caminho(933, 891, 1). caminho(933, 932, 1). caminho(933, 934, 1). 
caminho(934, 976, 1). caminho(934, 892, 1). caminho(934, 933, 1). caminho(934, 935, 1). 
caminho(935, 977, 1). caminho(935, 893, 1). caminho(935, 934, 1). caminho(935, 936, 1). 
caminho(936, 978, 1). caminho(936, 894, 1). caminho(936, 935, 1). caminho(936, 937, 1). 
caminho(937, 979, 1). caminho(937, 895, 1). caminho(937, 936, 1). caminho(937, 938, 1). 
caminho(938, 980, 1). caminho(938, 896, 1). caminho(938, 937, 1). caminho(938, 939, 1). 
caminho(939, 981, 1). caminho(939, 897, 1). caminho(939, 938, 1). caminho(939, 940, 1). 
caminho(940, 982, 1). caminho(940, 898, 1). caminho(940, 939, 1). caminho(940, 941, 1). 
caminho(941, 983, 1). caminho(941, 899, 1). caminho(941, 940, 1). caminho(941, 942, 1). 
caminho(942, 984, 1). caminho(942, 900, 1). caminho(942, 941, 1). caminho(942, 943, 1). 
caminho(943, 985, 1). caminho(943, 901, 1). caminho(943, 942, 1). caminho(943, 944, 1). 
caminho(944, 986, 1). caminho(944, 902, 1). caminho(944, 943, 1). caminho(944, 945, 1). 
caminho(945, 987, 1). caminho(945, 903, 1). caminho(945, 944, 1). caminho(945, 946, 1). 
caminho(946, 988, 1). caminho(946, 904, 1). caminho(946, 945, 1). caminho(946, 947, 1). 
caminho(947, 989, 1). caminho(947, 905, 1). caminho(947, 946, 1). caminho(947, 948, 1). 
caminho(948, 990, 1). caminho(948, 906, 1). caminho(948, 947, 1). caminho(948, 949, 1). 
caminho(949, 991, 1). caminho(949, 907, 1). caminho(949, 948, 1). caminho(949, 950, 1). 
caminho(950, 992, 1). caminho(950, 908, 1). caminho(950, 949, 1). caminho(950, 951, 1). 
caminho(951, 993, 1). caminho(951, 909, 1). caminho(951, 950, 1). caminho(951, 952, 1). 
caminho(952, 994, 1). caminho(952, 910, 1). caminho(952, 951, 1). caminho(952, 953, 1). 
caminho(953, 995, 1). caminho(953, 911, 1). caminho(953, 952, 1). caminho(953, 954, 1). 
caminho(954, 996, 1). caminho(954, 912, 1). caminho(954, 953, 1). caminho(954, 955, 1). 
caminho(955, 997, 1). caminho(955, 913, 1). caminho(955, 954, 1). caminho(955, 956, 1). 
caminho(956, 998, 1). caminho(956, 914, 1). caminho(956, 955, 1). caminho(956, 957, 1). 
caminho(957, 999, 1). caminho(957, 915, 1). caminho(957, 956, 1). caminho(957, 958, 1). 
caminho(958, 1000, 1). caminho(958, 916, 1). caminho(958, 957, 1). caminho(958, 959, 1). 
caminho(959, 1001, 1). caminho(959, 917, 1). caminho(959, 958, 1). caminho(959, 960, 1). 
caminho(960, 1002, 1). caminho(960, 918, 1). caminho(960, 959, 1). caminho(960, 961, 1). 
caminho(961, 1003, 1). caminho(961, 919, 1). caminho(961, 960, 1). caminho(961, 962, 1). 
caminho(962, 1004, 1). caminho(962, 920, 1). caminho(962, 961, 1). caminho(962, 963, 1). 
caminho(963, 1005, 1). caminho(963, 921, 1). caminho(963, 962, 1). caminho(963, 964, 1). 
caminho(964, 1006, 1). caminho(964, 922, 1). caminho(964, 963, 1). caminho(964, 965, 1). 
caminho(965, 1007, 1). caminho(965, 923, 1). caminho(965, 964, 1). caminho(965, 966, 1). 
caminho(966, 1008, 1). caminho(966, 924, 1). caminho(966, 965, 1). 
caminho(967, 1009, 1). caminho(967, 925, 1). caminho(967, 968, 1). 
caminho(968, 1010, 1). caminho(968, 926, 1). caminho(968, 967, 1). caminho(968, 969, 1). 
caminho(969, 1011, 1). caminho(969, 927, 1). caminho(969, 968, 1). caminho(969, 970, 1). 
caminho(970, 1012, 1). caminho(970, 928, 1). caminho(970, 969, 1). caminho(970, 971, 1). 
caminho(971, 1013, 1). caminho(971, 929, 1). caminho(971, 970, 1). caminho(971, 972, 1). 
caminho(972, 1014, 1). caminho(972, 930, 1). caminho(972, 971, 1). caminho(972, 973, 1). 
caminho(973, 1015, 1). caminho(973, 931, 1). caminho(973, 972, 1). caminho(973, 974, 1). 
caminho(974, 1016, 1). caminho(974, 932, 1). caminho(974, 973, 1). caminho(974, 975, 1). 
caminho(975, 1017, 1). caminho(975, 933, 1). caminho(975, 974, 1). caminho(975, 976, 1). 
caminho(976, 1018, 1). caminho(976, 934, 1). caminho(976, 975, 1). caminho(976, 977, 1). 
caminho(977, 1019, 1). caminho(977, 935, 1). caminho(977, 976, 1). caminho(977, 978, 1). 
caminho(978, 1020, 1). caminho(978, 936, 1). caminho(978, 977, 1). caminho(978, 979, 1). 
caminho(979, 1021, 1). caminho(979, 937, 1). caminho(979, 978, 1). caminho(979, 980, 1). 
caminho(980, 1022, 1). caminho(980, 938, 1). caminho(980, 979, 1). caminho(980, 981, 1). 
caminho(981, 1023, 1). caminho(981, 939, 1). caminho(981, 980, 1). caminho(981, 982, 1). 
caminho(982, 1024, 1). caminho(982, 940, 1). caminho(982, 981, 1). caminho(982, 983, 1). 
caminho(983, 1025, 1). caminho(983, 941, 1). caminho(983, 982, 1). caminho(983, 984, 1). 
caminho(984, 1026, 1). caminho(984, 942, 1). caminho(984, 983, 1). caminho(984, 985, 1). 
caminho(985, 1027, 1). caminho(985, 943, 1). caminho(985, 984, 1). caminho(985, 986, 1). 
caminho(986, 1028, 1). caminho(986, 944, 1). caminho(986, 985, 1). caminho(986, 987, 1). 
caminho(987, 1029, 1). caminho(987, 945, 1). caminho(987, 986, 1). caminho(987, 988, 1). 
caminho(988, 1030, 1). caminho(988, 946, 1). caminho(988, 987, 1). caminho(988, 989, 1). 
caminho(989, 1031, 1). caminho(989, 947, 1). caminho(989, 988, 1). caminho(989, 990, 1). 
caminho(990, 1032, 1). caminho(990, 948, 1). caminho(990, 989, 1). caminho(990, 991, 1). 
caminho(991, 1033, 1). caminho(991, 949, 1). caminho(991, 990, 1). caminho(991, 992, 1). 
caminho(992, 1034, 1). caminho(992, 950, 1). caminho(992, 991, 1). caminho(992, 993, 1). 
caminho(993, 1035, 1). caminho(993, 951, 1). caminho(993, 992, 1). caminho(993, 994, 1). 
caminho(994, 1036, 1). caminho(994, 952, 1). caminho(994, 993, 1). caminho(994, 995, 1). 
caminho(995, 1037, 1). caminho(995, 953, 1). caminho(995, 994, 1). caminho(995, 996, 1). 
caminho(996, 1038, 1). caminho(996, 954, 1). caminho(996, 995, 1). caminho(996, 997, 1). 
caminho(997, 1039, 1). caminho(997, 955, 1). caminho(997, 996, 1). caminho(997, 998, 1). 
caminho(998, 1040, 1). caminho(998, 956, 1). caminho(998, 997, 1). caminho(998, 999, 1). 
caminho(999, 1041, 1). caminho(999, 957, 1). caminho(999, 998, 1). caminho(999, 1000, 1). 
caminho(1000, 1042, 1). caminho(1000, 958, 1). caminho(1000, 999, 1). caminho(1000, 1001, 1). 
caminho(1001, 1043, 1). caminho(1001, 959, 1). caminho(1001, 1000, 1). caminho(1001, 1002, 1). 
caminho(1002, 1044, 1). caminho(1002, 960, 1). caminho(1002, 1001, 1). caminho(1002, 1003, 1). 
caminho(1003, 1045, 1). caminho(1003, 961, 1). caminho(1003, 1002, 1). caminho(1003, 1004, 1). 
caminho(1004, 1046, 1). caminho(1004, 962, 1). caminho(1004, 1003, 1). caminho(1004, 1005, 1). 
caminho(1005, 1047, 1). caminho(1005, 963, 1). caminho(1005, 1004, 1). caminho(1005, 1006, 1). 
caminho(1006, 1048, 1). caminho(1006, 964, 1). caminho(1006, 1005, 1). caminho(1006, 1007, 1). 
caminho(1007, 1049, 1). caminho(1007, 965, 1). caminho(1007, 1006, 1). caminho(1007, 1008, 1). 
caminho(1008, 1050, 1). caminho(1008, 966, 1). caminho(1008, 1007, 1). 
caminho(1009, 1051, 1). caminho(1009, 967, 1). caminho(1009, 1010, 1). 
caminho(1010, 1052, 1). caminho(1010, 968, 1). caminho(1010, 1009, 1). caminho(1010, 1011, 1). 
caminho(1011, 1053, 1). caminho(1011, 969, 1). caminho(1011, 1010, 1). caminho(1011, 1012, 1). 
caminho(1012, 1054, 1). caminho(1012, 970, 1). caminho(1012, 1011, 1). caminho(1012, 1013, 1). 
caminho(1013, 1055, 1). caminho(1013, 971, 1). caminho(1013, 1012, 1). caminho(1013, 1014, 1). 
caminho(1014, 1056, 1). caminho(1014, 972, 1). caminho(1014, 1013, 1). caminho(1014, 1015, 1). 
caminho(1015, 1057, 1). caminho(1015, 973, 1). caminho(1015, 1014, 1). caminho(1015, 1016, 1). 
caminho(1016, 1058, 1). caminho(1016, 974, 1). caminho(1016, 1015, 1). caminho(1016, 1017, 1). 
caminho(1017, 1059, 1). caminho(1017, 975, 1). caminho(1017, 1016, 1). caminho(1017, 1018, 1). 
caminho(1018, 1060, 1). caminho(1018, 976, 1). caminho(1018, 1017, 1). caminho(1018, 1019, 1). 
caminho(1019, 1061, 1). caminho(1019, 977, 1). caminho(1019, 1018, 1). caminho(1019, 1020, 1). 
caminho(1020, 1062, 1). caminho(1020, 978, 1). caminho(1020, 1019, 1). caminho(1020, 1021, 1). 
caminho(1021, 1063, 1). caminho(1021, 979, 1). caminho(1021, 1020, 1). caminho(1021, 1022, 1). 
caminho(1022, 1064, 1). caminho(1022, 980, 1). caminho(1022, 1021, 1). caminho(1022, 1023, 1). 
caminho(1023, 1065, 1). caminho(1023, 981, 1). caminho(1023, 1022, 1). caminho(1023, 1024, 1). 
caminho(1024, 1066, 1). caminho(1024, 982, 1). caminho(1024, 1023, 1). caminho(1024, 1025, 1). 
caminho(1025, 1067, 1). caminho(1025, 983, 1). caminho(1025, 1024, 1). caminho(1025, 1026, 1). 
caminho(1026, 1068, 1). caminho(1026, 984, 1). caminho(1026, 1025, 1). caminho(1026, 1027, 1). 
caminho(1027, 1069, 1). caminho(1027, 985, 1). caminho(1027, 1026, 1). caminho(1027, 1028, 1). 
caminho(1028, 1070, 1). caminho(1028, 986, 1). caminho(1028, 1027, 1). caminho(1028, 1029, 1). 
caminho(1029, 1071, 1). caminho(1029, 987, 1). caminho(1029, 1028, 1). caminho(1029, 1030, 1). 
caminho(1030, 1072, 1). caminho(1030, 988, 1). caminho(1030, 1029, 1). caminho(1030, 1031, 1). 
caminho(1031, 1073, 1). caminho(1031, 989, 1). caminho(1031, 1030, 1). caminho(1031, 1032, 1). 
caminho(1032, 1074, 1). caminho(1032, 990, 1). caminho(1032, 1031, 1). caminho(1032, 1033, 1). 
caminho(1033, 1075, 1). caminho(1033, 991, 1). caminho(1033, 1032, 1). caminho(1033, 1034, 1). 
caminho(1034, 1076, 1). caminho(1034, 992, 1). caminho(1034, 1033, 1). caminho(1034, 1035, 1). 
caminho(1035, 1077, 1). caminho(1035, 993, 1). caminho(1035, 1034, 1). caminho(1035, 1036, 1). 
caminho(1036, 1078, 1). caminho(1036, 994, 1). caminho(1036, 1035, 1). caminho(1036, 1037, 1). 
caminho(1037, 1079, 1). caminho(1037, 995, 1). caminho(1037, 1036, 1). caminho(1037, 1038, 1). 
caminho(1038, 1080, 1). caminho(1038, 996, 1). caminho(1038, 1037, 1). caminho(1038, 1039, 1). 
caminho(1039, 1081, 1). caminho(1039, 997, 1). caminho(1039, 1038, 1). caminho(1039, 1040, 1). 
caminho(1040, 1082, 1). caminho(1040, 998, 1). caminho(1040, 1039, 1). caminho(1040, 1041, 1). 
caminho(1041, 1083, 1). caminho(1041, 999, 1). caminho(1041, 1040, 1). caminho(1041, 1042, 1). 
caminho(1042, 1084, 1). caminho(1042, 1000, 1). caminho(1042, 1041, 1). caminho(1042, 1043, 1). 
caminho(1043, 1085, 1). caminho(1043, 1001, 1). caminho(1043, 1042, 1). caminho(1043, 1044, 1). 
caminho(1044, 1086, 1). caminho(1044, 1002, 1). caminho(1044, 1043, 1). caminho(1044, 1045, 1). 
caminho(1045, 1087, 1). caminho(1045, 1003, 1). caminho(1045, 1044, 1). caminho(1045, 1046, 1). 
caminho(1046, 1088, 1). caminho(1046, 1004, 1). caminho(1046, 1045, 1). caminho(1046, 1047, 1). 
caminho(1047, 1089, 1). caminho(1047, 1005, 1). caminho(1047, 1046, 1). caminho(1047, 1048, 1). 
caminho(1048, 1090, 1). caminho(1048, 1006, 1). caminho(1048, 1047, 1). caminho(1048, 1049, 1). 
caminho(1049, 1091, 1). caminho(1049, 1007, 1). caminho(1049, 1048, 1). caminho(1049, 1050, 1). 
caminho(1050, 1092, 1). caminho(1050, 1008, 1). caminho(1050, 1049, 1). 
caminho(1051, 1093, 1). caminho(1051, 1009, 1). caminho(1051, 1052, 1). 
caminho(1052, 1094, 1). caminho(1052, 1010, 1). caminho(1052, 1051, 1). caminho(1052, 1053, 1). 
caminho(1053, 1095, 1). caminho(1053, 1011, 1). caminho(1053, 1052, 1). caminho(1053, 1054, 1). 
caminho(1054, 1096, 1). caminho(1054, 1012, 1). caminho(1054, 1053, 1). caminho(1054, 1055, 1). 
caminho(1055, 1097, 1). caminho(1055, 1013, 1). caminho(1055, 1054, 1). caminho(1055, 1056, 1). 
caminho(1056, 1098, 1). caminho(1056, 1014, 1). caminho(1056, 1055, 1). caminho(1056, 1057, 1). 
caminho(1057, 1099, 1). caminho(1057, 1015, 1). caminho(1057, 1056, 1). caminho(1057, 1058, 1). 
caminho(1058, 1100, 1). caminho(1058, 1016, 1). caminho(1058, 1057, 1). caminho(1058, 1059, 1). 
caminho(1059, 1101, 1). caminho(1059, 1017, 1). caminho(1059, 1058, 1). caminho(1059, 1060, 1). 
caminho(1060, 1102, 1). caminho(1060, 1018, 1). caminho(1060, 1059, 1). caminho(1060, 1061, 1). 
caminho(1061, 1103, 1). caminho(1061, 1019, 1). caminho(1061, 1060, 1). caminho(1061, 1062, 1). 
caminho(1062, 1104, 1). caminho(1062, 1020, 1). caminho(1062, 1061, 1). caminho(1062, 1063, 1). 
caminho(1063, 1105, 1). caminho(1063, 1021, 1). caminho(1063, 1062, 1). caminho(1063, 1064, 1). 
caminho(1064, 1106, 1). caminho(1064, 1022, 1). caminho(1064, 1063, 1). caminho(1064, 1065, 1). 
caminho(1065, 1107, 1). caminho(1065, 1023, 1). caminho(1065, 1064, 1). caminho(1065, 1066, 1). 
caminho(1066, 1108, 1). caminho(1066, 1024, 1). caminho(1066, 1065, 1). caminho(1066, 1067, 1). 
caminho(1067, 1109, 1). caminho(1067, 1025, 1). caminho(1067, 1066, 1). caminho(1067, 1068, 1). 
caminho(1068, 1110, 1). caminho(1068, 1026, 1). caminho(1068, 1067, 1). caminho(1068, 1069, 1). 
caminho(1069, 1111, 1). caminho(1069, 1027, 1). caminho(1069, 1068, 1). caminho(1069, 1070, 1). 
caminho(1070, 1112, 1). caminho(1070, 1028, 1). caminho(1070, 1069, 1). caminho(1070, 1071, 1). 
caminho(1071, 1113, 1). caminho(1071, 1029, 1). caminho(1071, 1070, 1). caminho(1071, 1072, 1). 
caminho(1072, 1114, 1). caminho(1072, 1030, 1). caminho(1072, 1071, 1). caminho(1072, 1073, 1). 
caminho(1073, 1115, 1). caminho(1073, 1031, 1). caminho(1073, 1072, 1). caminho(1073, 1074, 1). 
caminho(1074, 1116, 1). caminho(1074, 1032, 1). caminho(1074, 1073, 1). caminho(1074, 1075, 1). 
caminho(1075, 1117, 1). caminho(1075, 1033, 1). caminho(1075, 1074, 1). caminho(1075, 1076, 1). 
caminho(1076, 1118, 1). caminho(1076, 1034, 1). caminho(1076, 1075, 1). caminho(1076, 1077, 1). 
caminho(1077, 1119, 1). caminho(1077, 1035, 1). caminho(1077, 1076, 1). caminho(1077, 1078, 1). 
caminho(1078, 1120, 1). caminho(1078, 1036, 1). caminho(1078, 1077, 1). caminho(1078, 1079, 1). 
caminho(1079, 1121, 1). caminho(1079, 1037, 1). caminho(1079, 1078, 1). caminho(1079, 1080, 1). 
caminho(1080, 1122, 1). caminho(1080, 1038, 1). caminho(1080, 1079, 1). caminho(1080, 1081, 1). 
caminho(1081, 1123, 1). caminho(1081, 1039, 1). caminho(1081, 1080, 1). caminho(1081, 1082, 1). 
caminho(1082, 1124, 1). caminho(1082, 1040, 1). caminho(1082, 1081, 1). caminho(1082, 1083, 1). 
caminho(1083, 1125, 1). caminho(1083, 1041, 1). caminho(1083, 1082, 1). caminho(1083, 1084, 1). 
caminho(1084, 1126, 1). caminho(1084, 1042, 1). caminho(1084, 1083, 1). caminho(1084, 1085, 1). 
caminho(1085, 1127, 1). caminho(1085, 1043, 1). caminho(1085, 1084, 1). caminho(1085, 1086, 1). 
caminho(1086, 1128, 1). caminho(1086, 1044, 1). caminho(1086, 1085, 1). caminho(1086, 1087, 1). 
caminho(1087, 1129, 1). caminho(1087, 1045, 1). caminho(1087, 1086, 1). caminho(1087, 1088, 1). 
caminho(1088, 1130, 1). caminho(1088, 1046, 1). caminho(1088, 1087, 1). caminho(1088, 1089, 1). 
caminho(1089, 1131, 1). caminho(1089, 1047, 1). caminho(1089, 1088, 1). caminho(1089, 1090, 1). 
caminho(1090, 1132, 1). caminho(1090, 1048, 1). caminho(1090, 1089, 1). caminho(1090, 1091, 1). 
caminho(1091, 1133, 1). caminho(1091, 1049, 1). caminho(1091, 1090, 1). caminho(1091, 1092, 1). 
caminho(1092, 1134, 1). caminho(1092, 1050, 1). caminho(1092, 1091, 1). 
caminho(1093, 1135, 1). caminho(1093, 1051, 1). caminho(1093, 1094, 1). 
caminho(1094, 1136, 1). caminho(1094, 1052, 1). caminho(1094, 1093, 1). caminho(1094, 1095, 1). 
caminho(1095, 1137, 1). caminho(1095, 1053, 1). caminho(1095, 1094, 1). caminho(1095, 1096, 1). 
caminho(1096, 1138, 1). caminho(1096, 1054, 1). caminho(1096, 1095, 1). caminho(1096, 1097, 1). 
caminho(1097, 1139, 1). caminho(1097, 1055, 1). caminho(1097, 1096, 1). caminho(1097, 1098, 1). 
caminho(1098, 1140, 1). caminho(1098, 1056, 1). caminho(1098, 1097, 1). caminho(1098, 1099, 1). 
caminho(1099, 1141, 1). caminho(1099, 1057, 1). caminho(1099, 1098, 1). caminho(1099, 1100, 1). 
caminho(1100, 1142, 1). caminho(1100, 1058, 1). caminho(1100, 1099, 1). caminho(1100, 1101, 1). 
caminho(1101, 1143, 1). caminho(1101, 1059, 1). caminho(1101, 1100, 1). caminho(1101, 1102, 1). 
caminho(1102, 1144, 1). caminho(1102, 1060, 1). caminho(1102, 1101, 1). caminho(1102, 1103, 1). 
caminho(1103, 1145, 1). caminho(1103, 1061, 1). caminho(1103, 1102, 1). caminho(1103, 1104, 1). 
caminho(1104, 1146, 1). caminho(1104, 1062, 1). caminho(1104, 1103, 1). caminho(1104, 1105, 1). 
caminho(1105, 1147, 1). caminho(1105, 1063, 1). caminho(1105, 1104, 1). caminho(1105, 1106, 1). 
caminho(1106, 1148, 1). caminho(1106, 1064, 1). caminho(1106, 1105, 1). caminho(1106, 1107, 1). 
caminho(1107, 1149, 1). caminho(1107, 1065, 1). caminho(1107, 1106, 1). caminho(1107, 1108, 1). 
caminho(1108, 1150, 1). caminho(1108, 1066, 1). caminho(1108, 1107, 1). caminho(1108, 1109, 1). 
caminho(1109, 1151, 1). caminho(1109, 1067, 1). caminho(1109, 1108, 1). caminho(1109, 1110, 1). 
caminho(1110, 1152, 1). caminho(1110, 1068, 1). caminho(1110, 1109, 1). caminho(1110, 1111, 1). 
caminho(1111, 1153, 1). caminho(1111, 1069, 1). caminho(1111, 1110, 1). caminho(1111, 1112, 1). 
caminho(1112, 1154, 1). caminho(1112, 1070, 1). caminho(1112, 1111, 1). caminho(1112, 1113, 1). 
caminho(1113, 1155, 1). caminho(1113, 1071, 1). caminho(1113, 1112, 1). caminho(1113, 1114, 1). 
caminho(1114, 1156, 1). caminho(1114, 1072, 1). caminho(1114, 1113, 1). caminho(1114, 1115, 1). 
caminho(1115, 1157, 1). caminho(1115, 1073, 1). caminho(1115, 1114, 1). caminho(1115, 1116, 1). 
caminho(1116, 1158, 1). caminho(1116, 1074, 1). caminho(1116, 1115, 1). caminho(1116, 1117, 1). 
caminho(1117, 1159, 1). caminho(1117, 1075, 1). caminho(1117, 1116, 1). caminho(1117, 1118, 1). 
caminho(1118, 1160, 1). caminho(1118, 1076, 1). caminho(1118, 1117, 1). caminho(1118, 1119, 1). 
caminho(1119, 1161, 1). caminho(1119, 1077, 1). caminho(1119, 1118, 1). caminho(1119, 1120, 1). 
caminho(1120, 1162, 1). caminho(1120, 1078, 1). caminho(1120, 1119, 1). caminho(1120, 1121, 1). 
caminho(1121, 1163, 1). caminho(1121, 1079, 1). caminho(1121, 1120, 1). caminho(1121, 1122, 1). 
caminho(1122, 1164, 1). caminho(1122, 1080, 1). caminho(1122, 1121, 1). caminho(1122, 1123, 1). 
caminho(1123, 1165, 1). caminho(1123, 1081, 1). caminho(1123, 1122, 1). caminho(1123, 1124, 1). 
caminho(1124, 1166, 1). caminho(1124, 1082, 1). caminho(1124, 1123, 1). caminho(1124, 1125, 1). 
caminho(1125, 1167, 1). caminho(1125, 1083, 1). caminho(1125, 1124, 1). caminho(1125, 1126, 1). 
caminho(1126, 1168, 1). caminho(1126, 1084, 1). caminho(1126, 1125, 1). caminho(1126, 1127, 1). 
caminho(1127, 1169, 1). caminho(1127, 1085, 1). caminho(1127, 1126, 1). caminho(1127, 1128, 1). 
caminho(1128, 1170, 1). caminho(1128, 1086, 1). caminho(1128, 1127, 1). caminho(1128, 1129, 1). 
caminho(1129, 1171, 1). caminho(1129, 1087, 1). caminho(1129, 1128, 1). caminho(1129, 1130, 1). 
caminho(1130, 1172, 1). caminho(1130, 1088, 1). caminho(1130, 1129, 1). caminho(1130, 1131, 1). 
caminho(1131, 1173, 1). caminho(1131, 1089, 1). caminho(1131, 1130, 1). caminho(1131, 1132, 1). 
caminho(1132, 1174, 1). caminho(1132, 1090, 1). caminho(1132, 1131, 1). caminho(1132, 1133, 1). 
caminho(1133, 1175, 1). caminho(1133, 1091, 1). caminho(1133, 1132, 1). caminho(1133, 1134, 1). 
caminho(1134, 1176, 1). caminho(1134, 1092, 1). caminho(1134, 1133, 1). 
caminho(1135, 1177, 1). caminho(1135, 1093, 1). caminho(1135, 1136, 1). 
caminho(1136, 1178, 1). caminho(1136, 1094, 1). caminho(1136, 1135, 1). caminho(1136, 1137, 1). 
caminho(1137, 1179, 1). caminho(1137, 1095, 1). caminho(1137, 1136, 1). caminho(1137, 1138, 1). 
caminho(1138, 1180, 1). caminho(1138, 1096, 1). caminho(1138, 1137, 1). caminho(1138, 1139, 1). 
caminho(1139, 1181, 1). caminho(1139, 1097, 1). caminho(1139, 1138, 1). caminho(1139, 1140, 1). 
caminho(1140, 1182, 1). caminho(1140, 1098, 1). caminho(1140, 1139, 1). caminho(1140, 1141, 1). 
caminho(1141, 1183, 1). caminho(1141, 1099, 1). caminho(1141, 1140, 1). caminho(1141, 1142, 1). 
caminho(1142, 1184, 1). caminho(1142, 1100, 1). caminho(1142, 1141, 1). caminho(1142, 1143, 1). 
caminho(1143, 1185, 1). caminho(1143, 1101, 1). caminho(1143, 1142, 1). caminho(1143, 1144, 1). 
caminho(1144, 1186, 1). caminho(1144, 1102, 1). caminho(1144, 1143, 1). caminho(1144, 1145, 1). 
caminho(1145, 1187, 1). caminho(1145, 1103, 1). caminho(1145, 1144, 1). caminho(1145, 1146, 1). 
caminho(1146, 1188, 1). caminho(1146, 1104, 1). caminho(1146, 1145, 1). caminho(1146, 1147, 1). 
caminho(1147, 1189, 1). caminho(1147, 1105, 1). caminho(1147, 1146, 1). caminho(1147, 1148, 1). 
caminho(1148, 1190, 1). caminho(1148, 1106, 1). caminho(1148, 1147, 1). caminho(1148, 1149, 1). 
caminho(1149, 1191, 1). caminho(1149, 1107, 1). caminho(1149, 1148, 1). caminho(1149, 1150, 1). 
caminho(1150, 1192, 1). caminho(1150, 1108, 1). caminho(1150, 1149, 1). caminho(1150, 1151, 1). 
caminho(1151, 1193, 1). caminho(1151, 1109, 1). caminho(1151, 1150, 1). caminho(1151, 1152, 1). 
caminho(1152, 1194, 1). caminho(1152, 1110, 1). caminho(1152, 1151, 1). caminho(1152, 1153, 1). 
caminho(1153, 1195, 1). caminho(1153, 1111, 1). caminho(1153, 1152, 1). caminho(1153, 1154, 1). 
caminho(1154, 1196, 1). caminho(1154, 1112, 1). caminho(1154, 1153, 1). caminho(1154, 1155, 1). 
caminho(1155, 1197, 1). caminho(1155, 1113, 1). caminho(1155, 1154, 1). caminho(1155, 1156, 1). 
caminho(1156, 1198, 1). caminho(1156, 1114, 1). caminho(1156, 1155, 1). caminho(1156, 1157, 1). 
caminho(1157, 1199, 1). caminho(1157, 1115, 1). caminho(1157, 1156, 1). caminho(1157, 1158, 1). 
caminho(1158, 1200, 1). caminho(1158, 1116, 1). caminho(1158, 1157, 1). caminho(1158, 1159, 1). 
caminho(1159, 1201, 1). caminho(1159, 1117, 1). caminho(1159, 1158, 1). caminho(1159, 1160, 1). 
caminho(1160, 1202, 1). caminho(1160, 1118, 1). caminho(1160, 1159, 1). caminho(1160, 1161, 1). 
caminho(1161, 1203, 1). caminho(1161, 1119, 1). caminho(1161, 1160, 1). caminho(1161, 1162, 1). 
caminho(1162, 1204, 1). caminho(1162, 1120, 1). caminho(1162, 1161, 1). caminho(1162, 1163, 1). 
caminho(1163, 1205, 1). caminho(1163, 1121, 1). caminho(1163, 1162, 1). caminho(1163, 1164, 1). 
caminho(1164, 1206, 1). caminho(1164, 1122, 1). caminho(1164, 1163, 1). caminho(1164, 1165, 1). 
caminho(1165, 1207, 1). caminho(1165, 1123, 1). caminho(1165, 1164, 1). caminho(1165, 1166, 1). 
caminho(1166, 1208, 1). caminho(1166, 1124, 1). caminho(1166, 1165, 1). caminho(1166, 1167, 1). 
caminho(1167, 1209, 1). caminho(1167, 1125, 1). caminho(1167, 1166, 1). caminho(1167, 1168, 1). 
caminho(1168, 1210, 1). caminho(1168, 1126, 1). caminho(1168, 1167, 1). caminho(1168, 1169, 1). 
caminho(1169, 1211, 1). caminho(1169, 1127, 1). caminho(1169, 1168, 1). caminho(1169, 1170, 1). 
caminho(1170, 1212, 1). caminho(1170, 1128, 1). caminho(1170, 1169, 1). caminho(1170, 1171, 1). 
caminho(1171, 1213, 1). caminho(1171, 1129, 1). caminho(1171, 1170, 1). caminho(1171, 1172, 1). 
caminho(1172, 1214, 1). caminho(1172, 1130, 1). caminho(1172, 1171, 1). caminho(1172, 1173, 1). 
caminho(1173, 1215, 1). caminho(1173, 1131, 1). caminho(1173, 1172, 1). caminho(1173, 1174, 1). 
caminho(1174, 1216, 1). caminho(1174, 1132, 1). caminho(1174, 1173, 1). caminho(1174, 1175, 1). 
caminho(1175, 1217, 1). caminho(1175, 1133, 1). caminho(1175, 1174, 1). caminho(1175, 1176, 1). 
caminho(1176, 1218, 1). caminho(1176, 1134, 1). caminho(1176, 1175, 1). 
caminho(1177, 1219, 1). caminho(1177, 1135, 1). caminho(1177, 1178, 1). 
caminho(1178, 1220, 1). caminho(1178, 1136, 1). caminho(1178, 1177, 1). caminho(1178, 1179, 1). 
caminho(1179, 1221, 1). caminho(1179, 1137, 1). caminho(1179, 1178, 1). caminho(1179, 1180, 1). 
caminho(1180, 1222, 1). caminho(1180, 1138, 1). caminho(1180, 1179, 1). caminho(1180, 1181, 1). 
caminho(1181, 1223, 1). caminho(1181, 1139, 1). caminho(1181, 1180, 1). caminho(1181, 1182, 1). 
caminho(1182, 1224, 1). caminho(1182, 1140, 1). caminho(1182, 1181, 1). caminho(1182, 1183, 1). 
caminho(1183, 1225, 1). caminho(1183, 1141, 1). caminho(1183, 1182, 1). caminho(1183, 1184, 1). 
caminho(1184, 1226, 1). caminho(1184, 1142, 1). caminho(1184, 1183, 1). caminho(1184, 1185, 1). 
caminho(1185, 1227, 1). caminho(1185, 1143, 1). caminho(1185, 1184, 1). caminho(1185, 1186, 1). 
caminho(1186, 1228, 1). caminho(1186, 1144, 1). caminho(1186, 1185, 1). caminho(1186, 1187, 1). 
caminho(1187, 1229, 1). caminho(1187, 1145, 1). caminho(1187, 1186, 1). caminho(1187, 1188, 1). 
caminho(1188, 1230, 1). caminho(1188, 1146, 1). caminho(1188, 1187, 1). caminho(1188, 1189, 1). 
caminho(1189, 1231, 1). caminho(1189, 1147, 1). caminho(1189, 1188, 1). caminho(1189, 1190, 1). 
caminho(1190, 1232, 1). caminho(1190, 1148, 1). caminho(1190, 1189, 1). caminho(1190, 1191, 1). 
caminho(1191, 1233, 1). caminho(1191, 1149, 1). caminho(1191, 1190, 1). caminho(1191, 1192, 1). 
caminho(1192, 1234, 1). caminho(1192, 1150, 1). caminho(1192, 1191, 1). caminho(1192, 1193, 1). 
caminho(1193, 1235, 1). caminho(1193, 1151, 1). caminho(1193, 1192, 1). caminho(1193, 1194, 1). 
caminho(1194, 1236, 1). caminho(1194, 1152, 1). caminho(1194, 1193, 1). caminho(1194, 1195, 1). 
caminho(1195, 1237, 1). caminho(1195, 1153, 1). caminho(1195, 1194, 1). caminho(1195, 1196, 1). 
caminho(1196, 1238, 1). caminho(1196, 1154, 1). caminho(1196, 1195, 1). caminho(1196, 1197, 1). 
caminho(1197, 1239, 1). caminho(1197, 1155, 1). caminho(1197, 1196, 1). caminho(1197, 1198, 1). 
caminho(1198, 1240, 1). caminho(1198, 1156, 1). caminho(1198, 1197, 1). caminho(1198, 1199, 1). 
caminho(1199, 1241, 1). caminho(1199, 1157, 1). caminho(1199, 1198, 1). caminho(1199, 1200, 1). 
caminho(1200, 1242, 1). caminho(1200, 1158, 1). caminho(1200, 1199, 1). caminho(1200, 1201, 1). 
caminho(1201, 1243, 1). caminho(1201, 1159, 1). caminho(1201, 1200, 1). caminho(1201, 1202, 1). 
caminho(1202, 1244, 1). caminho(1202, 1160, 1). caminho(1202, 1201, 1). caminho(1202, 1203, 1). 
caminho(1203, 1245, 1). caminho(1203, 1161, 1). caminho(1203, 1202, 1). caminho(1203, 1204, 1). 
caminho(1204, 1246, 1). caminho(1204, 1162, 1). caminho(1204, 1203, 1). caminho(1204, 1205, 1). 
caminho(1205, 1247, 1). caminho(1205, 1163, 1). caminho(1205, 1204, 1). caminho(1205, 1206, 1). 
caminho(1206, 1248, 1). caminho(1206, 1164, 1). caminho(1206, 1205, 1). caminho(1206, 1207, 1). 
caminho(1207, 1249, 1). caminho(1207, 1165, 1). caminho(1207, 1206, 1). caminho(1207, 1208, 1). 
caminho(1208, 1250, 1). caminho(1208, 1166, 1). caminho(1208, 1207, 1). caminho(1208, 1209, 1). 
caminho(1209, 1251, 1). caminho(1209, 1167, 1). caminho(1209, 1208, 1). caminho(1209, 1210, 1). 
caminho(1210, 1252, 1). caminho(1210, 1168, 1). caminho(1210, 1209, 1). caminho(1210, 1211, 1). 
caminho(1211, 1253, 1). caminho(1211, 1169, 1). caminho(1211, 1210, 1). caminho(1211, 1212, 1). 
caminho(1212, 1254, 1). caminho(1212, 1170, 1). caminho(1212, 1211, 1). caminho(1212, 1213, 1). 
caminho(1213, 1255, 1). caminho(1213, 1171, 1). caminho(1213, 1212, 1). caminho(1213, 1214, 1). 
caminho(1214, 1256, 1). caminho(1214, 1172, 1). caminho(1214, 1213, 1). caminho(1214, 1215, 1). 
caminho(1215, 1257, 1). caminho(1215, 1173, 1). caminho(1215, 1214, 1). caminho(1215, 1216, 1). 
caminho(1216, 1258, 1). caminho(1216, 1174, 1). caminho(1216, 1215, 1). caminho(1216, 1217, 1). 
caminho(1217, 1259, 1). caminho(1217, 1175, 1). caminho(1217, 1216, 1). caminho(1217, 1218, 1). 
caminho(1218, 1260, 1). caminho(1218, 1176, 1). caminho(1218, 1217, 1). 
caminho(1219, 1261, 1). caminho(1219, 1177, 1). caminho(1219, 1220, 1). 
caminho(1220, 1262, 1). caminho(1220, 1178, 1). caminho(1220, 1219, 1). caminho(1220, 1221, 1). 
caminho(1221, 1263, 1). caminho(1221, 1179, 1). caminho(1221, 1220, 1). caminho(1221, 1222, 1). 
caminho(1222, 1264, 1). caminho(1222, 1180, 1). caminho(1222, 1221, 1). caminho(1222, 1223, 1). 
caminho(1223, 1265, 1). caminho(1223, 1181, 1). caminho(1223, 1222, 1). caminho(1223, 1224, 1). 
caminho(1224, 1266, 1). caminho(1224, 1182, 1). caminho(1224, 1223, 1). caminho(1224, 1225, 1). 
caminho(1225, 1267, 1). caminho(1225, 1183, 1). caminho(1225, 1224, 1). caminho(1225, 1226, 1). 
caminho(1226, 1268, 1). caminho(1226, 1184, 1). caminho(1226, 1225, 1). caminho(1226, 1227, 1). 
caminho(1227, 1269, 1). caminho(1227, 1185, 1). caminho(1227, 1226, 1). caminho(1227, 1228, 1). 
caminho(1228, 1270, 1). caminho(1228, 1186, 1). caminho(1228, 1227, 1). caminho(1228, 1229, 1). 
caminho(1229, 1271, 1). caminho(1229, 1187, 1). caminho(1229, 1228, 1). caminho(1229, 1230, 1). 
caminho(1230, 1272, 1). caminho(1230, 1188, 1). caminho(1230, 1229, 1). caminho(1230, 1231, 1). 
caminho(1231, 1273, 1). caminho(1231, 1189, 1). caminho(1231, 1230, 1). caminho(1231, 1232, 1). 
caminho(1232, 1274, 1). caminho(1232, 1190, 1). caminho(1232, 1231, 1). caminho(1232, 1233, 1). 
caminho(1233, 1275, 1). caminho(1233, 1191, 1). caminho(1233, 1232, 1). caminho(1233, 1234, 1). 
caminho(1234, 1276, 1). caminho(1234, 1192, 1). caminho(1234, 1233, 1). caminho(1234, 1235, 1). 
caminho(1235, 1277, 1). caminho(1235, 1193, 1). caminho(1235, 1234, 1). caminho(1235, 1236, 1). 
caminho(1236, 1278, 1). caminho(1236, 1194, 1). caminho(1236, 1235, 1). caminho(1236, 1237, 1). 
caminho(1237, 1279, 1). caminho(1237, 1195, 1). caminho(1237, 1236, 1). caminho(1237, 1238, 1). 
caminho(1238, 1280, 1). caminho(1238, 1196, 1). caminho(1238, 1237, 1). caminho(1238, 1239, 1). 
caminho(1239, 1281, 1). caminho(1239, 1197, 1). caminho(1239, 1238, 1). caminho(1239, 1240, 1). 
caminho(1240, 1282, 1). caminho(1240, 1198, 1). caminho(1240, 1239, 1). caminho(1240, 1241, 1). 
caminho(1241, 1283, 1). caminho(1241, 1199, 1). caminho(1241, 1240, 1). caminho(1241, 1242, 1). 
caminho(1242, 1284, 1). caminho(1242, 1200, 1). caminho(1242, 1241, 1). caminho(1242, 1243, 1). 
caminho(1243, 1285, 1). caminho(1243, 1201, 1). caminho(1243, 1242, 1). caminho(1243, 1244, 1). 
caminho(1244, 1286, 1). caminho(1244, 1202, 1). caminho(1244, 1243, 1). caminho(1244, 1245, 1). 
caminho(1245, 1287, 1). caminho(1245, 1203, 1). caminho(1245, 1244, 1). caminho(1245, 1246, 1). 
caminho(1246, 1288, 1). caminho(1246, 1204, 1). caminho(1246, 1245, 1). caminho(1246, 1247, 1). 
caminho(1247, 1289, 1). caminho(1247, 1205, 1). caminho(1247, 1246, 1). caminho(1247, 1248, 1). 
caminho(1248, 1290, 1). caminho(1248, 1206, 1). caminho(1248, 1247, 1). caminho(1248, 1249, 1). 
caminho(1249, 1291, 1). caminho(1249, 1207, 1). caminho(1249, 1248, 1). caminho(1249, 1250, 1). 
caminho(1250, 1292, 1). caminho(1250, 1208, 1). caminho(1250, 1249, 1). caminho(1250, 1251, 1). 
caminho(1251, 1293, 1). caminho(1251, 1209, 1). caminho(1251, 1250, 1). caminho(1251, 1252, 1). 
caminho(1252, 1294, 1). caminho(1252, 1210, 1). caminho(1252, 1251, 1). caminho(1252, 1253, 1). 
caminho(1253, 1295, 1). caminho(1253, 1211, 1). caminho(1253, 1252, 1). caminho(1253, 1254, 1). 
caminho(1254, 1296, 1). caminho(1254, 1212, 1). caminho(1254, 1253, 1). caminho(1254, 1255, 1). 
caminho(1255, 1297, 1). caminho(1255, 1213, 1). caminho(1255, 1254, 1). caminho(1255, 1256, 1). 
caminho(1256, 1298, 1). caminho(1256, 1214, 1). caminho(1256, 1255, 1). caminho(1256, 1257, 1). 
caminho(1257, 1299, 1). caminho(1257, 1215, 1). caminho(1257, 1256, 1). caminho(1257, 1258, 1). 
caminho(1258, 1300, 1). caminho(1258, 1216, 1). caminho(1258, 1257, 1). caminho(1258, 1259, 1). 
caminho(1259, 1301, 1). caminho(1259, 1217, 1). caminho(1259, 1258, 1). caminho(1259, 1260, 1). 
caminho(1260, 1302, 1). caminho(1260, 1218, 1). caminho(1260, 1259, 1). 
caminho(1261, 1303, 1). caminho(1261, 1219, 1). caminho(1261, 1262, 1). 
caminho(1262, 1304, 1). caminho(1262, 1220, 1). caminho(1262, 1261, 1). caminho(1262, 1263, 1). 
caminho(1263, 1305, 1). caminho(1263, 1221, 1). caminho(1263, 1262, 1). caminho(1263, 1264, 1). 
caminho(1264, 1306, 1). caminho(1264, 1222, 1). caminho(1264, 1263, 1). caminho(1264, 1265, 1). 
caminho(1265, 1307, 1). caminho(1265, 1223, 1). caminho(1265, 1264, 1). caminho(1265, 1266, 1). 
caminho(1266, 1308, 1). caminho(1266, 1224, 1). caminho(1266, 1265, 1). caminho(1266, 1267, 1). 
caminho(1267, 1309, 1). caminho(1267, 1225, 1). caminho(1267, 1266, 1). caminho(1267, 1268, 1). 
caminho(1268, 1310, 1). caminho(1268, 1226, 1). caminho(1268, 1267, 1). caminho(1268, 1269, 1). 
caminho(1269, 1311, 1). caminho(1269, 1227, 1). caminho(1269, 1268, 1). caminho(1269, 1270, 1). 
caminho(1270, 1312, 1). caminho(1270, 1228, 1). caminho(1270, 1269, 1). caminho(1270, 1271, 1). 
caminho(1271, 1313, 1). caminho(1271, 1229, 1). caminho(1271, 1270, 1). caminho(1271, 1272, 1). 
caminho(1272, 1314, 1). caminho(1272, 1230, 1). caminho(1272, 1271, 1). caminho(1272, 1273, 1). 
caminho(1273, 1315, 1). caminho(1273, 1231, 1). caminho(1273, 1272, 1). caminho(1273, 1274, 1). 
caminho(1274, 1316, 1). caminho(1274, 1232, 1). caminho(1274, 1273, 1). caminho(1274, 1275, 1). 
caminho(1275, 1317, 1). caminho(1275, 1233, 1). caminho(1275, 1274, 1). caminho(1275, 1276, 1). 
caminho(1276, 1318, 1). caminho(1276, 1234, 1). caminho(1276, 1275, 1). caminho(1276, 1277, 1). 
caminho(1277, 1319, 1). caminho(1277, 1235, 1). caminho(1277, 1276, 1). caminho(1277, 1278, 1). 
caminho(1278, 1320, 1). caminho(1278, 1236, 1). caminho(1278, 1277, 1). caminho(1278, 1279, 1). 
caminho(1279, 1321, 1). caminho(1279, 1237, 1). caminho(1279, 1278, 1). caminho(1279, 1280, 1). 
caminho(1280, 1322, 1). caminho(1280, 1238, 1). caminho(1280, 1279, 1). caminho(1280, 1281, 1). 
caminho(1281, 1323, 1). caminho(1281, 1239, 1). caminho(1281, 1280, 1). caminho(1281, 1282, 1). 
caminho(1282, 1324, 1). caminho(1282, 1240, 1). caminho(1282, 1281, 1). caminho(1282, 1283, 1). 
caminho(1283, 1325, 1). caminho(1283, 1241, 1). caminho(1283, 1282, 1). caminho(1283, 1284, 1). 
caminho(1284, 1326, 1). caminho(1284, 1242, 1). caminho(1284, 1283, 1). caminho(1284, 1285, 1). 
caminho(1285, 1327, 1). caminho(1285, 1243, 1). caminho(1285, 1284, 1). caminho(1285, 1286, 1). 
caminho(1286, 1328, 1). caminho(1286, 1244, 1). caminho(1286, 1285, 1). caminho(1286, 1287, 1). 
caminho(1287, 1329, 1). caminho(1287, 1245, 1). caminho(1287, 1286, 1). caminho(1287, 1288, 1). 
caminho(1288, 1330, 1). caminho(1288, 1246, 1). caminho(1288, 1287, 1). caminho(1288, 1289, 1). 
caminho(1289, 1331, 1). caminho(1289, 1247, 1). caminho(1289, 1288, 1). caminho(1289, 1290, 1). 
caminho(1290, 1332, 1). caminho(1290, 1248, 1). caminho(1290, 1289, 1). caminho(1290, 1291, 1). 
caminho(1291, 1333, 1). caminho(1291, 1249, 1). caminho(1291, 1290, 1). caminho(1291, 1292, 1). 
caminho(1292, 1334, 1). caminho(1292, 1250, 1). caminho(1292, 1291, 1). caminho(1292, 1293, 1). 
caminho(1293, 1335, 1). caminho(1293, 1251, 1). caminho(1293, 1292, 1). caminho(1293, 1294, 1). 
caminho(1294, 1336, 1). caminho(1294, 1252, 1). caminho(1294, 1293, 1). caminho(1294, 1295, 1). 
caminho(1295, 1337, 1). caminho(1295, 1253, 1). caminho(1295, 1294, 1). caminho(1295, 1296, 1). 
caminho(1296, 1338, 1). caminho(1296, 1254, 1). caminho(1296, 1295, 1). caminho(1296, 1297, 1). 
caminho(1297, 1339, 1). caminho(1297, 1255, 1). caminho(1297, 1296, 1). caminho(1297, 1298, 1). 
caminho(1298, 1340, 1). caminho(1298, 1256, 1). caminho(1298, 1297, 1). caminho(1298, 1299, 1). 
caminho(1299, 1341, 1). caminho(1299, 1257, 1). caminho(1299, 1298, 1). caminho(1299, 1300, 1). 
caminho(1300, 1342, 1). caminho(1300, 1258, 1). caminho(1300, 1299, 1). caminho(1300, 1301, 1). 
caminho(1301, 1343, 1). caminho(1301, 1259, 1). caminho(1301, 1300, 1). caminho(1301, 1302, 1). 
caminho(1302, 1344, 1). caminho(1302, 1260, 1). caminho(1302, 1301, 1). 
caminho(1303, 1345, 1). caminho(1303, 1261, 1). caminho(1303, 1304, 1). 
caminho(1304, 1346, 1). caminho(1304, 1262, 1). caminho(1304, 1303, 1). caminho(1304, 1305, 1). 
caminho(1305, 1347, 1). caminho(1305, 1263, 1). caminho(1305, 1304, 1). caminho(1305, 1306, 1). 
caminho(1306, 1348, 1). caminho(1306, 1264, 1). caminho(1306, 1305, 1). caminho(1306, 1307, 1). 
caminho(1307, 1349, 1). caminho(1307, 1265, 1). caminho(1307, 1306, 1). caminho(1307, 1308, 1). 
caminho(1308, 1350, 1). caminho(1308, 1266, 1). caminho(1308, 1307, 1). caminho(1308, 1309, 1). 
caminho(1309, 1351, 1). caminho(1309, 1267, 1). caminho(1309, 1308, 1). caminho(1309, 1310, 1). 
caminho(1310, 1352, 1). caminho(1310, 1268, 1). caminho(1310, 1309, 1). caminho(1310, 1311, 1). 
caminho(1311, 1353, 1). caminho(1311, 1269, 1). caminho(1311, 1310, 1). caminho(1311, 1312, 1). 
caminho(1312, 1354, 1). caminho(1312, 1270, 1). caminho(1312, 1311, 1). caminho(1312, 1313, 1). 
caminho(1313, 1355, 1). caminho(1313, 1271, 1). caminho(1313, 1312, 1). caminho(1313, 1314, 1). 
caminho(1314, 1356, 1). caminho(1314, 1272, 1). caminho(1314, 1313, 1). caminho(1314, 1315, 1). 
caminho(1315, 1357, 1). caminho(1315, 1273, 1). caminho(1315, 1314, 1). caminho(1315, 1316, 1). 
caminho(1316, 1358, 1). caminho(1316, 1274, 1). caminho(1316, 1315, 1). caminho(1316, 1317, 1). 
caminho(1317, 1359, 1). caminho(1317, 1275, 1). caminho(1317, 1316, 1). caminho(1317, 1318, 1). 
caminho(1318, 1360, 1). caminho(1318, 1276, 1). caminho(1318, 1317, 1). caminho(1318, 1319, 1). 
caminho(1319, 1361, 1). caminho(1319, 1277, 1). caminho(1319, 1318, 1). caminho(1319, 1320, 1). 
caminho(1320, 1362, 1). caminho(1320, 1278, 1). caminho(1320, 1319, 1). caminho(1320, 1321, 1). 
caminho(1321, 1363, 1). caminho(1321, 1279, 1). caminho(1321, 1320, 1). caminho(1321, 1322, 1). 
caminho(1322, 1364, 1). caminho(1322, 1280, 1). caminho(1322, 1321, 1). caminho(1322, 1323, 1). 
caminho(1323, 1365, 1). caminho(1323, 1281, 1). caminho(1323, 1322, 1). caminho(1323, 1324, 1). 
caminho(1324, 1366, 1). caminho(1324, 1282, 1). caminho(1324, 1323, 1). caminho(1324, 1325, 1). 
caminho(1325, 1367, 1). caminho(1325, 1283, 1). caminho(1325, 1324, 1). caminho(1325, 1326, 1). 
caminho(1326, 1368, 1). caminho(1326, 1284, 1). caminho(1326, 1325, 1). caminho(1326, 1327, 1). 
caminho(1327, 1369, 1). caminho(1327, 1285, 1). caminho(1327, 1326, 1). caminho(1327, 1328, 1). 
caminho(1328, 1370, 1). caminho(1328, 1286, 1). caminho(1328, 1327, 1). caminho(1328, 1329, 1). 
caminho(1329, 1371, 1). caminho(1329, 1287, 1). caminho(1329, 1328, 1). caminho(1329, 1330, 1). 
caminho(1330, 1372, 1). caminho(1330, 1288, 1). caminho(1330, 1329, 1). caminho(1330, 1331, 1). 
caminho(1331, 1373, 1). caminho(1331, 1289, 1). caminho(1331, 1330, 1). caminho(1331, 1332, 1). 
caminho(1332, 1374, 1). caminho(1332, 1290, 1). caminho(1332, 1331, 1). caminho(1332, 1333, 1). 
caminho(1333, 1375, 1). caminho(1333, 1291, 1). caminho(1333, 1332, 1). caminho(1333, 1334, 1). 
caminho(1334, 1376, 1). caminho(1334, 1292, 1). caminho(1334, 1333, 1). caminho(1334, 1335, 1). 
caminho(1335, 1377, 1). caminho(1335, 1293, 1). caminho(1335, 1334, 1). caminho(1335, 1336, 1). 
caminho(1336, 1378, 1). caminho(1336, 1294, 1). caminho(1336, 1335, 1). caminho(1336, 1337, 1). 
caminho(1337, 1379, 1). caminho(1337, 1295, 1). caminho(1337, 1336, 1). caminho(1337, 1338, 1). 
caminho(1338, 1380, 1). caminho(1338, 1296, 1). caminho(1338, 1337, 1). caminho(1338, 1339, 1). 
caminho(1339, 1381, 1). caminho(1339, 1297, 1). caminho(1339, 1338, 1). caminho(1339, 1340, 1). 
caminho(1340, 1382, 1). caminho(1340, 1298, 1). caminho(1340, 1339, 1). caminho(1340, 1341, 1). 
caminho(1341, 1383, 1). caminho(1341, 1299, 1). caminho(1341, 1340, 1). caminho(1341, 1342, 1). 
caminho(1342, 1384, 1). caminho(1342, 1300, 1). caminho(1342, 1341, 1). caminho(1342, 1343, 1). 
caminho(1343, 1385, 1). caminho(1343, 1301, 1). caminho(1343, 1342, 1). caminho(1343, 1344, 1). 
caminho(1344, 1386, 1). caminho(1344, 1302, 1). caminho(1344, 1343, 1). 
caminho(1345, 1387, 1). caminho(1345, 1303, 1). caminho(1345, 1346, 1). 
caminho(1346, 1388, 1). caminho(1346, 1304, 1). caminho(1346, 1345, 1). caminho(1346, 1347, 1). 
caminho(1347, 1389, 1). caminho(1347, 1305, 1). caminho(1347, 1346, 1). caminho(1347, 1348, 1). 
caminho(1348, 1390, 1). caminho(1348, 1306, 1). caminho(1348, 1347, 1). caminho(1348, 1349, 1). 
caminho(1349, 1391, 1). caminho(1349, 1307, 1). caminho(1349, 1348, 1). caminho(1349, 1350, 1). 
caminho(1350, 1392, 1). caminho(1350, 1308, 1). caminho(1350, 1349, 1). caminho(1350, 1351, 1). 
caminho(1351, 1393, 1). caminho(1351, 1309, 1). caminho(1351, 1350, 1). caminho(1351, 1352, 1). 
caminho(1352, 1394, 1). caminho(1352, 1310, 1). caminho(1352, 1351, 1). caminho(1352, 1353, 1). 
caminho(1353, 1395, 1). caminho(1353, 1311, 1). caminho(1353, 1352, 1). caminho(1353, 1354, 1). 
caminho(1354, 1396, 1). caminho(1354, 1312, 1). caminho(1354, 1353, 1). caminho(1354, 1355, 1). 
caminho(1355, 1397, 1). caminho(1355, 1313, 1). caminho(1355, 1354, 1). caminho(1355, 1356, 1). 
caminho(1356, 1398, 1). caminho(1356, 1314, 1). caminho(1356, 1355, 1). caminho(1356, 1357, 1). 
caminho(1357, 1399, 1). caminho(1357, 1315, 1). caminho(1357, 1356, 1). caminho(1357, 1358, 1). 
caminho(1358, 1400, 1). caminho(1358, 1316, 1). caminho(1358, 1357, 1). caminho(1358, 1359, 1). 
caminho(1359, 1401, 1). caminho(1359, 1317, 1). caminho(1359, 1358, 1). caminho(1359, 1360, 1). 
caminho(1360, 1402, 1). caminho(1360, 1318, 1). caminho(1360, 1359, 1). caminho(1360, 1361, 1). 
caminho(1361, 1403, 1). caminho(1361, 1319, 1). caminho(1361, 1360, 1). caminho(1361, 1362, 1). 
caminho(1362, 1404, 1). caminho(1362, 1320, 1). caminho(1362, 1361, 1). caminho(1362, 1363, 1). 
caminho(1363, 1405, 1). caminho(1363, 1321, 1). caminho(1363, 1362, 1). caminho(1363, 1364, 1). 
caminho(1364, 1406, 1). caminho(1364, 1322, 1). caminho(1364, 1363, 1). caminho(1364, 1365, 1). 
caminho(1365, 1407, 1). caminho(1365, 1323, 1). caminho(1365, 1364, 1). caminho(1365, 1366, 1). 
caminho(1366, 1408, 1). caminho(1366, 1324, 1). caminho(1366, 1365, 1). caminho(1366, 1367, 1). 
caminho(1367, 1409, 1). caminho(1367, 1325, 1). caminho(1367, 1366, 1). caminho(1367, 1368, 1). 
caminho(1368, 1410, 1). caminho(1368, 1326, 1). caminho(1368, 1367, 1). caminho(1368, 1369, 1). 
caminho(1369, 1411, 1). caminho(1369, 1327, 1). caminho(1369, 1368, 1). caminho(1369, 1370, 1). 
caminho(1370, 1412, 1). caminho(1370, 1328, 1). caminho(1370, 1369, 1). caminho(1370, 1371, 1). 
caminho(1371, 1413, 1). caminho(1371, 1329, 1). caminho(1371, 1370, 1). caminho(1371, 1372, 1). 
caminho(1372, 1414, 1). caminho(1372, 1330, 1). caminho(1372, 1371, 1). caminho(1372, 1373, 1). 
caminho(1373, 1415, 1). caminho(1373, 1331, 1). caminho(1373, 1372, 1). caminho(1373, 1374, 1). 
caminho(1374, 1416, 1). caminho(1374, 1332, 1). caminho(1374, 1373, 1). caminho(1374, 1375, 1). 
caminho(1375, 1417, 1). caminho(1375, 1333, 1). caminho(1375, 1374, 1). caminho(1375, 1376, 1). 
caminho(1376, 1418, 1). caminho(1376, 1334, 1). caminho(1376, 1375, 1). caminho(1376, 1377, 1). 
caminho(1377, 1419, 1). caminho(1377, 1335, 1). caminho(1377, 1376, 1). caminho(1377, 1378, 1). 
caminho(1378, 1420, 1). caminho(1378, 1336, 1). caminho(1378, 1377, 1). caminho(1378, 1379, 1). 
caminho(1379, 1421, 1). caminho(1379, 1337, 1). caminho(1379, 1378, 1). caminho(1379, 1380, 1). 
caminho(1380, 1422, 1). caminho(1380, 1338, 1). caminho(1380, 1379, 1). caminho(1380, 1381, 1). 
caminho(1381, 1423, 1). caminho(1381, 1339, 1). caminho(1381, 1380, 1). caminho(1381, 1382, 1). 
caminho(1382, 1424, 1). caminho(1382, 1340, 1). caminho(1382, 1381, 1). caminho(1382, 1383, 1). 
caminho(1383, 1425, 1). caminho(1383, 1341, 1). caminho(1383, 1382, 1). caminho(1383, 1384, 1). 
caminho(1384, 1426, 1). caminho(1384, 1342, 1). caminho(1384, 1383, 1). caminho(1384, 1385, 1). 
caminho(1385, 1427, 1). caminho(1385, 1343, 1). caminho(1385, 1384, 1). caminho(1385, 1386, 1). 
caminho(1386, 1428, 1). caminho(1386, 1344, 1). caminho(1386, 1385, 1). 
caminho(1387, 1429, 1). caminho(1387, 1345, 1). caminho(1387, 1388, 1). 
caminho(1388, 1430, 1). caminho(1388, 1346, 1). caminho(1388, 1387, 1). caminho(1388, 1389, 1). 
caminho(1389, 1431, 1). caminho(1389, 1347, 1). caminho(1389, 1388, 1). caminho(1389, 1390, 1). 
caminho(1390, 1432, 1). caminho(1390, 1348, 1). caminho(1390, 1389, 1). caminho(1390, 1391, 1). 
caminho(1391, 1433, 1). caminho(1391, 1349, 1). caminho(1391, 1390, 1). caminho(1391, 1392, 1). 
caminho(1392, 1434, 1). caminho(1392, 1350, 1). caminho(1392, 1391, 1). caminho(1392, 1393, 1). 
caminho(1393, 1435, 1). caminho(1393, 1351, 1). caminho(1393, 1392, 1). caminho(1393, 1394, 1). 
caminho(1394, 1436, 1). caminho(1394, 1352, 1). caminho(1394, 1393, 1). caminho(1394, 1395, 1). 
caminho(1395, 1437, 1). caminho(1395, 1353, 1). caminho(1395, 1394, 1). caminho(1395, 1396, 1). 
caminho(1396, 1438, 1). caminho(1396, 1354, 1). caminho(1396, 1395, 1). caminho(1396, 1397, 1). 
caminho(1397, 1439, 1). caminho(1397, 1355, 1). caminho(1397, 1396, 1). caminho(1397, 1398, 1). 
caminho(1398, 1440, 1). caminho(1398, 1356, 1). caminho(1398, 1397, 1). caminho(1398, 1399, 1). 
caminho(1399, 1441, 1). caminho(1399, 1357, 1). caminho(1399, 1398, 1). caminho(1399, 1400, 1). 
caminho(1400, 1442, 1). caminho(1400, 1358, 1). caminho(1400, 1399, 1). caminho(1400, 1401, 1). 
caminho(1401, 1443, 1). caminho(1401, 1359, 1). caminho(1401, 1400, 1). caminho(1401, 1402, 1). 
caminho(1402, 1444, 1). caminho(1402, 1360, 1). caminho(1402, 1401, 1). caminho(1402, 1403, 1). 
caminho(1403, 1445, 1). caminho(1403, 1361, 1). caminho(1403, 1402, 1). caminho(1403, 1404, 1). 
caminho(1404, 1446, 1). caminho(1404, 1362, 1). caminho(1404, 1403, 1). caminho(1404, 1405, 1). 
caminho(1405, 1447, 1). caminho(1405, 1363, 1). caminho(1405, 1404, 1). caminho(1405, 1406, 1). 
caminho(1406, 1448, 1). caminho(1406, 1364, 1). caminho(1406, 1405, 1). caminho(1406, 1407, 1). 
caminho(1407, 1449, 1). caminho(1407, 1365, 1). caminho(1407, 1406, 1). caminho(1407, 1408, 1). 
caminho(1408, 1450, 1). caminho(1408, 1366, 1). caminho(1408, 1407, 1). caminho(1408, 1409, 1). 
caminho(1409, 1451, 1). caminho(1409, 1367, 1). caminho(1409, 1408, 1). caminho(1409, 1410, 1). 
caminho(1410, 1452, 1). caminho(1410, 1368, 1). caminho(1410, 1409, 1). caminho(1410, 1411, 1). 
caminho(1411, 1453, 1). caminho(1411, 1369, 1). caminho(1411, 1410, 1). caminho(1411, 1412, 1). 
caminho(1412, 1454, 1). caminho(1412, 1370, 1). caminho(1412, 1411, 1). caminho(1412, 1413, 1). 
caminho(1413, 1455, 1). caminho(1413, 1371, 1). caminho(1413, 1412, 1). caminho(1413, 1414, 1). 
caminho(1414, 1456, 1). caminho(1414, 1372, 1). caminho(1414, 1413, 1). caminho(1414, 1415, 1). 
caminho(1415, 1457, 1). caminho(1415, 1373, 1). caminho(1415, 1414, 1). caminho(1415, 1416, 1). 
caminho(1416, 1458, 1). caminho(1416, 1374, 1). caminho(1416, 1415, 1). caminho(1416, 1417, 1). 
caminho(1417, 1459, 1). caminho(1417, 1375, 1). caminho(1417, 1416, 1). caminho(1417, 1418, 1). 
caminho(1418, 1460, 1). caminho(1418, 1376, 1). caminho(1418, 1417, 1). caminho(1418, 1419, 1). 
caminho(1419, 1461, 1). caminho(1419, 1377, 1). caminho(1419, 1418, 1). caminho(1419, 1420, 1). 
caminho(1420, 1462, 1). caminho(1420, 1378, 1). caminho(1420, 1419, 1). caminho(1420, 1421, 1). 
caminho(1421, 1463, 1). caminho(1421, 1379, 1). caminho(1421, 1420, 1). caminho(1421, 1422, 1). 
caminho(1422, 1464, 1). caminho(1422, 1380, 1). caminho(1422, 1421, 1). caminho(1422, 1423, 1). 
caminho(1423, 1465, 1). caminho(1423, 1381, 1). caminho(1423, 1422, 1). caminho(1423, 1424, 1). 
caminho(1424, 1466, 1). caminho(1424, 1382, 1). caminho(1424, 1423, 1). caminho(1424, 1425, 1). 
caminho(1425, 1467, 1). caminho(1425, 1383, 1). caminho(1425, 1424, 1). caminho(1425, 1426, 1). 
caminho(1426, 1468, 1). caminho(1426, 1384, 1). caminho(1426, 1425, 1). caminho(1426, 1427, 1). 
caminho(1427, 1469, 1). caminho(1427, 1385, 1). caminho(1427, 1426, 1). caminho(1427, 1428, 1). 
caminho(1428, 1470, 1). caminho(1428, 1386, 1). caminho(1428, 1427, 1). 
caminho(1429, 1471, 1). caminho(1429, 1387, 1). caminho(1429, 1430, 1). 
caminho(1430, 1472, 1). caminho(1430, 1388, 1). caminho(1430, 1429, 1). caminho(1430, 1431, 1). 
caminho(1431, 1473, 1). caminho(1431, 1389, 1). caminho(1431, 1430, 1). caminho(1431, 1432, 1). 
caminho(1432, 1474, 1). caminho(1432, 1390, 1). caminho(1432, 1431, 1). caminho(1432, 1433, 1). 
caminho(1433, 1475, 1). caminho(1433, 1391, 1). caminho(1433, 1432, 1). caminho(1433, 1434, 1). 
caminho(1434, 1476, 1). caminho(1434, 1392, 1). caminho(1434, 1433, 1). caminho(1434, 1435, 1). 
caminho(1435, 1477, 1). caminho(1435, 1393, 1). caminho(1435, 1434, 1). caminho(1435, 1436, 1). 
caminho(1436, 1478, 1). caminho(1436, 1394, 1). caminho(1436, 1435, 1). caminho(1436, 1437, 1). 
caminho(1437, 1479, 1). caminho(1437, 1395, 1). caminho(1437, 1436, 1). caminho(1437, 1438, 1). 
caminho(1438, 1480, 1). caminho(1438, 1396, 1). caminho(1438, 1437, 1). caminho(1438, 1439, 1). 
caminho(1439, 1481, 1). caminho(1439, 1397, 1). caminho(1439, 1438, 1). caminho(1439, 1440, 1). 
caminho(1440, 1482, 1). caminho(1440, 1398, 1). caminho(1440, 1439, 1). caminho(1440, 1441, 1). 
caminho(1441, 1483, 1). caminho(1441, 1399, 1). caminho(1441, 1440, 1). caminho(1441, 1442, 1). 
caminho(1442, 1484, 1). caminho(1442, 1400, 1). caminho(1442, 1441, 1). caminho(1442, 1443, 1). 
caminho(1443, 1485, 1). caminho(1443, 1401, 1). caminho(1443, 1442, 1). caminho(1443, 1444, 1). 
caminho(1444, 1486, 1). caminho(1444, 1402, 1). caminho(1444, 1443, 1). caminho(1444, 1445, 1). 
caminho(1445, 1487, 1). caminho(1445, 1403, 1). caminho(1445, 1444, 1). caminho(1445, 1446, 1). 
caminho(1446, 1488, 1). caminho(1446, 1404, 1). caminho(1446, 1445, 1). caminho(1446, 1447, 1). 
caminho(1447, 1489, 1). caminho(1447, 1405, 1). caminho(1447, 1446, 1). caminho(1447, 1448, 1). 
caminho(1448, 1490, 1). caminho(1448, 1406, 1). caminho(1448, 1447, 1). caminho(1448, 1449, 1). 
caminho(1449, 1491, 1). caminho(1449, 1407, 1). caminho(1449, 1448, 1). caminho(1449, 1450, 1). 
caminho(1450, 1492, 1). caminho(1450, 1408, 1). caminho(1450, 1449, 1). caminho(1450, 1451, 1). 
caminho(1451, 1493, 1). caminho(1451, 1409, 1). caminho(1451, 1450, 1). caminho(1451, 1452, 1). 
caminho(1452, 1494, 1). caminho(1452, 1410, 1). caminho(1452, 1451, 1). caminho(1452, 1453, 1). 
caminho(1453, 1495, 1). caminho(1453, 1411, 1). caminho(1453, 1452, 1). caminho(1453, 1454, 1). 
caminho(1454, 1496, 1). caminho(1454, 1412, 1). caminho(1454, 1453, 1). caminho(1454, 1455, 1). 
caminho(1455, 1497, 1). caminho(1455, 1413, 1). caminho(1455, 1454, 1). caminho(1455, 1456, 1). 
caminho(1456, 1498, 1). caminho(1456, 1414, 1). caminho(1456, 1455, 1). caminho(1456, 1457, 1). 
caminho(1457, 1499, 1). caminho(1457, 1415, 1). caminho(1457, 1456, 1). caminho(1457, 1458, 1). 
caminho(1458, 1500, 1). caminho(1458, 1416, 1). caminho(1458, 1457, 1). caminho(1458, 1459, 1). 
caminho(1459, 1501, 1). caminho(1459, 1417, 1). caminho(1459, 1458, 1). caminho(1459, 1460, 1). 
caminho(1460, 1502, 1). caminho(1460, 1418, 1). caminho(1460, 1459, 1). caminho(1460, 1461, 1). 
caminho(1461, 1503, 1). caminho(1461, 1419, 1). caminho(1461, 1460, 1). caminho(1461, 1462, 1). 
caminho(1462, 1504, 1). caminho(1462, 1420, 1). caminho(1462, 1461, 1). caminho(1462, 1463, 1). 
caminho(1463, 1505, 1). caminho(1463, 1421, 1). caminho(1463, 1462, 1). caminho(1463, 1464, 1). 
caminho(1464, 1506, 1). caminho(1464, 1422, 1). caminho(1464, 1463, 1). caminho(1464, 1465, 1). 
caminho(1465, 1507, 1). caminho(1465, 1423, 1). caminho(1465, 1464, 1). caminho(1465, 1466, 1). 
caminho(1466, 1508, 1). caminho(1466, 1424, 1). caminho(1466, 1465, 1). caminho(1466, 1467, 1). 
caminho(1467, 1509, 1). caminho(1467, 1425, 1). caminho(1467, 1466, 1). caminho(1467, 1468, 1). 
caminho(1468, 1510, 1). caminho(1468, 1426, 1). caminho(1468, 1467, 1). caminho(1468, 1469, 1). 
caminho(1469, 1511, 1). caminho(1469, 1427, 1). caminho(1469, 1468, 1). caminho(1469, 1470, 1). 
caminho(1470, 1512, 1). caminho(1470, 1428, 1). caminho(1470, 1469, 1). 
caminho(1471, 1513, 1). caminho(1471, 1429, 1). caminho(1471, 1472, 1). 
caminho(1472, 1514, 1). caminho(1472, 1430, 1). caminho(1472, 1471, 1). caminho(1472, 1473, 1). 
caminho(1473, 1515, 1). caminho(1473, 1431, 1). caminho(1473, 1472, 1). caminho(1473, 1474, 1). 
caminho(1474, 1516, 1). caminho(1474, 1432, 1). caminho(1474, 1473, 1). caminho(1474, 1475, 1). 
caminho(1475, 1517, 1). caminho(1475, 1433, 1). caminho(1475, 1474, 1). caminho(1475, 1476, 1). 
caminho(1476, 1518, 1). caminho(1476, 1434, 1). caminho(1476, 1475, 1). caminho(1476, 1477, 1). 
caminho(1477, 1519, 1). caminho(1477, 1435, 1). caminho(1477, 1476, 1). caminho(1477, 1478, 1). 
caminho(1478, 1520, 1). caminho(1478, 1436, 1). caminho(1478, 1477, 1). caminho(1478, 1479, 1). 
caminho(1479, 1521, 1). caminho(1479, 1437, 1). caminho(1479, 1478, 1). caminho(1479, 1480, 1). 
caminho(1480, 1522, 1). caminho(1480, 1438, 1). caminho(1480, 1479, 1). caminho(1480, 1481, 1). 
caminho(1481, 1523, 1). caminho(1481, 1439, 1). caminho(1481, 1480, 1). caminho(1481, 1482, 1). 
caminho(1482, 1524, 1). caminho(1482, 1440, 1). caminho(1482, 1481, 1). caminho(1482, 1483, 1). 
caminho(1483, 1525, 1). caminho(1483, 1441, 1). caminho(1483, 1482, 1). caminho(1483, 1484, 1). 
caminho(1484, 1526, 1). caminho(1484, 1442, 1). caminho(1484, 1483, 1). caminho(1484, 1485, 1). 
caminho(1485, 1527, 1). caminho(1485, 1443, 1). caminho(1485, 1484, 1). caminho(1485, 1486, 1). 
caminho(1486, 1528, 1). caminho(1486, 1444, 1). caminho(1486, 1485, 1). caminho(1486, 1487, 1). 
caminho(1487, 1529, 1). caminho(1487, 1445, 1). caminho(1487, 1486, 1). caminho(1487, 1488, 1). 
caminho(1488, 1530, 1). caminho(1488, 1446, 1). caminho(1488, 1487, 1). caminho(1488, 1489, 1). 
caminho(1489, 1531, 1). caminho(1489, 1447, 1). caminho(1489, 1488, 1). caminho(1489, 1490, 1). 
caminho(1490, 1532, 1). caminho(1490, 1448, 1). caminho(1490, 1489, 1). caminho(1490, 1491, 1). 
caminho(1491, 1533, 1). caminho(1491, 1449, 1). caminho(1491, 1490, 1). caminho(1491, 1492, 1). 
caminho(1492, 1534, 1). caminho(1492, 1450, 1). caminho(1492, 1491, 1). caminho(1492, 1493, 1). 
caminho(1493, 1535, 1). caminho(1493, 1451, 1). caminho(1493, 1492, 1). caminho(1493, 1494, 1). 
caminho(1494, 1536, 1). caminho(1494, 1452, 1). caminho(1494, 1493, 1). caminho(1494, 1495, 1). 
caminho(1495, 1537, 1). caminho(1495, 1453, 1). caminho(1495, 1494, 1). caminho(1495, 1496, 1). 
caminho(1496, 1538, 1). caminho(1496, 1454, 1). caminho(1496, 1495, 1). caminho(1496, 1497, 1). 
caminho(1497, 1539, 1). caminho(1497, 1455, 1). caminho(1497, 1496, 1). caminho(1497, 1498, 1). 
caminho(1498, 1540, 1). caminho(1498, 1456, 1). caminho(1498, 1497, 1). caminho(1498, 1499, 1). 
caminho(1499, 1541, 1). caminho(1499, 1457, 1). caminho(1499, 1498, 1). caminho(1499, 1500, 1). 
caminho(1500, 1542, 1). caminho(1500, 1458, 1). caminho(1500, 1499, 1). caminho(1500, 1501, 1). 
caminho(1501, 1543, 1). caminho(1501, 1459, 1). caminho(1501, 1500, 1). caminho(1501, 1502, 1). 
caminho(1502, 1544, 1). caminho(1502, 1460, 1). caminho(1502, 1501, 1). caminho(1502, 1503, 1). 
caminho(1503, 1545, 1). caminho(1503, 1461, 1). caminho(1503, 1502, 1). caminho(1503, 1504, 1). 
caminho(1504, 1546, 1). caminho(1504, 1462, 1). caminho(1504, 1503, 1). caminho(1504, 1505, 1). 
caminho(1505, 1547, 1). caminho(1505, 1463, 1). caminho(1505, 1504, 1). caminho(1505, 1506, 1). 
caminho(1506, 1548, 1). caminho(1506, 1464, 1). caminho(1506, 1505, 1). caminho(1506, 1507, 1). 
caminho(1507, 1549, 1). caminho(1507, 1465, 1). caminho(1507, 1506, 1). caminho(1507, 1508, 1). 
caminho(1508, 1550, 1). caminho(1508, 1466, 1). caminho(1508, 1507, 1). caminho(1508, 1509, 1). 
caminho(1509, 1551, 1). caminho(1509, 1467, 1). caminho(1509, 1508, 1). caminho(1509, 1510, 1). 
caminho(1510, 1552, 1). caminho(1510, 1468, 1). caminho(1510, 1509, 1). caminho(1510, 1511, 1). 
caminho(1511, 1553, 1). caminho(1511, 1469, 1). caminho(1511, 1510, 1). caminho(1511, 1512, 1). 
caminho(1512, 1554, 1). caminho(1512, 1470, 1). caminho(1512, 1511, 1). 
caminho(1513, 1555, 1). caminho(1513, 1471, 1). caminho(1513, 1514, 1). 
caminho(1514, 1556, 1). caminho(1514, 1472, 1). caminho(1514, 1513, 1). caminho(1514, 1515, 1). 
caminho(1515, 1557, 1). caminho(1515, 1473, 1). caminho(1515, 1514, 1). caminho(1515, 1516, 1). 
caminho(1516, 1558, 1). caminho(1516, 1474, 1). caminho(1516, 1515, 1). caminho(1516, 1517, 1). 
caminho(1517, 1559, 1). caminho(1517, 1475, 1). caminho(1517, 1516, 1). caminho(1517, 1518, 1). 
caminho(1518, 1560, 1). caminho(1518, 1476, 1). caminho(1518, 1517, 1). caminho(1518, 1519, 1). 
caminho(1519, 1561, 1). caminho(1519, 1477, 1). caminho(1519, 1518, 1). caminho(1519, 1520, 1). 
caminho(1520, 1562, 1). caminho(1520, 1478, 1). caminho(1520, 1519, 1). caminho(1520, 1521, 1). 
caminho(1521, 1563, 1). caminho(1521, 1479, 1). caminho(1521, 1520, 1). caminho(1521, 1522, 1). 
caminho(1522, 1564, 1). caminho(1522, 1480, 1). caminho(1522, 1521, 1). caminho(1522, 1523, 1). 
caminho(1523, 1565, 1). caminho(1523, 1481, 1). caminho(1523, 1522, 1). caminho(1523, 1524, 1). 
caminho(1524, 1566, 1). caminho(1524, 1482, 1). caminho(1524, 1523, 1). caminho(1524, 1525, 1). 
caminho(1525, 1567, 1). caminho(1525, 1483, 1). caminho(1525, 1524, 1). caminho(1525, 1526, 1). 
caminho(1526, 1568, 1). caminho(1526, 1484, 1). caminho(1526, 1525, 1). caminho(1526, 1527, 1). 
caminho(1527, 1569, 1). caminho(1527, 1485, 1). caminho(1527, 1526, 1). caminho(1527, 1528, 1). 
caminho(1528, 1570, 1). caminho(1528, 1486, 1). caminho(1528, 1527, 1). caminho(1528, 1529, 1). 
caminho(1529, 1571, 1). caminho(1529, 1487, 1). caminho(1529, 1528, 1). caminho(1529, 1530, 1). 
caminho(1530, 1572, 1). caminho(1530, 1488, 1). caminho(1530, 1529, 1). caminho(1530, 1531, 1). 
caminho(1531, 1573, 1). caminho(1531, 1489, 1). caminho(1531, 1530, 1). caminho(1531, 1532, 1). 
caminho(1532, 1574, 1). caminho(1532, 1490, 1). caminho(1532, 1531, 1). caminho(1532, 1533, 1). 
caminho(1533, 1575, 1). caminho(1533, 1491, 1). caminho(1533, 1532, 1). caminho(1533, 1534, 1). 
caminho(1534, 1576, 1). caminho(1534, 1492, 1). caminho(1534, 1533, 1). caminho(1534, 1535, 1). 
caminho(1535, 1577, 1). caminho(1535, 1493, 1). caminho(1535, 1534, 1). caminho(1535, 1536, 1). 
caminho(1536, 1578, 1). caminho(1536, 1494, 1). caminho(1536, 1535, 1). caminho(1536, 1537, 1). 
caminho(1537, 1579, 1). caminho(1537, 1495, 1). caminho(1537, 1536, 1). caminho(1537, 1538, 1). 
caminho(1538, 1580, 1). caminho(1538, 1496, 1). caminho(1538, 1537, 1). caminho(1538, 1539, 1). 
caminho(1539, 1581, 1). caminho(1539, 1497, 1). caminho(1539, 1538, 1). caminho(1539, 1540, 1). 
caminho(1540, 1582, 1). caminho(1540, 1498, 1). caminho(1540, 1539, 1). caminho(1540, 1541, 1). 
caminho(1541, 1583, 1). caminho(1541, 1499, 1). caminho(1541, 1540, 1). caminho(1541, 1542, 1). 
caminho(1542, 1584, 1). caminho(1542, 1500, 1). caminho(1542, 1541, 1). caminho(1542, 1543, 1). 
caminho(1543, 1585, 1). caminho(1543, 1501, 1). caminho(1543, 1542, 1). caminho(1543, 1544, 1). 
caminho(1544, 1586, 1). caminho(1544, 1502, 1). caminho(1544, 1543, 1). caminho(1544, 1545, 1). 
caminho(1545, 1587, 1). caminho(1545, 1503, 1). caminho(1545, 1544, 1). caminho(1545, 1546, 1). 
caminho(1546, 1588, 1). caminho(1546, 1504, 1). caminho(1546, 1545, 1). caminho(1546, 1547, 1). 
caminho(1547, 1589, 1). caminho(1547, 1505, 1). caminho(1547, 1546, 1). caminho(1547, 1548, 1). 
caminho(1548, 1590, 1). caminho(1548, 1506, 1). caminho(1548, 1547, 1). caminho(1548, 1549, 1). 
caminho(1549, 1591, 1). caminho(1549, 1507, 1). caminho(1549, 1548, 1). caminho(1549, 1550, 1). 
caminho(1550, 1592, 1). caminho(1550, 1508, 1). caminho(1550, 1549, 1). caminho(1550, 1551, 1). 
caminho(1551, 1593, 1). caminho(1551, 1509, 1). caminho(1551, 1550, 1). caminho(1551, 1552, 1). 
caminho(1552, 1594, 1). caminho(1552, 1510, 1). caminho(1552, 1551, 1). caminho(1552, 1553, 1). 
caminho(1553, 1595, 1). caminho(1553, 1511, 1). caminho(1553, 1552, 1). caminho(1553, 1554, 1). 
caminho(1554, 1596, 1). caminho(1554, 1512, 1). caminho(1554, 1553, 1). 
caminho(1555, 1597, 1). caminho(1555, 1513, 1). caminho(1555, 1556, 1). 
caminho(1556, 1598, 1). caminho(1556, 1514, 1). caminho(1556, 1555, 1). caminho(1556, 1557, 1). 
caminho(1557, 1599, 1). caminho(1557, 1515, 1). caminho(1557, 1556, 1). caminho(1557, 1558, 1). 
caminho(1558, 1600, 1). caminho(1558, 1516, 1). caminho(1558, 1557, 1). caminho(1558, 1559, 1). 
caminho(1559, 1601, 1). caminho(1559, 1517, 1). caminho(1559, 1558, 1). caminho(1559, 1560, 1). 
caminho(1560, 1602, 1). caminho(1560, 1518, 1). caminho(1560, 1559, 1). caminho(1560, 1561, 1). 
caminho(1561, 1603, 1). caminho(1561, 1519, 1). caminho(1561, 1560, 1). caminho(1561, 1562, 1). 
caminho(1562, 1604, 1). caminho(1562, 1520, 1). caminho(1562, 1561, 1). caminho(1562, 1563, 1). 
caminho(1563, 1605, 1). caminho(1563, 1521, 1). caminho(1563, 1562, 1). caminho(1563, 1564, 1). 
caminho(1564, 1606, 1). caminho(1564, 1522, 1). caminho(1564, 1563, 1). caminho(1564, 1565, 1). 
caminho(1565, 1607, 1). caminho(1565, 1523, 1). caminho(1565, 1564, 1). caminho(1565, 1566, 1). 
caminho(1566, 1608, 1). caminho(1566, 1524, 1). caminho(1566, 1565, 1). caminho(1566, 1567, 1). 
caminho(1567, 1609, 1). caminho(1567, 1525, 1). caminho(1567, 1566, 1). caminho(1567, 1568, 1). 
caminho(1568, 1610, 1). caminho(1568, 1526, 1). caminho(1568, 1567, 1). caminho(1568, 1569, 1). 
caminho(1569, 1611, 1). caminho(1569, 1527, 1). caminho(1569, 1568, 1). caminho(1569, 1570, 1). 
caminho(1570, 1612, 1). caminho(1570, 1528, 1). caminho(1570, 1569, 1). caminho(1570, 1571, 1). 
caminho(1571, 1613, 1). caminho(1571, 1529, 1). caminho(1571, 1570, 1). caminho(1571, 1572, 1). 
caminho(1572, 1614, 1). caminho(1572, 1530, 1). caminho(1572, 1571, 1). caminho(1572, 1573, 1). 
caminho(1573, 1615, 1). caminho(1573, 1531, 1). caminho(1573, 1572, 1). caminho(1573, 1574, 1). 
caminho(1574, 1616, 1). caminho(1574, 1532, 1). caminho(1574, 1573, 1). caminho(1574, 1575, 1). 
caminho(1575, 1617, 1). caminho(1575, 1533, 1). caminho(1575, 1574, 1). caminho(1575, 1576, 1). 
caminho(1576, 1618, 1). caminho(1576, 1534, 1). caminho(1576, 1575, 1). caminho(1576, 1577, 1). 
caminho(1577, 1619, 1). caminho(1577, 1535, 1). caminho(1577, 1576, 1). caminho(1577, 1578, 1). 
caminho(1578, 1620, 1). caminho(1578, 1536, 1). caminho(1578, 1577, 1). caminho(1578, 1579, 1). 
caminho(1579, 1621, 1). caminho(1579, 1537, 1). caminho(1579, 1578, 1). caminho(1579, 1580, 1). 
caminho(1580, 1622, 1). caminho(1580, 1538, 1). caminho(1580, 1579, 1). caminho(1580, 1581, 1). 
caminho(1581, 1623, 1). caminho(1581, 1539, 1). caminho(1581, 1580, 1). caminho(1581, 1582, 1). 
caminho(1582, 1624, 1). caminho(1582, 1540, 1). caminho(1582, 1581, 1). caminho(1582, 1583, 1). 
caminho(1583, 1625, 1). caminho(1583, 1541, 1). caminho(1583, 1582, 1). caminho(1583, 1584, 1). 
caminho(1584, 1626, 1). caminho(1584, 1542, 1). caminho(1584, 1583, 1). caminho(1584, 1585, 1). 
caminho(1585, 1627, 1). caminho(1585, 1543, 1). caminho(1585, 1584, 1). caminho(1585, 1586, 1). 
caminho(1586, 1628, 1). caminho(1586, 1544, 1). caminho(1586, 1585, 1). caminho(1586, 1587, 1). 
caminho(1587, 1629, 1). caminho(1587, 1545, 1). caminho(1587, 1586, 1). caminho(1587, 1588, 1). 
caminho(1588, 1630, 1). caminho(1588, 1546, 1). caminho(1588, 1587, 1). caminho(1588, 1589, 1). 
caminho(1589, 1631, 1). caminho(1589, 1547, 1). caminho(1589, 1588, 1). caminho(1589, 1590, 1). 
caminho(1590, 1632, 1). caminho(1590, 1548, 1). caminho(1590, 1589, 1). caminho(1590, 1591, 1). 
caminho(1591, 1633, 1). caminho(1591, 1549, 1). caminho(1591, 1590, 1). caminho(1591, 1592, 1). 
caminho(1592, 1634, 1). caminho(1592, 1550, 1). caminho(1592, 1591, 1). caminho(1592, 1593, 1). 
caminho(1593, 1635, 1). caminho(1593, 1551, 1). caminho(1593, 1592, 1). caminho(1593, 1594, 1). 
caminho(1594, 1636, 1). caminho(1594, 1552, 1). caminho(1594, 1593, 1). caminho(1594, 1595, 1). 
caminho(1595, 1637, 1). caminho(1595, 1553, 1). caminho(1595, 1594, 1). caminho(1595, 1596, 1). 
caminho(1596, 1638, 1). caminho(1596, 1554, 1). caminho(1596, 1595, 1). 
caminho(1597, 1639, 1). caminho(1597, 1555, 1). caminho(1597, 1598, 1). 
caminho(1598, 1640, 1). caminho(1598, 1556, 1). caminho(1598, 1597, 1). caminho(1598, 1599, 1). 
caminho(1599, 1641, 1). caminho(1599, 1557, 1). caminho(1599, 1598, 1). caminho(1599, 1600, 1). 
caminho(1600, 1642, 1). caminho(1600, 1558, 1). caminho(1600, 1599, 1). caminho(1600, 1601, 1). 
caminho(1601, 1643, 1). caminho(1601, 1559, 1). caminho(1601, 1600, 1). caminho(1601, 1602, 1). 
caminho(1602, 1644, 1). caminho(1602, 1560, 1). caminho(1602, 1601, 1). caminho(1602, 1603, 1). 
caminho(1603, 1645, 1). caminho(1603, 1561, 1). caminho(1603, 1602, 1). caminho(1603, 1604, 1). 
caminho(1604, 1646, 1). caminho(1604, 1562, 1). caminho(1604, 1603, 1). caminho(1604, 1605, 1). 
caminho(1605, 1647, 1). caminho(1605, 1563, 1). caminho(1605, 1604, 1). caminho(1605, 1606, 1). 
caminho(1606, 1648, 1). caminho(1606, 1564, 1). caminho(1606, 1605, 1). caminho(1606, 1607, 1). 
caminho(1607, 1649, 1). caminho(1607, 1565, 1). caminho(1607, 1606, 1). caminho(1607, 1608, 1). 
caminho(1608, 1650, 1). caminho(1608, 1566, 1). caminho(1608, 1607, 1). caminho(1608, 1609, 1). 
caminho(1609, 1651, 1). caminho(1609, 1567, 1). caminho(1609, 1608, 1). caminho(1609, 1610, 1). 
caminho(1610, 1652, 1). caminho(1610, 1568, 1). caminho(1610, 1609, 1). caminho(1610, 1611, 1). 
caminho(1611, 1653, 1). caminho(1611, 1569, 1). caminho(1611, 1610, 1). caminho(1611, 1612, 1). 
caminho(1612, 1654, 1). caminho(1612, 1570, 1). caminho(1612, 1611, 1). caminho(1612, 1613, 1). 
caminho(1613, 1655, 1). caminho(1613, 1571, 1). caminho(1613, 1612, 1). caminho(1613, 1614, 1). 
caminho(1614, 1656, 1). caminho(1614, 1572, 1). caminho(1614, 1613, 1). caminho(1614, 1615, 1). 
caminho(1615, 1657, 1). caminho(1615, 1573, 1). caminho(1615, 1614, 1). caminho(1615, 1616, 1). 
caminho(1616, 1658, 1). caminho(1616, 1574, 1). caminho(1616, 1615, 1). caminho(1616, 1617, 1). 
caminho(1617, 1659, 1). caminho(1617, 1575, 1). caminho(1617, 1616, 1). caminho(1617, 1618, 1). 
caminho(1618, 1660, 1). caminho(1618, 1576, 1). caminho(1618, 1617, 1). caminho(1618, 1619, 1). 
caminho(1619, 1661, 1). caminho(1619, 1577, 1). caminho(1619, 1618, 1). caminho(1619, 1620, 1). 
caminho(1620, 1662, 1). caminho(1620, 1578, 1). caminho(1620, 1619, 1). caminho(1620, 1621, 1). 
caminho(1621, 1663, 1). caminho(1621, 1579, 1). caminho(1621, 1620, 1). caminho(1621, 1622, 1). 
caminho(1622, 1664, 1). caminho(1622, 1580, 1). caminho(1622, 1621, 1). caminho(1622, 1623, 1). 
caminho(1623, 1665, 1). caminho(1623, 1581, 1). caminho(1623, 1622, 1). caminho(1623, 1624, 1). 
caminho(1624, 1666, 1). caminho(1624, 1582, 1). caminho(1624, 1623, 1). caminho(1624, 1625, 1). 
caminho(1625, 1667, 1). caminho(1625, 1583, 1). caminho(1625, 1624, 1). caminho(1625, 1626, 1). 
caminho(1626, 1668, 1). caminho(1626, 1584, 1). caminho(1626, 1625, 1). caminho(1626, 1627, 1). 
caminho(1627, 1669, 1). caminho(1627, 1585, 1). caminho(1627, 1626, 1). caminho(1627, 1628, 1). 
caminho(1628, 1670, 1). caminho(1628, 1586, 1). caminho(1628, 1627, 1). caminho(1628, 1629, 1). 
caminho(1629, 1671, 1). caminho(1629, 1587, 1). caminho(1629, 1628, 1). caminho(1629, 1630, 1). 
caminho(1630, 1672, 1). caminho(1630, 1588, 1). caminho(1630, 1629, 1). caminho(1630, 1631, 1). 
caminho(1631, 1673, 1). caminho(1631, 1589, 1). caminho(1631, 1630, 1). caminho(1631, 1632, 1). 
caminho(1632, 1674, 1). caminho(1632, 1590, 1). caminho(1632, 1631, 1). caminho(1632, 1633, 1). 
caminho(1633, 1675, 1). caminho(1633, 1591, 1). caminho(1633, 1632, 1). caminho(1633, 1634, 1). 
caminho(1634, 1676, 1). caminho(1634, 1592, 1). caminho(1634, 1633, 1). caminho(1634, 1635, 1). 
caminho(1635, 1677, 1). caminho(1635, 1593, 1). caminho(1635, 1634, 1). caminho(1635, 1636, 1). 
caminho(1636, 1678, 1). caminho(1636, 1594, 1). caminho(1636, 1635, 1). caminho(1636, 1637, 1). 
caminho(1637, 1679, 1). caminho(1637, 1595, 1). caminho(1637, 1636, 1). caminho(1637, 1638, 1). 
caminho(1638, 1680, 1). caminho(1638, 1596, 1). caminho(1638, 1637, 1). 
caminho(1639, 1681, 1). caminho(1639, 1597, 1). caminho(1639, 1640, 1). 
caminho(1640, 1682, 1). caminho(1640, 1598, 1). caminho(1640, 1639, 1). caminho(1640, 1641, 1). 
caminho(1641, 1683, 1). caminho(1641, 1599, 1). caminho(1641, 1640, 1). caminho(1641, 1642, 1). 
caminho(1642, 1684, 1). caminho(1642, 1600, 1). caminho(1642, 1641, 1). caminho(1642, 1643, 1). 
caminho(1643, 1685, 1). caminho(1643, 1601, 1). caminho(1643, 1642, 1). caminho(1643, 1644, 1). 
caminho(1644, 1686, 1). caminho(1644, 1602, 1). caminho(1644, 1643, 1). caminho(1644, 1645, 1). 
caminho(1645, 1687, 1). caminho(1645, 1603, 1). caminho(1645, 1644, 1). caminho(1645, 1646, 1). 
caminho(1646, 1688, 1). caminho(1646, 1604, 1). caminho(1646, 1645, 1). caminho(1646, 1647, 1). 
caminho(1647, 1689, 1). caminho(1647, 1605, 1). caminho(1647, 1646, 1). caminho(1647, 1648, 1). 
caminho(1648, 1690, 1). caminho(1648, 1606, 1). caminho(1648, 1647, 1). caminho(1648, 1649, 1). 
caminho(1649, 1691, 1). caminho(1649, 1607, 1). caminho(1649, 1648, 1). caminho(1649, 1650, 1). 
caminho(1650, 1692, 1). caminho(1650, 1608, 1). caminho(1650, 1649, 1). caminho(1650, 1651, 1). 
caminho(1651, 1693, 1). caminho(1651, 1609, 1). caminho(1651, 1650, 1). caminho(1651, 1652, 1). 
caminho(1652, 1694, 1). caminho(1652, 1610, 1). caminho(1652, 1651, 1). caminho(1652, 1653, 1). 
caminho(1653, 1695, 1). caminho(1653, 1611, 1). caminho(1653, 1652, 1). caminho(1653, 1654, 1). 
caminho(1654, 1696, 1). caminho(1654, 1612, 1). caminho(1654, 1653, 1). caminho(1654, 1655, 1). 
caminho(1655, 1697, 1). caminho(1655, 1613, 1). caminho(1655, 1654, 1). caminho(1655, 1656, 1). 
caminho(1656, 1698, 1). caminho(1656, 1614, 1). caminho(1656, 1655, 1). caminho(1656, 1657, 1). 
caminho(1657, 1699, 1). caminho(1657, 1615, 1). caminho(1657, 1656, 1). caminho(1657, 1658, 1). 
caminho(1658, 1700, 1). caminho(1658, 1616, 1). caminho(1658, 1657, 1). caminho(1658, 1659, 1). 
caminho(1659, 1701, 1). caminho(1659, 1617, 1). caminho(1659, 1658, 1). caminho(1659, 1660, 1). 
caminho(1660, 1702, 1). caminho(1660, 1618, 1). caminho(1660, 1659, 1). caminho(1660, 1661, 1). 
caminho(1661, 1703, 1). caminho(1661, 1619, 1). caminho(1661, 1660, 1). caminho(1661, 1662, 1). 
caminho(1662, 1704, 1). caminho(1662, 1620, 1). caminho(1662, 1661, 1). caminho(1662, 1663, 1). 
caminho(1663, 1705, 1). caminho(1663, 1621, 1). caminho(1663, 1662, 1). caminho(1663, 1664, 1). 
caminho(1664, 1706, 1). caminho(1664, 1622, 1). caminho(1664, 1663, 1). caminho(1664, 1665, 1). 
caminho(1665, 1707, 1). caminho(1665, 1623, 1). caminho(1665, 1664, 1). caminho(1665, 1666, 1). 
caminho(1666, 1708, 1). caminho(1666, 1624, 1). caminho(1666, 1665, 1). caminho(1666, 1667, 1). 
caminho(1667, 1709, 1). caminho(1667, 1625, 1). caminho(1667, 1666, 1). caminho(1667, 1668, 1). 
caminho(1668, 1710, 1). caminho(1668, 1626, 1). caminho(1668, 1667, 1). caminho(1668, 1669, 1). 
caminho(1669, 1711, 1). caminho(1669, 1627, 1). caminho(1669, 1668, 1). caminho(1669, 1670, 1). 
caminho(1670, 1712, 1). caminho(1670, 1628, 1). caminho(1670, 1669, 1). caminho(1670, 1671, 1). 
caminho(1671, 1713, 1). caminho(1671, 1629, 1). caminho(1671, 1670, 1). caminho(1671, 1672, 1). 
caminho(1672, 1714, 1). caminho(1672, 1630, 1). caminho(1672, 1671, 1). caminho(1672, 1673, 1). 
caminho(1673, 1715, 1). caminho(1673, 1631, 1). caminho(1673, 1672, 1). caminho(1673, 1674, 1). 
caminho(1674, 1716, 1). caminho(1674, 1632, 1). caminho(1674, 1673, 1). caminho(1674, 1675, 1). 
caminho(1675, 1717, 1). caminho(1675, 1633, 1). caminho(1675, 1674, 1). caminho(1675, 1676, 1). 
caminho(1676, 1718, 1). caminho(1676, 1634, 1). caminho(1676, 1675, 1). caminho(1676, 1677, 1). 
caminho(1677, 1719, 1). caminho(1677, 1635, 1). caminho(1677, 1676, 1). caminho(1677, 1678, 1). 
caminho(1678, 1720, 1). caminho(1678, 1636, 1). caminho(1678, 1677, 1). caminho(1678, 1679, 1). 
caminho(1679, 1721, 1). caminho(1679, 1637, 1). caminho(1679, 1678, 1). caminho(1679, 1680, 1). 
caminho(1680, 1722, 1). caminho(1680, 1638, 1). caminho(1680, 1679, 1). 
caminho(1681, 1723, 1). caminho(1681, 1639, 1). caminho(1681, 1682, 1). 
caminho(1682, 1724, 1). caminho(1682, 1640, 1). caminho(1682, 1681, 1). caminho(1682, 1683, 1). 
caminho(1683, 1725, 1). caminho(1683, 1641, 1). caminho(1683, 1682, 1). caminho(1683, 1684, 1). 
caminho(1684, 1726, 1). caminho(1684, 1642, 1). caminho(1684, 1683, 1). caminho(1684, 1685, 1). 
caminho(1685, 1727, 1). caminho(1685, 1643, 1). caminho(1685, 1684, 1). caminho(1685, 1686, 1). 
caminho(1686, 1728, 1). caminho(1686, 1644, 1). caminho(1686, 1685, 1). caminho(1686, 1687, 1). 
caminho(1687, 1729, 1). caminho(1687, 1645, 1). caminho(1687, 1686, 1). caminho(1687, 1688, 1). 
caminho(1688, 1730, 1). caminho(1688, 1646, 1). caminho(1688, 1687, 1). caminho(1688, 1689, 1). 
caminho(1689, 1731, 1). caminho(1689, 1647, 1). caminho(1689, 1688, 1). caminho(1689, 1690, 1). 
caminho(1690, 1732, 1). caminho(1690, 1648, 1). caminho(1690, 1689, 1). caminho(1690, 1691, 1). 
caminho(1691, 1733, 1). caminho(1691, 1649, 1). caminho(1691, 1690, 1). caminho(1691, 1692, 1). 
caminho(1692, 1734, 1). caminho(1692, 1650, 1). caminho(1692, 1691, 1). caminho(1692, 1693, 1). 
caminho(1693, 1735, 1). caminho(1693, 1651, 1). caminho(1693, 1692, 1). caminho(1693, 1694, 1). 
caminho(1694, 1736, 1). caminho(1694, 1652, 1). caminho(1694, 1693, 1). caminho(1694, 1695, 1). 
caminho(1695, 1737, 1). caminho(1695, 1653, 1). caminho(1695, 1694, 1). caminho(1695, 1696, 1). 
caminho(1696, 1738, 1). caminho(1696, 1654, 1). caminho(1696, 1695, 1). caminho(1696, 1697, 1). 
caminho(1697, 1739, 1). caminho(1697, 1655, 1). caminho(1697, 1696, 1). caminho(1697, 1698, 1). 
caminho(1698, 1740, 1). caminho(1698, 1656, 1). caminho(1698, 1697, 1). caminho(1698, 1699, 1). 
caminho(1699, 1741, 1). caminho(1699, 1657, 1). caminho(1699, 1698, 1). caminho(1699, 1700, 1). 
caminho(1700, 1742, 1). caminho(1700, 1658, 1). caminho(1700, 1699, 1). caminho(1700, 1701, 1). 
caminho(1701, 1743, 1). caminho(1701, 1659, 1). caminho(1701, 1700, 1). caminho(1701, 1702, 1). 
caminho(1702, 1744, 1). caminho(1702, 1660, 1). caminho(1702, 1701, 1). caminho(1702, 1703, 1). 
caminho(1703, 1745, 1). caminho(1703, 1661, 1). caminho(1703, 1702, 1). caminho(1703, 1704, 1). 
caminho(1704, 1746, 1). caminho(1704, 1662, 1). caminho(1704, 1703, 1). caminho(1704, 1705, 1). 
caminho(1705, 1747, 1). caminho(1705, 1663, 1). caminho(1705, 1704, 1). caminho(1705, 1706, 1). 
caminho(1706, 1748, 1). caminho(1706, 1664, 1). caminho(1706, 1705, 1). caminho(1706, 1707, 1). 
caminho(1707, 1749, 1). caminho(1707, 1665, 1). caminho(1707, 1706, 1). caminho(1707, 1708, 1). 
caminho(1708, 1750, 1). caminho(1708, 1666, 1). caminho(1708, 1707, 1). caminho(1708, 1709, 1). 
caminho(1709, 1751, 1). caminho(1709, 1667, 1). caminho(1709, 1708, 1). caminho(1709, 1710, 1). 
caminho(1710, 1752, 1). caminho(1710, 1668, 1). caminho(1710, 1709, 1). caminho(1710, 1711, 1). 
caminho(1711, 1753, 1). caminho(1711, 1669, 1). caminho(1711, 1710, 1). caminho(1711, 1712, 1). 
caminho(1712, 1754, 1). caminho(1712, 1670, 1). caminho(1712, 1711, 1). caminho(1712, 1713, 1). 
caminho(1713, 1755, 1). caminho(1713, 1671, 1). caminho(1713, 1712, 1). caminho(1713, 1714, 1). 
caminho(1714, 1756, 1). caminho(1714, 1672, 1). caminho(1714, 1713, 1). caminho(1714, 1715, 1). 
caminho(1715, 1757, 1). caminho(1715, 1673, 1). caminho(1715, 1714, 1). caminho(1715, 1716, 1). 
caminho(1716, 1758, 1). caminho(1716, 1674, 1). caminho(1716, 1715, 1). caminho(1716, 1717, 1). 
caminho(1717, 1759, 1). caminho(1717, 1675, 1). caminho(1717, 1716, 1). caminho(1717, 1718, 1). 
caminho(1718, 1760, 1). caminho(1718, 1676, 1). caminho(1718, 1717, 1). caminho(1718, 1719, 1). 
caminho(1719, 1761, 1). caminho(1719, 1677, 1). caminho(1719, 1718, 1). caminho(1719, 1720, 1). 
caminho(1720, 1762, 1). caminho(1720, 1678, 1). caminho(1720, 1719, 1). caminho(1720, 1721, 1). 
caminho(1721, 1763, 1). caminho(1721, 1679, 1). caminho(1721, 1720, 1). caminho(1721, 1722, 1). 
caminho(1722, 1764, 1). caminho(1722, 1680, 1). caminho(1722, 1721, 1). 
caminho(1723, 1681, 1). caminho(1723, 1724, 1). 
caminho(1724, 1682, 1). caminho(1724, 1723, 1). caminho(1724, 1725, 1). 
caminho(1725, 1683, 1). caminho(1725, 1724, 1). caminho(1725, 1726, 1). 
caminho(1726, 1684, 1). caminho(1726, 1725, 1). caminho(1726, 1727, 1). 
caminho(1727, 1685, 1). caminho(1727, 1726, 1). caminho(1727, 1728, 1). 
caminho(1728, 1686, 1). caminho(1728, 1727, 1). caminho(1728, 1729, 1). 
caminho(1729, 1687, 1). caminho(1729, 1728, 1). caminho(1729, 1730, 1). 
caminho(1730, 1688, 1). caminho(1730, 1729, 1). caminho(1730, 1731, 1). 
caminho(1731, 1689, 1). caminho(1731, 1730, 1). caminho(1731, 1732, 1). 
caminho(1732, 1690, 1). caminho(1732, 1731, 1). caminho(1732, 1733, 1). 
caminho(1733, 1691, 1). caminho(1733, 1732, 1). caminho(1733, 1734, 1). 
caminho(1734, 1692, 1). caminho(1734, 1733, 1). caminho(1734, 1735, 1). 
caminho(1735, 1693, 1). caminho(1735, 1734, 1). caminho(1735, 1736, 1). 
caminho(1736, 1694, 1). caminho(1736, 1735, 1). caminho(1736, 1737, 1). 
caminho(1737, 1695, 1). caminho(1737, 1736, 1). caminho(1737, 1738, 1). 
caminho(1738, 1696, 1). caminho(1738, 1737, 1). caminho(1738, 1739, 1). 
caminho(1739, 1697, 1). caminho(1739, 1738, 1). caminho(1739, 1740, 1). 
caminho(1740, 1698, 1). caminho(1740, 1739, 1). caminho(1740, 1741, 1). 
caminho(1741, 1699, 1). caminho(1741, 1740, 1). caminho(1741, 1742, 1). 
caminho(1742, 1700, 1). caminho(1742, 1741, 1). caminho(1742, 1743, 1). 
caminho(1743, 1701, 1). caminho(1743, 1742, 1). caminho(1743, 1744, 1). 
caminho(1744, 1702, 1). caminho(1744, 1743, 1). caminho(1744, 1745, 1). 
caminho(1745, 1703, 1). caminho(1745, 1744, 1). caminho(1745, 1746, 1). 
caminho(1746, 1704, 1). caminho(1746, 1745, 1). caminho(1746, 1747, 1). 
caminho(1747, 1705, 1). caminho(1747, 1746, 1). caminho(1747, 1748, 1). 
caminho(1748, 1706, 1). caminho(1748, 1747, 1). caminho(1748, 1749, 1). 
caminho(1749, 1707, 1). caminho(1749, 1748, 1). caminho(1749, 1750, 1). 
caminho(1750, 1708, 1). caminho(1750, 1749, 1). caminho(1750, 1751, 1). 
caminho(1751, 1709, 1). caminho(1751, 1750, 1). caminho(1751, 1752, 1). 
caminho(1752, 1710, 1). caminho(1752, 1751, 1). caminho(1752, 1753, 1). 
caminho(1753, 1711, 1). caminho(1753, 1752, 1). caminho(1753, 1754, 1). 
caminho(1754, 1712, 1). caminho(1754, 1753, 1). caminho(1754, 1755, 1). 
caminho(1755, 1713, 1). caminho(1755, 1754, 1). caminho(1755, 1756, 1). 
caminho(1756, 1714, 1). caminho(1756, 1755, 1). caminho(1756, 1757, 1). 
caminho(1757, 1715, 1). caminho(1757, 1756, 1). caminho(1757, 1758, 1). 
caminho(1758, 1716, 1). caminho(1758, 1757, 1). caminho(1758, 1759, 1). 
caminho(1759, 1717, 1). caminho(1759, 1758, 1). caminho(1759, 1760, 1). 
caminho(1760, 1718, 1). caminho(1760, 1759, 1). caminho(1760, 1761, 1). 
caminho(1761, 1719, 1). caminho(1761, 1760, 1). caminho(1761, 1762, 1). 
caminho(1762, 1720, 1). caminho(1762, 1761, 1). caminho(1762, 1763, 1). 
caminho(1763, 1721, 1). caminho(1763, 1762, 1). caminho(1763, 1764, 1). 
caminho(1764, 1722, 1). caminho(1764, 1763, 1).
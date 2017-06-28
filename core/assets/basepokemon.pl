% Autores: Fillipe Campos e Thiago Alvoravel

%FATOS
%objeto(coordx, coordy, tipo)

%Fatos dinâmicos
:- dynamic pokemon/3.
:- dynamic objeto/3.
:- dynamic pokebolas/1.
:- dynamic quadrado/3.

pokemon('sparow', '30', 'cheia').
pokemon_tipo('sparow', 'normal', 1).
pokemon_tipo('sparow', 'voador', 2).
objeto('pokemon', 33, 35).
objeto('centroP', 11, 9).





path(A,B,V) :- walk(A,B,[V]).

walk(A,B,V) :-	caminho(A,X) ,
				not(member(X,V)) ,
				( 
					(B = X , write(B), write(', ')) , fail ; 
					walk(X,B,[A|V]) 
				),
				write(A), write(', ').


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
get_quadrado(Quadrado, Coordx, Coordy) :- quadrado(Quadrado, Coordx, Coordy).

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

get_quadrados(Quadrado, Coordx, Coordy) :- quadrado(Quadrado, Coordx, Coordy).

get_quadrado_norte(Quadrado, Norte, Resultado) :- 	quadrado(Quadrado, Coordx, Coordy) ,
													Xnovo is Coordx + 1 ,
													quadrado(Norte, Xnovo, Coordy) -> Resultado is Norte ;
													Resultado is 0.

get_quadrado_sul(Quadrado, Sul, Resultado) :- 		quadrado(Quadrado, Coordx, Coordy) ,
													Xnovo is Coordx - 1 ,
													quadrado(Sul, Xnovo, Coordy) -> Resultado is Sul ;
													Resultado is 0.

get_quadrado_leste(Quadrado, Leste, Resultado) :- 	quadrado(Quadrado, Coordx, Coordy) ,
													Ynovo is Coordy + 1 ,
													quadrado(Leste, Coordx, Ynovo) -> Resultado is Leste ;
													Resultado is 0.

get_quadrado_oeste(Quadrado, Oeste, Resultado) :- 	quadrado(Quadrado, Coordx, Coordy) ,
													Ynovo is Coordy - 1 ,
													quadrado(Oeste, Coordx, Ynovo) -> Resultado is Oeste ;
													Resultado is 0.

get_quadrados_adjacentes(QuadradoAtual, Norte, Sul, Leste, Oeste) :- 	get_quadrado_norte(QuadradoAtual, _, Norte) ,
																		get_quadrado_sul(QuadradoAtual, _, Sul) ,
																		get_quadrado_oeste(QuadradoAtual, _, Oeste) ,
																		get_quadrado_leste(QuadradoAtual, _, Leste).

%getQuadradoY(Quadrado, _, Coordy) :- quadrado(Quadrado, _, Coordy).

%caminhos(Norte, Atual) :-	quadrado(Atual, Cx, Cy) ,
%							quadrado(Norte, Nx, Ny) ,
%							Nx = Cx + 1 , Ny = Cy.

quadrado(1, 0, 0).
quadrado(2, 0, 1).
quadrado(3, 0, 2).
quadrado(4, 0, 3).
quadrado(5, 0, 4).
quadrado(6, 0, 5).
quadrado(7, 0, 6).
quadrado(8, 0, 7).
quadrado(9, 0, 8).
quadrado(10, 0, 9).
quadrado(11, 0, 10).
quadrado(12, 0, 11).
quadrado(13, 0, 12).
quadrado(14, 0, 13).
quadrado(15, 0, 14).
quadrado(16, 0, 15).
quadrado(17, 0, 16).
quadrado(18, 0, 17).
quadrado(19, 0, 18).
quadrado(20, 0, 19).
quadrado(21, 0, 20).
quadrado(22, 0, 21).
quadrado(23, 0, 22).
quadrado(24, 0, 23).
quadrado(25, 0, 24).
quadrado(26, 0, 25).
quadrado(27, 0, 26).
quadrado(28, 0, 27).
quadrado(29, 0, 28).
quadrado(30, 0, 29).
quadrado(31, 0, 30).
quadrado(32, 0, 31).
quadrado(33, 0, 32).
quadrado(34, 0, 33).
quadrado(35, 0, 34).
quadrado(36, 0, 35).
quadrado(37, 0, 36).
quadrado(38, 0, 37).
quadrado(39, 0, 38).
quadrado(40, 0, 39).
quadrado(41, 0, 40).
quadrado(42, 0, 41).
quadrado(43, 1, 0).
quadrado(44, 1, 1).
quadrado(45, 1, 2).
quadrado(46, 1, 3).
quadrado(47, 1, 4).
quadrado(48, 1, 5).
quadrado(49, 1, 6).
quadrado(50, 1, 7).
quadrado(51, 1, 8).
quadrado(52, 1, 9).
quadrado(53, 1, 10).
quadrado(54, 1, 11).
quadrado(55, 1, 12).
quadrado(56, 1, 13).
quadrado(57, 1, 14).
quadrado(58, 1, 15).
quadrado(59, 1, 16).
quadrado(60, 1, 17).
quadrado(61, 1, 18).
quadrado(62, 1, 19).
quadrado(63, 1, 20).
quadrado(64, 1, 21).
quadrado(65, 1, 22).
quadrado(66, 1, 23).
quadrado(67, 1, 24).
quadrado(68, 1, 25).
quadrado(69, 1, 26).
quadrado(70, 1, 27).
quadrado(71, 1, 28).
quadrado(72, 1, 29).
quadrado(73, 1, 30).
quadrado(74, 1, 31).
quadrado(75, 1, 32).
quadrado(76, 1, 33).
quadrado(77, 1, 34).
quadrado(78, 1, 35).
quadrado(79, 1, 36).
quadrado(80, 1, 37).
quadrado(81, 1, 38).
quadrado(82, 1, 39).
quadrado(83, 1, 40).
quadrado(84, 1, 41).
quadrado(85, 2, 0).
quadrado(86, 2, 1).
quadrado(87, 2, 2).
quadrado(88, 2, 3).
quadrado(89, 2, 4).
quadrado(90, 2, 5).
quadrado(91, 2, 6).
quadrado(92, 2, 7).
quadrado(93, 2, 8).
quadrado(94, 2, 9).
quadrado(95, 2, 10).
quadrado(96, 2, 11).
quadrado(97, 2, 12).
quadrado(98, 2, 13).
quadrado(99, 2, 14).
quadrado(100, 2, 15).
quadrado(101, 2, 16).
quadrado(102, 2, 17).
quadrado(103, 2, 18).
quadrado(104, 2, 19).
quadrado(105, 2, 20).
quadrado(106, 2, 21).
quadrado(107, 2, 22).
quadrado(108, 2, 23).
quadrado(109, 2, 24).
quadrado(110, 2, 25).
quadrado(111, 2, 26).
quadrado(112, 2, 27).
quadrado(113, 2, 28).
quadrado(114, 2, 29).
quadrado(115, 2, 30).
quadrado(116, 2, 31).
quadrado(117, 2, 32).
quadrado(118, 2, 33).
quadrado(119, 2, 34).
quadrado(120, 2, 35).
quadrado(121, 2, 36).
quadrado(122, 2, 37).
quadrado(123, 2, 38).
quadrado(124, 2, 39).
quadrado(125, 2, 40).
quadrado(126, 2, 41).
quadrado(127, 3, 0).
quadrado(128, 3, 1).
quadrado(129, 3, 2).
quadrado(130, 3, 3).
quadrado(131, 3, 4).
quadrado(132, 3, 5).
quadrado(133, 3, 6).
quadrado(134, 3, 7).
quadrado(135, 3, 8).
quadrado(136, 3, 9).
quadrado(137, 3, 10).
quadrado(138, 3, 11).
quadrado(139, 3, 12).
quadrado(140, 3, 13).
quadrado(141, 3, 14).
quadrado(142, 3, 15).
quadrado(143, 3, 16).
quadrado(144, 3, 17).
quadrado(145, 3, 18).
quadrado(146, 3, 19).
quadrado(147, 3, 20).
quadrado(148, 3, 21).
quadrado(149, 3, 22).
quadrado(150, 3, 23).
quadrado(151, 3, 24).
quadrado(152, 3, 25).
quadrado(153, 3, 26).
quadrado(154, 3, 27).
quadrado(155, 3, 28).
quadrado(156, 3, 29).
quadrado(157, 3, 30).
quadrado(158, 3, 31).
quadrado(159, 3, 32).
quadrado(160, 3, 33).
quadrado(161, 3, 34).
quadrado(162, 3, 35).
quadrado(163, 3, 36).
quadrado(164, 3, 37).
quadrado(165, 3, 38).
quadrado(166, 3, 39).
quadrado(167, 3, 40).
quadrado(168, 3, 41).
quadrado(169, 4, 0).
quadrado(170, 4, 1).
quadrado(171, 4, 2).
quadrado(172, 4, 3).
quadrado(173, 4, 4).
quadrado(174, 4, 5).
quadrado(175, 4, 6).
quadrado(176, 4, 7).
quadrado(177, 4, 8).
quadrado(178, 4, 9).
quadrado(179, 4, 10).
quadrado(180, 4, 11).
quadrado(181, 4, 12).
quadrado(182, 4, 13).
quadrado(183, 4, 14).
quadrado(184, 4, 15).
quadrado(185, 4, 16).
quadrado(186, 4, 17).
quadrado(187, 4, 18).
quadrado(188, 4, 19).
quadrado(189, 4, 20).
quadrado(190, 4, 21).
quadrado(191, 4, 22).
quadrado(192, 4, 23).
quadrado(193, 4, 24).
quadrado(194, 4, 25).
quadrado(195, 4, 26).
quadrado(196, 4, 27).
quadrado(197, 4, 28).
quadrado(198, 4, 29).
quadrado(199, 4, 30).
quadrado(200, 4, 31).
quadrado(201, 4, 32).
quadrado(202, 4, 33).
quadrado(203, 4, 34).
quadrado(204, 4, 35).
quadrado(205, 4, 36).
quadrado(206, 4, 37).
quadrado(207, 4, 38).
quadrado(208, 4, 39).
quadrado(209, 4, 40).
quadrado(210, 4, 41).
quadrado(211, 5, 0).
quadrado(212, 5, 1).
quadrado(213, 5, 2).
quadrado(214, 5, 3).
quadrado(215, 5, 4).
quadrado(216, 5, 5).
quadrado(217, 5, 6).
quadrado(218, 5, 7).
quadrado(219, 5, 8).
quadrado(220, 5, 9).
quadrado(221, 5, 10).
quadrado(222, 5, 11).
quadrado(223, 5, 12).
quadrado(224, 5, 13).
quadrado(225, 5, 14).
quadrado(226, 5, 15).
quadrado(227, 5, 16).
quadrado(228, 5, 17).
quadrado(229, 5, 18).
quadrado(230, 5, 19).
quadrado(231, 5, 20).
quadrado(232, 5, 21).
quadrado(233, 5, 22).
quadrado(234, 5, 23).
quadrado(235, 5, 24).
quadrado(236, 5, 25).
quadrado(237, 5, 26).
quadrado(238, 5, 27).
quadrado(239, 5, 28).
quadrado(240, 5, 29).
quadrado(241, 5, 30).
quadrado(242, 5, 31).
quadrado(243, 5, 32).
quadrado(244, 5, 33).
quadrado(245, 5, 34).
quadrado(246, 5, 35).
quadrado(247, 5, 36).
quadrado(248, 5, 37).
quadrado(249, 5, 38).
quadrado(250, 5, 39).
quadrado(251, 5, 40).
quadrado(252, 5, 41).
quadrado(253, 6, 0).
quadrado(254, 6, 1).
quadrado(255, 6, 2).
quadrado(256, 6, 3).
quadrado(257, 6, 4).
quadrado(258, 6, 5).
quadrado(259, 6, 6).
quadrado(260, 6, 7).
quadrado(261, 6, 8).
quadrado(262, 6, 9).
quadrado(263, 6, 10).
quadrado(264, 6, 11).
quadrado(265, 6, 12).
quadrado(266, 6, 13).
quadrado(267, 6, 14).
quadrado(268, 6, 15).
quadrado(269, 6, 16).
quadrado(270, 6, 17).
quadrado(271, 6, 18).
quadrado(272, 6, 19).
quadrado(273, 6, 20).
quadrado(274, 6, 21).
quadrado(275, 6, 22).
quadrado(276, 6, 23).
quadrado(277, 6, 24).
quadrado(278, 6, 25).
quadrado(279, 6, 26).
quadrado(280, 6, 27).
quadrado(281, 6, 28).
quadrado(282, 6, 29).
quadrado(283, 6, 30).
quadrado(284, 6, 31).
quadrado(285, 6, 32).
quadrado(286, 6, 33).
quadrado(287, 6, 34).
quadrado(288, 6, 35).
quadrado(289, 6, 36).
quadrado(290, 6, 37).
quadrado(291, 6, 38).
quadrado(292, 6, 39).
quadrado(293, 6, 40).
quadrado(294, 6, 41).
quadrado(295, 7, 0).
quadrado(296, 7, 1).
quadrado(297, 7, 2).
quadrado(298, 7, 3).
quadrado(299, 7, 4).
quadrado(300, 7, 5).
quadrado(301, 7, 6).
quadrado(302, 7, 7).
quadrado(303, 7, 8).
quadrado(304, 7, 9).
quadrado(305, 7, 10).
quadrado(306, 7, 11).
quadrado(307, 7, 12).
quadrado(308, 7, 13).
quadrado(309, 7, 14).
quadrado(310, 7, 15).
quadrado(311, 7, 16).
quadrado(312, 7, 17).
quadrado(313, 7, 18).
quadrado(314, 7, 19).
quadrado(315, 7, 20).
quadrado(316, 7, 21).
quadrado(317, 7, 22).
quadrado(318, 7, 23).
quadrado(319, 7, 24).
quadrado(320, 7, 25).
quadrado(321, 7, 26).
quadrado(322, 7, 27).
quadrado(323, 7, 28).
quadrado(324, 7, 29).
quadrado(325, 7, 30).
quadrado(326, 7, 31).
quadrado(327, 7, 32).
quadrado(328, 7, 33).
quadrado(329, 7, 34).
quadrado(330, 7, 35).
quadrado(331, 7, 36).
quadrado(332, 7, 37).
quadrado(333, 7, 38).
quadrado(334, 7, 39).
quadrado(335, 7, 40).
quadrado(336, 7, 41).
quadrado(337, 8, 0).
quadrado(338, 8, 1).
quadrado(339, 8, 2).
quadrado(340, 8, 3).
quadrado(341, 8, 4).
quadrado(342, 8, 5).
quadrado(343, 8, 6).
quadrado(344, 8, 7).
quadrado(345, 8, 8).
quadrado(346, 8, 9).
quadrado(347, 8, 10).
quadrado(348, 8, 11).
quadrado(349, 8, 12).
quadrado(350, 8, 13).
quadrado(351, 8, 14).
quadrado(352, 8, 15).
quadrado(353, 8, 16).
quadrado(354, 8, 17).
quadrado(355, 8, 18).
quadrado(356, 8, 19).
quadrado(357, 8, 20).
quadrado(358, 8, 21).
quadrado(359, 8, 22).
quadrado(360, 8, 23).
quadrado(361, 8, 24).
quadrado(362, 8, 25).
quadrado(363, 8, 26).
quadrado(364, 8, 27).
quadrado(365, 8, 28).
quadrado(366, 8, 29).
quadrado(367, 8, 30).
quadrado(368, 8, 31).
quadrado(369, 8, 32).
quadrado(370, 8, 33).
quadrado(371, 8, 34).
quadrado(372, 8, 35).
quadrado(373, 8, 36).
quadrado(374, 8, 37).
quadrado(375, 8, 38).
quadrado(376, 8, 39).
quadrado(377, 8, 40).
quadrado(378, 8, 41).
quadrado(379, 9, 0).
quadrado(380, 9, 1).
quadrado(381, 9, 2).
quadrado(382, 9, 3).
quadrado(383, 9, 4).
quadrado(384, 9, 5).
quadrado(385, 9, 6).
quadrado(386, 9, 7).
quadrado(387, 9, 8).
quadrado(388, 9, 9).
quadrado(389, 9, 10).
quadrado(390, 9, 11).
quadrado(391, 9, 12).
quadrado(392, 9, 13).
quadrado(393, 9, 14).
quadrado(394, 9, 15).
quadrado(395, 9, 16).
quadrado(396, 9, 17).
quadrado(397, 9, 18).
quadrado(398, 9, 19).
quadrado(399, 9, 20).
quadrado(400, 9, 21).
quadrado(401, 9, 22).
quadrado(402, 9, 23).
quadrado(403, 9, 24).
quadrado(404, 9, 25).
quadrado(405, 9, 26).
quadrado(406, 9, 27).
quadrado(407, 9, 28).
quadrado(408, 9, 29).
quadrado(409, 9, 30).
quadrado(410, 9, 31).
quadrado(411, 9, 32).
quadrado(412, 9, 33).
quadrado(413, 9, 34).
quadrado(414, 9, 35).
quadrado(415, 9, 36).
quadrado(416, 9, 37).
quadrado(417, 9, 38).
quadrado(418, 9, 39).
quadrado(419, 9, 40).
quadrado(420, 9, 41).
quadrado(421, 10, 0).
quadrado(422, 10, 1).
quadrado(423, 10, 2).
quadrado(424, 10, 3).
quadrado(425, 10, 4).
quadrado(426, 10, 5).
quadrado(427, 10, 6).
quadrado(428, 10, 7).
quadrado(429, 10, 8).
quadrado(430, 10, 9).
quadrado(431, 10, 10).
quadrado(432, 10, 11).
quadrado(433, 10, 12).
quadrado(434, 10, 13).
quadrado(435, 10, 14).
quadrado(436, 10, 15).
quadrado(437, 10, 16).
quadrado(438, 10, 17).
quadrado(439, 10, 18).
quadrado(440, 10, 19).
quadrado(441, 10, 20).
quadrado(442, 10, 21).
quadrado(443, 10, 22).
quadrado(444, 10, 23).
quadrado(445, 10, 24).
quadrado(446, 10, 25).
quadrado(447, 10, 26).
quadrado(448, 10, 27).
quadrado(449, 10, 28).
quadrado(450, 10, 29).
quadrado(451, 10, 30).
quadrado(452, 10, 31).
quadrado(453, 10, 32).
quadrado(454, 10, 33).
quadrado(455, 10, 34).
quadrado(456, 10, 35).
quadrado(457, 10, 36).
quadrado(458, 10, 37).
quadrado(459, 10, 38).
quadrado(460, 10, 39).
quadrado(461, 10, 40).
quadrado(462, 10, 41).
quadrado(463, 11, 0).
quadrado(464, 11, 1).
quadrado(465, 11, 2).
quadrado(466, 11, 3).
quadrado(467, 11, 4).
quadrado(468, 11, 5).
quadrado(469, 11, 6).
quadrado(470, 11, 7).
quadrado(471, 11, 8).
quadrado(472, 11, 9).
quadrado(473, 11, 10).
quadrado(474, 11, 11).
quadrado(475, 11, 12).
quadrado(476, 11, 13).
quadrado(477, 11, 14).
quadrado(478, 11, 15).
quadrado(479, 11, 16).
quadrado(480, 11, 17).
quadrado(481, 11, 18).
quadrado(482, 11, 19).
quadrado(483, 11, 20).
quadrado(484, 11, 21).
quadrado(485, 11, 22).
quadrado(486, 11, 23).
quadrado(487, 11, 24).
quadrado(488, 11, 25).
quadrado(489, 11, 26).
quadrado(490, 11, 27).
quadrado(491, 11, 28).
quadrado(492, 11, 29).
quadrado(493, 11, 30).
quadrado(494, 11, 31).
quadrado(495, 11, 32).
quadrado(496, 11, 33).
quadrado(497, 11, 34).
quadrado(498, 11, 35).
quadrado(499, 11, 36).
quadrado(500, 11, 37).
quadrado(501, 11, 38).
quadrado(502, 11, 39).
quadrado(503, 11, 40).
quadrado(504, 11, 41).
quadrado(505, 12, 0).
quadrado(506, 12, 1).
quadrado(507, 12, 2).
quadrado(508, 12, 3).
quadrado(509, 12, 4).
quadrado(510, 12, 5).
quadrado(511, 12, 6).
quadrado(512, 12, 7).
quadrado(513, 12, 8).
quadrado(514, 12, 9).
quadrado(515, 12, 10).
quadrado(516, 12, 11).
quadrado(517, 12, 12).
quadrado(518, 12, 13).
quadrado(519, 12, 14).
quadrado(520, 12, 15).
quadrado(521, 12, 16).
quadrado(522, 12, 17).
quadrado(523, 12, 18).
quadrado(524, 12, 19).
quadrado(525, 12, 20).
quadrado(526, 12, 21).
quadrado(527, 12, 22).
quadrado(528, 12, 23).
quadrado(529, 12, 24).
quadrado(530, 12, 25).
quadrado(531, 12, 26).
quadrado(532, 12, 27).
quadrado(533, 12, 28).
quadrado(534, 12, 29).
quadrado(535, 12, 30).
quadrado(536, 12, 31).
quadrado(537, 12, 32).
quadrado(538, 12, 33).
quadrado(539, 12, 34).
quadrado(540, 12, 35).
quadrado(541, 12, 36).
quadrado(542, 12, 37).
quadrado(543, 12, 38).
quadrado(544, 12, 39).
quadrado(545, 12, 40).
quadrado(546, 12, 41).
quadrado(547, 13, 0).
quadrado(548, 13, 1).
quadrado(549, 13, 2).
quadrado(550, 13, 3).
quadrado(551, 13, 4).
quadrado(552, 13, 5).
quadrado(553, 13, 6).
quadrado(554, 13, 7).
quadrado(555, 13, 8).
quadrado(556, 13, 9).
quadrado(557, 13, 10).
quadrado(558, 13, 11).
quadrado(559, 13, 12).
quadrado(560, 13, 13).
quadrado(561, 13, 14).
quadrado(562, 13, 15).
quadrado(563, 13, 16).
quadrado(564, 13, 17).
quadrado(565, 13, 18).
quadrado(566, 13, 19).
quadrado(567, 13, 20).
quadrado(568, 13, 21).
quadrado(569, 13, 22).
quadrado(570, 13, 23).
quadrado(571, 13, 24).
quadrado(572, 13, 25).
quadrado(573, 13, 26).
quadrado(574, 13, 27).
quadrado(575, 13, 28).
quadrado(576, 13, 29).
quadrado(577, 13, 30).
quadrado(578, 13, 31).
quadrado(579, 13, 32).
quadrado(580, 13, 33).
quadrado(581, 13, 34).
quadrado(582, 13, 35).
quadrado(583, 13, 36).
quadrado(584, 13, 37).
quadrado(585, 13, 38).
quadrado(586, 13, 39).
quadrado(587, 13, 40).
quadrado(588, 13, 41).
quadrado(589, 14, 0).
quadrado(590, 14, 1).
quadrado(591, 14, 2).
quadrado(592, 14, 3).
quadrado(593, 14, 4).
quadrado(594, 14, 5).
quadrado(595, 14, 6).
quadrado(596, 14, 7).
quadrado(597, 14, 8).
quadrado(598, 14, 9).
quadrado(599, 14, 10).
quadrado(600, 14, 11).
quadrado(601, 14, 12).
quadrado(602, 14, 13).
quadrado(603, 14, 14).
quadrado(604, 14, 15).
quadrado(605, 14, 16).
quadrado(606, 14, 17).
quadrado(607, 14, 18).
quadrado(608, 14, 19).
quadrado(609, 14, 20).
quadrado(610, 14, 21).
quadrado(611, 14, 22).
quadrado(612, 14, 23).
quadrado(613, 14, 24).
quadrado(614, 14, 25).
quadrado(615, 14, 26).
quadrado(616, 14, 27).
quadrado(617, 14, 28).
quadrado(618, 14, 29).
quadrado(619, 14, 30).
quadrado(620, 14, 31).
quadrado(621, 14, 32).
quadrado(622, 14, 33).
quadrado(623, 14, 34).
quadrado(624, 14, 35).
quadrado(625, 14, 36).
quadrado(626, 14, 37).
quadrado(627, 14, 38).
quadrado(628, 14, 39).
quadrado(629, 14, 40).
quadrado(630, 14, 41).
quadrado(631, 15, 0).
quadrado(632, 15, 1).
quadrado(633, 15, 2).
quadrado(634, 15, 3).
quadrado(635, 15, 4).
quadrado(636, 15, 5).
quadrado(637, 15, 6).
quadrado(638, 15, 7).
quadrado(639, 15, 8).
quadrado(640, 15, 9).
quadrado(641, 15, 10).
quadrado(642, 15, 11).
quadrado(643, 15, 12).
quadrado(644, 15, 13).
quadrado(645, 15, 14).
quadrado(646, 15, 15).
quadrado(647, 15, 16).
quadrado(648, 15, 17).
quadrado(649, 15, 18).
quadrado(650, 15, 19).
quadrado(651, 15, 20).
quadrado(652, 15, 21).
quadrado(653, 15, 22).
quadrado(654, 15, 23).
quadrado(655, 15, 24).
quadrado(656, 15, 25).
quadrado(657, 15, 26).
quadrado(658, 15, 27).
quadrado(659, 15, 28).
quadrado(660, 15, 29).
quadrado(661, 15, 30).
quadrado(662, 15, 31).
quadrado(663, 15, 32).
quadrado(664, 15, 33).
quadrado(665, 15, 34).
quadrado(666, 15, 35).
quadrado(667, 15, 36).
quadrado(668, 15, 37).
quadrado(669, 15, 38).
quadrado(670, 15, 39).
quadrado(671, 15, 40).
quadrado(672, 15, 41).
quadrado(673, 16, 0).
quadrado(674, 16, 1).
quadrado(675, 16, 2).
quadrado(676, 16, 3).
quadrado(677, 16, 4).
quadrado(678, 16, 5).
quadrado(679, 16, 6).
quadrado(680, 16, 7).
quadrado(681, 16, 8).
quadrado(682, 16, 9).
quadrado(683, 16, 10).
quadrado(684, 16, 11).
quadrado(685, 16, 12).
quadrado(686, 16, 13).
quadrado(687, 16, 14).
quadrado(688, 16, 15).
quadrado(689, 16, 16).
quadrado(690, 16, 17).
quadrado(691, 16, 18).
quadrado(692, 16, 19).
quadrado(693, 16, 20).
quadrado(694, 16, 21).
quadrado(695, 16, 22).
quadrado(696, 16, 23).
quadrado(697, 16, 24).
quadrado(698, 16, 25).
quadrado(699, 16, 26).
quadrado(700, 16, 27).
quadrado(701, 16, 28).
quadrado(702, 16, 29).
quadrado(703, 16, 30).
quadrado(704, 16, 31).
quadrado(705, 16, 32).
quadrado(706, 16, 33).
quadrado(707, 16, 34).
quadrado(708, 16, 35).
quadrado(709, 16, 36).
quadrado(710, 16, 37).
quadrado(711, 16, 38).
quadrado(712, 16, 39).
quadrado(713, 16, 40).
quadrado(714, 16, 41).
quadrado(715, 17, 0).
quadrado(716, 17, 1).
quadrado(717, 17, 2).
quadrado(718, 17, 3).
quadrado(719, 17, 4).
quadrado(720, 17, 5).
quadrado(721, 17, 6).
quadrado(722, 17, 7).
quadrado(723, 17, 8).
quadrado(724, 17, 9).
quadrado(725, 17, 10).
quadrado(726, 17, 11).
quadrado(727, 17, 12).
quadrado(728, 17, 13).
quadrado(729, 17, 14).
quadrado(730, 17, 15).
quadrado(731, 17, 16).
quadrado(732, 17, 17).
quadrado(733, 17, 18).
quadrado(734, 17, 19).
quadrado(735, 17, 20).
quadrado(736, 17, 21).
quadrado(737, 17, 22).
quadrado(738, 17, 23).
quadrado(739, 17, 24).
quadrado(740, 17, 25).
quadrado(741, 17, 26).
quadrado(742, 17, 27).
quadrado(743, 17, 28).
quadrado(744, 17, 29).
quadrado(745, 17, 30).
quadrado(746, 17, 31).
quadrado(747, 17, 32).
quadrado(748, 17, 33).
quadrado(749, 17, 34).
quadrado(750, 17, 35).
quadrado(751, 17, 36).
quadrado(752, 17, 37).
quadrado(753, 17, 38).
quadrado(754, 17, 39).
quadrado(755, 17, 40).
quadrado(756, 17, 41).
quadrado(757, 18, 0).
quadrado(758, 18, 1).
quadrado(759, 18, 2).
quadrado(760, 18, 3).
quadrado(761, 18, 4).
quadrado(762, 18, 5).
quadrado(763, 18, 6).
quadrado(764, 18, 7).
quadrado(765, 18, 8).
quadrado(766, 18, 9).
quadrado(767, 18, 10).
quadrado(768, 18, 11).
quadrado(769, 18, 12).
quadrado(770, 18, 13).
quadrado(771, 18, 14).
quadrado(772, 18, 15).
quadrado(773, 18, 16).
quadrado(774, 18, 17).
quadrado(775, 18, 18).
quadrado(776, 18, 19).
quadrado(777, 18, 20).
quadrado(778, 18, 21).
quadrado(779, 18, 22).
quadrado(780, 18, 23).
quadrado(781, 18, 24).
quadrado(782, 18, 25).
quadrado(783, 18, 26).
quadrado(784, 18, 27).
quadrado(785, 18, 28).
quadrado(786, 18, 29).
quadrado(787, 18, 30).
quadrado(788, 18, 31).
quadrado(789, 18, 32).
quadrado(790, 18, 33).
quadrado(791, 18, 34).
quadrado(792, 18, 35).
quadrado(793, 18, 36).
quadrado(794, 18, 37).
quadrado(795, 18, 38).
quadrado(796, 18, 39).
quadrado(797, 18, 40).
quadrado(798, 18, 41).
quadrado(799, 19, 0).
quadrado(800, 19, 1).
quadrado(801, 19, 2).
quadrado(802, 19, 3).
quadrado(803, 19, 4).
quadrado(804, 19, 5).
quadrado(805, 19, 6).
quadrado(806, 19, 7).
quadrado(807, 19, 8).
quadrado(808, 19, 9).
quadrado(809, 19, 10).
quadrado(810, 19, 11).
quadrado(811, 19, 12).
quadrado(812, 19, 13).
quadrado(813, 19, 14).
quadrado(814, 19, 15).
quadrado(815, 19, 16).
quadrado(816, 19, 17).
quadrado(817, 19, 18).
quadrado(818, 19, 19).
quadrado(819, 19, 20).
quadrado(820, 19, 21).
quadrado(821, 19, 22).
quadrado(822, 19, 23).
quadrado(823, 19, 24).
quadrado(824, 19, 25).
quadrado(825, 19, 26).
quadrado(826, 19, 27).
quadrado(827, 19, 28).
quadrado(828, 19, 29).
quadrado(829, 19, 30).
quadrado(830, 19, 31).
quadrado(831, 19, 32).
quadrado(832, 19, 33).
quadrado(833, 19, 34).
quadrado(834, 19, 35).
quadrado(835, 19, 36).
quadrado(836, 19, 37).
quadrado(837, 19, 38).
quadrado(838, 19, 39).
quadrado(839, 19, 40).
quadrado(840, 19, 41).
quadrado(841, 20, 0).
quadrado(842, 20, 1).
quadrado(843, 20, 2).
quadrado(844, 20, 3).
quadrado(845, 20, 4).
quadrado(846, 20, 5).
quadrado(847, 20, 6).
quadrado(848, 20, 7).
quadrado(849, 20, 8).
quadrado(850, 20, 9).
quadrado(851, 20, 10).
quadrado(852, 20, 11).
quadrado(853, 20, 12).
quadrado(854, 20, 13).
quadrado(855, 20, 14).
quadrado(856, 20, 15).
quadrado(857, 20, 16).
quadrado(858, 20, 17).
quadrado(859, 20, 18).
quadrado(860, 20, 19).
quadrado(861, 20, 20).
quadrado(862, 20, 21).
quadrado(863, 20, 22).
quadrado(864, 20, 23).
quadrado(865, 20, 24).
quadrado(866, 20, 25).
quadrado(867, 20, 26).
quadrado(868, 20, 27).
quadrado(869, 20, 28).
quadrado(870, 20, 29).
quadrado(871, 20, 30).
quadrado(872, 20, 31).
quadrado(873, 20, 32).
quadrado(874, 20, 33).
quadrado(875, 20, 34).
quadrado(876, 20, 35).
quadrado(877, 20, 36).
quadrado(878, 20, 37).
quadrado(879, 20, 38).
quadrado(880, 20, 39).
quadrado(881, 20, 40).
quadrado(882, 20, 41).
quadrado(883, 21, 0).
quadrado(884, 21, 1).
quadrado(885, 21, 2).
quadrado(886, 21, 3).
quadrado(887, 21, 4).
quadrado(888, 21, 5).
quadrado(889, 21, 6).
quadrado(890, 21, 7).
quadrado(891, 21, 8).
quadrado(892, 21, 9).
quadrado(893, 21, 10).
quadrado(894, 21, 11).
quadrado(895, 21, 12).
quadrado(896, 21, 13).
quadrado(897, 21, 14).
quadrado(898, 21, 15).
quadrado(899, 21, 16).
quadrado(900, 21, 17).
quadrado(901, 21, 18).
quadrado(902, 21, 19).
quadrado(903, 21, 20).
quadrado(904, 21, 21).
quadrado(905, 21, 22).
quadrado(906, 21, 23).
quadrado(907, 21, 24).
quadrado(908, 21, 25).
quadrado(909, 21, 26).
quadrado(910, 21, 27).
quadrado(911, 21, 28).
quadrado(912, 21, 29).
quadrado(913, 21, 30).
quadrado(914, 21, 31).
quadrado(915, 21, 32).
quadrado(916, 21, 33).
quadrado(917, 21, 34).
quadrado(918, 21, 35).
quadrado(919, 21, 36).
quadrado(920, 21, 37).
quadrado(921, 21, 38).
quadrado(922, 21, 39).
quadrado(923, 21, 40).
quadrado(924, 21, 41).
quadrado(925, 22, 0).
quadrado(926, 22, 1).
quadrado(927, 22, 2).
quadrado(928, 22, 3).
quadrado(929, 22, 4).
quadrado(930, 22, 5).
quadrado(931, 22, 6).
quadrado(932, 22, 7).
quadrado(933, 22, 8).
quadrado(934, 22, 9).
quadrado(935, 22, 10).
quadrado(936, 22, 11).
quadrado(937, 22, 12).
quadrado(938, 22, 13).
quadrado(939, 22, 14).
quadrado(940, 22, 15).
quadrado(941, 22, 16).
quadrado(942, 22, 17).
quadrado(943, 22, 18).
quadrado(944, 22, 19).
quadrado(945, 22, 20).
quadrado(946, 22, 21).
quadrado(947, 22, 22).
quadrado(948, 22, 23).
quadrado(949, 22, 24).
quadrado(950, 22, 25).
quadrado(951, 22, 26).
quadrado(952, 22, 27).
quadrado(953, 22, 28).
quadrado(954, 22, 29).
quadrado(955, 22, 30).
quadrado(956, 22, 31).
quadrado(957, 22, 32).
quadrado(958, 22, 33).
quadrado(959, 22, 34).
quadrado(960, 22, 35).
quadrado(961, 22, 36).
quadrado(962, 22, 37).
quadrado(963, 22, 38).
quadrado(964, 22, 39).
quadrado(965, 22, 40).
quadrado(966, 22, 41).
quadrado(967, 23, 0).
quadrado(968, 23, 1).
quadrado(969, 23, 2).
quadrado(970, 23, 3).
quadrado(971, 23, 4).
quadrado(972, 23, 5).
quadrado(973, 23, 6).
quadrado(974, 23, 7).
quadrado(975, 23, 8).
quadrado(976, 23, 9).
quadrado(977, 23, 10).
quadrado(978, 23, 11).
quadrado(979, 23, 12).
quadrado(980, 23, 13).
quadrado(981, 23, 14).
quadrado(982, 23, 15).
quadrado(983, 23, 16).
quadrado(984, 23, 17).
quadrado(985, 23, 18).
quadrado(986, 23, 19).
quadrado(987, 23, 20).
quadrado(988, 23, 21).
quadrado(989, 23, 22).
quadrado(990, 23, 23).
quadrado(991, 23, 24).
quadrado(992, 23, 25).
quadrado(993, 23, 26).
quadrado(994, 23, 27).
quadrado(995, 23, 28).
quadrado(996, 23, 29).
quadrado(997, 23, 30).
quadrado(998, 23, 31).
quadrado(999, 23, 32).
quadrado(1000, 23, 33).
quadrado(1001, 23, 34).
quadrado(1002, 23, 35).
quadrado(1003, 23, 36).
quadrado(1004, 23, 37).
quadrado(1005, 23, 38).
quadrado(1006, 23, 39).
quadrado(1007, 23, 40).
quadrado(1008, 23, 41).
quadrado(1009, 24, 0).
quadrado(1010, 24, 1).
quadrado(1011, 24, 2).
quadrado(1012, 24, 3).
quadrado(1013, 24, 4).
quadrado(1014, 24, 5).
quadrado(1015, 24, 6).
quadrado(1016, 24, 7).
quadrado(1017, 24, 8).
quadrado(1018, 24, 9).
quadrado(1019, 24, 10).
quadrado(1020, 24, 11).
quadrado(1021, 24, 12).
quadrado(1022, 24, 13).
quadrado(1023, 24, 14).
quadrado(1024, 24, 15).
quadrado(1025, 24, 16).
quadrado(1026, 24, 17).
quadrado(1027, 24, 18).
quadrado(1028, 24, 19).
quadrado(1029, 24, 20).
quadrado(1030, 24, 21).
quadrado(1031, 24, 22).
quadrado(1032, 24, 23).
quadrado(1033, 24, 24).
quadrado(1034, 24, 25).
quadrado(1035, 24, 26).
quadrado(1036, 24, 27).
quadrado(1037, 24, 28).
quadrado(1038, 24, 29).
quadrado(1039, 24, 30).
quadrado(1040, 24, 31).
quadrado(1041, 24, 32).
quadrado(1042, 24, 33).
quadrado(1043, 24, 34).
quadrado(1044, 24, 35).
quadrado(1045, 24, 36).
quadrado(1046, 24, 37).
quadrado(1047, 24, 38).
quadrado(1048, 24, 39).
quadrado(1049, 24, 40).
quadrado(1050, 24, 41).
quadrado(1051, 25, 0).
quadrado(1052, 25, 1).
quadrado(1053, 25, 2).
quadrado(1054, 25, 3).
quadrado(1055, 25, 4).
quadrado(1056, 25, 5).
quadrado(1057, 25, 6).
quadrado(1058, 25, 7).
quadrado(1059, 25, 8).
quadrado(1060, 25, 9).
quadrado(1061, 25, 10).
quadrado(1062, 25, 11).
quadrado(1063, 25, 12).
quadrado(1064, 25, 13).
quadrado(1065, 25, 14).
quadrado(1066, 25, 15).
quadrado(1067, 25, 16).
quadrado(1068, 25, 17).
quadrado(1069, 25, 18).
quadrado(1070, 25, 19).
quadrado(1071, 25, 20).
quadrado(1072, 25, 21).
quadrado(1073, 25, 22).
quadrado(1074, 25, 23).
quadrado(1075, 25, 24).
quadrado(1076, 25, 25).
quadrado(1077, 25, 26).
quadrado(1078, 25, 27).
quadrado(1079, 25, 28).
quadrado(1080, 25, 29).
quadrado(1081, 25, 30).
quadrado(1082, 25, 31).
quadrado(1083, 25, 32).
quadrado(1084, 25, 33).
quadrado(1085, 25, 34).
quadrado(1086, 25, 35).
quadrado(1087, 25, 36).
quadrado(1088, 25, 37).
quadrado(1089, 25, 38).
quadrado(1090, 25, 39).
quadrado(1091, 25, 40).
quadrado(1092, 25, 41).
quadrado(1093, 26, 0).
quadrado(1094, 26, 1).
quadrado(1095, 26, 2).
quadrado(1096, 26, 3).
quadrado(1097, 26, 4).
quadrado(1098, 26, 5).
quadrado(1099, 26, 6).
quadrado(1100, 26, 7).
quadrado(1101, 26, 8).
quadrado(1102, 26, 9).
quadrado(1103, 26, 10).
quadrado(1104, 26, 11).
quadrado(1105, 26, 12).
quadrado(1106, 26, 13).
quadrado(1107, 26, 14).
quadrado(1108, 26, 15).
quadrado(1109, 26, 16).
quadrado(1110, 26, 17).
quadrado(1111, 26, 18).
quadrado(1112, 26, 19).
quadrado(1113, 26, 20).
quadrado(1114, 26, 21).
quadrado(1115, 26, 22).
quadrado(1116, 26, 23).
quadrado(1117, 26, 24).
quadrado(1118, 26, 25).
quadrado(1119, 26, 26).
quadrado(1120, 26, 27).
quadrado(1121, 26, 28).
quadrado(1122, 26, 29).
quadrado(1123, 26, 30).
quadrado(1124, 26, 31).
quadrado(1125, 26, 32).
quadrado(1126, 26, 33).
quadrado(1127, 26, 34).
quadrado(1128, 26, 35).
quadrado(1129, 26, 36).
quadrado(1130, 26, 37).
quadrado(1131, 26, 38).
quadrado(1132, 26, 39).
quadrado(1133, 26, 40).
quadrado(1134, 26, 41).
quadrado(1135, 27, 0).
quadrado(1136, 27, 1).
quadrado(1137, 27, 2).
quadrado(1138, 27, 3).
quadrado(1139, 27, 4).
quadrado(1140, 27, 5).
quadrado(1141, 27, 6).
quadrado(1142, 27, 7).
quadrado(1143, 27, 8).
quadrado(1144, 27, 9).
quadrado(1145, 27, 10).
quadrado(1146, 27, 11).
quadrado(1147, 27, 12).
quadrado(1148, 27, 13).
quadrado(1149, 27, 14).
quadrado(1150, 27, 15).
quadrado(1151, 27, 16).
quadrado(1152, 27, 17).
quadrado(1153, 27, 18).
quadrado(1154, 27, 19).
quadrado(1155, 27, 20).
quadrado(1156, 27, 21).
quadrado(1157, 27, 22).
quadrado(1158, 27, 23).
quadrado(1159, 27, 24).
quadrado(1160, 27, 25).
quadrado(1161, 27, 26).
quadrado(1162, 27, 27).
quadrado(1163, 27, 28).
quadrado(1164, 27, 29).
quadrado(1165, 27, 30).
quadrado(1166, 27, 31).
quadrado(1167, 27, 32).
quadrado(1168, 27, 33).
quadrado(1169, 27, 34).
quadrado(1170, 27, 35).
quadrado(1171, 27, 36).
quadrado(1172, 27, 37).
quadrado(1173, 27, 38).
quadrado(1174, 27, 39).
quadrado(1175, 27, 40).
quadrado(1176, 27, 41).
quadrado(1177, 28, 0).
quadrado(1178, 28, 1).
quadrado(1179, 28, 2).
quadrado(1180, 28, 3).
quadrado(1181, 28, 4).
quadrado(1182, 28, 5).
quadrado(1183, 28, 6).
quadrado(1184, 28, 7).
quadrado(1185, 28, 8).
quadrado(1186, 28, 9).
quadrado(1187, 28, 10).
quadrado(1188, 28, 11).
quadrado(1189, 28, 12).
quadrado(1190, 28, 13).
quadrado(1191, 28, 14).
quadrado(1192, 28, 15).
quadrado(1193, 28, 16).
quadrado(1194, 28, 17).
quadrado(1195, 28, 18).
quadrado(1196, 28, 19).
quadrado(1197, 28, 20).
quadrado(1198, 28, 21).
quadrado(1199, 28, 22).
quadrado(1200, 28, 23).
quadrado(1201, 28, 24).
quadrado(1202, 28, 25).
quadrado(1203, 28, 26).
quadrado(1204, 28, 27).
quadrado(1205, 28, 28).
quadrado(1206, 28, 29).
quadrado(1207, 28, 30).
quadrado(1208, 28, 31).
quadrado(1209, 28, 32).
quadrado(1210, 28, 33).
quadrado(1211, 28, 34).
quadrado(1212, 28, 35).
quadrado(1213, 28, 36).
quadrado(1214, 28, 37).
quadrado(1215, 28, 38).
quadrado(1216, 28, 39).
quadrado(1217, 28, 40).
quadrado(1218, 28, 41).
quadrado(1219, 29, 0).
quadrado(1220, 29, 1).
quadrado(1221, 29, 2).
quadrado(1222, 29, 3).
quadrado(1223, 29, 4).
quadrado(1224, 29, 5).
quadrado(1225, 29, 6).
quadrado(1226, 29, 7).
quadrado(1227, 29, 8).
quadrado(1228, 29, 9).
quadrado(1229, 29, 10).
quadrado(1230, 29, 11).
quadrado(1231, 29, 12).
quadrado(1232, 29, 13).
quadrado(1233, 29, 14).
quadrado(1234, 29, 15).
quadrado(1235, 29, 16).
quadrado(1236, 29, 17).
quadrado(1237, 29, 18).
quadrado(1238, 29, 19).
quadrado(1239, 29, 20).
quadrado(1240, 29, 21).
quadrado(1241, 29, 22).
quadrado(1242, 29, 23).
quadrado(1243, 29, 24).
quadrado(1244, 29, 25).
quadrado(1245, 29, 26).
quadrado(1246, 29, 27).
quadrado(1247, 29, 28).
quadrado(1248, 29, 29).
quadrado(1249, 29, 30).
quadrado(1250, 29, 31).
quadrado(1251, 29, 32).
quadrado(1252, 29, 33).
quadrado(1253, 29, 34).
quadrado(1254, 29, 35).
quadrado(1255, 29, 36).
quadrado(1256, 29, 37).
quadrado(1257, 29, 38).
quadrado(1258, 29, 39).
quadrado(1259, 29, 40).
quadrado(1260, 29, 41).
quadrado(1261, 30, 0).
quadrado(1262, 30, 1).
quadrado(1263, 30, 2).
quadrado(1264, 30, 3).
quadrado(1265, 30, 4).
quadrado(1266, 30, 5).
quadrado(1267, 30, 6).
quadrado(1268, 30, 7).
quadrado(1269, 30, 8).
quadrado(1270, 30, 9).
quadrado(1271, 30, 10).
quadrado(1272, 30, 11).
quadrado(1273, 30, 12).
quadrado(1274, 30, 13).
quadrado(1275, 30, 14).
quadrado(1276, 30, 15).
quadrado(1277, 30, 16).
quadrado(1278, 30, 17).
quadrado(1279, 30, 18).
quadrado(1280, 30, 19).
quadrado(1281, 30, 20).
quadrado(1282, 30, 21).
quadrado(1283, 30, 22).
quadrado(1284, 30, 23).
quadrado(1285, 30, 24).
quadrado(1286, 30, 25).
quadrado(1287, 30, 26).
quadrado(1288, 30, 27).
quadrado(1289, 30, 28).
quadrado(1290, 30, 29).
quadrado(1291, 30, 30).
quadrado(1292, 30, 31).
quadrado(1293, 30, 32).
quadrado(1294, 30, 33).
quadrado(1295, 30, 34).
quadrado(1296, 30, 35).
quadrado(1297, 30, 36).
quadrado(1298, 30, 37).
quadrado(1299, 30, 38).
quadrado(1300, 30, 39).
quadrado(1301, 30, 40).
quadrado(1302, 30, 41).
quadrado(1303, 31, 0).
quadrado(1304, 31, 1).
quadrado(1305, 31, 2).
quadrado(1306, 31, 3).
quadrado(1307, 31, 4).
quadrado(1308, 31, 5).
quadrado(1309, 31, 6).
quadrado(1310, 31, 7).
quadrado(1311, 31, 8).
quadrado(1312, 31, 9).
quadrado(1313, 31, 10).
quadrado(1314, 31, 11).
quadrado(1315, 31, 12).
quadrado(1316, 31, 13).
quadrado(1317, 31, 14).
quadrado(1318, 31, 15).
quadrado(1319, 31, 16).
quadrado(1320, 31, 17).
quadrado(1321, 31, 18).
quadrado(1322, 31, 19).
quadrado(1323, 31, 20).
quadrado(1324, 31, 21).
quadrado(1325, 31, 22).
quadrado(1326, 31, 23).
quadrado(1327, 31, 24).
quadrado(1328, 31, 25).
quadrado(1329, 31, 26).
quadrado(1330, 31, 27).
quadrado(1331, 31, 28).
quadrado(1332, 31, 29).
quadrado(1333, 31, 30).
quadrado(1334, 31, 31).
quadrado(1335, 31, 32).
quadrado(1336, 31, 33).
quadrado(1337, 31, 34).
quadrado(1338, 31, 35).
quadrado(1339, 31, 36).
quadrado(1340, 31, 37).
quadrado(1341, 31, 38).
quadrado(1342, 31, 39).
quadrado(1343, 31, 40).
quadrado(1344, 31, 41).
quadrado(1345, 32, 0).
quadrado(1346, 32, 1).
quadrado(1347, 32, 2).
quadrado(1348, 32, 3).
quadrado(1349, 32, 4).
quadrado(1350, 32, 5).
quadrado(1351, 32, 6).
quadrado(1352, 32, 7).
quadrado(1353, 32, 8).
quadrado(1354, 32, 9).
quadrado(1355, 32, 10).
quadrado(1356, 32, 11).
quadrado(1357, 32, 12).
quadrado(1358, 32, 13).
quadrado(1359, 32, 14).
quadrado(1360, 32, 15).
quadrado(1361, 32, 16).
quadrado(1362, 32, 17).
quadrado(1363, 32, 18).
quadrado(1364, 32, 19).
quadrado(1365, 32, 20).
quadrado(1366, 32, 21).
quadrado(1367, 32, 22).
quadrado(1368, 32, 23).
quadrado(1369, 32, 24).
quadrado(1370, 32, 25).
quadrado(1371, 32, 26).
quadrado(1372, 32, 27).
quadrado(1373, 32, 28).
quadrado(1374, 32, 29).
quadrado(1375, 32, 30).
quadrado(1376, 32, 31).
quadrado(1377, 32, 32).
quadrado(1378, 32, 33).
quadrado(1379, 32, 34).
quadrado(1380, 32, 35).
quadrado(1381, 32, 36).
quadrado(1382, 32, 37).
quadrado(1383, 32, 38).
quadrado(1384, 32, 39).
quadrado(1385, 32, 40).
quadrado(1386, 32, 41).
quadrado(1387, 33, 0).
quadrado(1388, 33, 1).
quadrado(1389, 33, 2).
quadrado(1390, 33, 3).
quadrado(1391, 33, 4).
quadrado(1392, 33, 5).
quadrado(1393, 33, 6).
quadrado(1394, 33, 7).
quadrado(1395, 33, 8).
quadrado(1396, 33, 9).
quadrado(1397, 33, 10).
quadrado(1398, 33, 11).
quadrado(1399, 33, 12).
quadrado(1400, 33, 13).
quadrado(1401, 33, 14).
quadrado(1402, 33, 15).
quadrado(1403, 33, 16).
quadrado(1404, 33, 17).
quadrado(1405, 33, 18).
quadrado(1406, 33, 19).
quadrado(1407, 33, 20).
quadrado(1408, 33, 21).
quadrado(1409, 33, 22).
quadrado(1410, 33, 23).
quadrado(1411, 33, 24).
quadrado(1412, 33, 25).
quadrado(1413, 33, 26).
quadrado(1414, 33, 27).
quadrado(1415, 33, 28).
quadrado(1416, 33, 29).
quadrado(1417, 33, 30).
quadrado(1418, 33, 31).
quadrado(1419, 33, 32).
quadrado(1420, 33, 33).
quadrado(1421, 33, 34).
quadrado(1422, 33, 35).
quadrado(1423, 33, 36).
quadrado(1424, 33, 37).
quadrado(1425, 33, 38).
quadrado(1426, 33, 39).
quadrado(1427, 33, 40).
quadrado(1428, 33, 41).
quadrado(1429, 34, 0).
quadrado(1430, 34, 1).
quadrado(1431, 34, 2).
quadrado(1432, 34, 3).
quadrado(1433, 34, 4).
quadrado(1434, 34, 5).
quadrado(1435, 34, 6).
quadrado(1436, 34, 7).
quadrado(1437, 34, 8).
quadrado(1438, 34, 9).
quadrado(1439, 34, 10).
quadrado(1440, 34, 11).
quadrado(1441, 34, 12).
quadrado(1442, 34, 13).
quadrado(1443, 34, 14).
quadrado(1444, 34, 15).
quadrado(1445, 34, 16).
quadrado(1446, 34, 17).
quadrado(1447, 34, 18).
quadrado(1448, 34, 19).
quadrado(1449, 34, 20).
quadrado(1450, 34, 21).
quadrado(1451, 34, 22).
quadrado(1452, 34, 23).
quadrado(1453, 34, 24).
quadrado(1454, 34, 25).
quadrado(1455, 34, 26).
quadrado(1456, 34, 27).
quadrado(1457, 34, 28).
quadrado(1458, 34, 29).
quadrado(1459, 34, 30).
quadrado(1460, 34, 31).
quadrado(1461, 34, 32).
quadrado(1462, 34, 33).
quadrado(1463, 34, 34).
quadrado(1464, 34, 35).
quadrado(1465, 34, 36).
quadrado(1466, 34, 37).
quadrado(1467, 34, 38).
quadrado(1468, 34, 39).
quadrado(1469, 34, 40).
quadrado(1470, 34, 41).
quadrado(1471, 35, 0).
quadrado(1472, 35, 1).
quadrado(1473, 35, 2).
quadrado(1474, 35, 3).
quadrado(1475, 35, 4).
quadrado(1476, 35, 5).
quadrado(1477, 35, 6).
quadrado(1478, 35, 7).
quadrado(1479, 35, 8).
quadrado(1480, 35, 9).
quadrado(1481, 35, 10).
quadrado(1482, 35, 11).
quadrado(1483, 35, 12).
quadrado(1484, 35, 13).
quadrado(1485, 35, 14).
quadrado(1486, 35, 15).
quadrado(1487, 35, 16).
quadrado(1488, 35, 17).
quadrado(1489, 35, 18).
quadrado(1490, 35, 19).
quadrado(1491, 35, 20).
quadrado(1492, 35, 21).
quadrado(1493, 35, 22).
quadrado(1494, 35, 23).
quadrado(1495, 35, 24).
quadrado(1496, 35, 25).
quadrado(1497, 35, 26).
quadrado(1498, 35, 27).
quadrado(1499, 35, 28).
quadrado(1500, 35, 29).
quadrado(1501, 35, 30).
quadrado(1502, 35, 31).
quadrado(1503, 35, 32).
quadrado(1504, 35, 33).
quadrado(1505, 35, 34).
quadrado(1506, 35, 35).
quadrado(1507, 35, 36).
quadrado(1508, 35, 37).
quadrado(1509, 35, 38).
quadrado(1510, 35, 39).
quadrado(1511, 35, 40).
quadrado(1512, 35, 41).
quadrado(1513, 36, 0).
quadrado(1514, 36, 1).
quadrado(1515, 36, 2).
quadrado(1516, 36, 3).
quadrado(1517, 36, 4).
quadrado(1518, 36, 5).
quadrado(1519, 36, 6).
quadrado(1520, 36, 7).
quadrado(1521, 36, 8).
quadrado(1522, 36, 9).
quadrado(1523, 36, 10).
quadrado(1524, 36, 11).
quadrado(1525, 36, 12).
quadrado(1526, 36, 13).
quadrado(1527, 36, 14).
quadrado(1528, 36, 15).
quadrado(1529, 36, 16).
quadrado(1530, 36, 17).
quadrado(1531, 36, 18).
quadrado(1532, 36, 19).
quadrado(1533, 36, 20).
quadrado(1534, 36, 21).
quadrado(1535, 36, 22).
quadrado(1536, 36, 23).
quadrado(1537, 36, 24).
quadrado(1538, 36, 25).
quadrado(1539, 36, 26).
quadrado(1540, 36, 27).
quadrado(1541, 36, 28).
quadrado(1542, 36, 29).
quadrado(1543, 36, 30).
quadrado(1544, 36, 31).
quadrado(1545, 36, 32).
quadrado(1546, 36, 33).
quadrado(1547, 36, 34).
quadrado(1548, 36, 35).
quadrado(1549, 36, 36).
quadrado(1550, 36, 37).
quadrado(1551, 36, 38).
quadrado(1552, 36, 39).
quadrado(1553, 36, 40).
quadrado(1554, 36, 41).
quadrado(1555, 37, 0).
quadrado(1556, 37, 1).
quadrado(1557, 37, 2).
quadrado(1558, 37, 3).
quadrado(1559, 37, 4).
quadrado(1560, 37, 5).
quadrado(1561, 37, 6).
quadrado(1562, 37, 7).
quadrado(1563, 37, 8).
quadrado(1564, 37, 9).
quadrado(1565, 37, 10).
quadrado(1566, 37, 11).
quadrado(1567, 37, 12).
quadrado(1568, 37, 13).
quadrado(1569, 37, 14).
quadrado(1570, 37, 15).
quadrado(1571, 37, 16).
quadrado(1572, 37, 17).
quadrado(1573, 37, 18).
quadrado(1574, 37, 19).
quadrado(1575, 37, 20).
quadrado(1576, 37, 21).
quadrado(1577, 37, 22).
quadrado(1578, 37, 23).
quadrado(1579, 37, 24).
quadrado(1580, 37, 25).
quadrado(1581, 37, 26).
quadrado(1582, 37, 27).
quadrado(1583, 37, 28).
quadrado(1584, 37, 29).
quadrado(1585, 37, 30).
quadrado(1586, 37, 31).
quadrado(1587, 37, 32).
quadrado(1588, 37, 33).
quadrado(1589, 37, 34).
quadrado(1590, 37, 35).
quadrado(1591, 37, 36).
quadrado(1592, 37, 37).
quadrado(1593, 37, 38).
quadrado(1594, 37, 39).
quadrado(1595, 37, 40).
quadrado(1596, 37, 41).
quadrado(1597, 38, 0).
quadrado(1598, 38, 1).
quadrado(1599, 38, 2).
quadrado(1600, 38, 3).
quadrado(1601, 38, 4).
quadrado(1602, 38, 5).
quadrado(1603, 38, 6).
quadrado(1604, 38, 7).
quadrado(1605, 38, 8).
quadrado(1606, 38, 9).
quadrado(1607, 38, 10).
quadrado(1608, 38, 11).
quadrado(1609, 38, 12).
quadrado(1610, 38, 13).
quadrado(1611, 38, 14).
quadrado(1612, 38, 15).
quadrado(1613, 38, 16).
quadrado(1614, 38, 17).
quadrado(1615, 38, 18).
quadrado(1616, 38, 19).
quadrado(1617, 38, 20).
quadrado(1618, 38, 21).
quadrado(1619, 38, 22).
quadrado(1620, 38, 23).
quadrado(1621, 38, 24).
quadrado(1622, 38, 25).
quadrado(1623, 38, 26).
quadrado(1624, 38, 27).
quadrado(1625, 38, 28).
quadrado(1626, 38, 29).
quadrado(1627, 38, 30).
quadrado(1628, 38, 31).
quadrado(1629, 38, 32).
quadrado(1630, 38, 33).
quadrado(1631, 38, 34).
quadrado(1632, 38, 35).
quadrado(1633, 38, 36).
quadrado(1634, 38, 37).
quadrado(1635, 38, 38).
quadrado(1636, 38, 39).
quadrado(1637, 38, 40).
quadrado(1638, 38, 41).
quadrado(1639, 39, 0).
quadrado(1640, 39, 1).
quadrado(1641, 39, 2).
quadrado(1642, 39, 3).
quadrado(1643, 39, 4).
quadrado(1644, 39, 5).
quadrado(1645, 39, 6).
quadrado(1646, 39, 7).
quadrado(1647, 39, 8).
quadrado(1648, 39, 9).
quadrado(1649, 39, 10).
quadrado(1650, 39, 11).
quadrado(1651, 39, 12).
quadrado(1652, 39, 13).
quadrado(1653, 39, 14).
quadrado(1654, 39, 15).
quadrado(1655, 39, 16).
quadrado(1656, 39, 17).
quadrado(1657, 39, 18).
quadrado(1658, 39, 19).
quadrado(1659, 39, 20).
quadrado(1660, 39, 21).
quadrado(1661, 39, 22).
quadrado(1662, 39, 23).
quadrado(1663, 39, 24).
quadrado(1664, 39, 25).
quadrado(1665, 39, 26).
quadrado(1666, 39, 27).
quadrado(1667, 39, 28).
quadrado(1668, 39, 29).
quadrado(1669, 39, 30).
quadrado(1670, 39, 31).
quadrado(1671, 39, 32).
quadrado(1672, 39, 33).
quadrado(1673, 39, 34).
quadrado(1674, 39, 35).
quadrado(1675, 39, 36).
quadrado(1676, 39, 37).
quadrado(1677, 39, 38).
quadrado(1678, 39, 39).
quadrado(1679, 39, 40).
quadrado(1680, 39, 41).
quadrado(1681, 40, 0).
quadrado(1682, 40, 1).
quadrado(1683, 40, 2).
quadrado(1684, 40, 3).
quadrado(1685, 40, 4).
quadrado(1686, 40, 5).
quadrado(1687, 40, 6).
quadrado(1688, 40, 7).
quadrado(1689, 40, 8).
quadrado(1690, 40, 9).
quadrado(1691, 40, 10).
quadrado(1692, 40, 11).
quadrado(1693, 40, 12).
quadrado(1694, 40, 13).
quadrado(1695, 40, 14).
quadrado(1696, 40, 15).
quadrado(1697, 40, 16).
quadrado(1698, 40, 17).
quadrado(1699, 40, 18).
quadrado(1700, 40, 19).
quadrado(1701, 40, 20).
quadrado(1702, 40, 21).
quadrado(1703, 40, 22).
quadrado(1704, 40, 23).
quadrado(1705, 40, 24).
quadrado(1706, 40, 25).
quadrado(1707, 40, 26).
quadrado(1708, 40, 27).
quadrado(1709, 40, 28).
quadrado(1710, 40, 29).
quadrado(1711, 40, 30).
quadrado(1712, 40, 31).
quadrado(1713, 40, 32).
quadrado(1714, 40, 33).
quadrado(1715, 40, 34).
quadrado(1716, 40, 35).
quadrado(1717, 40, 36).
quadrado(1718, 40, 37).
quadrado(1719, 40, 38).
quadrado(1720, 40, 39).
quadrado(1721, 40, 40).
quadrado(1722, 40, 41).
quadrado(1723, 41, 0).
quadrado(1724, 41, 1).
quadrado(1725, 41, 2).
quadrado(1726, 41, 3).
quadrado(1727, 41, 4).
quadrado(1728, 41, 5).
quadrado(1729, 41, 6).
quadrado(1730, 41, 7).
quadrado(1731, 41, 8).
quadrado(1732, 41, 9).
quadrado(1733, 41, 10).
quadrado(1734, 41, 11).
quadrado(1735, 41, 12).
quadrado(1736, 41, 13).
quadrado(1737, 41, 14).
quadrado(1738, 41, 15).
quadrado(1739, 41, 16).
quadrado(1740, 41, 17).
quadrado(1741, 41, 18).
quadrado(1742, 41, 19).
quadrado(1743, 41, 20).
quadrado(1744, 41, 21).
quadrado(1745, 41, 22).
quadrado(1746, 41, 23).
quadrado(1747, 41, 24).
quadrado(1748, 41, 25).
quadrado(1749, 41, 26).
quadrado(1750, 41, 27).
quadrado(1751, 41, 28).
quadrado(1752, 41, 29).
quadrado(1753, 41, 30).
quadrado(1754, 41, 31).
quadrado(1755, 41, 32).
quadrado(1756, 41, 33).
quadrado(1757, 41, 34).
quadrado(1758, 41, 35).
quadrado(1759, 41, 36).
quadrado(1760, 41, 37).
quadrado(1761, 41, 38).
quadrado(1762, 41, 39).
quadrado(1763, 41, 40).
quadrado(1764, 41, 41).

caminho(1, 43). caminho(1, 2). 
caminho(2, 44). caminho(2, 1). caminho(2, 3). 
caminho(3, 45). caminho(3, 2). caminho(3, 4). 
caminho(4, 46). caminho(4, 3). caminho(4, 5). 
caminho(5, 47). caminho(5, 4). caminho(5, 6). 
caminho(6, 48). caminho(6, 5). caminho(6, 7). 
caminho(7, 49). caminho(7, 6). caminho(7, 8). 
caminho(8, 50). caminho(8, 7). caminho(8, 9). 
caminho(9, 51). caminho(9, 8). caminho(9, 10). 
caminho(10, 52). caminho(10, 9). caminho(10, 11). 
caminho(11, 53). caminho(11, 10). caminho(11, 12). 
caminho(12, 54). caminho(12, 11). caminho(12, 13). 
caminho(13, 55). caminho(13, 12). caminho(13, 14). 
caminho(14, 56). caminho(14, 13). caminho(14, 15). 
caminho(15, 57). caminho(15, 14). caminho(15, 16). 
caminho(16, 58). caminho(16, 15). caminho(16, 17). 
caminho(17, 59). caminho(17, 16). caminho(17, 18). 
caminho(18, 60). caminho(18, 17). caminho(18, 19). 
caminho(19, 61). caminho(19, 18). caminho(19, 20). 
caminho(20, 62). caminho(20, 19). caminho(20, 21). 
caminho(21, 63). caminho(21, 20). caminho(21, 22). 
caminho(22, 64). caminho(22, 21). caminho(22, 23). 
caminho(23, 65). caminho(23, 22). caminho(23, 24). 
caminho(24, 66). caminho(24, 23). caminho(24, 25). 
caminho(25, 67). caminho(25, 24). caminho(25, 26). 
caminho(26, 68). caminho(26, 25). caminho(26, 27). 
caminho(27, 69). caminho(27, 26). caminho(27, 28). 
caminho(28, 70). caminho(28, 27). caminho(28, 29). 
caminho(29, 71). caminho(29, 28). caminho(29, 30). 
caminho(30, 72). caminho(30, 29). caminho(30, 31). 
caminho(31, 73). caminho(31, 30). caminho(31, 32). 
caminho(32, 74). caminho(32, 31). caminho(32, 33). 
caminho(33, 75). caminho(33, 32). caminho(33, 34). 
caminho(34, 76). caminho(34, 33). caminho(34, 35). 
caminho(35, 77). caminho(35, 34). caminho(35, 36). 
caminho(36, 78). caminho(36, 35). caminho(36, 37). 
caminho(37, 79). caminho(37, 36). caminho(37, 38). 
caminho(38, 80). caminho(38, 37). caminho(38, 39). 
caminho(39, 81). caminho(39, 38). caminho(39, 40). 
caminho(40, 82). caminho(40, 39). caminho(40, 41). 
caminho(41, 83). caminho(41, 40). caminho(41, 42). 
caminho(42, 84). caminho(42, 41). 
caminho(43, 85). caminho(43, 1). caminho(43, 44). 
caminho(44, 86). caminho(44, 2). caminho(44, 43). caminho(44, 45). 
caminho(45, 87). caminho(45, 3). caminho(45, 44). caminho(45, 46). 
caminho(46, 88). caminho(46, 4). caminho(46, 45). caminho(46, 47). 
caminho(47, 89). caminho(47, 5). caminho(47, 46). caminho(47, 48). 
caminho(48, 90). caminho(48, 6). caminho(48, 47). caminho(48, 49). 
caminho(49, 91). caminho(49, 7). caminho(49, 48). caminho(49, 50). 
caminho(50, 92). caminho(50, 8). caminho(50, 49). caminho(50, 51). 
caminho(51, 93). caminho(51, 9). caminho(51, 50). caminho(51, 52). 
caminho(52, 94). caminho(52, 10). caminho(52, 51). caminho(52, 53). 
caminho(53, 95). caminho(53, 11). caminho(53, 52). caminho(53, 54). 
caminho(54, 96). caminho(54, 12). caminho(54, 53). caminho(54, 55). 
caminho(55, 97). caminho(55, 13). caminho(55, 54). caminho(55, 56). 
caminho(56, 98). caminho(56, 14). caminho(56, 55). caminho(56, 57). 
caminho(57, 99). caminho(57, 15). caminho(57, 56). caminho(57, 58). 
caminho(58, 100). caminho(58, 16). caminho(58, 57). caminho(58, 59). 
caminho(59, 101). caminho(59, 17). caminho(59, 58). caminho(59, 60). 
caminho(60, 102). caminho(60, 18). caminho(60, 59). caminho(60, 61). 
caminho(61, 103). caminho(61, 19). caminho(61, 60). caminho(61, 62). 
caminho(62, 104). caminho(62, 20). caminho(62, 61). caminho(62, 63). 
caminho(63, 105). caminho(63, 21). caminho(63, 62). caminho(63, 64). 
caminho(64, 106). caminho(64, 22). caminho(64, 63). caminho(64, 65). 
caminho(65, 107). caminho(65, 23). caminho(65, 64). caminho(65, 66). 
caminho(66, 108). caminho(66, 24). caminho(66, 65). caminho(66, 67). 
caminho(67, 109). caminho(67, 25). caminho(67, 66). caminho(67, 68). 
caminho(68, 110). caminho(68, 26). caminho(68, 67). caminho(68, 69). 
caminho(69, 111). caminho(69, 27). caminho(69, 68). caminho(69, 70). 
caminho(70, 112). caminho(70, 28). caminho(70, 69). caminho(70, 71). 
caminho(71, 113). caminho(71, 29). caminho(71, 70). caminho(71, 72). 
caminho(72, 114). caminho(72, 30). caminho(72, 71). caminho(72, 73). 
caminho(73, 115). caminho(73, 31). caminho(73, 72). caminho(73, 74). 
caminho(74, 116). caminho(74, 32). caminho(74, 73). caminho(74, 75). 
caminho(75, 117). caminho(75, 33). caminho(75, 74). caminho(75, 76). 
caminho(76, 118). caminho(76, 34). caminho(76, 75). caminho(76, 77). 
caminho(77, 119). caminho(77, 35). caminho(77, 76). caminho(77, 78). 
caminho(78, 120). caminho(78, 36). caminho(78, 77). caminho(78, 79). 
caminho(79, 121). caminho(79, 37). caminho(79, 78). caminho(79, 80). 
caminho(80, 122). caminho(80, 38). caminho(80, 79). caminho(80, 81). 
caminho(81, 123). caminho(81, 39). caminho(81, 80). caminho(81, 82). 
caminho(82, 124). caminho(82, 40). caminho(82, 81). caminho(82, 83). 
caminho(83, 125). caminho(83, 41). caminho(83, 82). caminho(83, 84). 
caminho(84, 126). caminho(84, 42). caminho(84, 83). 
caminho(85, 127). caminho(85, 43). caminho(85, 86). 
caminho(86, 128). caminho(86, 44). caminho(86, 85). caminho(86, 87). 
caminho(87, 129). caminho(87, 45). caminho(87, 86). caminho(87, 88). 
caminho(88, 130). caminho(88, 46). caminho(88, 87). caminho(88, 89). 
caminho(89, 131). caminho(89, 47). caminho(89, 88). caminho(89, 90). 
caminho(90, 132). caminho(90, 48). caminho(90, 89). caminho(90, 91). 
caminho(91, 133). caminho(91, 49). caminho(91, 90). caminho(91, 92). 
caminho(92, 134). caminho(92, 50). caminho(92, 91). caminho(92, 93). 
caminho(93, 135). caminho(93, 51). caminho(93, 92). caminho(93, 94). 
caminho(94, 136). caminho(94, 52). caminho(94, 93). caminho(94, 95). 
caminho(95, 137). caminho(95, 53). caminho(95, 94). caminho(95, 96). 
caminho(96, 138). caminho(96, 54). caminho(96, 95). caminho(96, 97). 
caminho(97, 139). caminho(97, 55). caminho(97, 96). caminho(97, 98). 
caminho(98, 140). caminho(98, 56). caminho(98, 97). caminho(98, 99). 
caminho(99, 141). caminho(99, 57). caminho(99, 98). caminho(99, 100). 
caminho(100, 142). caminho(100, 58). caminho(100, 99). caminho(100, 101). 
caminho(101, 143). caminho(101, 59). caminho(101, 100). caminho(101, 102). 
caminho(102, 144). caminho(102, 60). caminho(102, 101). caminho(102, 103). 
caminho(103, 145). caminho(103, 61). caminho(103, 102). caminho(103, 104). 
caminho(104, 146). caminho(104, 62). caminho(104, 103). caminho(104, 105). 
caminho(105, 147). caminho(105, 63). caminho(105, 104). caminho(105, 106). 
caminho(106, 148). caminho(106, 64). caminho(106, 105). caminho(106, 107). 
caminho(107, 149). caminho(107, 65). caminho(107, 106). caminho(107, 108). 
caminho(108, 150). caminho(108, 66). caminho(108, 107). caminho(108, 109). 
caminho(109, 151). caminho(109, 67). caminho(109, 108). caminho(109, 110). 
caminho(110, 152). caminho(110, 68). caminho(110, 109). caminho(110, 111). 
caminho(111, 153). caminho(111, 69). caminho(111, 110). caminho(111, 112). 
caminho(112, 154). caminho(112, 70). caminho(112, 111). caminho(112, 113). 
caminho(113, 155). caminho(113, 71). caminho(113, 112). caminho(113, 114). 
caminho(114, 156). caminho(114, 72). caminho(114, 113). caminho(114, 115). 
caminho(115, 157). caminho(115, 73). caminho(115, 114). caminho(115, 116). 
caminho(116, 158). caminho(116, 74). caminho(116, 115). caminho(116, 117). 
caminho(117, 159). caminho(117, 75). caminho(117, 116). caminho(117, 118). 
caminho(118, 160). caminho(118, 76). caminho(118, 117). caminho(118, 119). 
caminho(119, 161). caminho(119, 77). caminho(119, 118). caminho(119, 120). 
caminho(120, 162). caminho(120, 78). caminho(120, 119). caminho(120, 121). 
caminho(121, 163). caminho(121, 79). caminho(121, 120). caminho(121, 122). 
caminho(122, 164). caminho(122, 80). caminho(122, 121). caminho(122, 123). 
caminho(123, 165). caminho(123, 81). caminho(123, 122). caminho(123, 124). 
caminho(124, 166). caminho(124, 82). caminho(124, 123). caminho(124, 125). 
caminho(125, 167). caminho(125, 83). caminho(125, 124). caminho(125, 126). 
caminho(126, 168). caminho(126, 84). caminho(126, 125). 
caminho(127, 169). caminho(127, 85). caminho(127, 128). 
caminho(128, 170). caminho(128, 86). caminho(128, 127). caminho(128, 129). 
caminho(129, 171). caminho(129, 87). caminho(129, 128). caminho(129, 130). 
caminho(130, 172). caminho(130, 88). caminho(130, 129). caminho(130, 131). 
caminho(131, 173). caminho(131, 89). caminho(131, 130). caminho(131, 132). 
caminho(132, 174). caminho(132, 90). caminho(132, 131). caminho(132, 133). 
caminho(133, 175). caminho(133, 91). caminho(133, 132). caminho(133, 134). 
caminho(134, 176). caminho(134, 92). caminho(134, 133). caminho(134, 135). 
caminho(135, 177). caminho(135, 93). caminho(135, 134). caminho(135, 136). 
caminho(136, 178). caminho(136, 94). caminho(136, 135). caminho(136, 137). 
caminho(137, 179). caminho(137, 95). caminho(137, 136). caminho(137, 138). 
caminho(138, 180). caminho(138, 96). caminho(138, 137). caminho(138, 139). 
caminho(139, 181). caminho(139, 97). caminho(139, 138). caminho(139, 140). 
caminho(140, 182). caminho(140, 98). caminho(140, 139). caminho(140, 141). 
caminho(141, 183). caminho(141, 99). caminho(141, 140). caminho(141, 142). 
caminho(142, 184). caminho(142, 100). caminho(142, 141). caminho(142, 143). 
caminho(143, 185). caminho(143, 101). caminho(143, 142). caminho(143, 144). 
caminho(144, 186). caminho(144, 102). caminho(144, 143). caminho(144, 145). 
caminho(145, 187). caminho(145, 103). caminho(145, 144). caminho(145, 146). 
caminho(146, 188). caminho(146, 104). caminho(146, 145). caminho(146, 147). 
caminho(147, 189). caminho(147, 105). caminho(147, 146). caminho(147, 148). 
caminho(148, 190). caminho(148, 106). caminho(148, 147). caminho(148, 149). 
caminho(149, 191). caminho(149, 107). caminho(149, 148). caminho(149, 150). 
caminho(150, 192). caminho(150, 108). caminho(150, 149). caminho(150, 151). 
caminho(151, 193). caminho(151, 109). caminho(151, 150). caminho(151, 152). 
caminho(152, 194). caminho(152, 110). caminho(152, 151). caminho(152, 153). 
caminho(153, 195). caminho(153, 111). caminho(153, 152). caminho(153, 154). 
caminho(154, 196). caminho(154, 112). caminho(154, 153). caminho(154, 155). 
caminho(155, 197). caminho(155, 113). caminho(155, 154). caminho(155, 156). 
caminho(156, 198). caminho(156, 114). caminho(156, 155). caminho(156, 157). 
caminho(157, 199). caminho(157, 115). caminho(157, 156). caminho(157, 158). 
caminho(158, 200). caminho(158, 116). caminho(158, 157). caminho(158, 159). 
caminho(159, 201). caminho(159, 117). caminho(159, 158). caminho(159, 160). 
caminho(160, 202). caminho(160, 118). caminho(160, 159). caminho(160, 161). 
caminho(161, 203). caminho(161, 119). caminho(161, 160). caminho(161, 162). 
caminho(162, 204). caminho(162, 120). caminho(162, 161). caminho(162, 163). 
caminho(163, 205). caminho(163, 121). caminho(163, 162). caminho(163, 164). 
caminho(164, 206). caminho(164, 122). caminho(164, 163). caminho(164, 165). 
caminho(165, 207). caminho(165, 123). caminho(165, 164). caminho(165, 166). 
caminho(166, 208). caminho(166, 124). caminho(166, 165). caminho(166, 167). 
caminho(167, 209). caminho(167, 125). caminho(167, 166). caminho(167, 168). 
caminho(168, 210). caminho(168, 126). caminho(168, 167). 
caminho(169, 211). caminho(169, 127). caminho(169, 170). 
caminho(170, 212). caminho(170, 128). caminho(170, 169). caminho(170, 171). 
caminho(171, 213). caminho(171, 129). caminho(171, 170). caminho(171, 172). 
caminho(172, 214). caminho(172, 130). caminho(172, 171). caminho(172, 173). 
caminho(173, 215). caminho(173, 131). caminho(173, 172). caminho(173, 174). 
caminho(174, 216). caminho(174, 132). caminho(174, 173). caminho(174, 175). 
caminho(175, 217). caminho(175, 133). caminho(175, 174). caminho(175, 176). 
caminho(176, 218). caminho(176, 134). caminho(176, 175). caminho(176, 177). 
caminho(177, 219). caminho(177, 135). caminho(177, 176). caminho(177, 178). 
caminho(178, 220). caminho(178, 136). caminho(178, 177). caminho(178, 179). 
caminho(179, 221). caminho(179, 137). caminho(179, 178). caminho(179, 180). 
caminho(180, 222). caminho(180, 138). caminho(180, 179). caminho(180, 181). 
caminho(181, 223). caminho(181, 139). caminho(181, 180). caminho(181, 182). 
caminho(182, 224). caminho(182, 140). caminho(182, 181). caminho(182, 183). 
caminho(183, 225). caminho(183, 141). caminho(183, 182). caminho(183, 184). 
caminho(184, 226). caminho(184, 142). caminho(184, 183). caminho(184, 185). 
caminho(185, 227). caminho(185, 143). caminho(185, 184). caminho(185, 186). 
caminho(186, 228). caminho(186, 144). caminho(186, 185). caminho(186, 187). 
caminho(187, 229). caminho(187, 145). caminho(187, 186). caminho(187, 188). 
caminho(188, 230). caminho(188, 146). caminho(188, 187). caminho(188, 189). 
caminho(189, 231). caminho(189, 147). caminho(189, 188). caminho(189, 190). 
caminho(190, 232). caminho(190, 148). caminho(190, 189). caminho(190, 191). 
caminho(191, 233). caminho(191, 149). caminho(191, 190). caminho(191, 192). 
caminho(192, 234). caminho(192, 150). caminho(192, 191). caminho(192, 193). 
caminho(193, 235). caminho(193, 151). caminho(193, 192). caminho(193, 194). 
caminho(194, 236). caminho(194, 152). caminho(194, 193). caminho(194, 195). 
caminho(195, 237). caminho(195, 153). caminho(195, 194). caminho(195, 196). 
caminho(196, 238). caminho(196, 154). caminho(196, 195). caminho(196, 197). 
caminho(197, 239). caminho(197, 155). caminho(197, 196). caminho(197, 198). 
caminho(198, 240). caminho(198, 156). caminho(198, 197). caminho(198, 199). 
caminho(199, 241). caminho(199, 157). caminho(199, 198). caminho(199, 200). 
caminho(200, 242). caminho(200, 158). caminho(200, 199). caminho(200, 201). 
caminho(201, 243). caminho(201, 159). caminho(201, 200). caminho(201, 202). 
caminho(202, 244). caminho(202, 160). caminho(202, 201). caminho(202, 203). 
caminho(203, 245). caminho(203, 161). caminho(203, 202). caminho(203, 204). 
caminho(204, 246). caminho(204, 162). caminho(204, 203). caminho(204, 205). 
caminho(205, 247). caminho(205, 163). caminho(205, 204). caminho(205, 206). 
caminho(206, 248). caminho(206, 164). caminho(206, 205). caminho(206, 207). 
caminho(207, 249). caminho(207, 165). caminho(207, 206). caminho(207, 208). 
caminho(208, 250). caminho(208, 166). caminho(208, 207). caminho(208, 209). 
caminho(209, 251). caminho(209, 167). caminho(209, 208). caminho(209, 210). 
caminho(210, 252). caminho(210, 168). caminho(210, 209). 
caminho(211, 253). caminho(211, 169). caminho(211, 212). 
caminho(212, 254). caminho(212, 170). caminho(212, 211). caminho(212, 213). 
caminho(213, 255). caminho(213, 171). caminho(213, 212). caminho(213, 214). 
caminho(214, 256). caminho(214, 172). caminho(214, 213). caminho(214, 215). 
caminho(215, 257). caminho(215, 173). caminho(215, 214). caminho(215, 216). 
caminho(216, 258). caminho(216, 174). caminho(216, 215). caminho(216, 217). 
caminho(217, 259). caminho(217, 175). caminho(217, 216). caminho(217, 218). 
caminho(218, 260). caminho(218, 176). caminho(218, 217). caminho(218, 219). 
caminho(219, 261). caminho(219, 177). caminho(219, 218). caminho(219, 220). 
caminho(220, 262). caminho(220, 178). caminho(220, 219). caminho(220, 221). 
caminho(221, 263). caminho(221, 179). caminho(221, 220). caminho(221, 222). 
caminho(222, 264). caminho(222, 180). caminho(222, 221). caminho(222, 223). 
caminho(223, 265). caminho(223, 181). caminho(223, 222). caminho(223, 224). 
caminho(224, 266). caminho(224, 182). caminho(224, 223). caminho(224, 225). 
caminho(225, 267). caminho(225, 183). caminho(225, 224). caminho(225, 226). 
caminho(226, 268). caminho(226, 184). caminho(226, 225). caminho(226, 227). 
caminho(227, 269). caminho(227, 185). caminho(227, 226). caminho(227, 228). 
caminho(228, 270). caminho(228, 186). caminho(228, 227). caminho(228, 229). 
caminho(229, 271). caminho(229, 187). caminho(229, 228). caminho(229, 230). 
caminho(230, 272). caminho(230, 188). caminho(230, 229). caminho(230, 231). 
caminho(231, 273). caminho(231, 189). caminho(231, 230). caminho(231, 232). 
caminho(232, 274). caminho(232, 190). caminho(232, 231). caminho(232, 233). 
caminho(233, 275). caminho(233, 191). caminho(233, 232). caminho(233, 234). 
caminho(234, 276). caminho(234, 192). caminho(234, 233). caminho(234, 235). 
caminho(235, 277). caminho(235, 193). caminho(235, 234). caminho(235, 236). 
caminho(236, 278). caminho(236, 194). caminho(236, 235). caminho(236, 237). 
caminho(237, 279). caminho(237, 195). caminho(237, 236). caminho(237, 238). 
caminho(238, 280). caminho(238, 196). caminho(238, 237). caminho(238, 239). 
caminho(239, 281). caminho(239, 197). caminho(239, 238). caminho(239, 240). 
caminho(240, 282). caminho(240, 198). caminho(240, 239). caminho(240, 241). 
caminho(241, 283). caminho(241, 199). caminho(241, 240). caminho(241, 242). 
caminho(242, 284). caminho(242, 200). caminho(242, 241). caminho(242, 243). 
caminho(243, 285). caminho(243, 201). caminho(243, 242). caminho(243, 244). 
caminho(244, 286). caminho(244, 202). caminho(244, 243). caminho(244, 245). 
caminho(245, 287). caminho(245, 203). caminho(245, 244). caminho(245, 246). 
caminho(246, 288). caminho(246, 204). caminho(246, 245). caminho(246, 247). 
caminho(247, 289). caminho(247, 205). caminho(247, 246). caminho(247, 248). 
caminho(248, 290). caminho(248, 206). caminho(248, 247). caminho(248, 249). 
caminho(249, 291). caminho(249, 207). caminho(249, 248). caminho(249, 250). 
caminho(250, 292). caminho(250, 208). caminho(250, 249). caminho(250, 251). 
caminho(251, 293). caminho(251, 209). caminho(251, 250). caminho(251, 252). 
caminho(252, 294). caminho(252, 210). caminho(252, 251). 
caminho(253, 295). caminho(253, 211). caminho(253, 254). 
caminho(254, 296). caminho(254, 212). caminho(254, 253). caminho(254, 255). 
caminho(255, 297). caminho(255, 213). caminho(255, 254). caminho(255, 256). 
caminho(256, 298). caminho(256, 214). caminho(256, 255). caminho(256, 257). 
caminho(257, 299). caminho(257, 215). caminho(257, 256). caminho(257, 258). 
caminho(258, 300). caminho(258, 216). caminho(258, 257). caminho(258, 259). 
caminho(259, 301). caminho(259, 217). caminho(259, 258). caminho(259, 260). 
caminho(260, 302). caminho(260, 218). caminho(260, 259). caminho(260, 261). 
caminho(261, 303). caminho(261, 219). caminho(261, 260). caminho(261, 262). 
caminho(262, 304). caminho(262, 220). caminho(262, 261). caminho(262, 263). 
caminho(263, 305). caminho(263, 221). caminho(263, 262). caminho(263, 264). 
caminho(264, 306). caminho(264, 222). caminho(264, 263). caminho(264, 265). 
caminho(265, 307). caminho(265, 223). caminho(265, 264). caminho(265, 266). 
caminho(266, 308). caminho(266, 224). caminho(266, 265). caminho(266, 267). 
caminho(267, 309). caminho(267, 225). caminho(267, 266). caminho(267, 268). 
caminho(268, 310). caminho(268, 226). caminho(268, 267). caminho(268, 269). 
caminho(269, 311). caminho(269, 227). caminho(269, 268). caminho(269, 270). 
caminho(270, 312). caminho(270, 228). caminho(270, 269). caminho(270, 271). 
caminho(271, 313). caminho(271, 229). caminho(271, 270). caminho(271, 272). 
caminho(272, 314). caminho(272, 230). caminho(272, 271). caminho(272, 273). 
caminho(273, 315). caminho(273, 231). caminho(273, 272). caminho(273, 274). 
caminho(274, 316). caminho(274, 232). caminho(274, 273). caminho(274, 275). 
caminho(275, 317). caminho(275, 233). caminho(275, 274). caminho(275, 276). 
caminho(276, 318). caminho(276, 234). caminho(276, 275). caminho(276, 277). 
caminho(277, 319). caminho(277, 235). caminho(277, 276). caminho(277, 278). 
caminho(278, 320). caminho(278, 236). caminho(278, 277). caminho(278, 279). 
caminho(279, 321). caminho(279, 237). caminho(279, 278). caminho(279, 280). 
caminho(280, 322). caminho(280, 238). caminho(280, 279). caminho(280, 281). 
caminho(281, 323). caminho(281, 239). caminho(281, 280). caminho(281, 282). 
caminho(282, 324). caminho(282, 240). caminho(282, 281). caminho(282, 283). 
caminho(283, 325). caminho(283, 241). caminho(283, 282). caminho(283, 284). 
caminho(284, 326). caminho(284, 242). caminho(284, 283). caminho(284, 285). 
caminho(285, 327). caminho(285, 243). caminho(285, 284). caminho(285, 286). 
caminho(286, 328). caminho(286, 244). caminho(286, 285). caminho(286, 287). 
caminho(287, 329). caminho(287, 245). caminho(287, 286). caminho(287, 288). 
caminho(288, 330). caminho(288, 246). caminho(288, 287). caminho(288, 289). 
caminho(289, 331). caminho(289, 247). caminho(289, 288). caminho(289, 290). 
caminho(290, 332). caminho(290, 248). caminho(290, 289). caminho(290, 291). 
caminho(291, 333). caminho(291, 249). caminho(291, 290). caminho(291, 292). 
caminho(292, 334). caminho(292, 250). caminho(292, 291). caminho(292, 293). 
caminho(293, 335). caminho(293, 251). caminho(293, 292). caminho(293, 294). 
caminho(294, 336). caminho(294, 252). caminho(294, 293). 
caminho(295, 337). caminho(295, 253). caminho(295, 296). 
caminho(296, 338). caminho(296, 254). caminho(296, 295). caminho(296, 297). 
caminho(297, 339). caminho(297, 255). caminho(297, 296). caminho(297, 298). 
caminho(298, 340). caminho(298, 256). caminho(298, 297). caminho(298, 299). 
caminho(299, 341). caminho(299, 257). caminho(299, 298). caminho(299, 300). 
caminho(300, 342). caminho(300, 258). caminho(300, 299). caminho(300, 301). 
caminho(301, 343). caminho(301, 259). caminho(301, 300). caminho(301, 302). 
caminho(302, 344). caminho(302, 260). caminho(302, 301). caminho(302, 303). 
caminho(303, 345). caminho(303, 261). caminho(303, 302). caminho(303, 304). 
caminho(304, 346). caminho(304, 262). caminho(304, 303). caminho(304, 305). 
caminho(305, 347). caminho(305, 263). caminho(305, 304). caminho(305, 306). 
caminho(306, 348). caminho(306, 264). caminho(306, 305). caminho(306, 307). 
caminho(307, 349). caminho(307, 265). caminho(307, 306). caminho(307, 308). 
caminho(308, 350). caminho(308, 266). caminho(308, 307). caminho(308, 309). 
caminho(309, 351). caminho(309, 267). caminho(309, 308). caminho(309, 310). 
caminho(310, 352). caminho(310, 268). caminho(310, 309). caminho(310, 311). 
caminho(311, 353). caminho(311, 269). caminho(311, 310). caminho(311, 312). 
caminho(312, 354). caminho(312, 270). caminho(312, 311). caminho(312, 313). 
caminho(313, 355). caminho(313, 271). caminho(313, 312). caminho(313, 314). 
caminho(314, 356). caminho(314, 272). caminho(314, 313). caminho(314, 315). 
caminho(315, 357). caminho(315, 273). caminho(315, 314). caminho(315, 316). 
caminho(316, 358). caminho(316, 274). caminho(316, 315). caminho(316, 317). 
caminho(317, 359). caminho(317, 275). caminho(317, 316). caminho(317, 318). 
caminho(318, 360). caminho(318, 276). caminho(318, 317). caminho(318, 319). 
caminho(319, 361). caminho(319, 277). caminho(319, 318). caminho(319, 320). 
caminho(320, 362). caminho(320, 278). caminho(320, 319). caminho(320, 321). 
caminho(321, 363). caminho(321, 279). caminho(321, 320). caminho(321, 322). 
caminho(322, 364). caminho(322, 280). caminho(322, 321). caminho(322, 323). 
caminho(323, 365). caminho(323, 281). caminho(323, 322). caminho(323, 324). 
caminho(324, 366). caminho(324, 282). caminho(324, 323). caminho(324, 325). 
caminho(325, 367). caminho(325, 283). caminho(325, 324). caminho(325, 326). 
caminho(326, 368). caminho(326, 284). caminho(326, 325). caminho(326, 327). 
caminho(327, 369). caminho(327, 285). caminho(327, 326). caminho(327, 328). 
caminho(328, 370). caminho(328, 286). caminho(328, 327). caminho(328, 329). 
caminho(329, 371). caminho(329, 287). caminho(329, 328). caminho(329, 330). 
caminho(330, 372). caminho(330, 288). caminho(330, 329). caminho(330, 331). 
caminho(331, 373). caminho(331, 289). caminho(331, 330). caminho(331, 332). 
caminho(332, 374). caminho(332, 290). caminho(332, 331). caminho(332, 333). 
caminho(333, 375). caminho(333, 291). caminho(333, 332). caminho(333, 334). 
caminho(334, 376). caminho(334, 292). caminho(334, 333). caminho(334, 335). 
caminho(335, 377). caminho(335, 293). caminho(335, 334). caminho(335, 336). 
caminho(336, 378). caminho(336, 294). caminho(336, 335). 
caminho(337, 379). caminho(337, 295). caminho(337, 338). 
caminho(338, 380). caminho(338, 296). caminho(338, 337). caminho(338, 339). 
caminho(339, 381). caminho(339, 297). caminho(339, 338). caminho(339, 340). 
caminho(340, 382). caminho(340, 298). caminho(340, 339). caminho(340, 341). 
caminho(341, 383). caminho(341, 299). caminho(341, 340). caminho(341, 342). 
caminho(342, 384). caminho(342, 300). caminho(342, 341). caminho(342, 343). 
caminho(343, 385). caminho(343, 301). caminho(343, 342). caminho(343, 344). 
caminho(344, 386). caminho(344, 302). caminho(344, 343). caminho(344, 345). 
caminho(345, 387). caminho(345, 303). caminho(345, 344). caminho(345, 346). 
caminho(346, 388). caminho(346, 304). caminho(346, 345). caminho(346, 347). 
caminho(347, 389). caminho(347, 305). caminho(347, 346). caminho(347, 348). 
caminho(348, 390). caminho(348, 306). caminho(348, 347). caminho(348, 349). 
caminho(349, 391). caminho(349, 307). caminho(349, 348). caminho(349, 350). 
caminho(350, 392). caminho(350, 308). caminho(350, 349). caminho(350, 351). 
caminho(351, 393). caminho(351, 309). caminho(351, 350). caminho(351, 352). 
caminho(352, 394). caminho(352, 310). caminho(352, 351). caminho(352, 353). 
caminho(353, 395). caminho(353, 311). caminho(353, 352). caminho(353, 354). 
caminho(354, 396). caminho(354, 312). caminho(354, 353). caminho(354, 355). 
caminho(355, 397). caminho(355, 313). caminho(355, 354). caminho(355, 356). 
caminho(356, 398). caminho(356, 314). caminho(356, 355). caminho(356, 357). 
caminho(357, 399). caminho(357, 315). caminho(357, 356). caminho(357, 358). 
caminho(358, 400). caminho(358, 316). caminho(358, 357). caminho(358, 359). 
caminho(359, 401). caminho(359, 317). caminho(359, 358). caminho(359, 360). 
caminho(360, 402). caminho(360, 318). caminho(360, 359). caminho(360, 361). 
caminho(361, 403). caminho(361, 319). caminho(361, 360). caminho(361, 362). 
caminho(362, 404). caminho(362, 320). caminho(362, 361). caminho(362, 363). 
caminho(363, 405). caminho(363, 321). caminho(363, 362). caminho(363, 364). 
caminho(364, 406). caminho(364, 322). caminho(364, 363). caminho(364, 365). 
caminho(365, 407). caminho(365, 323). caminho(365, 364). caminho(365, 366). 
caminho(366, 408). caminho(366, 324). caminho(366, 365). caminho(366, 367). 
caminho(367, 409). caminho(367, 325). caminho(367, 366). caminho(367, 368). 
caminho(368, 410). caminho(368, 326). caminho(368, 367). caminho(368, 369). 
caminho(369, 411). caminho(369, 327). caminho(369, 368). caminho(369, 370). 
caminho(370, 412). caminho(370, 328). caminho(370, 369). caminho(370, 371). 
caminho(371, 413). caminho(371, 329). caminho(371, 370). caminho(371, 372). 
caminho(372, 414). caminho(372, 330). caminho(372, 371). caminho(372, 373). 
caminho(373, 415). caminho(373, 331). caminho(373, 372). caminho(373, 374). 
caminho(374, 416). caminho(374, 332). caminho(374, 373). caminho(374, 375). 
caminho(375, 417). caminho(375, 333). caminho(375, 374). caminho(375, 376). 
caminho(376, 418). caminho(376, 334). caminho(376, 375). caminho(376, 377). 
caminho(377, 419). caminho(377, 335). caminho(377, 376). caminho(377, 378). 
caminho(378, 420). caminho(378, 336). caminho(378, 377). 
caminho(379, 421). caminho(379, 337). caminho(379, 380). 
caminho(380, 422). caminho(380, 338). caminho(380, 379). caminho(380, 381). 
caminho(381, 423). caminho(381, 339). caminho(381, 380). caminho(381, 382). 
caminho(382, 424). caminho(382, 340). caminho(382, 381). caminho(382, 383). 
caminho(383, 425). caminho(383, 341). caminho(383, 382). caminho(383, 384). 
caminho(384, 426). caminho(384, 342). caminho(384, 383). caminho(384, 385). 
caminho(385, 427). caminho(385, 343). caminho(385, 384). caminho(385, 386). 
caminho(386, 428). caminho(386, 344). caminho(386, 385). caminho(386, 387). 
caminho(387, 429). caminho(387, 345). caminho(387, 386). caminho(387, 388). 
caminho(388, 430). caminho(388, 346). caminho(388, 387). caminho(388, 389). 
caminho(389, 431). caminho(389, 347). caminho(389, 388). caminho(389, 390). 
caminho(390, 432). caminho(390, 348). caminho(390, 389). caminho(390, 391). 
caminho(391, 433). caminho(391, 349). caminho(391, 390). caminho(391, 392). 
caminho(392, 434). caminho(392, 350). caminho(392, 391). caminho(392, 393). 
caminho(393, 435). caminho(393, 351). caminho(393, 392). caminho(393, 394). 
caminho(394, 436). caminho(394, 352). caminho(394, 393). caminho(394, 395). 
caminho(395, 437). caminho(395, 353). caminho(395, 394). caminho(395, 396). 
caminho(396, 438). caminho(396, 354). caminho(396, 395). caminho(396, 397). 
caminho(397, 439). caminho(397, 355). caminho(397, 396). caminho(397, 398). 
caminho(398, 440). caminho(398, 356). caminho(398, 397). caminho(398, 399). 
caminho(399, 441). caminho(399, 357). caminho(399, 398). caminho(399, 400). 
caminho(400, 442). caminho(400, 358). caminho(400, 399). caminho(400, 401). 
caminho(401, 443). caminho(401, 359). caminho(401, 400). caminho(401, 402). 
caminho(402, 444). caminho(402, 360). caminho(402, 401). caminho(402, 403). 
caminho(403, 445). caminho(403, 361). caminho(403, 402). caminho(403, 404). 
caminho(404, 446). caminho(404, 362). caminho(404, 403). caminho(404, 405). 
caminho(405, 447). caminho(405, 363). caminho(405, 404). caminho(405, 406). 
caminho(406, 448). caminho(406, 364). caminho(406, 405). caminho(406, 407). 
caminho(407, 449). caminho(407, 365). caminho(407, 406). caminho(407, 408). 
caminho(408, 450). caminho(408, 366). caminho(408, 407). caminho(408, 409). 
caminho(409, 451). caminho(409, 367). caminho(409, 408). caminho(409, 410). 
caminho(410, 452). caminho(410, 368). caminho(410, 409). caminho(410, 411). 
caminho(411, 453). caminho(411, 369). caminho(411, 410). caminho(411, 412). 
caminho(412, 454). caminho(412, 370). caminho(412, 411). caminho(412, 413). 
caminho(413, 455). caminho(413, 371). caminho(413, 412). caminho(413, 414). 
caminho(414, 456). caminho(414, 372). caminho(414, 413). caminho(414, 415). 
caminho(415, 457). caminho(415, 373). caminho(415, 414). caminho(415, 416). 
caminho(416, 458). caminho(416, 374). caminho(416, 415). caminho(416, 417). 
caminho(417, 459). caminho(417, 375). caminho(417, 416). caminho(417, 418). 
caminho(418, 460). caminho(418, 376). caminho(418, 417). caminho(418, 419). 
caminho(419, 461). caminho(419, 377). caminho(419, 418). caminho(419, 420). 
caminho(420, 462). caminho(420, 378). caminho(420, 419). 
caminho(421, 463). caminho(421, 379). caminho(421, 422). 
caminho(422, 464). caminho(422, 380). caminho(422, 421). caminho(422, 423). 
caminho(423, 465). caminho(423, 381). caminho(423, 422). caminho(423, 424). 
caminho(424, 466). caminho(424, 382). caminho(424, 423). caminho(424, 425). 
caminho(425, 467). caminho(425, 383). caminho(425, 424). caminho(425, 426). 
caminho(426, 468). caminho(426, 384). caminho(426, 425). caminho(426, 427). 
caminho(427, 469). caminho(427, 385). caminho(427, 426). caminho(427, 428). 
caminho(428, 470). caminho(428, 386). caminho(428, 427). caminho(428, 429). 
caminho(429, 471). caminho(429, 387). caminho(429, 428). caminho(429, 430). 
caminho(430, 472). caminho(430, 388). caminho(430, 429). caminho(430, 431). 
caminho(431, 473). caminho(431, 389). caminho(431, 430). caminho(431, 432). 
caminho(432, 474). caminho(432, 390). caminho(432, 431). caminho(432, 433). 
caminho(433, 475). caminho(433, 391). caminho(433, 432). caminho(433, 434). 
caminho(434, 476). caminho(434, 392). caminho(434, 433). caminho(434, 435). 
caminho(435, 477). caminho(435, 393). caminho(435, 434). caminho(435, 436). 
caminho(436, 478). caminho(436, 394). caminho(436, 435). caminho(436, 437). 
caminho(437, 479). caminho(437, 395). caminho(437, 436). caminho(437, 438). 
caminho(438, 480). caminho(438, 396). caminho(438, 437). caminho(438, 439). 
caminho(439, 481). caminho(439, 397). caminho(439, 438). caminho(439, 440). 
caminho(440, 482). caminho(440, 398). caminho(440, 439). caminho(440, 441). 
caminho(441, 483). caminho(441, 399). caminho(441, 440). caminho(441, 442). 
caminho(442, 484). caminho(442, 400). caminho(442, 441). caminho(442, 443). 
caminho(443, 485). caminho(443, 401). caminho(443, 442). caminho(443, 444). 
caminho(444, 486). caminho(444, 402). caminho(444, 443). caminho(444, 445). 
caminho(445, 487). caminho(445, 403). caminho(445, 444). caminho(445, 446). 
caminho(446, 488). caminho(446, 404). caminho(446, 445). caminho(446, 447). 
caminho(447, 489). caminho(447, 405). caminho(447, 446). caminho(447, 448). 
caminho(448, 490). caminho(448, 406). caminho(448, 447). caminho(448, 449). 
caminho(449, 491). caminho(449, 407). caminho(449, 448). caminho(449, 450). 
caminho(450, 492). caminho(450, 408). caminho(450, 449). caminho(450, 451). 
caminho(451, 493). caminho(451, 409). caminho(451, 450). caminho(451, 452). 
caminho(452, 494). caminho(452, 410). caminho(452, 451). caminho(452, 453). 
caminho(453, 495). caminho(453, 411). caminho(453, 452). caminho(453, 454). 
caminho(454, 496). caminho(454, 412). caminho(454, 453). caminho(454, 455). 
caminho(455, 497). caminho(455, 413). caminho(455, 454). caminho(455, 456). 
caminho(456, 498). caminho(456, 414). caminho(456, 455). caminho(456, 457). 
caminho(457, 499). caminho(457, 415). caminho(457, 456). caminho(457, 458). 
caminho(458, 500). caminho(458, 416). caminho(458, 457). caminho(458, 459). 
caminho(459, 501). caminho(459, 417). caminho(459, 458). caminho(459, 460). 
caminho(460, 502). caminho(460, 418). caminho(460, 459). caminho(460, 461). 
caminho(461, 503). caminho(461, 419). caminho(461, 460). caminho(461, 462). 
caminho(462, 504). caminho(462, 420). caminho(462, 461). 
caminho(463, 505). caminho(463, 421). caminho(463, 464). 
caminho(464, 506). caminho(464, 422). caminho(464, 463). caminho(464, 465). 
caminho(465, 507). caminho(465, 423). caminho(465, 464). caminho(465, 466). 
caminho(466, 508). caminho(466, 424). caminho(466, 465). caminho(466, 467). 
caminho(467, 509). caminho(467, 425). caminho(467, 466). caminho(467, 468). 
caminho(468, 510). caminho(468, 426). caminho(468, 467). caminho(468, 469). 
caminho(469, 511). caminho(469, 427). caminho(469, 468). caminho(469, 470). 
caminho(470, 512). caminho(470, 428). caminho(470, 469). caminho(470, 471). 
caminho(471, 513). caminho(471, 429). caminho(471, 470). caminho(471, 472). 
caminho(472, 514). caminho(472, 430). caminho(472, 471). caminho(472, 473). 
caminho(473, 515). caminho(473, 431). caminho(473, 472). caminho(473, 474). 
caminho(474, 516). caminho(474, 432). caminho(474, 473). caminho(474, 475). 
caminho(475, 517). caminho(475, 433). caminho(475, 474). caminho(475, 476). 
caminho(476, 518). caminho(476, 434). caminho(476, 475). caminho(476, 477). 
caminho(477, 519). caminho(477, 435). caminho(477, 476). caminho(477, 478). 
caminho(478, 520). caminho(478, 436). caminho(478, 477). caminho(478, 479). 
caminho(479, 521). caminho(479, 437). caminho(479, 478). caminho(479, 480). 
caminho(480, 522). caminho(480, 438). caminho(480, 479). caminho(480, 481). 
caminho(481, 523). caminho(481, 439). caminho(481, 480). caminho(481, 482). 
caminho(482, 524). caminho(482, 440). caminho(482, 481). caminho(482, 483). 
caminho(483, 525). caminho(483, 441). caminho(483, 482). caminho(483, 484). 
caminho(484, 526). caminho(484, 442). caminho(484, 483). caminho(484, 485). 
caminho(485, 527). caminho(485, 443). caminho(485, 484). caminho(485, 486). 
caminho(486, 528). caminho(486, 444). caminho(486, 485). caminho(486, 487). 
caminho(487, 529). caminho(487, 445). caminho(487, 486). caminho(487, 488). 
caminho(488, 530). caminho(488, 446). caminho(488, 487). caminho(488, 489). 
caminho(489, 531). caminho(489, 447). caminho(489, 488). caminho(489, 490). 
caminho(490, 532). caminho(490, 448). caminho(490, 489). caminho(490, 491). 
caminho(491, 533). caminho(491, 449). caminho(491, 490). caminho(491, 492). 
caminho(492, 534). caminho(492, 450). caminho(492, 491). caminho(492, 493). 
caminho(493, 535). caminho(493, 451). caminho(493, 492). caminho(493, 494). 
caminho(494, 536). caminho(494, 452). caminho(494, 493). caminho(494, 495). 
caminho(495, 537). caminho(495, 453). caminho(495, 494). caminho(495, 496). 
caminho(496, 538). caminho(496, 454). caminho(496, 495). caminho(496, 497). 
caminho(497, 539). caminho(497, 455). caminho(497, 496). caminho(497, 498). 
caminho(498, 540). caminho(498, 456). caminho(498, 497). caminho(498, 499). 
caminho(499, 541). caminho(499, 457). caminho(499, 498). caminho(499, 500). 
caminho(500, 542). caminho(500, 458). caminho(500, 499). caminho(500, 501). 
caminho(501, 543). caminho(501, 459). caminho(501, 500). caminho(501, 502). 
caminho(502, 544). caminho(502, 460). caminho(502, 501). caminho(502, 503). 
caminho(503, 545). caminho(503, 461). caminho(503, 502). caminho(503, 504). 
caminho(504, 546). caminho(504, 462). caminho(504, 503). 
caminho(505, 547). caminho(505, 463). caminho(505, 506). 
caminho(506, 548). caminho(506, 464). caminho(506, 505). caminho(506, 507). 
caminho(507, 549). caminho(507, 465). caminho(507, 506). caminho(507, 508). 
caminho(508, 550). caminho(508, 466). caminho(508, 507). caminho(508, 509). 
caminho(509, 551). caminho(509, 467). caminho(509, 508). caminho(509, 510). 
caminho(510, 552). caminho(510, 468). caminho(510, 509). caminho(510, 511). 
caminho(511, 553). caminho(511, 469). caminho(511, 510). caminho(511, 512). 
caminho(512, 554). caminho(512, 470). caminho(512, 511). caminho(512, 513). 
caminho(513, 555). caminho(513, 471). caminho(513, 512). caminho(513, 514). 
caminho(514, 556). caminho(514, 472). caminho(514, 513). caminho(514, 515). 
caminho(515, 557). caminho(515, 473). caminho(515, 514). caminho(515, 516). 
caminho(516, 558). caminho(516, 474). caminho(516, 515). caminho(516, 517). 
caminho(517, 559). caminho(517, 475). caminho(517, 516). caminho(517, 518). 
caminho(518, 560). caminho(518, 476). caminho(518, 517). caminho(518, 519). 
caminho(519, 561). caminho(519, 477). caminho(519, 518). caminho(519, 520). 
caminho(520, 562). caminho(520, 478). caminho(520, 519). caminho(520, 521). 
caminho(521, 563). caminho(521, 479). caminho(521, 520). caminho(521, 522). 
caminho(522, 564). caminho(522, 480). caminho(522, 521). caminho(522, 523). 
caminho(523, 565). caminho(523, 481). caminho(523, 522). caminho(523, 524). 
caminho(524, 566). caminho(524, 482). caminho(524, 523). caminho(524, 525). 
caminho(525, 567). caminho(525, 483). caminho(525, 524). caminho(525, 526). 
caminho(526, 568). caminho(526, 484). caminho(526, 525). caminho(526, 527). 
caminho(527, 569). caminho(527, 485). caminho(527, 526). caminho(527, 528). 
caminho(528, 570). caminho(528, 486). caminho(528, 527). caminho(528, 529). 
caminho(529, 571). caminho(529, 487). caminho(529, 528). caminho(529, 530). 
caminho(530, 572). caminho(530, 488). caminho(530, 529). caminho(530, 531). 
caminho(531, 573). caminho(531, 489). caminho(531, 530). caminho(531, 532). 
caminho(532, 574). caminho(532, 490). caminho(532, 531). caminho(532, 533). 
caminho(533, 575). caminho(533, 491). caminho(533, 532). caminho(533, 534). 
caminho(534, 576). caminho(534, 492). caminho(534, 533). caminho(534, 535). 
caminho(535, 577). caminho(535, 493). caminho(535, 534). caminho(535, 536). 
caminho(536, 578). caminho(536, 494). caminho(536, 535). caminho(536, 537). 
caminho(537, 579). caminho(537, 495). caminho(537, 536). caminho(537, 538). 
caminho(538, 580). caminho(538, 496). caminho(538, 537). caminho(538, 539). 
caminho(539, 581). caminho(539, 497). caminho(539, 538). caminho(539, 540). 
caminho(540, 582). caminho(540, 498). caminho(540, 539). caminho(540, 541). 
caminho(541, 583). caminho(541, 499). caminho(541, 540). caminho(541, 542). 
caminho(542, 584). caminho(542, 500). caminho(542, 541). caminho(542, 543). 
caminho(543, 585). caminho(543, 501). caminho(543, 542). caminho(543, 544). 
caminho(544, 586). caminho(544, 502). caminho(544, 543). caminho(544, 545). 
caminho(545, 587). caminho(545, 503). caminho(545, 544). caminho(545, 546). 
caminho(546, 588). caminho(546, 504). caminho(546, 545). 
caminho(547, 589). caminho(547, 505). caminho(547, 548). 
caminho(548, 590). caminho(548, 506). caminho(548, 547). caminho(548, 549). 
caminho(549, 591). caminho(549, 507). caminho(549, 548). caminho(549, 550). 
caminho(550, 592). caminho(550, 508). caminho(550, 549). caminho(550, 551). 
caminho(551, 593). caminho(551, 509). caminho(551, 550). caminho(551, 552). 
caminho(552, 594). caminho(552, 510). caminho(552, 551). caminho(552, 553). 
caminho(553, 595). caminho(553, 511). caminho(553, 552). caminho(553, 554). 
caminho(554, 596). caminho(554, 512). caminho(554, 553). caminho(554, 555). 
caminho(555, 597). caminho(555, 513). caminho(555, 554). caminho(555, 556). 
caminho(556, 598). caminho(556, 514). caminho(556, 555). caminho(556, 557). 
caminho(557, 599). caminho(557, 515). caminho(557, 556). caminho(557, 558). 
caminho(558, 600). caminho(558, 516). caminho(558, 557). caminho(558, 559). 
caminho(559, 601). caminho(559, 517). caminho(559, 558). caminho(559, 560). 
caminho(560, 602). caminho(560, 518). caminho(560, 559). caminho(560, 561). 
caminho(561, 603). caminho(561, 519). caminho(561, 560). caminho(561, 562). 
caminho(562, 604). caminho(562, 520). caminho(562, 561). caminho(562, 563). 
caminho(563, 605). caminho(563, 521). caminho(563, 562). caminho(563, 564). 
caminho(564, 606). caminho(564, 522). caminho(564, 563). caminho(564, 565). 
caminho(565, 607). caminho(565, 523). caminho(565, 564). caminho(565, 566). 
caminho(566, 608). caminho(566, 524). caminho(566, 565). caminho(566, 567). 
caminho(567, 609). caminho(567, 525). caminho(567, 566). caminho(567, 568). 
caminho(568, 610). caminho(568, 526). caminho(568, 567). caminho(568, 569). 
caminho(569, 611). caminho(569, 527). caminho(569, 568). caminho(569, 570). 
caminho(570, 612). caminho(570, 528). caminho(570, 569). caminho(570, 571). 
caminho(571, 613). caminho(571, 529). caminho(571, 570). caminho(571, 572). 
caminho(572, 614). caminho(572, 530). caminho(572, 571). caminho(572, 573). 
caminho(573, 615). caminho(573, 531). caminho(573, 572). caminho(573, 574). 
caminho(574, 616). caminho(574, 532). caminho(574, 573). caminho(574, 575). 
caminho(575, 617). caminho(575, 533). caminho(575, 574). caminho(575, 576). 
caminho(576, 618). caminho(576, 534). caminho(576, 575). caminho(576, 577). 
caminho(577, 619). caminho(577, 535). caminho(577, 576). caminho(577, 578). 
caminho(578, 620). caminho(578, 536). caminho(578, 577). caminho(578, 579). 
caminho(579, 621). caminho(579, 537). caminho(579, 578). caminho(579, 580). 
caminho(580, 622). caminho(580, 538). caminho(580, 579). caminho(580, 581). 
caminho(581, 623). caminho(581, 539). caminho(581, 580). caminho(581, 582). 
caminho(582, 624). caminho(582, 540). caminho(582, 581). caminho(582, 583). 
caminho(583, 625). caminho(583, 541). caminho(583, 582). caminho(583, 584). 
caminho(584, 626). caminho(584, 542). caminho(584, 583). caminho(584, 585). 
caminho(585, 627). caminho(585, 543). caminho(585, 584). caminho(585, 586). 
caminho(586, 628). caminho(586, 544). caminho(586, 585). caminho(586, 587). 
caminho(587, 629). caminho(587, 545). caminho(587, 586). caminho(587, 588). 
caminho(588, 630). caminho(588, 546). caminho(588, 587). 
caminho(589, 631). caminho(589, 547). caminho(589, 590). 
caminho(590, 632). caminho(590, 548). caminho(590, 589). caminho(590, 591). 
caminho(591, 633). caminho(591, 549). caminho(591, 590). caminho(591, 592). 
caminho(592, 634). caminho(592, 550). caminho(592, 591). caminho(592, 593). 
caminho(593, 635). caminho(593, 551). caminho(593, 592). caminho(593, 594). 
caminho(594, 636). caminho(594, 552). caminho(594, 593). caminho(594, 595). 
caminho(595, 637). caminho(595, 553). caminho(595, 594). caminho(595, 596). 
caminho(596, 638). caminho(596, 554). caminho(596, 595). caminho(596, 597). 
caminho(597, 639). caminho(597, 555). caminho(597, 596). caminho(597, 598). 
caminho(598, 640). caminho(598, 556). caminho(598, 597). caminho(598, 599). 
caminho(599, 641). caminho(599, 557). caminho(599, 598). caminho(599, 600). 
caminho(600, 642). caminho(600, 558). caminho(600, 599). caminho(600, 601). 
caminho(601, 643). caminho(601, 559). caminho(601, 600). caminho(601, 602). 
caminho(602, 644). caminho(602, 560). caminho(602, 601). caminho(602, 603). 
caminho(603, 645). caminho(603, 561). caminho(603, 602). caminho(603, 604). 
caminho(604, 646). caminho(604, 562). caminho(604, 603). caminho(604, 605). 
caminho(605, 647). caminho(605, 563). caminho(605, 604). caminho(605, 606). 
caminho(606, 648). caminho(606, 564). caminho(606, 605). caminho(606, 607). 
caminho(607, 649). caminho(607, 565). caminho(607, 606). caminho(607, 608). 
caminho(608, 650). caminho(608, 566). caminho(608, 607). caminho(608, 609). 
caminho(609, 651). caminho(609, 567). caminho(609, 608). caminho(609, 610). 
caminho(610, 652). caminho(610, 568). caminho(610, 609). caminho(610, 611). 
caminho(611, 653). caminho(611, 569). caminho(611, 610). caminho(611, 612). 
caminho(612, 654). caminho(612, 570). caminho(612, 611). caminho(612, 613). 
caminho(613, 655). caminho(613, 571). caminho(613, 612). caminho(613, 614). 
caminho(614, 656). caminho(614, 572). caminho(614, 613). caminho(614, 615). 
caminho(615, 657). caminho(615, 573). caminho(615, 614). caminho(615, 616). 
caminho(616, 658). caminho(616, 574). caminho(616, 615). caminho(616, 617). 
caminho(617, 659). caminho(617, 575). caminho(617, 616). caminho(617, 618). 
caminho(618, 660). caminho(618, 576). caminho(618, 617). caminho(618, 619). 
caminho(619, 661). caminho(619, 577). caminho(619, 618). caminho(619, 620). 
caminho(620, 662). caminho(620, 578). caminho(620, 619). caminho(620, 621). 
caminho(621, 663). caminho(621, 579). caminho(621, 620). caminho(621, 622). 
caminho(622, 664). caminho(622, 580). caminho(622, 621). caminho(622, 623). 
caminho(623, 665). caminho(623, 581). caminho(623, 622). caminho(623, 624). 
caminho(624, 666). caminho(624, 582). caminho(624, 623). caminho(624, 625). 
caminho(625, 667). caminho(625, 583). caminho(625, 624). caminho(625, 626). 
caminho(626, 668). caminho(626, 584). caminho(626, 625). caminho(626, 627). 
caminho(627, 669). caminho(627, 585). caminho(627, 626). caminho(627, 628). 
caminho(628, 670). caminho(628, 586). caminho(628, 627). caminho(628, 629). 
caminho(629, 671). caminho(629, 587). caminho(629, 628). caminho(629, 630). 
caminho(630, 672). caminho(630, 588). caminho(630, 629). 
caminho(631, 673). caminho(631, 589). caminho(631, 632). 
caminho(632, 674). caminho(632, 590). caminho(632, 631). caminho(632, 633). 
caminho(633, 675). caminho(633, 591). caminho(633, 632). caminho(633, 634). 
caminho(634, 676). caminho(634, 592). caminho(634, 633). caminho(634, 635). 
caminho(635, 677). caminho(635, 593). caminho(635, 634). caminho(635, 636). 
caminho(636, 678). caminho(636, 594). caminho(636, 635). caminho(636, 637). 
caminho(637, 679). caminho(637, 595). caminho(637, 636). caminho(637, 638). 
caminho(638, 680). caminho(638, 596). caminho(638, 637). caminho(638, 639). 
caminho(639, 681). caminho(639, 597). caminho(639, 638). caminho(639, 640). 
caminho(640, 682). caminho(640, 598). caminho(640, 639). caminho(640, 641). 
caminho(641, 683). caminho(641, 599). caminho(641, 640). caminho(641, 642). 
caminho(642, 684). caminho(642, 600). caminho(642, 641). caminho(642, 643). 
caminho(643, 685). caminho(643, 601). caminho(643, 642). caminho(643, 644). 
caminho(644, 686). caminho(644, 602). caminho(644, 643). caminho(644, 645). 
caminho(645, 687). caminho(645, 603). caminho(645, 644). caminho(645, 646). 
caminho(646, 688). caminho(646, 604). caminho(646, 645). caminho(646, 647). 
caminho(647, 689). caminho(647, 605). caminho(647, 646). caminho(647, 648). 
caminho(648, 690). caminho(648, 606). caminho(648, 647). caminho(648, 649). 
caminho(649, 691). caminho(649, 607). caminho(649, 648). caminho(649, 650). 
caminho(650, 692). caminho(650, 608). caminho(650, 649). caminho(650, 651). 
caminho(651, 693). caminho(651, 609). caminho(651, 650). caminho(651, 652). 
caminho(652, 694). caminho(652, 610). caminho(652, 651). caminho(652, 653). 
caminho(653, 695). caminho(653, 611). caminho(653, 652). caminho(653, 654). 
caminho(654, 696). caminho(654, 612). caminho(654, 653). caminho(654, 655). 
caminho(655, 697). caminho(655, 613). caminho(655, 654). caminho(655, 656). 
caminho(656, 698). caminho(656, 614). caminho(656, 655). caminho(656, 657). 
caminho(657, 699). caminho(657, 615). caminho(657, 656). caminho(657, 658). 
caminho(658, 700). caminho(658, 616). caminho(658, 657). caminho(658, 659). 
caminho(659, 701). caminho(659, 617). caminho(659, 658). caminho(659, 660). 
caminho(660, 702). caminho(660, 618). caminho(660, 659). caminho(660, 661). 
caminho(661, 703). caminho(661, 619). caminho(661, 660). caminho(661, 662). 
caminho(662, 704). caminho(662, 620). caminho(662, 661). caminho(662, 663). 
caminho(663, 705). caminho(663, 621). caminho(663, 662). caminho(663, 664). 
caminho(664, 706). caminho(664, 622). caminho(664, 663). caminho(664, 665). 
caminho(665, 707). caminho(665, 623). caminho(665, 664). caminho(665, 666). 
caminho(666, 708). caminho(666, 624). caminho(666, 665). caminho(666, 667). 
caminho(667, 709). caminho(667, 625). caminho(667, 666). caminho(667, 668). 
caminho(668, 710). caminho(668, 626). caminho(668, 667). caminho(668, 669). 
caminho(669, 711). caminho(669, 627). caminho(669, 668). caminho(669, 670). 
caminho(670, 712). caminho(670, 628). caminho(670, 669). caminho(670, 671). 
caminho(671, 713). caminho(671, 629). caminho(671, 670). caminho(671, 672). 
caminho(672, 714). caminho(672, 630). caminho(672, 671). 
caminho(673, 715). caminho(673, 631). caminho(673, 674). 
caminho(674, 716). caminho(674, 632). caminho(674, 673). caminho(674, 675). 
caminho(675, 717). caminho(675, 633). caminho(675, 674). caminho(675, 676). 
caminho(676, 718). caminho(676, 634). caminho(676, 675). caminho(676, 677). 
caminho(677, 719). caminho(677, 635). caminho(677, 676). caminho(677, 678). 
caminho(678, 720). caminho(678, 636). caminho(678, 677). caminho(678, 679). 
caminho(679, 721). caminho(679, 637). caminho(679, 678). caminho(679, 680). 
caminho(680, 722). caminho(680, 638). caminho(680, 679). caminho(680, 681). 
caminho(681, 723). caminho(681, 639). caminho(681, 680). caminho(681, 682). 
caminho(682, 724). caminho(682, 640). caminho(682, 681). caminho(682, 683). 
caminho(683, 725). caminho(683, 641). caminho(683, 682). caminho(683, 684). 
caminho(684, 726). caminho(684, 642). caminho(684, 683). caminho(684, 685). 
caminho(685, 727). caminho(685, 643). caminho(685, 684). caminho(685, 686). 
caminho(686, 728). caminho(686, 644). caminho(686, 685). caminho(686, 687). 
caminho(687, 729). caminho(687, 645). caminho(687, 686). caminho(687, 688). 
caminho(688, 730). caminho(688, 646). caminho(688, 687). caminho(688, 689). 
caminho(689, 731). caminho(689, 647). caminho(689, 688). caminho(689, 690). 
caminho(690, 732). caminho(690, 648). caminho(690, 689). caminho(690, 691). 
caminho(691, 733). caminho(691, 649). caminho(691, 690). caminho(691, 692). 
caminho(692, 734). caminho(692, 650). caminho(692, 691). caminho(692, 693). 
caminho(693, 735). caminho(693, 651). caminho(693, 692). caminho(693, 694). 
caminho(694, 736). caminho(694, 652). caminho(694, 693). caminho(694, 695). 
caminho(695, 737). caminho(695, 653). caminho(695, 694). caminho(695, 696). 
caminho(696, 738). caminho(696, 654). caminho(696, 695). caminho(696, 697). 
caminho(697, 739). caminho(697, 655). caminho(697, 696). caminho(697, 698). 
caminho(698, 740). caminho(698, 656). caminho(698, 697). caminho(698, 699). 
caminho(699, 741). caminho(699, 657). caminho(699, 698). caminho(699, 700). 
caminho(700, 742). caminho(700, 658). caminho(700, 699). caminho(700, 701). 
caminho(701, 743). caminho(701, 659). caminho(701, 700). caminho(701, 702). 
caminho(702, 744). caminho(702, 660). caminho(702, 701). caminho(702, 703). 
caminho(703, 745). caminho(703, 661). caminho(703, 702). caminho(703, 704). 
caminho(704, 746). caminho(704, 662). caminho(704, 703). caminho(704, 705). 
caminho(705, 747). caminho(705, 663). caminho(705, 704). caminho(705, 706). 
caminho(706, 748). caminho(706, 664). caminho(706, 705). caminho(706, 707). 
caminho(707, 749). caminho(707, 665). caminho(707, 706). caminho(707, 708). 
caminho(708, 750). caminho(708, 666). caminho(708, 707). caminho(708, 709). 
caminho(709, 751). caminho(709, 667). caminho(709, 708). caminho(709, 710). 
caminho(710, 752). caminho(710, 668). caminho(710, 709). caminho(710, 711). 
caminho(711, 753). caminho(711, 669). caminho(711, 710). caminho(711, 712). 
caminho(712, 754). caminho(712, 670). caminho(712, 711). caminho(712, 713). 
caminho(713, 755). caminho(713, 671). caminho(713, 712). caminho(713, 714). 
caminho(714, 756). caminho(714, 672). caminho(714, 713). 
caminho(715, 757). caminho(715, 673). caminho(715, 716). 
caminho(716, 758). caminho(716, 674). caminho(716, 715). caminho(716, 717). 
caminho(717, 759). caminho(717, 675). caminho(717, 716). caminho(717, 718). 
caminho(718, 760). caminho(718, 676). caminho(718, 717). caminho(718, 719). 
caminho(719, 761). caminho(719, 677). caminho(719, 718). caminho(719, 720). 
caminho(720, 762). caminho(720, 678). caminho(720, 719). caminho(720, 721). 
caminho(721, 763). caminho(721, 679). caminho(721, 720). caminho(721, 722). 
caminho(722, 764). caminho(722, 680). caminho(722, 721). caminho(722, 723). 
caminho(723, 765). caminho(723, 681). caminho(723, 722). caminho(723, 724). 
caminho(724, 766). caminho(724, 682). caminho(724, 723). caminho(724, 725). 
caminho(725, 767). caminho(725, 683). caminho(725, 724). caminho(725, 726). 
caminho(726, 768). caminho(726, 684). caminho(726, 725). caminho(726, 727). 
caminho(727, 769). caminho(727, 685). caminho(727, 726). caminho(727, 728). 
caminho(728, 770). caminho(728, 686). caminho(728, 727). caminho(728, 729). 
caminho(729, 771). caminho(729, 687). caminho(729, 728). caminho(729, 730). 
caminho(730, 772). caminho(730, 688). caminho(730, 729). caminho(730, 731). 
caminho(731, 773). caminho(731, 689). caminho(731, 730). caminho(731, 732). 
caminho(732, 774). caminho(732, 690). caminho(732, 731). caminho(732, 733). 
caminho(733, 775). caminho(733, 691). caminho(733, 732). caminho(733, 734). 
caminho(734, 776). caminho(734, 692). caminho(734, 733). caminho(734, 735). 
caminho(735, 777). caminho(735, 693). caminho(735, 734). caminho(735, 736). 
caminho(736, 778). caminho(736, 694). caminho(736, 735). caminho(736, 737). 
caminho(737, 779). caminho(737, 695). caminho(737, 736). caminho(737, 738). 
caminho(738, 780). caminho(738, 696). caminho(738, 737). caminho(738, 739). 
caminho(739, 781). caminho(739, 697). caminho(739, 738). caminho(739, 740). 
caminho(740, 782). caminho(740, 698). caminho(740, 739). caminho(740, 741). 
caminho(741, 783). caminho(741, 699). caminho(741, 740). caminho(741, 742). 
caminho(742, 784). caminho(742, 700). caminho(742, 741). caminho(742, 743). 
caminho(743, 785). caminho(743, 701). caminho(743, 742). caminho(743, 744). 
caminho(744, 786). caminho(744, 702). caminho(744, 743). caminho(744, 745). 
caminho(745, 787). caminho(745, 703). caminho(745, 744). caminho(745, 746). 
caminho(746, 788). caminho(746, 704). caminho(746, 745). caminho(746, 747). 
caminho(747, 789). caminho(747, 705). caminho(747, 746). caminho(747, 748). 
caminho(748, 790). caminho(748, 706). caminho(748, 747). caminho(748, 749). 
caminho(749, 791). caminho(749, 707). caminho(749, 748). caminho(749, 750). 
caminho(750, 792). caminho(750, 708). caminho(750, 749). caminho(750, 751). 
caminho(751, 793). caminho(751, 709). caminho(751, 750). caminho(751, 752). 
caminho(752, 794). caminho(752, 710). caminho(752, 751). caminho(752, 753). 
caminho(753, 795). caminho(753, 711). caminho(753, 752). caminho(753, 754). 
caminho(754, 796). caminho(754, 712). caminho(754, 753). caminho(754, 755). 
caminho(755, 797). caminho(755, 713). caminho(755, 754). caminho(755, 756). 
caminho(756, 798). caminho(756, 714). caminho(756, 755). 
caminho(757, 799). caminho(757, 715). caminho(757, 758). 
caminho(758, 800). caminho(758, 716). caminho(758, 757). caminho(758, 759). 
caminho(759, 801). caminho(759, 717). caminho(759, 758). caminho(759, 760). 
caminho(760, 802). caminho(760, 718). caminho(760, 759). caminho(760, 761). 
caminho(761, 803). caminho(761, 719). caminho(761, 760). caminho(761, 762). 
caminho(762, 804). caminho(762, 720). caminho(762, 761). caminho(762, 763). 
caminho(763, 805). caminho(763, 721). caminho(763, 762). caminho(763, 764). 
caminho(764, 806). caminho(764, 722). caminho(764, 763). caminho(764, 765). 
caminho(765, 807). caminho(765, 723). caminho(765, 764). caminho(765, 766). 
caminho(766, 808). caminho(766, 724). caminho(766, 765). caminho(766, 767). 
caminho(767, 809). caminho(767, 725). caminho(767, 766). caminho(767, 768). 
caminho(768, 810). caminho(768, 726). caminho(768, 767). caminho(768, 769). 
caminho(769, 811). caminho(769, 727). caminho(769, 768). caminho(769, 770). 
caminho(770, 812). caminho(770, 728). caminho(770, 769). caminho(770, 771). 
caminho(771, 813). caminho(771, 729). caminho(771, 770). caminho(771, 772). 
caminho(772, 814). caminho(772, 730). caminho(772, 771). caminho(772, 773). 
caminho(773, 815). caminho(773, 731). caminho(773, 772). caminho(773, 774). 
caminho(774, 816). caminho(774, 732). caminho(774, 773). caminho(774, 775). 
caminho(775, 817). caminho(775, 733). caminho(775, 774). caminho(775, 776). 
caminho(776, 818). caminho(776, 734). caminho(776, 775). caminho(776, 777). 
caminho(777, 819). caminho(777, 735). caminho(777, 776). caminho(777, 778). 
caminho(778, 820). caminho(778, 736). caminho(778, 777). caminho(778, 779). 
caminho(779, 821). caminho(779, 737). caminho(779, 778). caminho(779, 780). 
caminho(780, 822). caminho(780, 738). caminho(780, 779). caminho(780, 781). 
caminho(781, 823). caminho(781, 739). caminho(781, 780). caminho(781, 782). 
caminho(782, 824). caminho(782, 740). caminho(782, 781). caminho(782, 783). 
caminho(783, 825). caminho(783, 741). caminho(783, 782). caminho(783, 784). 
caminho(784, 826). caminho(784, 742). caminho(784, 783). caminho(784, 785). 
caminho(785, 827). caminho(785, 743). caminho(785, 784). caminho(785, 786). 
caminho(786, 828). caminho(786, 744). caminho(786, 785). caminho(786, 787). 
caminho(787, 829). caminho(787, 745). caminho(787, 786). caminho(787, 788). 
caminho(788, 830). caminho(788, 746). caminho(788, 787). caminho(788, 789). 
caminho(789, 831). caminho(789, 747). caminho(789, 788). caminho(789, 790). 
caminho(790, 832). caminho(790, 748). caminho(790, 789). caminho(790, 791). 
caminho(791, 833). caminho(791, 749). caminho(791, 790). caminho(791, 792). 
caminho(792, 834). caminho(792, 750). caminho(792, 791). caminho(792, 793). 
caminho(793, 835). caminho(793, 751). caminho(793, 792). caminho(793, 794). 
caminho(794, 836). caminho(794, 752). caminho(794, 793). caminho(794, 795). 
caminho(795, 837). caminho(795, 753). caminho(795, 794). caminho(795, 796). 
caminho(796, 838). caminho(796, 754). caminho(796, 795). caminho(796, 797). 
caminho(797, 839). caminho(797, 755). caminho(797, 796). caminho(797, 798). 
caminho(798, 840). caminho(798, 756). caminho(798, 797). 
caminho(799, 841). caminho(799, 757). caminho(799, 800). 
caminho(800, 842). caminho(800, 758). caminho(800, 799). caminho(800, 801). 
caminho(801, 843). caminho(801, 759). caminho(801, 800). caminho(801, 802). 
caminho(802, 844). caminho(802, 760). caminho(802, 801). caminho(802, 803). 
caminho(803, 845). caminho(803, 761). caminho(803, 802). caminho(803, 804). 
caminho(804, 846). caminho(804, 762). caminho(804, 803). caminho(804, 805). 
caminho(805, 847). caminho(805, 763). caminho(805, 804). caminho(805, 806). 
caminho(806, 848). caminho(806, 764). caminho(806, 805). caminho(806, 807). 
caminho(807, 849). caminho(807, 765). caminho(807, 806). caminho(807, 808). 
caminho(808, 850). caminho(808, 766). caminho(808, 807). caminho(808, 809). 
caminho(809, 851). caminho(809, 767). caminho(809, 808). caminho(809, 810). 
caminho(810, 852). caminho(810, 768). caminho(810, 809). caminho(810, 811). 
caminho(811, 853). caminho(811, 769). caminho(811, 810). caminho(811, 812). 
caminho(812, 854). caminho(812, 770). caminho(812, 811). caminho(812, 813). 
caminho(813, 855). caminho(813, 771). caminho(813, 812). caminho(813, 814). 
caminho(814, 856). caminho(814, 772). caminho(814, 813). caminho(814, 815). 
caminho(815, 857). caminho(815, 773). caminho(815, 814). caminho(815, 816). 
caminho(816, 858). caminho(816, 774). caminho(816, 815). caminho(816, 817). 
caminho(817, 859). caminho(817, 775). caminho(817, 816). caminho(817, 818). 
caminho(818, 860). caminho(818, 776). caminho(818, 817). caminho(818, 819). 
caminho(819, 861). caminho(819, 777). caminho(819, 818). caminho(819, 820). 
caminho(820, 862). caminho(820, 778). caminho(820, 819). caminho(820, 821). 
caminho(821, 863). caminho(821, 779). caminho(821, 820). caminho(821, 822). 
caminho(822, 864). caminho(822, 780). caminho(822, 821). caminho(822, 823). 
caminho(823, 865). caminho(823, 781). caminho(823, 822). caminho(823, 824). 
caminho(824, 866). caminho(824, 782). caminho(824, 823). caminho(824, 825). 
caminho(825, 867). caminho(825, 783). caminho(825, 824). caminho(825, 826). 
caminho(826, 868). caminho(826, 784). caminho(826, 825). caminho(826, 827). 
caminho(827, 869). caminho(827, 785). caminho(827, 826). caminho(827, 828). 
caminho(828, 870). caminho(828, 786). caminho(828, 827). caminho(828, 829). 
caminho(829, 871). caminho(829, 787). caminho(829, 828). caminho(829, 830). 
caminho(830, 872). caminho(830, 788). caminho(830, 829). caminho(830, 831). 
caminho(831, 873). caminho(831, 789). caminho(831, 830). caminho(831, 832). 
caminho(832, 874). caminho(832, 790). caminho(832, 831). caminho(832, 833). 
caminho(833, 875). caminho(833, 791). caminho(833, 832). caminho(833, 834). 
caminho(834, 876). caminho(834, 792). caminho(834, 833). caminho(834, 835). 
caminho(835, 877). caminho(835, 793). caminho(835, 834). caminho(835, 836). 
caminho(836, 878). caminho(836, 794). caminho(836, 835). caminho(836, 837). 
caminho(837, 879). caminho(837, 795). caminho(837, 836). caminho(837, 838). 
caminho(838, 880). caminho(838, 796). caminho(838, 837). caminho(838, 839). 
caminho(839, 881). caminho(839, 797). caminho(839, 838). caminho(839, 840). 
caminho(840, 882). caminho(840, 798). caminho(840, 839). 
caminho(841, 883). caminho(841, 799). caminho(841, 842). 
caminho(842, 884). caminho(842, 800). caminho(842, 841). caminho(842, 843). 
caminho(843, 885). caminho(843, 801). caminho(843, 842). caminho(843, 844). 
caminho(844, 886). caminho(844, 802). caminho(844, 843). caminho(844, 845). 
caminho(845, 887). caminho(845, 803). caminho(845, 844). caminho(845, 846). 
caminho(846, 888). caminho(846, 804). caminho(846, 845). caminho(846, 847). 
caminho(847, 889). caminho(847, 805). caminho(847, 846). caminho(847, 848). 
caminho(848, 890). caminho(848, 806). caminho(848, 847). caminho(848, 849). 
caminho(849, 891). caminho(849, 807). caminho(849, 848). caminho(849, 850). 
caminho(850, 892). caminho(850, 808). caminho(850, 849). caminho(850, 851). 
caminho(851, 893). caminho(851, 809). caminho(851, 850). caminho(851, 852). 
caminho(852, 894). caminho(852, 810). caminho(852, 851). caminho(852, 853). 
caminho(853, 895). caminho(853, 811). caminho(853, 852). caminho(853, 854). 
caminho(854, 896). caminho(854, 812). caminho(854, 853). caminho(854, 855). 
caminho(855, 897). caminho(855, 813). caminho(855, 854). caminho(855, 856). 
caminho(856, 898). caminho(856, 814). caminho(856, 855). caminho(856, 857). 
caminho(857, 899). caminho(857, 815). caminho(857, 856). caminho(857, 858). 
caminho(858, 900). caminho(858, 816). caminho(858, 857). caminho(858, 859). 
caminho(859, 901). caminho(859, 817). caminho(859, 858). caminho(859, 860). 
caminho(860, 902). caminho(860, 818). caminho(860, 859). caminho(860, 861). 
caminho(861, 903). caminho(861, 819). caminho(861, 860). caminho(861, 862). 
caminho(862, 904). caminho(862, 820). caminho(862, 861). caminho(862, 863). 
caminho(863, 905). caminho(863, 821). caminho(863, 862). caminho(863, 864). 
caminho(864, 906). caminho(864, 822). caminho(864, 863). caminho(864, 865). 
caminho(865, 907). caminho(865, 823). caminho(865, 864). caminho(865, 866). 
caminho(866, 908). caminho(866, 824). caminho(866, 865). caminho(866, 867). 
caminho(867, 909). caminho(867, 825). caminho(867, 866). caminho(867, 868). 
caminho(868, 910). caminho(868, 826). caminho(868, 867). caminho(868, 869). 
caminho(869, 911). caminho(869, 827). caminho(869, 868). caminho(869, 870). 
caminho(870, 912). caminho(870, 828). caminho(870, 869). caminho(870, 871). 
caminho(871, 913). caminho(871, 829). caminho(871, 870). caminho(871, 872). 
caminho(872, 914). caminho(872, 830). caminho(872, 871). caminho(872, 873). 
caminho(873, 915). caminho(873, 831). caminho(873, 872). caminho(873, 874). 
caminho(874, 916). caminho(874, 832). caminho(874, 873). caminho(874, 875). 
caminho(875, 917). caminho(875, 833). caminho(875, 874). caminho(875, 876). 
caminho(876, 918). caminho(876, 834). caminho(876, 875). caminho(876, 877). 
caminho(877, 919). caminho(877, 835). caminho(877, 876). caminho(877, 878). 
caminho(878, 920). caminho(878, 836). caminho(878, 877). caminho(878, 879). 
caminho(879, 921). caminho(879, 837). caminho(879, 878). caminho(879, 880). 
caminho(880, 922). caminho(880, 838). caminho(880, 879). caminho(880, 881). 
caminho(881, 923). caminho(881, 839). caminho(881, 880). caminho(881, 882). 
caminho(882, 924). caminho(882, 840). caminho(882, 881). 
caminho(883, 925). caminho(883, 841). caminho(883, 884). 
caminho(884, 926). caminho(884, 842). caminho(884, 883). caminho(884, 885). 
caminho(885, 927). caminho(885, 843). caminho(885, 884). caminho(885, 886). 
caminho(886, 928). caminho(886, 844). caminho(886, 885). caminho(886, 887). 
caminho(887, 929). caminho(887, 845). caminho(887, 886). caminho(887, 888). 
caminho(888, 930). caminho(888, 846). caminho(888, 887). caminho(888, 889). 
caminho(889, 931). caminho(889, 847). caminho(889, 888). caminho(889, 890). 
caminho(890, 932). caminho(890, 848). caminho(890, 889). caminho(890, 891). 
caminho(891, 933). caminho(891, 849). caminho(891, 890). caminho(891, 892). 
caminho(892, 934). caminho(892, 850). caminho(892, 891). caminho(892, 893). 
caminho(893, 935). caminho(893, 851). caminho(893, 892). caminho(893, 894). 
caminho(894, 936). caminho(894, 852). caminho(894, 893). caminho(894, 895). 
caminho(895, 937). caminho(895, 853). caminho(895, 894). caminho(895, 896). 
caminho(896, 938). caminho(896, 854). caminho(896, 895). caminho(896, 897). 
caminho(897, 939). caminho(897, 855). caminho(897, 896). caminho(897, 898). 
caminho(898, 940). caminho(898, 856). caminho(898, 897). caminho(898, 899). 
caminho(899, 941). caminho(899, 857). caminho(899, 898). caminho(899, 900). 
caminho(900, 942). caminho(900, 858). caminho(900, 899). caminho(900, 901). 
caminho(901, 943). caminho(901, 859). caminho(901, 900). caminho(901, 902). 
caminho(902, 944). caminho(902, 860). caminho(902, 901). caminho(902, 903). 
caminho(903, 945). caminho(903, 861). caminho(903, 902). caminho(903, 904). 
caminho(904, 946). caminho(904, 862). caminho(904, 903). caminho(904, 905). 
caminho(905, 947). caminho(905, 863). caminho(905, 904). caminho(905, 906). 
caminho(906, 948). caminho(906, 864). caminho(906, 905). caminho(906, 907). 
caminho(907, 949). caminho(907, 865). caminho(907, 906). caminho(907, 908). 
caminho(908, 950). caminho(908, 866). caminho(908, 907). caminho(908, 909). 
caminho(909, 951). caminho(909, 867). caminho(909, 908). caminho(909, 910). 
caminho(910, 952). caminho(910, 868). caminho(910, 909). caminho(910, 911). 
caminho(911, 953). caminho(911, 869). caminho(911, 910). caminho(911, 912). 
caminho(912, 954). caminho(912, 870). caminho(912, 911). caminho(912, 913). 
caminho(913, 955). caminho(913, 871). caminho(913, 912). caminho(913, 914). 
caminho(914, 956). caminho(914, 872). caminho(914, 913). caminho(914, 915). 
caminho(915, 957). caminho(915, 873). caminho(915, 914). caminho(915, 916). 
caminho(916, 958). caminho(916, 874). caminho(916, 915). caminho(916, 917). 
caminho(917, 959). caminho(917, 875). caminho(917, 916). caminho(917, 918). 
caminho(918, 960). caminho(918, 876). caminho(918, 917). caminho(918, 919). 
caminho(919, 961). caminho(919, 877). caminho(919, 918). caminho(919, 920). 
caminho(920, 962). caminho(920, 878). caminho(920, 919). caminho(920, 921). 
caminho(921, 963). caminho(921, 879). caminho(921, 920). caminho(921, 922). 
caminho(922, 964). caminho(922, 880). caminho(922, 921). caminho(922, 923). 
caminho(923, 965). caminho(923, 881). caminho(923, 922). caminho(923, 924). 
caminho(924, 966). caminho(924, 882). caminho(924, 923). 
caminho(925, 967). caminho(925, 883). caminho(925, 926). 
caminho(926, 968). caminho(926, 884). caminho(926, 925). caminho(926, 927). 
caminho(927, 969). caminho(927, 885). caminho(927, 926). caminho(927, 928). 
caminho(928, 970). caminho(928, 886). caminho(928, 927). caminho(928, 929). 
caminho(929, 971). caminho(929, 887). caminho(929, 928). caminho(929, 930). 
caminho(930, 972). caminho(930, 888). caminho(930, 929). caminho(930, 931). 
caminho(931, 973). caminho(931, 889). caminho(931, 930). caminho(931, 932). 
caminho(932, 974). caminho(932, 890). caminho(932, 931). caminho(932, 933). 
caminho(933, 975). caminho(933, 891). caminho(933, 932). caminho(933, 934). 
caminho(934, 976). caminho(934, 892). caminho(934, 933). caminho(934, 935). 
caminho(935, 977). caminho(935, 893). caminho(935, 934). caminho(935, 936). 
caminho(936, 978). caminho(936, 894). caminho(936, 935). caminho(936, 937). 
caminho(937, 979). caminho(937, 895). caminho(937, 936). caminho(937, 938). 
caminho(938, 980). caminho(938, 896). caminho(938, 937). caminho(938, 939). 
caminho(939, 981). caminho(939, 897). caminho(939, 938). caminho(939, 940). 
caminho(940, 982). caminho(940, 898). caminho(940, 939). caminho(940, 941). 
caminho(941, 983). caminho(941, 899). caminho(941, 940). caminho(941, 942). 
caminho(942, 984). caminho(942, 900). caminho(942, 941). caminho(942, 943). 
caminho(943, 985). caminho(943, 901). caminho(943, 942). caminho(943, 944). 
caminho(944, 986). caminho(944, 902). caminho(944, 943). caminho(944, 945). 
caminho(945, 987). caminho(945, 903). caminho(945, 944). caminho(945, 946). 
caminho(946, 988). caminho(946, 904). caminho(946, 945). caminho(946, 947). 
caminho(947, 989). caminho(947, 905). caminho(947, 946). caminho(947, 948). 
caminho(948, 990). caminho(948, 906). caminho(948, 947). caminho(948, 949). 
caminho(949, 991). caminho(949, 907). caminho(949, 948). caminho(949, 950). 
caminho(950, 992). caminho(950, 908). caminho(950, 949). caminho(950, 951). 
caminho(951, 993). caminho(951, 909). caminho(951, 950). caminho(951, 952). 
caminho(952, 994). caminho(952, 910). caminho(952, 951). caminho(952, 953). 
caminho(953, 995). caminho(953, 911). caminho(953, 952). caminho(953, 954). 
caminho(954, 996). caminho(954, 912). caminho(954, 953). caminho(954, 955). 
caminho(955, 997). caminho(955, 913). caminho(955, 954). caminho(955, 956). 
caminho(956, 998). caminho(956, 914). caminho(956, 955). caminho(956, 957). 
caminho(957, 999). caminho(957, 915). caminho(957, 956). caminho(957, 958). 
caminho(958, 1000). caminho(958, 916). caminho(958, 957). caminho(958, 959). 
caminho(959, 1001). caminho(959, 917). caminho(959, 958). caminho(959, 960). 
caminho(960, 1002). caminho(960, 918). caminho(960, 959). caminho(960, 961). 
caminho(961, 1003). caminho(961, 919). caminho(961, 960). caminho(961, 962). 
caminho(962, 1004). caminho(962, 920). caminho(962, 961). caminho(962, 963). 
caminho(963, 1005). caminho(963, 921). caminho(963, 962). caminho(963, 964). 
caminho(964, 1006). caminho(964, 922). caminho(964, 963). caminho(964, 965). 
caminho(965, 1007). caminho(965, 923). caminho(965, 964). caminho(965, 966). 
caminho(966, 1008). caminho(966, 924). caminho(966, 965). 
caminho(967, 1009). caminho(967, 925). caminho(967, 968). 
caminho(968, 1010). caminho(968, 926). caminho(968, 967). caminho(968, 969). 
caminho(969, 1011). caminho(969, 927). caminho(969, 968). caminho(969, 970). 
caminho(970, 1012). caminho(970, 928). caminho(970, 969). caminho(970, 971). 
caminho(971, 1013). caminho(971, 929). caminho(971, 970). caminho(971, 972). 
caminho(972, 1014). caminho(972, 930). caminho(972, 971). caminho(972, 973). 
caminho(973, 1015). caminho(973, 931). caminho(973, 972). caminho(973, 974). 
caminho(974, 1016). caminho(974, 932). caminho(974, 973). caminho(974, 975). 
caminho(975, 1017). caminho(975, 933). caminho(975, 974). caminho(975, 976). 
caminho(976, 1018). caminho(976, 934). caminho(976, 975). caminho(976, 977). 
caminho(977, 1019). caminho(977, 935). caminho(977, 976). caminho(977, 978). 
caminho(978, 1020). caminho(978, 936). caminho(978, 977). caminho(978, 979). 
caminho(979, 1021). caminho(979, 937). caminho(979, 978). caminho(979, 980). 
caminho(980, 1022). caminho(980, 938). caminho(980, 979). caminho(980, 981). 
caminho(981, 1023). caminho(981, 939). caminho(981, 980). caminho(981, 982). 
caminho(982, 1024). caminho(982, 940). caminho(982, 981). caminho(982, 983). 
caminho(983, 1025). caminho(983, 941). caminho(983, 982). caminho(983, 984). 
caminho(984, 1026). caminho(984, 942). caminho(984, 983). caminho(984, 985). 
caminho(985, 1027). caminho(985, 943). caminho(985, 984). caminho(985, 986). 
caminho(986, 1028). caminho(986, 944). caminho(986, 985). caminho(986, 987). 
caminho(987, 1029). caminho(987, 945). caminho(987, 986). caminho(987, 988). 
caminho(988, 1030). caminho(988, 946). caminho(988, 987). caminho(988, 989). 
caminho(989, 1031). caminho(989, 947). caminho(989, 988). caminho(989, 990). 
caminho(990, 1032). caminho(990, 948). caminho(990, 989). caminho(990, 991). 
caminho(991, 1033). caminho(991, 949). caminho(991, 990). caminho(991, 992). 
caminho(992, 1034). caminho(992, 950). caminho(992, 991). caminho(992, 993). 
caminho(993, 1035). caminho(993, 951). caminho(993, 992). caminho(993, 994). 
caminho(994, 1036). caminho(994, 952). caminho(994, 993). caminho(994, 995). 
caminho(995, 1037). caminho(995, 953). caminho(995, 994). caminho(995, 996). 
caminho(996, 1038). caminho(996, 954). caminho(996, 995). caminho(996, 997). 
caminho(997, 1039). caminho(997, 955). caminho(997, 996). caminho(997, 998). 
caminho(998, 1040). caminho(998, 956). caminho(998, 997). caminho(998, 999). 
caminho(999, 1041). caminho(999, 957). caminho(999, 998). caminho(999, 1000). 
caminho(1000, 1042). caminho(1000, 958). caminho(1000, 999). caminho(1000, 1001). 
caminho(1001, 1043). caminho(1001, 959). caminho(1001, 1000). caminho(1001, 1002). 
caminho(1002, 1044). caminho(1002, 960). caminho(1002, 1001). caminho(1002, 1003). 
caminho(1003, 1045). caminho(1003, 961). caminho(1003, 1002). caminho(1003, 1004). 
caminho(1004, 1046). caminho(1004, 962). caminho(1004, 1003). caminho(1004, 1005). 
caminho(1005, 1047). caminho(1005, 963). caminho(1005, 1004). caminho(1005, 1006). 
caminho(1006, 1048). caminho(1006, 964). caminho(1006, 1005). caminho(1006, 1007). 
caminho(1007, 1049). caminho(1007, 965). caminho(1007, 1006). caminho(1007, 1008). 
caminho(1008, 1050). caminho(1008, 966). caminho(1008, 1007). 
caminho(1009, 1051). caminho(1009, 967). caminho(1009, 1010). 
caminho(1010, 1052). caminho(1010, 968). caminho(1010, 1009). caminho(1010, 1011). 
caminho(1011, 1053). caminho(1011, 969). caminho(1011, 1010). caminho(1011, 1012). 
caminho(1012, 1054). caminho(1012, 970). caminho(1012, 1011). caminho(1012, 1013). 
caminho(1013, 1055). caminho(1013, 971). caminho(1013, 1012). caminho(1013, 1014). 
caminho(1014, 1056). caminho(1014, 972). caminho(1014, 1013). caminho(1014, 1015). 
caminho(1015, 1057). caminho(1015, 973). caminho(1015, 1014). caminho(1015, 1016). 
caminho(1016, 1058). caminho(1016, 974). caminho(1016, 1015). caminho(1016, 1017). 
caminho(1017, 1059). caminho(1017, 975). caminho(1017, 1016). caminho(1017, 1018). 
caminho(1018, 1060). caminho(1018, 976). caminho(1018, 1017). caminho(1018, 1019). 
caminho(1019, 1061). caminho(1019, 977). caminho(1019, 1018). caminho(1019, 1020). 
caminho(1020, 1062). caminho(1020, 978). caminho(1020, 1019). caminho(1020, 1021). 
caminho(1021, 1063). caminho(1021, 979). caminho(1021, 1020). caminho(1021, 1022). 
caminho(1022, 1064). caminho(1022, 980). caminho(1022, 1021). caminho(1022, 1023). 
caminho(1023, 1065). caminho(1023, 981). caminho(1023, 1022). caminho(1023, 1024). 
caminho(1024, 1066). caminho(1024, 982). caminho(1024, 1023). caminho(1024, 1025). 
caminho(1025, 1067). caminho(1025, 983). caminho(1025, 1024). caminho(1025, 1026). 
caminho(1026, 1068). caminho(1026, 984). caminho(1026, 1025). caminho(1026, 1027). 
caminho(1027, 1069). caminho(1027, 985). caminho(1027, 1026). caminho(1027, 1028). 
caminho(1028, 1070). caminho(1028, 986). caminho(1028, 1027). caminho(1028, 1029). 
caminho(1029, 1071). caminho(1029, 987). caminho(1029, 1028). caminho(1029, 1030). 
caminho(1030, 1072). caminho(1030, 988). caminho(1030, 1029). caminho(1030, 1031). 
caminho(1031, 1073). caminho(1031, 989). caminho(1031, 1030). caminho(1031, 1032). 
caminho(1032, 1074). caminho(1032, 990). caminho(1032, 1031). caminho(1032, 1033). 
caminho(1033, 1075). caminho(1033, 991). caminho(1033, 1032). caminho(1033, 1034). 
caminho(1034, 1076). caminho(1034, 992). caminho(1034, 1033). caminho(1034, 1035). 
caminho(1035, 1077). caminho(1035, 993). caminho(1035, 1034). caminho(1035, 1036). 
caminho(1036, 1078). caminho(1036, 994). caminho(1036, 1035). caminho(1036, 1037). 
caminho(1037, 1079). caminho(1037, 995). caminho(1037, 1036). caminho(1037, 1038). 
caminho(1038, 1080). caminho(1038, 996). caminho(1038, 1037). caminho(1038, 1039). 
caminho(1039, 1081). caminho(1039, 997). caminho(1039, 1038). caminho(1039, 1040). 
caminho(1040, 1082). caminho(1040, 998). caminho(1040, 1039). caminho(1040, 1041). 
caminho(1041, 1083). caminho(1041, 999). caminho(1041, 1040). caminho(1041, 1042). 
caminho(1042, 1084). caminho(1042, 1000). caminho(1042, 1041). caminho(1042, 1043). 
caminho(1043, 1085). caminho(1043, 1001). caminho(1043, 1042). caminho(1043, 1044). 
caminho(1044, 1086). caminho(1044, 1002). caminho(1044, 1043). caminho(1044, 1045). 
caminho(1045, 1087). caminho(1045, 1003). caminho(1045, 1044). caminho(1045, 1046). 
caminho(1046, 1088). caminho(1046, 1004). caminho(1046, 1045). caminho(1046, 1047). 
caminho(1047, 1089). caminho(1047, 1005). caminho(1047, 1046). caminho(1047, 1048). 
caminho(1048, 1090). caminho(1048, 1006). caminho(1048, 1047). caminho(1048, 1049). 
caminho(1049, 1091). caminho(1049, 1007). caminho(1049, 1048). caminho(1049, 1050). 
caminho(1050, 1092). caminho(1050, 1008). caminho(1050, 1049). 
caminho(1051, 1093). caminho(1051, 1009). caminho(1051, 1052). 
caminho(1052, 1094). caminho(1052, 1010). caminho(1052, 1051). caminho(1052, 1053). 
caminho(1053, 1095). caminho(1053, 1011). caminho(1053, 1052). caminho(1053, 1054). 
caminho(1054, 1096). caminho(1054, 1012). caminho(1054, 1053). caminho(1054, 1055). 
caminho(1055, 1097). caminho(1055, 1013). caminho(1055, 1054). caminho(1055, 1056). 
caminho(1056, 1098). caminho(1056, 1014). caminho(1056, 1055). caminho(1056, 1057). 
caminho(1057, 1099). caminho(1057, 1015). caminho(1057, 1056). caminho(1057, 1058). 
caminho(1058, 1100). caminho(1058, 1016). caminho(1058, 1057). caminho(1058, 1059). 
caminho(1059, 1101). caminho(1059, 1017). caminho(1059, 1058). caminho(1059, 1060). 
caminho(1060, 1102). caminho(1060, 1018). caminho(1060, 1059). caminho(1060, 1061). 
caminho(1061, 1103). caminho(1061, 1019). caminho(1061, 1060). caminho(1061, 1062). 
caminho(1062, 1104). caminho(1062, 1020). caminho(1062, 1061). caminho(1062, 1063). 
caminho(1063, 1105). caminho(1063, 1021). caminho(1063, 1062). caminho(1063, 1064). 
caminho(1064, 1106). caminho(1064, 1022). caminho(1064, 1063). caminho(1064, 1065). 
caminho(1065, 1107). caminho(1065, 1023). caminho(1065, 1064). caminho(1065, 1066). 
caminho(1066, 1108). caminho(1066, 1024). caminho(1066, 1065). caminho(1066, 1067). 
caminho(1067, 1109). caminho(1067, 1025). caminho(1067, 1066). caminho(1067, 1068). 
caminho(1068, 1110). caminho(1068, 1026). caminho(1068, 1067). caminho(1068, 1069). 
caminho(1069, 1111). caminho(1069, 1027). caminho(1069, 1068). caminho(1069, 1070). 
caminho(1070, 1112). caminho(1070, 1028). caminho(1070, 1069). caminho(1070, 1071). 
caminho(1071, 1113). caminho(1071, 1029). caminho(1071, 1070). caminho(1071, 1072). 
caminho(1072, 1114). caminho(1072, 1030). caminho(1072, 1071). caminho(1072, 1073). 
caminho(1073, 1115). caminho(1073, 1031). caminho(1073, 1072). caminho(1073, 1074). 
caminho(1074, 1116). caminho(1074, 1032). caminho(1074, 1073). caminho(1074, 1075). 
caminho(1075, 1117). caminho(1075, 1033). caminho(1075, 1074). caminho(1075, 1076). 
caminho(1076, 1118). caminho(1076, 1034). caminho(1076, 1075). caminho(1076, 1077). 
caminho(1077, 1119). caminho(1077, 1035). caminho(1077, 1076). caminho(1077, 1078). 
caminho(1078, 1120). caminho(1078, 1036). caminho(1078, 1077). caminho(1078, 1079). 
caminho(1079, 1121). caminho(1079, 1037). caminho(1079, 1078). caminho(1079, 1080). 
caminho(1080, 1122). caminho(1080, 1038). caminho(1080, 1079). caminho(1080, 1081). 
caminho(1081, 1123). caminho(1081, 1039). caminho(1081, 1080). caminho(1081, 1082). 
caminho(1082, 1124). caminho(1082, 1040). caminho(1082, 1081). caminho(1082, 1083). 
caminho(1083, 1125). caminho(1083, 1041). caminho(1083, 1082). caminho(1083, 1084). 
caminho(1084, 1126). caminho(1084, 1042). caminho(1084, 1083). caminho(1084, 1085). 
caminho(1085, 1127). caminho(1085, 1043). caminho(1085, 1084). caminho(1085, 1086). 
caminho(1086, 1128). caminho(1086, 1044). caminho(1086, 1085). caminho(1086, 1087). 
caminho(1087, 1129). caminho(1087, 1045). caminho(1087, 1086). caminho(1087, 1088). 
caminho(1088, 1130). caminho(1088, 1046). caminho(1088, 1087). caminho(1088, 1089). 
caminho(1089, 1131). caminho(1089, 1047). caminho(1089, 1088). caminho(1089, 1090). 
caminho(1090, 1132). caminho(1090, 1048). caminho(1090, 1089). caminho(1090, 1091). 
caminho(1091, 1133). caminho(1091, 1049). caminho(1091, 1090). caminho(1091, 1092). 
caminho(1092, 1134). caminho(1092, 1050). caminho(1092, 1091). 
caminho(1093, 1135). caminho(1093, 1051). caminho(1093, 1094). 
caminho(1094, 1136). caminho(1094, 1052). caminho(1094, 1093). caminho(1094, 1095). 
caminho(1095, 1137). caminho(1095, 1053). caminho(1095, 1094). caminho(1095, 1096). 
caminho(1096, 1138). caminho(1096, 1054). caminho(1096, 1095). caminho(1096, 1097). 
caminho(1097, 1139). caminho(1097, 1055). caminho(1097, 1096). caminho(1097, 1098). 
caminho(1098, 1140). caminho(1098, 1056). caminho(1098, 1097). caminho(1098, 1099). 
caminho(1099, 1141). caminho(1099, 1057). caminho(1099, 1098). caminho(1099, 1100). 
caminho(1100, 1142). caminho(1100, 1058). caminho(1100, 1099). caminho(1100, 1101). 
caminho(1101, 1143). caminho(1101, 1059). caminho(1101, 1100). caminho(1101, 1102). 
caminho(1102, 1144). caminho(1102, 1060). caminho(1102, 1101). caminho(1102, 1103). 
caminho(1103, 1145). caminho(1103, 1061). caminho(1103, 1102). caminho(1103, 1104). 
caminho(1104, 1146). caminho(1104, 1062). caminho(1104, 1103). caminho(1104, 1105). 
caminho(1105, 1147). caminho(1105, 1063). caminho(1105, 1104). caminho(1105, 1106). 
caminho(1106, 1148). caminho(1106, 1064). caminho(1106, 1105). caminho(1106, 1107). 
caminho(1107, 1149). caminho(1107, 1065). caminho(1107, 1106). caminho(1107, 1108). 
caminho(1108, 1150). caminho(1108, 1066). caminho(1108, 1107). caminho(1108, 1109). 
caminho(1109, 1151). caminho(1109, 1067). caminho(1109, 1108). caminho(1109, 1110). 
caminho(1110, 1152). caminho(1110, 1068). caminho(1110, 1109). caminho(1110, 1111). 
caminho(1111, 1153). caminho(1111, 1069). caminho(1111, 1110). caminho(1111, 1112). 
caminho(1112, 1154). caminho(1112, 1070). caminho(1112, 1111). caminho(1112, 1113). 
caminho(1113, 1155). caminho(1113, 1071). caminho(1113, 1112). caminho(1113, 1114). 
caminho(1114, 1156). caminho(1114, 1072). caminho(1114, 1113). caminho(1114, 1115). 
caminho(1115, 1157). caminho(1115, 1073). caminho(1115, 1114). caminho(1115, 1116). 
caminho(1116, 1158). caminho(1116, 1074). caminho(1116, 1115). caminho(1116, 1117). 
caminho(1117, 1159). caminho(1117, 1075). caminho(1117, 1116). caminho(1117, 1118). 
caminho(1118, 1160). caminho(1118, 1076). caminho(1118, 1117). caminho(1118, 1119). 
caminho(1119, 1161). caminho(1119, 1077). caminho(1119, 1118). caminho(1119, 1120). 
caminho(1120, 1162). caminho(1120, 1078). caminho(1120, 1119). caminho(1120, 1121). 
caminho(1121, 1163). caminho(1121, 1079). caminho(1121, 1120). caminho(1121, 1122). 
caminho(1122, 1164). caminho(1122, 1080). caminho(1122, 1121). caminho(1122, 1123). 
caminho(1123, 1165). caminho(1123, 1081). caminho(1123, 1122). caminho(1123, 1124). 
caminho(1124, 1166). caminho(1124, 1082). caminho(1124, 1123). caminho(1124, 1125). 
caminho(1125, 1167). caminho(1125, 1083). caminho(1125, 1124). caminho(1125, 1126). 
caminho(1126, 1168). caminho(1126, 1084). caminho(1126, 1125). caminho(1126, 1127). 
caminho(1127, 1169). caminho(1127, 1085). caminho(1127, 1126). caminho(1127, 1128). 
caminho(1128, 1170). caminho(1128, 1086). caminho(1128, 1127). caminho(1128, 1129). 
caminho(1129, 1171). caminho(1129, 1087). caminho(1129, 1128). caminho(1129, 1130). 
caminho(1130, 1172). caminho(1130, 1088). caminho(1130, 1129). caminho(1130, 1131). 
caminho(1131, 1173). caminho(1131, 1089). caminho(1131, 1130). caminho(1131, 1132). 
caminho(1132, 1174). caminho(1132, 1090). caminho(1132, 1131). caminho(1132, 1133). 
caminho(1133, 1175). caminho(1133, 1091). caminho(1133, 1132). caminho(1133, 1134). 
caminho(1134, 1176). caminho(1134, 1092). caminho(1134, 1133). 
caminho(1135, 1177). caminho(1135, 1093). caminho(1135, 1136). 
caminho(1136, 1178). caminho(1136, 1094). caminho(1136, 1135). caminho(1136, 1137). 
caminho(1137, 1179). caminho(1137, 1095). caminho(1137, 1136). caminho(1137, 1138). 
caminho(1138, 1180). caminho(1138, 1096). caminho(1138, 1137). caminho(1138, 1139). 
caminho(1139, 1181). caminho(1139, 1097). caminho(1139, 1138). caminho(1139, 1140). 
caminho(1140, 1182). caminho(1140, 1098). caminho(1140, 1139). caminho(1140, 1141). 
caminho(1141, 1183). caminho(1141, 1099). caminho(1141, 1140). caminho(1141, 1142). 
caminho(1142, 1184). caminho(1142, 1100). caminho(1142, 1141). caminho(1142, 1143). 
caminho(1143, 1185). caminho(1143, 1101). caminho(1143, 1142). caminho(1143, 1144). 
caminho(1144, 1186). caminho(1144, 1102). caminho(1144, 1143). caminho(1144, 1145). 
caminho(1145, 1187). caminho(1145, 1103). caminho(1145, 1144). caminho(1145, 1146). 
caminho(1146, 1188). caminho(1146, 1104). caminho(1146, 1145). caminho(1146, 1147). 
caminho(1147, 1189). caminho(1147, 1105). caminho(1147, 1146). caminho(1147, 1148). 
caminho(1148, 1190). caminho(1148, 1106). caminho(1148, 1147). caminho(1148, 1149). 
caminho(1149, 1191). caminho(1149, 1107). caminho(1149, 1148). caminho(1149, 1150). 
caminho(1150, 1192). caminho(1150, 1108). caminho(1150, 1149). caminho(1150, 1151). 
caminho(1151, 1193). caminho(1151, 1109). caminho(1151, 1150). caminho(1151, 1152). 
caminho(1152, 1194). caminho(1152, 1110). caminho(1152, 1151). caminho(1152, 1153). 
caminho(1153, 1195). caminho(1153, 1111). caminho(1153, 1152). caminho(1153, 1154). 
caminho(1154, 1196). caminho(1154, 1112). caminho(1154, 1153). caminho(1154, 1155). 
caminho(1155, 1197). caminho(1155, 1113). caminho(1155, 1154). caminho(1155, 1156). 
caminho(1156, 1198). caminho(1156, 1114). caminho(1156, 1155). caminho(1156, 1157). 
caminho(1157, 1199). caminho(1157, 1115). caminho(1157, 1156). caminho(1157, 1158). 
caminho(1158, 1200). caminho(1158, 1116). caminho(1158, 1157). caminho(1158, 1159). 
caminho(1159, 1201). caminho(1159, 1117). caminho(1159, 1158). caminho(1159, 1160). 
caminho(1160, 1202). caminho(1160, 1118). caminho(1160, 1159). caminho(1160, 1161). 
caminho(1161, 1203). caminho(1161, 1119). caminho(1161, 1160). caminho(1161, 1162). 
caminho(1162, 1204). caminho(1162, 1120). caminho(1162, 1161). caminho(1162, 1163). 
caminho(1163, 1205). caminho(1163, 1121). caminho(1163, 1162). caminho(1163, 1164). 
caminho(1164, 1206). caminho(1164, 1122). caminho(1164, 1163). caminho(1164, 1165). 
caminho(1165, 1207). caminho(1165, 1123). caminho(1165, 1164). caminho(1165, 1166). 
caminho(1166, 1208). caminho(1166, 1124). caminho(1166, 1165). caminho(1166, 1167). 
caminho(1167, 1209). caminho(1167, 1125). caminho(1167, 1166). caminho(1167, 1168). 
caminho(1168, 1210). caminho(1168, 1126). caminho(1168, 1167). caminho(1168, 1169). 
caminho(1169, 1211). caminho(1169, 1127). caminho(1169, 1168). caminho(1169, 1170). 
caminho(1170, 1212). caminho(1170, 1128). caminho(1170, 1169). caminho(1170, 1171). 
caminho(1171, 1213). caminho(1171, 1129). caminho(1171, 1170). caminho(1171, 1172). 
caminho(1172, 1214). caminho(1172, 1130). caminho(1172, 1171). caminho(1172, 1173). 
caminho(1173, 1215). caminho(1173, 1131). caminho(1173, 1172). caminho(1173, 1174). 
caminho(1174, 1216). caminho(1174, 1132). caminho(1174, 1173). caminho(1174, 1175). 
caminho(1175, 1217). caminho(1175, 1133). caminho(1175, 1174). caminho(1175, 1176). 
caminho(1176, 1218). caminho(1176, 1134). caminho(1176, 1175). 
caminho(1177, 1219). caminho(1177, 1135). caminho(1177, 1178). 
caminho(1178, 1220). caminho(1178, 1136). caminho(1178, 1177). caminho(1178, 1179). 
caminho(1179, 1221). caminho(1179, 1137). caminho(1179, 1178). caminho(1179, 1180). 
caminho(1180, 1222). caminho(1180, 1138). caminho(1180, 1179). caminho(1180, 1181). 
caminho(1181, 1223). caminho(1181, 1139). caminho(1181, 1180). caminho(1181, 1182). 
caminho(1182, 1224). caminho(1182, 1140). caminho(1182, 1181). caminho(1182, 1183). 
caminho(1183, 1225). caminho(1183, 1141). caminho(1183, 1182). caminho(1183, 1184). 
caminho(1184, 1226). caminho(1184, 1142). caminho(1184, 1183). caminho(1184, 1185). 
caminho(1185, 1227). caminho(1185, 1143). caminho(1185, 1184). caminho(1185, 1186). 
caminho(1186, 1228). caminho(1186, 1144). caminho(1186, 1185). caminho(1186, 1187). 
caminho(1187, 1229). caminho(1187, 1145). caminho(1187, 1186). caminho(1187, 1188). 
caminho(1188, 1230). caminho(1188, 1146). caminho(1188, 1187). caminho(1188, 1189). 
caminho(1189, 1231). caminho(1189, 1147). caminho(1189, 1188). caminho(1189, 1190). 
caminho(1190, 1232). caminho(1190, 1148). caminho(1190, 1189). caminho(1190, 1191). 
caminho(1191, 1233). caminho(1191, 1149). caminho(1191, 1190). caminho(1191, 1192). 
caminho(1192, 1234). caminho(1192, 1150). caminho(1192, 1191). caminho(1192, 1193). 
caminho(1193, 1235). caminho(1193, 1151). caminho(1193, 1192). caminho(1193, 1194). 
caminho(1194, 1236). caminho(1194, 1152). caminho(1194, 1193). caminho(1194, 1195). 
caminho(1195, 1237). caminho(1195, 1153). caminho(1195, 1194). caminho(1195, 1196). 
caminho(1196, 1238). caminho(1196, 1154). caminho(1196, 1195). caminho(1196, 1197). 
caminho(1197, 1239). caminho(1197, 1155). caminho(1197, 1196). caminho(1197, 1198). 
caminho(1198, 1240). caminho(1198, 1156). caminho(1198, 1197). caminho(1198, 1199). 
caminho(1199, 1241). caminho(1199, 1157). caminho(1199, 1198). caminho(1199, 1200). 
caminho(1200, 1242). caminho(1200, 1158). caminho(1200, 1199). caminho(1200, 1201). 
caminho(1201, 1243). caminho(1201, 1159). caminho(1201, 1200). caminho(1201, 1202). 
caminho(1202, 1244). caminho(1202, 1160). caminho(1202, 1201). caminho(1202, 1203). 
caminho(1203, 1245). caminho(1203, 1161). caminho(1203, 1202). caminho(1203, 1204). 
caminho(1204, 1246). caminho(1204, 1162). caminho(1204, 1203). caminho(1204, 1205). 
caminho(1205, 1247). caminho(1205, 1163). caminho(1205, 1204). caminho(1205, 1206). 
caminho(1206, 1248). caminho(1206, 1164). caminho(1206, 1205). caminho(1206, 1207). 
caminho(1207, 1249). caminho(1207, 1165). caminho(1207, 1206). caminho(1207, 1208). 
caminho(1208, 1250). caminho(1208, 1166). caminho(1208, 1207). caminho(1208, 1209). 
caminho(1209, 1251). caminho(1209, 1167). caminho(1209, 1208). caminho(1209, 1210). 
caminho(1210, 1252). caminho(1210, 1168). caminho(1210, 1209). caminho(1210, 1211). 
caminho(1211, 1253). caminho(1211, 1169). caminho(1211, 1210). caminho(1211, 1212). 
caminho(1212, 1254). caminho(1212, 1170). caminho(1212, 1211). caminho(1212, 1213). 
caminho(1213, 1255). caminho(1213, 1171). caminho(1213, 1212). caminho(1213, 1214). 
caminho(1214, 1256). caminho(1214, 1172). caminho(1214, 1213). caminho(1214, 1215). 
caminho(1215, 1257). caminho(1215, 1173). caminho(1215, 1214). caminho(1215, 1216). 
caminho(1216, 1258). caminho(1216, 1174). caminho(1216, 1215). caminho(1216, 1217). 
caminho(1217, 1259). caminho(1217, 1175). caminho(1217, 1216). caminho(1217, 1218). 
caminho(1218, 1260). caminho(1218, 1176). caminho(1218, 1217). 
caminho(1219, 1261). caminho(1219, 1177). caminho(1219, 1220). 
caminho(1220, 1262). caminho(1220, 1178). caminho(1220, 1219). caminho(1220, 1221). 
caminho(1221, 1263). caminho(1221, 1179). caminho(1221, 1220). caminho(1221, 1222). 
caminho(1222, 1264). caminho(1222, 1180). caminho(1222, 1221). caminho(1222, 1223). 
caminho(1223, 1265). caminho(1223, 1181). caminho(1223, 1222). caminho(1223, 1224). 
caminho(1224, 1266). caminho(1224, 1182). caminho(1224, 1223). caminho(1224, 1225). 
caminho(1225, 1267). caminho(1225, 1183). caminho(1225, 1224). caminho(1225, 1226). 
caminho(1226, 1268). caminho(1226, 1184). caminho(1226, 1225). caminho(1226, 1227). 
caminho(1227, 1269). caminho(1227, 1185). caminho(1227, 1226). caminho(1227, 1228). 
caminho(1228, 1270). caminho(1228, 1186). caminho(1228, 1227). caminho(1228, 1229). 
caminho(1229, 1271). caminho(1229, 1187). caminho(1229, 1228). caminho(1229, 1230). 
caminho(1230, 1272). caminho(1230, 1188). caminho(1230, 1229). caminho(1230, 1231). 
caminho(1231, 1273). caminho(1231, 1189). caminho(1231, 1230). caminho(1231, 1232). 
caminho(1232, 1274). caminho(1232, 1190). caminho(1232, 1231). caminho(1232, 1233). 
caminho(1233, 1275). caminho(1233, 1191). caminho(1233, 1232). caminho(1233, 1234). 
caminho(1234, 1276). caminho(1234, 1192). caminho(1234, 1233). caminho(1234, 1235). 
caminho(1235, 1277). caminho(1235, 1193). caminho(1235, 1234). caminho(1235, 1236). 
caminho(1236, 1278). caminho(1236, 1194). caminho(1236, 1235). caminho(1236, 1237). 
caminho(1237, 1279). caminho(1237, 1195). caminho(1237, 1236). caminho(1237, 1238). 
caminho(1238, 1280). caminho(1238, 1196). caminho(1238, 1237). caminho(1238, 1239). 
caminho(1239, 1281). caminho(1239, 1197). caminho(1239, 1238). caminho(1239, 1240). 
caminho(1240, 1282). caminho(1240, 1198). caminho(1240, 1239). caminho(1240, 1241). 
caminho(1241, 1283). caminho(1241, 1199). caminho(1241, 1240). caminho(1241, 1242). 
caminho(1242, 1284). caminho(1242, 1200). caminho(1242, 1241). caminho(1242, 1243). 
caminho(1243, 1285). caminho(1243, 1201). caminho(1243, 1242). caminho(1243, 1244). 
caminho(1244, 1286). caminho(1244, 1202). caminho(1244, 1243). caminho(1244, 1245). 
caminho(1245, 1287). caminho(1245, 1203). caminho(1245, 1244). caminho(1245, 1246). 
caminho(1246, 1288). caminho(1246, 1204). caminho(1246, 1245). caminho(1246, 1247). 
caminho(1247, 1289). caminho(1247, 1205). caminho(1247, 1246). caminho(1247, 1248). 
caminho(1248, 1290). caminho(1248, 1206). caminho(1248, 1247). caminho(1248, 1249). 
caminho(1249, 1291). caminho(1249, 1207). caminho(1249, 1248). caminho(1249, 1250). 
caminho(1250, 1292). caminho(1250, 1208). caminho(1250, 1249). caminho(1250, 1251). 
caminho(1251, 1293). caminho(1251, 1209). caminho(1251, 1250). caminho(1251, 1252). 
caminho(1252, 1294). caminho(1252, 1210). caminho(1252, 1251). caminho(1252, 1253). 
caminho(1253, 1295). caminho(1253, 1211). caminho(1253, 1252). caminho(1253, 1254). 
caminho(1254, 1296). caminho(1254, 1212). caminho(1254, 1253). caminho(1254, 1255). 
caminho(1255, 1297). caminho(1255, 1213). caminho(1255, 1254). caminho(1255, 1256). 
caminho(1256, 1298). caminho(1256, 1214). caminho(1256, 1255). caminho(1256, 1257). 
caminho(1257, 1299). caminho(1257, 1215). caminho(1257, 1256). caminho(1257, 1258). 
caminho(1258, 1300). caminho(1258, 1216). caminho(1258, 1257). caminho(1258, 1259). 
caminho(1259, 1301). caminho(1259, 1217). caminho(1259, 1258). caminho(1259, 1260). 
caminho(1260, 1302). caminho(1260, 1218). caminho(1260, 1259). 
caminho(1261, 1303). caminho(1261, 1219). caminho(1261, 1262). 
caminho(1262, 1304). caminho(1262, 1220). caminho(1262, 1261). caminho(1262, 1263). 
caminho(1263, 1305). caminho(1263, 1221). caminho(1263, 1262). caminho(1263, 1264). 
caminho(1264, 1306). caminho(1264, 1222). caminho(1264, 1263). caminho(1264, 1265). 
caminho(1265, 1307). caminho(1265, 1223). caminho(1265, 1264). caminho(1265, 1266). 
caminho(1266, 1308). caminho(1266, 1224). caminho(1266, 1265). caminho(1266, 1267). 
caminho(1267, 1309). caminho(1267, 1225). caminho(1267, 1266). caminho(1267, 1268). 
caminho(1268, 1310). caminho(1268, 1226). caminho(1268, 1267). caminho(1268, 1269). 
caminho(1269, 1311). caminho(1269, 1227). caminho(1269, 1268). caminho(1269, 1270). 
caminho(1270, 1312). caminho(1270, 1228). caminho(1270, 1269). caminho(1270, 1271). 
caminho(1271, 1313). caminho(1271, 1229). caminho(1271, 1270). caminho(1271, 1272). 
caminho(1272, 1314). caminho(1272, 1230). caminho(1272, 1271). caminho(1272, 1273). 
caminho(1273, 1315). caminho(1273, 1231). caminho(1273, 1272). caminho(1273, 1274). 
caminho(1274, 1316). caminho(1274, 1232). caminho(1274, 1273). caminho(1274, 1275). 
caminho(1275, 1317). caminho(1275, 1233). caminho(1275, 1274). caminho(1275, 1276). 
caminho(1276, 1318). caminho(1276, 1234). caminho(1276, 1275). caminho(1276, 1277). 
caminho(1277, 1319). caminho(1277, 1235). caminho(1277, 1276). caminho(1277, 1278). 
caminho(1278, 1320). caminho(1278, 1236). caminho(1278, 1277). caminho(1278, 1279). 
caminho(1279, 1321). caminho(1279, 1237). caminho(1279, 1278). caminho(1279, 1280). 
caminho(1280, 1322). caminho(1280, 1238). caminho(1280, 1279). caminho(1280, 1281). 
caminho(1281, 1323). caminho(1281, 1239). caminho(1281, 1280). caminho(1281, 1282). 
caminho(1282, 1324). caminho(1282, 1240). caminho(1282, 1281). caminho(1282, 1283). 
caminho(1283, 1325). caminho(1283, 1241). caminho(1283, 1282). caminho(1283, 1284). 
caminho(1284, 1326). caminho(1284, 1242). caminho(1284, 1283). caminho(1284, 1285). 
caminho(1285, 1327). caminho(1285, 1243). caminho(1285, 1284). caminho(1285, 1286). 
caminho(1286, 1328). caminho(1286, 1244). caminho(1286, 1285). caminho(1286, 1287). 
caminho(1287, 1329). caminho(1287, 1245). caminho(1287, 1286). caminho(1287, 1288). 
caminho(1288, 1330). caminho(1288, 1246). caminho(1288, 1287). caminho(1288, 1289). 
caminho(1289, 1331). caminho(1289, 1247). caminho(1289, 1288). caminho(1289, 1290). 
caminho(1290, 1332). caminho(1290, 1248). caminho(1290, 1289). caminho(1290, 1291). 
caminho(1291, 1333). caminho(1291, 1249). caminho(1291, 1290). caminho(1291, 1292). 
caminho(1292, 1334). caminho(1292, 1250). caminho(1292, 1291). caminho(1292, 1293). 
caminho(1293, 1335). caminho(1293, 1251). caminho(1293, 1292). caminho(1293, 1294). 
caminho(1294, 1336). caminho(1294, 1252). caminho(1294, 1293). caminho(1294, 1295). 
caminho(1295, 1337). caminho(1295, 1253). caminho(1295, 1294). caminho(1295, 1296). 
caminho(1296, 1338). caminho(1296, 1254). caminho(1296, 1295). caminho(1296, 1297). 
caminho(1297, 1339). caminho(1297, 1255). caminho(1297, 1296). caminho(1297, 1298). 
caminho(1298, 1340). caminho(1298, 1256). caminho(1298, 1297). caminho(1298, 1299). 
caminho(1299, 1341). caminho(1299, 1257). caminho(1299, 1298). caminho(1299, 1300). 
caminho(1300, 1342). caminho(1300, 1258). caminho(1300, 1299). caminho(1300, 1301). 
caminho(1301, 1343). caminho(1301, 1259). caminho(1301, 1300). caminho(1301, 1302). 
caminho(1302, 1344). caminho(1302, 1260). caminho(1302, 1301). 
caminho(1303, 1345). caminho(1303, 1261). caminho(1303, 1304). 
caminho(1304, 1346). caminho(1304, 1262). caminho(1304, 1303). caminho(1304, 1305). 
caminho(1305, 1347). caminho(1305, 1263). caminho(1305, 1304). caminho(1305, 1306). 
caminho(1306, 1348). caminho(1306, 1264). caminho(1306, 1305). caminho(1306, 1307). 
caminho(1307, 1349). caminho(1307, 1265). caminho(1307, 1306). caminho(1307, 1308). 
caminho(1308, 1350). caminho(1308, 1266). caminho(1308, 1307). caminho(1308, 1309). 
caminho(1309, 1351). caminho(1309, 1267). caminho(1309, 1308). caminho(1309, 1310). 
caminho(1310, 1352). caminho(1310, 1268). caminho(1310, 1309). caminho(1310, 1311). 
caminho(1311, 1353). caminho(1311, 1269). caminho(1311, 1310). caminho(1311, 1312). 
caminho(1312, 1354). caminho(1312, 1270). caminho(1312, 1311). caminho(1312, 1313). 
caminho(1313, 1355). caminho(1313, 1271). caminho(1313, 1312). caminho(1313, 1314). 
caminho(1314, 1356). caminho(1314, 1272). caminho(1314, 1313). caminho(1314, 1315). 
caminho(1315, 1357). caminho(1315, 1273). caminho(1315, 1314). caminho(1315, 1316). 
caminho(1316, 1358). caminho(1316, 1274). caminho(1316, 1315). caminho(1316, 1317). 
caminho(1317, 1359). caminho(1317, 1275). caminho(1317, 1316). caminho(1317, 1318). 
caminho(1318, 1360). caminho(1318, 1276). caminho(1318, 1317). caminho(1318, 1319). 
caminho(1319, 1361). caminho(1319, 1277). caminho(1319, 1318). caminho(1319, 1320). 
caminho(1320, 1362). caminho(1320, 1278). caminho(1320, 1319). caminho(1320, 1321). 
caminho(1321, 1363). caminho(1321, 1279). caminho(1321, 1320). caminho(1321, 1322). 
caminho(1322, 1364). caminho(1322, 1280). caminho(1322, 1321). caminho(1322, 1323). 
caminho(1323, 1365). caminho(1323, 1281). caminho(1323, 1322). caminho(1323, 1324). 
caminho(1324, 1366). caminho(1324, 1282). caminho(1324, 1323). caminho(1324, 1325). 
caminho(1325, 1367). caminho(1325, 1283). caminho(1325, 1324). caminho(1325, 1326). 
caminho(1326, 1368). caminho(1326, 1284). caminho(1326, 1325). caminho(1326, 1327). 
caminho(1327, 1369). caminho(1327, 1285). caminho(1327, 1326). caminho(1327, 1328). 
caminho(1328, 1370). caminho(1328, 1286). caminho(1328, 1327). caminho(1328, 1329). 
caminho(1329, 1371). caminho(1329, 1287). caminho(1329, 1328). caminho(1329, 1330). 
caminho(1330, 1372). caminho(1330, 1288). caminho(1330, 1329). caminho(1330, 1331). 
caminho(1331, 1373). caminho(1331, 1289). caminho(1331, 1330). caminho(1331, 1332). 
caminho(1332, 1374). caminho(1332, 1290). caminho(1332, 1331). caminho(1332, 1333). 
caminho(1333, 1375). caminho(1333, 1291). caminho(1333, 1332). caminho(1333, 1334). 
caminho(1334, 1376). caminho(1334, 1292). caminho(1334, 1333). caminho(1334, 1335). 
caminho(1335, 1377). caminho(1335, 1293). caminho(1335, 1334). caminho(1335, 1336). 
caminho(1336, 1378). caminho(1336, 1294). caminho(1336, 1335). caminho(1336, 1337). 
caminho(1337, 1379). caminho(1337, 1295). caminho(1337, 1336). caminho(1337, 1338). 
caminho(1338, 1380). caminho(1338, 1296). caminho(1338, 1337). caminho(1338, 1339). 
caminho(1339, 1381). caminho(1339, 1297). caminho(1339, 1338). caminho(1339, 1340). 
caminho(1340, 1382). caminho(1340, 1298). caminho(1340, 1339). caminho(1340, 1341). 
caminho(1341, 1383). caminho(1341, 1299). caminho(1341, 1340). caminho(1341, 1342). 
caminho(1342, 1384). caminho(1342, 1300). caminho(1342, 1341). caminho(1342, 1343). 
caminho(1343, 1385). caminho(1343, 1301). caminho(1343, 1342). caminho(1343, 1344). 
caminho(1344, 1386). caminho(1344, 1302). caminho(1344, 1343). 
caminho(1345, 1387). caminho(1345, 1303). caminho(1345, 1346). 
caminho(1346, 1388). caminho(1346, 1304). caminho(1346, 1345). caminho(1346, 1347). 
caminho(1347, 1389). caminho(1347, 1305). caminho(1347, 1346). caminho(1347, 1348). 
caminho(1348, 1390). caminho(1348, 1306). caminho(1348, 1347). caminho(1348, 1349). 
caminho(1349, 1391). caminho(1349, 1307). caminho(1349, 1348). caminho(1349, 1350). 
caminho(1350, 1392). caminho(1350, 1308). caminho(1350, 1349). caminho(1350, 1351). 
caminho(1351, 1393). caminho(1351, 1309). caminho(1351, 1350). caminho(1351, 1352). 
caminho(1352, 1394). caminho(1352, 1310). caminho(1352, 1351). caminho(1352, 1353). 
caminho(1353, 1395). caminho(1353, 1311). caminho(1353, 1352). caminho(1353, 1354). 
caminho(1354, 1396). caminho(1354, 1312). caminho(1354, 1353). caminho(1354, 1355). 
caminho(1355, 1397). caminho(1355, 1313). caminho(1355, 1354). caminho(1355, 1356). 
caminho(1356, 1398). caminho(1356, 1314). caminho(1356, 1355). caminho(1356, 1357). 
caminho(1357, 1399). caminho(1357, 1315). caminho(1357, 1356). caminho(1357, 1358). 
caminho(1358, 1400). caminho(1358, 1316). caminho(1358, 1357). caminho(1358, 1359). 
caminho(1359, 1401). caminho(1359, 1317). caminho(1359, 1358). caminho(1359, 1360). 
caminho(1360, 1402). caminho(1360, 1318). caminho(1360, 1359). caminho(1360, 1361). 
caminho(1361, 1403). caminho(1361, 1319). caminho(1361, 1360). caminho(1361, 1362). 
caminho(1362, 1404). caminho(1362, 1320). caminho(1362, 1361). caminho(1362, 1363). 
caminho(1363, 1405). caminho(1363, 1321). caminho(1363, 1362). caminho(1363, 1364). 
caminho(1364, 1406). caminho(1364, 1322). caminho(1364, 1363). caminho(1364, 1365). 
caminho(1365, 1407). caminho(1365, 1323). caminho(1365, 1364). caminho(1365, 1366). 
caminho(1366, 1408). caminho(1366, 1324). caminho(1366, 1365). caminho(1366, 1367). 
caminho(1367, 1409). caminho(1367, 1325). caminho(1367, 1366). caminho(1367, 1368). 
caminho(1368, 1410). caminho(1368, 1326). caminho(1368, 1367). caminho(1368, 1369). 
caminho(1369, 1411). caminho(1369, 1327). caminho(1369, 1368). caminho(1369, 1370). 
caminho(1370, 1412). caminho(1370, 1328). caminho(1370, 1369). caminho(1370, 1371). 
caminho(1371, 1413). caminho(1371, 1329). caminho(1371, 1370). caminho(1371, 1372). 
caminho(1372, 1414). caminho(1372, 1330). caminho(1372, 1371). caminho(1372, 1373). 
caminho(1373, 1415). caminho(1373, 1331). caminho(1373, 1372). caminho(1373, 1374). 
caminho(1374, 1416). caminho(1374, 1332). caminho(1374, 1373). caminho(1374, 1375). 
caminho(1375, 1417). caminho(1375, 1333). caminho(1375, 1374). caminho(1375, 1376). 
caminho(1376, 1418). caminho(1376, 1334). caminho(1376, 1375). caminho(1376, 1377). 
caminho(1377, 1419). caminho(1377, 1335). caminho(1377, 1376). caminho(1377, 1378). 
caminho(1378, 1420). caminho(1378, 1336). caminho(1378, 1377). caminho(1378, 1379). 
caminho(1379, 1421). caminho(1379, 1337). caminho(1379, 1378). caminho(1379, 1380). 
caminho(1380, 1422). caminho(1380, 1338). caminho(1380, 1379). caminho(1380, 1381). 
caminho(1381, 1423). caminho(1381, 1339). caminho(1381, 1380). caminho(1381, 1382). 
caminho(1382, 1424). caminho(1382, 1340). caminho(1382, 1381). caminho(1382, 1383). 
caminho(1383, 1425). caminho(1383, 1341). caminho(1383, 1382). caminho(1383, 1384). 
caminho(1384, 1426). caminho(1384, 1342). caminho(1384, 1383). caminho(1384, 1385). 
caminho(1385, 1427). caminho(1385, 1343). caminho(1385, 1384). caminho(1385, 1386). 
caminho(1386, 1428). caminho(1386, 1344). caminho(1386, 1385). 
caminho(1387, 1429). caminho(1387, 1345). caminho(1387, 1388). 
caminho(1388, 1430). caminho(1388, 1346). caminho(1388, 1387). caminho(1388, 1389). 
caminho(1389, 1431). caminho(1389, 1347). caminho(1389, 1388). caminho(1389, 1390). 
caminho(1390, 1432). caminho(1390, 1348). caminho(1390, 1389). caminho(1390, 1391). 
caminho(1391, 1433). caminho(1391, 1349). caminho(1391, 1390). caminho(1391, 1392). 
caminho(1392, 1434). caminho(1392, 1350). caminho(1392, 1391). caminho(1392, 1393). 
caminho(1393, 1435). caminho(1393, 1351). caminho(1393, 1392). caminho(1393, 1394). 
caminho(1394, 1436). caminho(1394, 1352). caminho(1394, 1393). caminho(1394, 1395). 
caminho(1395, 1437). caminho(1395, 1353). caminho(1395, 1394). caminho(1395, 1396). 
caminho(1396, 1438). caminho(1396, 1354). caminho(1396, 1395). caminho(1396, 1397). 
caminho(1397, 1439). caminho(1397, 1355). caminho(1397, 1396). caminho(1397, 1398). 
caminho(1398, 1440). caminho(1398, 1356). caminho(1398, 1397). caminho(1398, 1399). 
caminho(1399, 1441). caminho(1399, 1357). caminho(1399, 1398). caminho(1399, 1400). 
caminho(1400, 1442). caminho(1400, 1358). caminho(1400, 1399). caminho(1400, 1401). 
caminho(1401, 1443). caminho(1401, 1359). caminho(1401, 1400). caminho(1401, 1402). 
caminho(1402, 1444). caminho(1402, 1360). caminho(1402, 1401). caminho(1402, 1403). 
caminho(1403, 1445). caminho(1403, 1361). caminho(1403, 1402). caminho(1403, 1404). 
caminho(1404, 1446). caminho(1404, 1362). caminho(1404, 1403). caminho(1404, 1405). 
caminho(1405, 1447). caminho(1405, 1363). caminho(1405, 1404). caminho(1405, 1406). 
caminho(1406, 1448). caminho(1406, 1364). caminho(1406, 1405). caminho(1406, 1407). 
caminho(1407, 1449). caminho(1407, 1365). caminho(1407, 1406). caminho(1407, 1408). 
caminho(1408, 1450). caminho(1408, 1366). caminho(1408, 1407). caminho(1408, 1409). 
caminho(1409, 1451). caminho(1409, 1367). caminho(1409, 1408). caminho(1409, 1410). 
caminho(1410, 1452). caminho(1410, 1368). caminho(1410, 1409). caminho(1410, 1411). 
caminho(1411, 1453). caminho(1411, 1369). caminho(1411, 1410). caminho(1411, 1412). 
caminho(1412, 1454). caminho(1412, 1370). caminho(1412, 1411). caminho(1412, 1413). 
caminho(1413, 1455). caminho(1413, 1371). caminho(1413, 1412). caminho(1413, 1414). 
caminho(1414, 1456). caminho(1414, 1372). caminho(1414, 1413). caminho(1414, 1415). 
caminho(1415, 1457). caminho(1415, 1373). caminho(1415, 1414). caminho(1415, 1416). 
caminho(1416, 1458). caminho(1416, 1374). caminho(1416, 1415). caminho(1416, 1417). 
caminho(1417, 1459). caminho(1417, 1375). caminho(1417, 1416). caminho(1417, 1418). 
caminho(1418, 1460). caminho(1418, 1376). caminho(1418, 1417). caminho(1418, 1419). 
caminho(1419, 1461). caminho(1419, 1377). caminho(1419, 1418). caminho(1419, 1420). 
caminho(1420, 1462). caminho(1420, 1378). caminho(1420, 1419). caminho(1420, 1421). 
caminho(1421, 1463). caminho(1421, 1379). caminho(1421, 1420). caminho(1421, 1422). 
caminho(1422, 1464). caminho(1422, 1380). caminho(1422, 1421). caminho(1422, 1423). 
caminho(1423, 1465). caminho(1423, 1381). caminho(1423, 1422). caminho(1423, 1424). 
caminho(1424, 1466). caminho(1424, 1382). caminho(1424, 1423). caminho(1424, 1425). 
caminho(1425, 1467). caminho(1425, 1383). caminho(1425, 1424). caminho(1425, 1426). 
caminho(1426, 1468). caminho(1426, 1384). caminho(1426, 1425). caminho(1426, 1427). 
caminho(1427, 1469). caminho(1427, 1385). caminho(1427, 1426). caminho(1427, 1428). 
caminho(1428, 1470). caminho(1428, 1386). caminho(1428, 1427). 
caminho(1429, 1471). caminho(1429, 1387). caminho(1429, 1430). 
caminho(1430, 1472). caminho(1430, 1388). caminho(1430, 1429). caminho(1430, 1431). 
caminho(1431, 1473). caminho(1431, 1389). caminho(1431, 1430). caminho(1431, 1432). 
caminho(1432, 1474). caminho(1432, 1390). caminho(1432, 1431). caminho(1432, 1433). 
caminho(1433, 1475). caminho(1433, 1391). caminho(1433, 1432). caminho(1433, 1434). 
caminho(1434, 1476). caminho(1434, 1392). caminho(1434, 1433). caminho(1434, 1435). 
caminho(1435, 1477). caminho(1435, 1393). caminho(1435, 1434). caminho(1435, 1436). 
caminho(1436, 1478). caminho(1436, 1394). caminho(1436, 1435). caminho(1436, 1437). 
caminho(1437, 1479). caminho(1437, 1395). caminho(1437, 1436). caminho(1437, 1438). 
caminho(1438, 1480). caminho(1438, 1396). caminho(1438, 1437). caminho(1438, 1439). 
caminho(1439, 1481). caminho(1439, 1397). caminho(1439, 1438). caminho(1439, 1440). 
caminho(1440, 1482). caminho(1440, 1398). caminho(1440, 1439). caminho(1440, 1441). 
caminho(1441, 1483). caminho(1441, 1399). caminho(1441, 1440). caminho(1441, 1442). 
caminho(1442, 1484). caminho(1442, 1400). caminho(1442, 1441). caminho(1442, 1443). 
caminho(1443, 1485). caminho(1443, 1401). caminho(1443, 1442). caminho(1443, 1444). 
caminho(1444, 1486). caminho(1444, 1402). caminho(1444, 1443). caminho(1444, 1445). 
caminho(1445, 1487). caminho(1445, 1403). caminho(1445, 1444). caminho(1445, 1446). 
caminho(1446, 1488). caminho(1446, 1404). caminho(1446, 1445). caminho(1446, 1447). 
caminho(1447, 1489). caminho(1447, 1405). caminho(1447, 1446). caminho(1447, 1448). 
caminho(1448, 1490). caminho(1448, 1406). caminho(1448, 1447). caminho(1448, 1449). 
caminho(1449, 1491). caminho(1449, 1407). caminho(1449, 1448). caminho(1449, 1450). 
caminho(1450, 1492). caminho(1450, 1408). caminho(1450, 1449). caminho(1450, 1451). 
caminho(1451, 1493). caminho(1451, 1409). caminho(1451, 1450). caminho(1451, 1452). 
caminho(1452, 1494). caminho(1452, 1410). caminho(1452, 1451). caminho(1452, 1453). 
caminho(1453, 1495). caminho(1453, 1411). caminho(1453, 1452). caminho(1453, 1454). 
caminho(1454, 1496). caminho(1454, 1412). caminho(1454, 1453). caminho(1454, 1455). 
caminho(1455, 1497). caminho(1455, 1413). caminho(1455, 1454). caminho(1455, 1456). 
caminho(1456, 1498). caminho(1456, 1414). caminho(1456, 1455). caminho(1456, 1457). 
caminho(1457, 1499). caminho(1457, 1415). caminho(1457, 1456). caminho(1457, 1458). 
caminho(1458, 1500). caminho(1458, 1416). caminho(1458, 1457). caminho(1458, 1459). 
caminho(1459, 1501). caminho(1459, 1417). caminho(1459, 1458). caminho(1459, 1460). 
caminho(1460, 1502). caminho(1460, 1418). caminho(1460, 1459). caminho(1460, 1461). 
caminho(1461, 1503). caminho(1461, 1419). caminho(1461, 1460). caminho(1461, 1462). 
caminho(1462, 1504). caminho(1462, 1420). caminho(1462, 1461). caminho(1462, 1463). 
caminho(1463, 1505). caminho(1463, 1421). caminho(1463, 1462). caminho(1463, 1464). 
caminho(1464, 1506). caminho(1464, 1422). caminho(1464, 1463). caminho(1464, 1465). 
caminho(1465, 1507). caminho(1465, 1423). caminho(1465, 1464). caminho(1465, 1466). 
caminho(1466, 1508). caminho(1466, 1424). caminho(1466, 1465). caminho(1466, 1467). 
caminho(1467, 1509). caminho(1467, 1425). caminho(1467, 1466). caminho(1467, 1468). 
caminho(1468, 1510). caminho(1468, 1426). caminho(1468, 1467). caminho(1468, 1469). 
caminho(1469, 1511). caminho(1469, 1427). caminho(1469, 1468). caminho(1469, 1470). 
caminho(1470, 1512). caminho(1470, 1428). caminho(1470, 1469). 
caminho(1471, 1513). caminho(1471, 1429). caminho(1471, 1472). 
caminho(1472, 1514). caminho(1472, 1430). caminho(1472, 1471). caminho(1472, 1473). 
caminho(1473, 1515). caminho(1473, 1431). caminho(1473, 1472). caminho(1473, 1474). 
caminho(1474, 1516). caminho(1474, 1432). caminho(1474, 1473). caminho(1474, 1475). 
caminho(1475, 1517). caminho(1475, 1433). caminho(1475, 1474). caminho(1475, 1476). 
caminho(1476, 1518). caminho(1476, 1434). caminho(1476, 1475). caminho(1476, 1477). 
caminho(1477, 1519). caminho(1477, 1435). caminho(1477, 1476). caminho(1477, 1478). 
caminho(1478, 1520). caminho(1478, 1436). caminho(1478, 1477). caminho(1478, 1479). 
caminho(1479, 1521). caminho(1479, 1437). caminho(1479, 1478). caminho(1479, 1480). 
caminho(1480, 1522). caminho(1480, 1438). caminho(1480, 1479). caminho(1480, 1481). 
caminho(1481, 1523). caminho(1481, 1439). caminho(1481, 1480). caminho(1481, 1482). 
caminho(1482, 1524). caminho(1482, 1440). caminho(1482, 1481). caminho(1482, 1483). 
caminho(1483, 1525). caminho(1483, 1441). caminho(1483, 1482). caminho(1483, 1484). 
caminho(1484, 1526). caminho(1484, 1442). caminho(1484, 1483). caminho(1484, 1485). 
caminho(1485, 1527). caminho(1485, 1443). caminho(1485, 1484). caminho(1485, 1486). 
caminho(1486, 1528). caminho(1486, 1444). caminho(1486, 1485). caminho(1486, 1487). 
caminho(1487, 1529). caminho(1487, 1445). caminho(1487, 1486). caminho(1487, 1488). 
caminho(1488, 1530). caminho(1488, 1446). caminho(1488, 1487). caminho(1488, 1489). 
caminho(1489, 1531). caminho(1489, 1447). caminho(1489, 1488). caminho(1489, 1490). 
caminho(1490, 1532). caminho(1490, 1448). caminho(1490, 1489). caminho(1490, 1491). 
caminho(1491, 1533). caminho(1491, 1449). caminho(1491, 1490). caminho(1491, 1492). 
caminho(1492, 1534). caminho(1492, 1450). caminho(1492, 1491). caminho(1492, 1493). 
caminho(1493, 1535). caminho(1493, 1451). caminho(1493, 1492). caminho(1493, 1494). 
caminho(1494, 1536). caminho(1494, 1452). caminho(1494, 1493). caminho(1494, 1495). 
caminho(1495, 1537). caminho(1495, 1453). caminho(1495, 1494). caminho(1495, 1496). 
caminho(1496, 1538). caminho(1496, 1454). caminho(1496, 1495). caminho(1496, 1497). 
caminho(1497, 1539). caminho(1497, 1455). caminho(1497, 1496). caminho(1497, 1498). 
caminho(1498, 1540). caminho(1498, 1456). caminho(1498, 1497). caminho(1498, 1499). 
caminho(1499, 1541). caminho(1499, 1457). caminho(1499, 1498). caminho(1499, 1500). 
caminho(1500, 1542). caminho(1500, 1458). caminho(1500, 1499). caminho(1500, 1501). 
caminho(1501, 1543). caminho(1501, 1459). caminho(1501, 1500). caminho(1501, 1502). 
caminho(1502, 1544). caminho(1502, 1460). caminho(1502, 1501). caminho(1502, 1503). 
caminho(1503, 1545). caminho(1503, 1461). caminho(1503, 1502). caminho(1503, 1504). 
caminho(1504, 1546). caminho(1504, 1462). caminho(1504, 1503). caminho(1504, 1505). 
caminho(1505, 1547). caminho(1505, 1463). caminho(1505, 1504). caminho(1505, 1506). 
caminho(1506, 1548). caminho(1506, 1464). caminho(1506, 1505). caminho(1506, 1507). 
caminho(1507, 1549). caminho(1507, 1465). caminho(1507, 1506). caminho(1507, 1508). 
caminho(1508, 1550). caminho(1508, 1466). caminho(1508, 1507). caminho(1508, 1509). 
caminho(1509, 1551). caminho(1509, 1467). caminho(1509, 1508). caminho(1509, 1510). 
caminho(1510, 1552). caminho(1510, 1468). caminho(1510, 1509). caminho(1510, 1511). 
caminho(1511, 1553). caminho(1511, 1469). caminho(1511, 1510). caminho(1511, 1512). 
caminho(1512, 1554). caminho(1512, 1470). caminho(1512, 1511). 
caminho(1513, 1555). caminho(1513, 1471). caminho(1513, 1514). 
caminho(1514, 1556). caminho(1514, 1472). caminho(1514, 1513). caminho(1514, 1515). 
caminho(1515, 1557). caminho(1515, 1473). caminho(1515, 1514). caminho(1515, 1516). 
caminho(1516, 1558). caminho(1516, 1474). caminho(1516, 1515). caminho(1516, 1517). 
caminho(1517, 1559). caminho(1517, 1475). caminho(1517, 1516). caminho(1517, 1518). 
caminho(1518, 1560). caminho(1518, 1476). caminho(1518, 1517). caminho(1518, 1519). 
caminho(1519, 1561). caminho(1519, 1477). caminho(1519, 1518). caminho(1519, 1520). 
caminho(1520, 1562). caminho(1520, 1478). caminho(1520, 1519). caminho(1520, 1521). 
caminho(1521, 1563). caminho(1521, 1479). caminho(1521, 1520). caminho(1521, 1522). 
caminho(1522, 1564). caminho(1522, 1480). caminho(1522, 1521). caminho(1522, 1523). 
caminho(1523, 1565). caminho(1523, 1481). caminho(1523, 1522). caminho(1523, 1524). 
caminho(1524, 1566). caminho(1524, 1482). caminho(1524, 1523). caminho(1524, 1525). 
caminho(1525, 1567). caminho(1525, 1483). caminho(1525, 1524). caminho(1525, 1526). 
caminho(1526, 1568). caminho(1526, 1484). caminho(1526, 1525). caminho(1526, 1527). 
caminho(1527, 1569). caminho(1527, 1485). caminho(1527, 1526). caminho(1527, 1528). 
caminho(1528, 1570). caminho(1528, 1486). caminho(1528, 1527). caminho(1528, 1529). 
caminho(1529, 1571). caminho(1529, 1487). caminho(1529, 1528). caminho(1529, 1530). 
caminho(1530, 1572). caminho(1530, 1488). caminho(1530, 1529). caminho(1530, 1531). 
caminho(1531, 1573). caminho(1531, 1489). caminho(1531, 1530). caminho(1531, 1532). 
caminho(1532, 1574). caminho(1532, 1490). caminho(1532, 1531). caminho(1532, 1533). 
caminho(1533, 1575). caminho(1533, 1491). caminho(1533, 1532). caminho(1533, 1534). 
caminho(1534, 1576). caminho(1534, 1492). caminho(1534, 1533). caminho(1534, 1535). 
caminho(1535, 1577). caminho(1535, 1493). caminho(1535, 1534). caminho(1535, 1536). 
caminho(1536, 1578). caminho(1536, 1494). caminho(1536, 1535). caminho(1536, 1537). 
caminho(1537, 1579). caminho(1537, 1495). caminho(1537, 1536). caminho(1537, 1538). 
caminho(1538, 1580). caminho(1538, 1496). caminho(1538, 1537). caminho(1538, 1539). 
caminho(1539, 1581). caminho(1539, 1497). caminho(1539, 1538). caminho(1539, 1540). 
caminho(1540, 1582). caminho(1540, 1498). caminho(1540, 1539). caminho(1540, 1541). 
caminho(1541, 1583). caminho(1541, 1499). caminho(1541, 1540). caminho(1541, 1542). 
caminho(1542, 1584). caminho(1542, 1500). caminho(1542, 1541). caminho(1542, 1543). 
caminho(1543, 1585). caminho(1543, 1501). caminho(1543, 1542). caminho(1543, 1544). 
caminho(1544, 1586). caminho(1544, 1502). caminho(1544, 1543). caminho(1544, 1545). 
caminho(1545, 1587). caminho(1545, 1503). caminho(1545, 1544). caminho(1545, 1546). 
caminho(1546, 1588). caminho(1546, 1504). caminho(1546, 1545). caminho(1546, 1547). 
caminho(1547, 1589). caminho(1547, 1505). caminho(1547, 1546). caminho(1547, 1548). 
caminho(1548, 1590). caminho(1548, 1506). caminho(1548, 1547). caminho(1548, 1549). 
caminho(1549, 1591). caminho(1549, 1507). caminho(1549, 1548). caminho(1549, 1550). 
caminho(1550, 1592). caminho(1550, 1508). caminho(1550, 1549). caminho(1550, 1551). 
caminho(1551, 1593). caminho(1551, 1509). caminho(1551, 1550). caminho(1551, 1552). 
caminho(1552, 1594). caminho(1552, 1510). caminho(1552, 1551). caminho(1552, 1553). 
caminho(1553, 1595). caminho(1553, 1511). caminho(1553, 1552). caminho(1553, 1554). 
caminho(1554, 1596). caminho(1554, 1512). caminho(1554, 1553). 
caminho(1555, 1597). caminho(1555, 1513). caminho(1555, 1556). 
caminho(1556, 1598). caminho(1556, 1514). caminho(1556, 1555). caminho(1556, 1557). 
caminho(1557, 1599). caminho(1557, 1515). caminho(1557, 1556). caminho(1557, 1558). 
caminho(1558, 1600). caminho(1558, 1516). caminho(1558, 1557). caminho(1558, 1559). 
caminho(1559, 1601). caminho(1559, 1517). caminho(1559, 1558). caminho(1559, 1560). 
caminho(1560, 1602). caminho(1560, 1518). caminho(1560, 1559). caminho(1560, 1561). 
caminho(1561, 1603). caminho(1561, 1519). caminho(1561, 1560). caminho(1561, 1562). 
caminho(1562, 1604). caminho(1562, 1520). caminho(1562, 1561). caminho(1562, 1563). 
caminho(1563, 1605). caminho(1563, 1521). caminho(1563, 1562). caminho(1563, 1564). 
caminho(1564, 1606). caminho(1564, 1522). caminho(1564, 1563). caminho(1564, 1565). 
caminho(1565, 1607). caminho(1565, 1523). caminho(1565, 1564). caminho(1565, 1566). 
caminho(1566, 1608). caminho(1566, 1524). caminho(1566, 1565). caminho(1566, 1567). 
caminho(1567, 1609). caminho(1567, 1525). caminho(1567, 1566). caminho(1567, 1568). 
caminho(1568, 1610). caminho(1568, 1526). caminho(1568, 1567). caminho(1568, 1569). 
caminho(1569, 1611). caminho(1569, 1527). caminho(1569, 1568). caminho(1569, 1570). 
caminho(1570, 1612). caminho(1570, 1528). caminho(1570, 1569). caminho(1570, 1571). 
caminho(1571, 1613). caminho(1571, 1529). caminho(1571, 1570). caminho(1571, 1572). 
caminho(1572, 1614). caminho(1572, 1530). caminho(1572, 1571). caminho(1572, 1573). 
caminho(1573, 1615). caminho(1573, 1531). caminho(1573, 1572). caminho(1573, 1574). 
caminho(1574, 1616). caminho(1574, 1532). caminho(1574, 1573). caminho(1574, 1575). 
caminho(1575, 1617). caminho(1575, 1533). caminho(1575, 1574). caminho(1575, 1576). 
caminho(1576, 1618). caminho(1576, 1534). caminho(1576, 1575). caminho(1576, 1577). 
caminho(1577, 1619). caminho(1577, 1535). caminho(1577, 1576). caminho(1577, 1578). 
caminho(1578, 1620). caminho(1578, 1536). caminho(1578, 1577). caminho(1578, 1579). 
caminho(1579, 1621). caminho(1579, 1537). caminho(1579, 1578). caminho(1579, 1580). 
caminho(1580, 1622). caminho(1580, 1538). caminho(1580, 1579). caminho(1580, 1581). 
caminho(1581, 1623). caminho(1581, 1539). caminho(1581, 1580). caminho(1581, 1582). 
caminho(1582, 1624). caminho(1582, 1540). caminho(1582, 1581). caminho(1582, 1583). 
caminho(1583, 1625). caminho(1583, 1541). caminho(1583, 1582). caminho(1583, 1584). 
caminho(1584, 1626). caminho(1584, 1542). caminho(1584, 1583). caminho(1584, 1585). 
caminho(1585, 1627). caminho(1585, 1543). caminho(1585, 1584). caminho(1585, 1586). 
caminho(1586, 1628). caminho(1586, 1544). caminho(1586, 1585). caminho(1586, 1587). 
caminho(1587, 1629). caminho(1587, 1545). caminho(1587, 1586). caminho(1587, 1588). 
caminho(1588, 1630). caminho(1588, 1546). caminho(1588, 1587). caminho(1588, 1589). 
caminho(1589, 1631). caminho(1589, 1547). caminho(1589, 1588). caminho(1589, 1590). 
caminho(1590, 1632). caminho(1590, 1548). caminho(1590, 1589). caminho(1590, 1591). 
caminho(1591, 1633). caminho(1591, 1549). caminho(1591, 1590). caminho(1591, 1592). 
caminho(1592, 1634). caminho(1592, 1550). caminho(1592, 1591). caminho(1592, 1593). 
caminho(1593, 1635). caminho(1593, 1551). caminho(1593, 1592). caminho(1593, 1594). 
caminho(1594, 1636). caminho(1594, 1552). caminho(1594, 1593). caminho(1594, 1595). 
caminho(1595, 1637). caminho(1595, 1553). caminho(1595, 1594). caminho(1595, 1596). 
caminho(1596, 1638). caminho(1596, 1554). caminho(1596, 1595). 
caminho(1597, 1639). caminho(1597, 1555). caminho(1597, 1598). 
caminho(1598, 1640). caminho(1598, 1556). caminho(1598, 1597). caminho(1598, 1599). 
caminho(1599, 1641). caminho(1599, 1557). caminho(1599, 1598). caminho(1599, 1600). 
caminho(1600, 1642). caminho(1600, 1558). caminho(1600, 1599). caminho(1600, 1601). 
caminho(1601, 1643). caminho(1601, 1559). caminho(1601, 1600). caminho(1601, 1602). 
caminho(1602, 1644). caminho(1602, 1560). caminho(1602, 1601). caminho(1602, 1603). 
caminho(1603, 1645). caminho(1603, 1561). caminho(1603, 1602). caminho(1603, 1604). 
caminho(1604, 1646). caminho(1604, 1562). caminho(1604, 1603). caminho(1604, 1605). 
caminho(1605, 1647). caminho(1605, 1563). caminho(1605, 1604). caminho(1605, 1606). 
caminho(1606, 1648). caminho(1606, 1564). caminho(1606, 1605). caminho(1606, 1607). 
caminho(1607, 1649). caminho(1607, 1565). caminho(1607, 1606). caminho(1607, 1608). 
caminho(1608, 1650). caminho(1608, 1566). caminho(1608, 1607). caminho(1608, 1609). 
caminho(1609, 1651). caminho(1609, 1567). caminho(1609, 1608). caminho(1609, 1610). 
caminho(1610, 1652). caminho(1610, 1568). caminho(1610, 1609). caminho(1610, 1611). 
caminho(1611, 1653). caminho(1611, 1569). caminho(1611, 1610). caminho(1611, 1612). 
caminho(1612, 1654). caminho(1612, 1570). caminho(1612, 1611). caminho(1612, 1613). 
caminho(1613, 1655). caminho(1613, 1571). caminho(1613, 1612). caminho(1613, 1614). 
caminho(1614, 1656). caminho(1614, 1572). caminho(1614, 1613). caminho(1614, 1615). 
caminho(1615, 1657). caminho(1615, 1573). caminho(1615, 1614). caminho(1615, 1616). 
caminho(1616, 1658). caminho(1616, 1574). caminho(1616, 1615). caminho(1616, 1617). 
caminho(1617, 1659). caminho(1617, 1575). caminho(1617, 1616). caminho(1617, 1618). 
caminho(1618, 1660). caminho(1618, 1576). caminho(1618, 1617). caminho(1618, 1619). 
caminho(1619, 1661). caminho(1619, 1577). caminho(1619, 1618). caminho(1619, 1620). 
caminho(1620, 1662). caminho(1620, 1578). caminho(1620, 1619). caminho(1620, 1621). 
caminho(1621, 1663). caminho(1621, 1579). caminho(1621, 1620). caminho(1621, 1622). 
caminho(1622, 1664). caminho(1622, 1580). caminho(1622, 1621). caminho(1622, 1623). 
caminho(1623, 1665). caminho(1623, 1581). caminho(1623, 1622). caminho(1623, 1624). 
caminho(1624, 1666). caminho(1624, 1582). caminho(1624, 1623). caminho(1624, 1625). 
caminho(1625, 1667). caminho(1625, 1583). caminho(1625, 1624). caminho(1625, 1626). 
caminho(1626, 1668). caminho(1626, 1584). caminho(1626, 1625). caminho(1626, 1627). 
caminho(1627, 1669). caminho(1627, 1585). caminho(1627, 1626). caminho(1627, 1628). 
caminho(1628, 1670). caminho(1628, 1586). caminho(1628, 1627). caminho(1628, 1629). 
caminho(1629, 1671). caminho(1629, 1587). caminho(1629, 1628). caminho(1629, 1630). 
caminho(1630, 1672). caminho(1630, 1588). caminho(1630, 1629). caminho(1630, 1631). 
caminho(1631, 1673). caminho(1631, 1589). caminho(1631, 1630). caminho(1631, 1632). 
caminho(1632, 1674). caminho(1632, 1590). caminho(1632, 1631). caminho(1632, 1633). 
caminho(1633, 1675). caminho(1633, 1591). caminho(1633, 1632). caminho(1633, 1634). 
caminho(1634, 1676). caminho(1634, 1592). caminho(1634, 1633). caminho(1634, 1635). 
caminho(1635, 1677). caminho(1635, 1593). caminho(1635, 1634). caminho(1635, 1636). 
caminho(1636, 1678). caminho(1636, 1594). caminho(1636, 1635). caminho(1636, 1637). 
caminho(1637, 1679). caminho(1637, 1595). caminho(1637, 1636). caminho(1637, 1638). 
caminho(1638, 1680). caminho(1638, 1596). caminho(1638, 1637). 
caminho(1639, 1681). caminho(1639, 1597). caminho(1639, 1640). 
caminho(1640, 1682). caminho(1640, 1598). caminho(1640, 1639). caminho(1640, 1641). 
caminho(1641, 1683). caminho(1641, 1599). caminho(1641, 1640). caminho(1641, 1642). 
caminho(1642, 1684). caminho(1642, 1600). caminho(1642, 1641). caminho(1642, 1643). 
caminho(1643, 1685). caminho(1643, 1601). caminho(1643, 1642). caminho(1643, 1644). 
caminho(1644, 1686). caminho(1644, 1602). caminho(1644, 1643). caminho(1644, 1645). 
caminho(1645, 1687). caminho(1645, 1603). caminho(1645, 1644). caminho(1645, 1646). 
caminho(1646, 1688). caminho(1646, 1604). caminho(1646, 1645). caminho(1646, 1647). 
caminho(1647, 1689). caminho(1647, 1605). caminho(1647, 1646). caminho(1647, 1648). 
caminho(1648, 1690). caminho(1648, 1606). caminho(1648, 1647). caminho(1648, 1649). 
caminho(1649, 1691). caminho(1649, 1607). caminho(1649, 1648). caminho(1649, 1650). 
caminho(1650, 1692). caminho(1650, 1608). caminho(1650, 1649). caminho(1650, 1651). 
caminho(1651, 1693). caminho(1651, 1609). caminho(1651, 1650). caminho(1651, 1652). 
caminho(1652, 1694). caminho(1652, 1610). caminho(1652, 1651). caminho(1652, 1653). 
caminho(1653, 1695). caminho(1653, 1611). caminho(1653, 1652). caminho(1653, 1654). 
caminho(1654, 1696). caminho(1654, 1612). caminho(1654, 1653). caminho(1654, 1655). 
caminho(1655, 1697). caminho(1655, 1613). caminho(1655, 1654). caminho(1655, 1656). 
caminho(1656, 1698). caminho(1656, 1614). caminho(1656, 1655). caminho(1656, 1657). 
caminho(1657, 1699). caminho(1657, 1615). caminho(1657, 1656). caminho(1657, 1658). 
caminho(1658, 1700). caminho(1658, 1616). caminho(1658, 1657). caminho(1658, 1659). 
caminho(1659, 1701). caminho(1659, 1617). caminho(1659, 1658). caminho(1659, 1660). 
caminho(1660, 1702). caminho(1660, 1618). caminho(1660, 1659). caminho(1660, 1661). 
caminho(1661, 1703). caminho(1661, 1619). caminho(1661, 1660). caminho(1661, 1662). 
caminho(1662, 1704). caminho(1662, 1620). caminho(1662, 1661). caminho(1662, 1663). 
caminho(1663, 1705). caminho(1663, 1621). caminho(1663, 1662). caminho(1663, 1664). 
caminho(1664, 1706). caminho(1664, 1622). caminho(1664, 1663). caminho(1664, 1665). 
caminho(1665, 1707). caminho(1665, 1623). caminho(1665, 1664). caminho(1665, 1666). 
caminho(1666, 1708). caminho(1666, 1624). caminho(1666, 1665). caminho(1666, 1667). 
caminho(1667, 1709). caminho(1667, 1625). caminho(1667, 1666). caminho(1667, 1668). 
caminho(1668, 1710). caminho(1668, 1626). caminho(1668, 1667). caminho(1668, 1669). 
caminho(1669, 1711). caminho(1669, 1627). caminho(1669, 1668). caminho(1669, 1670). 
caminho(1670, 1712). caminho(1670, 1628). caminho(1670, 1669). caminho(1670, 1671). 
caminho(1671, 1713). caminho(1671, 1629). caminho(1671, 1670). caminho(1671, 1672). 
caminho(1672, 1714). caminho(1672, 1630). caminho(1672, 1671). caminho(1672, 1673). 
caminho(1673, 1715). caminho(1673, 1631). caminho(1673, 1672). caminho(1673, 1674). 
caminho(1674, 1716). caminho(1674, 1632). caminho(1674, 1673). caminho(1674, 1675). 
caminho(1675, 1717). caminho(1675, 1633). caminho(1675, 1674). caminho(1675, 1676). 
caminho(1676, 1718). caminho(1676, 1634). caminho(1676, 1675). caminho(1676, 1677). 
caminho(1677, 1719). caminho(1677, 1635). caminho(1677, 1676). caminho(1677, 1678). 
caminho(1678, 1720). caminho(1678, 1636). caminho(1678, 1677). caminho(1678, 1679). 
caminho(1679, 1721). caminho(1679, 1637). caminho(1679, 1678). caminho(1679, 1680). 
caminho(1680, 1722). caminho(1680, 1638). caminho(1680, 1679). 
caminho(1681, 1723). caminho(1681, 1639). caminho(1681, 1682). 
caminho(1682, 1724). caminho(1682, 1640). caminho(1682, 1681). caminho(1682, 1683). 
caminho(1683, 1725). caminho(1683, 1641). caminho(1683, 1682). caminho(1683, 1684). 
caminho(1684, 1726). caminho(1684, 1642). caminho(1684, 1683). caminho(1684, 1685). 
caminho(1685, 1727). caminho(1685, 1643). caminho(1685, 1684). caminho(1685, 1686). 
caminho(1686, 1728). caminho(1686, 1644). caminho(1686, 1685). caminho(1686, 1687). 
caminho(1687, 1729). caminho(1687, 1645). caminho(1687, 1686). caminho(1687, 1688). 
caminho(1688, 1730). caminho(1688, 1646). caminho(1688, 1687). caminho(1688, 1689). 
caminho(1689, 1731). caminho(1689, 1647). caminho(1689, 1688). caminho(1689, 1690). 
caminho(1690, 1732). caminho(1690, 1648). caminho(1690, 1689). caminho(1690, 1691). 
caminho(1691, 1733). caminho(1691, 1649). caminho(1691, 1690). caminho(1691, 1692). 
caminho(1692, 1734). caminho(1692, 1650). caminho(1692, 1691). caminho(1692, 1693). 
caminho(1693, 1735). caminho(1693, 1651). caminho(1693, 1692). caminho(1693, 1694). 
caminho(1694, 1736). caminho(1694, 1652). caminho(1694, 1693). caminho(1694, 1695). 
caminho(1695, 1737). caminho(1695, 1653). caminho(1695, 1694). caminho(1695, 1696). 
caminho(1696, 1738). caminho(1696, 1654). caminho(1696, 1695). caminho(1696, 1697). 
caminho(1697, 1739). caminho(1697, 1655). caminho(1697, 1696). caminho(1697, 1698). 
caminho(1698, 1740). caminho(1698, 1656). caminho(1698, 1697). caminho(1698, 1699). 
caminho(1699, 1741). caminho(1699, 1657). caminho(1699, 1698). caminho(1699, 1700). 
caminho(1700, 1742). caminho(1700, 1658). caminho(1700, 1699). caminho(1700, 1701). 
caminho(1701, 1743). caminho(1701, 1659). caminho(1701, 1700). caminho(1701, 1702). 
caminho(1702, 1744). caminho(1702, 1660). caminho(1702, 1701). caminho(1702, 1703). 
caminho(1703, 1745). caminho(1703, 1661). caminho(1703, 1702). caminho(1703, 1704). 
caminho(1704, 1746). caminho(1704, 1662). caminho(1704, 1703). caminho(1704, 1705). 
caminho(1705, 1747). caminho(1705, 1663). caminho(1705, 1704). caminho(1705, 1706). 
caminho(1706, 1748). caminho(1706, 1664). caminho(1706, 1705). caminho(1706, 1707). 
caminho(1707, 1749). caminho(1707, 1665). caminho(1707, 1706). caminho(1707, 1708). 
caminho(1708, 1750). caminho(1708, 1666). caminho(1708, 1707). caminho(1708, 1709). 
caminho(1709, 1751). caminho(1709, 1667). caminho(1709, 1708). caminho(1709, 1710). 
caminho(1710, 1752). caminho(1710, 1668). caminho(1710, 1709). caminho(1710, 1711). 
caminho(1711, 1753). caminho(1711, 1669). caminho(1711, 1710). caminho(1711, 1712). 
caminho(1712, 1754). caminho(1712, 1670). caminho(1712, 1711). caminho(1712, 1713). 
caminho(1713, 1755). caminho(1713, 1671). caminho(1713, 1712). caminho(1713, 1714). 
caminho(1714, 1756). caminho(1714, 1672). caminho(1714, 1713). caminho(1714, 1715). 
caminho(1715, 1757). caminho(1715, 1673). caminho(1715, 1714). caminho(1715, 1716). 
caminho(1716, 1758). caminho(1716, 1674). caminho(1716, 1715). caminho(1716, 1717). 
caminho(1717, 1759). caminho(1717, 1675). caminho(1717, 1716). caminho(1717, 1718). 
caminho(1718, 1760). caminho(1718, 1676). caminho(1718, 1717). caminho(1718, 1719). 
caminho(1719, 1761). caminho(1719, 1677). caminho(1719, 1718). caminho(1719, 1720). 
caminho(1720, 1762). caminho(1720, 1678). caminho(1720, 1719). caminho(1720, 1721). 
caminho(1721, 1763). caminho(1721, 1679). caminho(1721, 1720). caminho(1721, 1722). 
caminho(1722, 1764). caminho(1722, 1680). caminho(1722, 1721). 
caminho(1723, 1681). caminho(1723, 1724). 
caminho(1724, 1682). caminho(1724, 1723). caminho(1724, 1725). 
caminho(1725, 1683). caminho(1725, 1724). caminho(1725, 1726). 
caminho(1726, 1684). caminho(1726, 1725). caminho(1726, 1727). 
caminho(1727, 1685). caminho(1727, 1726). caminho(1727, 1728). 
caminho(1728, 1686). caminho(1728, 1727). caminho(1728, 1729). 
caminho(1729, 1687). caminho(1729, 1728). caminho(1729, 1730). 
caminho(1730, 1688). caminho(1730, 1729). caminho(1730, 1731). 
caminho(1731, 1689). caminho(1731, 1730). caminho(1731, 1732). 
caminho(1732, 1690). caminho(1732, 1731). caminho(1732, 1733). 
caminho(1733, 1691). caminho(1733, 1732). caminho(1733, 1734). 
caminho(1734, 1692). caminho(1734, 1733). caminho(1734, 1735). 
caminho(1735, 1693). caminho(1735, 1734). caminho(1735, 1736). 
caminho(1736, 1694). caminho(1736, 1735). caminho(1736, 1737). 
caminho(1737, 1695). caminho(1737, 1736). caminho(1737, 1738). 
caminho(1738, 1696). caminho(1738, 1737). caminho(1738, 1739). 
caminho(1739, 1697). caminho(1739, 1738). caminho(1739, 1740). 
caminho(1740, 1698). caminho(1740, 1739). caminho(1740, 1741). 
caminho(1741, 1699). caminho(1741, 1740). caminho(1741, 1742). 
caminho(1742, 1700). caminho(1742, 1741). caminho(1742, 1743). 
caminho(1743, 1701). caminho(1743, 1742). caminho(1743, 1744). 
caminho(1744, 1702). caminho(1744, 1743). caminho(1744, 1745). 
caminho(1745, 1703). caminho(1745, 1744). caminho(1745, 1746). 
caminho(1746, 1704). caminho(1746, 1745). caminho(1746, 1747). 
caminho(1747, 1705). caminho(1747, 1746). caminho(1747, 1748). 
caminho(1748, 1706). caminho(1748, 1747). caminho(1748, 1749). 
caminho(1749, 1707). caminho(1749, 1748). caminho(1749, 1750). 
caminho(1750, 1708). caminho(1750, 1749). caminho(1750, 1751). 
caminho(1751, 1709). caminho(1751, 1750). caminho(1751, 1752). 
caminho(1752, 1710). caminho(1752, 1751). caminho(1752, 1753). 
caminho(1753, 1711). caminho(1753, 1752). caminho(1753, 1754). 
caminho(1754, 1712). caminho(1754, 1753). caminho(1754, 1755). 
caminho(1755, 1713). caminho(1755, 1754). caminho(1755, 1756). 
caminho(1756, 1714). caminho(1756, 1755). caminho(1756, 1757). 
caminho(1757, 1715). caminho(1757, 1756). caminho(1757, 1758). 
caminho(1758, 1716). caminho(1758, 1757). caminho(1758, 1759). 
caminho(1759, 1717). caminho(1759, 1758). caminho(1759, 1760). 
caminho(1760, 1718). caminho(1760, 1759). caminho(1760, 1761). 
caminho(1761, 1719). caminho(1761, 1760). caminho(1761, 1762). 
caminho(1762, 1720). caminho(1762, 1761). caminho(1762, 1763). 
caminho(1763, 1721). caminho(1763, 1762). caminho(1763, 1764). 
caminho(1764, 1722). caminho(1764, 1763).
/*
package com.pokemon.game.desktop.model;

import java.util.ArrayList;
import java.util.List;

/*
Autor: Fillipe Campos

Retorna uma matriz com as posições que o agente deve ir para chegar no destino.
A posição X e Y da matriz que tiver preenchida com valor 1 representa as posições
x e y no mapa que o agente deve andar
 */
/*
public class Roteamento {

    public int[][] roteamento(TileMap map, int pos_do_agenteX, int pos_do_agenteY, int pos_destinoX, int pos_destinoY) {
        //Retorna as coordenadas para alcançar o objetivo 
        int caminho[][] = new int[41][41];

        //Indica que um caminho já foi encontrado
        int caminho_encontrado = 0;

        //Irá guardar as posições possíveis para chegar no destino
        List<Bloco> open_list = new ArrayList<Bloco>();

        // Guarda as posições que o agente já caminhou
        List<Bloco> block_list = new ArrayList<Bloco>();

        // Cria objeto Bloco para guardar o valor G,H e F da posição adjacente
        Bloco posicao_adjacente;

        //Guarda a posição inicial do agente
        Bloco posicao_inicial = new Bloco();
        posicao_inicial.set_x(pos_do_agenteX);
        posicao_inicial.set_y(pos_do_agenteY);

        //Adiciona na lista de bloqueio
        block_list.add(posicao_inicial);

        //Inicializa em 0 a matriz caminho
        for (int i = 0; i < 41; i++) {
            for (int j = 0; j < 41; j++) {
                caminho[i][j] = 0;
            }

        }

        do {
            //Verifica se a coordenada X e Y do destino foi adicionado ao bloqueio, se sim então o caminho até o destino foi encontrado 
            if (block_list != null) {
                for (int i = block_list.size() - 1; i >= 0; i++) {
                    if ((block_list.get(i).get_x() == pos_destinoX) && (block_list.get(i).get_y() == pos_destinoY)) {
                        caminho_encontrado = 1;
                    }
                }

            }

            if (caminho_encontrado == 0) {
                // Se não há obstáculos na posição Leste, então guarda na lista de caminhos possíveis
                if (pode_mover(map.getTile(block_list.get(block_list.size() - 1).get_x() + 1, pos_do_agentY, Pode).equals("Sim"))) {
                    posicao_adjacente = new Bloco();

                    // Se é início do jogo então o valor padrão G da posição será 1
                    if (block_list.size() == 1) {
                        //Guarda valor G
                        posicao_adjacente.set_G(1);

                        //Calcula o valor H da posição adjacente
                        int distancia = (pos_destinoX - block_list.get(0).get_x() + 1) + 1;
                        int h = distancia + pos_destinoY;
                        posicao_adjacente.set_H(h);

                        //Guarda valor F
                        int f = posicao_adjacente.get_G() + posicao_adjacente.get_H();
                        posicao_adjacente.set_F(f);

                        open_list.add(posicao_adjacente);
                    } else {
                        //Calcula o valor G 
                        int g = 0;
                        for (int i = 0; i < block_list.size(); i++) {
                            g++;
                        }

                        posicao_adjacente.set_G(g);

                        //Calcula o valor H da posição adjacente
                        int distancia = (pos_destinoX - block_list.get(block_list.size() - 1).get_x() + 1) + 1;
                        int h = distancia + pos_destinoY;
                        posicao_adjacente.set_H(h);

                        //Guarda valor F
                        int f = posicao_adjacente.get_G() + posicao_adjacente.get_H();
                        posicao_adjacente.set_F(f);
                        open_list.add(posicao_adjacente);
                    }
                }

                //Se não há obstaculos na posição Oeste, então guarda na lista de caminhos possíveis
                if (pode_mover(map.getTile(block_list.get(block_list.length - 1).get_x() - 1, pos_do_agentY, Pode).equals("Sim"))) {

                    posicao_adjacente = new Bloco();

                    // Se é início do jogo então o valor padrão G da posição será 1
                    if (block_list.size() == 1) {
                        //Guarda valor G
                        posicao_adjacente.set_G(1);

                        //Calcula o valor H da posição adjacente
                        int distancia = (pos_destinoX - block_list.get(0).get_x() - 1) + 1;
                        int h = distancia + pos_destinoY;
                        posicao_adjacente.set_H(h);

                        //Guarda valor F
                        int f = posicao_adjacente.get_G() + posicao_adjacente.get_H();
                        posicao_adjacente.set_F(f);

                        open_list.add(posicao_adjacente);
                    } else {
                        //Calcula o valor G 
                        int g = 0;
                        for (int i = 0; i < block_list.size(); i++) {
                            g++;
                        }

                        posicao_adjacente.set_G(g);

                        //Calcula o valor H da posição adjacente
                        int distancia = (pos_destinoX - block_list.get(block_list.size() - 1).get_x() - 1) + 1;
                        int h = distancia + pos_destinoY;
                        posicao_adjacente.set_H(h);

                        //Guarda valor F
                        int f = posicao_adjacente.get_G() + posicao_adjacente.get_H();
                        posicao_adjacente.set_F(f);
                        open_list.add(posicao_adjacente);
                    }
                }

                //Se não há obstaculos na posição Norte, então guarda na lista de caminhos possíveis
                if (pode_mover(map.getTile(pos_do_agenteX, block_list.get(block_list.length - 1).get_y() + 1, Pode).equals("Sim"))) {

                    posicao_adjacente = new Bloco();

                    // Se é início do jogo então o valor padrão G da posição será 1
                    if (block_list.size() == 1) {
                        //Guarda valor G
                        posicao_adjacente.set_G(1);

                        //Calcula o valor H da posição adjacente
                        int distancia = (pos_destinoX - block_list.get(0).get_x()) + 1;
                        int h = distancia + pos_destinoY;
                        posicao_adjacente.set_H(h);

                        //Guarda valor F
                        int f = posicao_adjacente.get_G() + posicao_adjacente.get_H();
                        posicao_adjacente.set_F(f);

                        open_list.add(posicao_adjacente);
                    } else {
                        //Calcula o valor G 
                        int g = 0;
                        for (int i = 0; i < block_list.size(); i++) {
                            g++;
                        }

                        posicao_adjacente.set_G(g);

                        //Calcula o valor H da posição adjacente
                        int distancia = (pos_destinoX - block_list.get(block_list.size() - 1).get_x()) + 1;
                        int h = distancia + pos_destinoY;
                        posicao_adjacente.set_H(h);

                        //Guarda valor F
                        int f = posicao_adjacente.get_G() + posicao_adjacente.get_H();
                        posicao_adjacente.set_F(f);
                        open_list.add(posicao_adjacente);
                    }

                }

                //Se não há obstaculos na posição Sul, então guarda na lista de caminhos possíveis
                if (pode_mover(map.getTile(pos_do_agenteX, block_list.get(block_list.length - 1).get_y() - 1, Pode).equals("Sim"))) {
                    posicao_adjacente = new Bloco();

                    // Se é início do jogo então o valor padrão G da posição será 1
                    if (block_list.size() == 1) {
                        //Guarda valor G
                        posicao_adjacente.set_G(1);

                        //Calcula o valor H da posição adjacente
                        int distancia = (pos_destinoX - block_list.get(0).get_x()) + 1;
                        int h = distancia + pos_destinoY;
                        posicao_adjacente.set_H(h);

                        //Guarda valor F
                        int f = posicao_adjacente.get_G() + posicao_adjacente.get_H();
                        posicao_adjacente.set_F(f);

                        open_list.add(posicao_adjacente);
                    } else {
                        //Calcula o valor G 
                        int g = 0;
                        for (int i = 0; i < block_list.size(); i++) {
                            g++;
                        }

                        posicao_adjacente.set_G(g);

                        //Calcula o valor H da posição adjacente
                        int distancia = (pos_destinoX - block_list.get(block_list.size() - 1).get_x()) + 1;
                        int h = distancia + pos_destinoY;
                        posicao_adjacente.set_H(h);

                        //Guarda valor F
                        int f = posicao_adjacente.get_G() + posicao_adjacente.get_H();
                        posicao_adjacente.set_F(f);
                        open_list.add(posicao_adjacente);
                    }

                }

                int menor_F = 1000;
                int pos_bloco_menor_f = 0;

                //Armazena menor valor F das posições em open_list
                for (int i = open_list.size() - 1; i >= 0; i--) {
                    if (open_list.get(i).get_F() < menor_F) {
                        menor_F = open_list.get(i).get_F();
                        pos_bloco_menor_f = i;
                    }
                }

                //Adiciona na lista de bloqueio a posição com menor valor F
                block_list.add(open_list.get(pos_bloco_menor_f));

                //Remove o elemento que tem o menor valor F da lista de posições possíveis (open_list) 
                open_list.get(pos_bloco_menor_f).
            }

        } while (caminho_encontrado == 0); //Enquanto existir um caminho possível para chegar no destino

        //Associa a posicao x e y da matriz caminho como as coordenadas da rota até o objetivo
        for (int i = 0; i < block_list.length; i++) {
            caminho[block_list.get(i).get_x()][block_list.get(i).get_y()] = 1;
        }

        return caminho;
    }

    public class Bloco

    {
    private int g;
    private int h;
    private int f;
    private int x;
    private int y;

    public Bloco() {

    }

    public void set_G(int g) {
        this.g = g;
    }

    public void set_H(int h) {
        this.h = h;
    }

    public void set_F(int f) {
        this.f = f;
    }

    public void set_x(int x) {
        this.x = x;
    }

    public void set_y(int y) {
        this.y = y;
    }

    public int get_x() {
        return x;
    }

    public int get_y() {
        return y;
    }

    public int get_G() {
        return g;
    }

    public int get_F() {
        return f;
    }

    public int get_H() {
        return h;
    }

} 
*/
package com.pokemon.game.desktop.model;

public enum PONTOSACAO {

    MOVER(-1),
    VIRAR_ESQUERDA(-1),
    VIRAR_DIREITA(-1),
    USAR_POKEBOLA(-5),
    PEGAR_POKEBOLAS(-10),
    RECUPERAR_POKEMONS(-100),
    DERROTAR_TREINADOR(150),
    PERDER_TREINADOR(-1000);

    private int custo;

    private PONTOSACAO(int custo) {
        this.custo = custo;
    }

    public int getCusto() {
        return this.custo;
    }
    
}

package com.pokemon.game.desktop.model;

public enum TERRAIN {   
    GRASS_1("grama"),
    GRASS_2("grama"),
    MONTANHA("montanha"),
    VULCAO("vulcao"),
    AGUA("agua"),
    CAVERNA("caverna"),
    ;  
    
    private String nome;
    
    private TERRAIN(String nome) {
        this.nome = nome;
    }

    public String getNome() {
        return this.nome;
    }
}

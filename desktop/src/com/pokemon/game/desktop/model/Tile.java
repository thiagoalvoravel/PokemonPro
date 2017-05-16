package com.pokemon.game.desktop.model;

public class Tile {
  
    private TERRAIN terrain;
    private Actor actor;
    private Treinador  treinador;
    
    
    public Treinador getTreinador() {
        return treinador;
    }

    public void setTreinador(Treinador treinador) {
        this.treinador = treinador;
    }

    public Actor getActor() {
        return actor;
    }

    public void setActor(Actor actor) {
        this.actor = actor;
    }

    public Tile(TERRAIN terrain) {
        this.terrain = terrain;
    }
    
    public TERRAIN getTerrain() {
        return terrain;
    }
    
}

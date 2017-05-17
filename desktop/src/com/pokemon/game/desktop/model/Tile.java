package com.pokemon.game.desktop.model;

public class Tile {
  
    private TERRAIN terrain;
    private Actor actor;
    private Treinador  treinador;
    private CentroPokemon centro_pokemon;
    private LojaPokemon lojaPokemon;

    public LojaPokemon getLojaPokemon() {
        return lojaPokemon;
    }

    public void setLoja(LojaPokemon lojaPokemon) {
        this.lojaPokemon = lojaPokemon;
    }

    public CentroPokemon getCentro_pokemon() {
        return centro_pokemon;
    }

    public void setCentroPokemon(CentroPokemon centro_pokemon) {
        this.centro_pokemon = centro_pokemon;
    }
    
    
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

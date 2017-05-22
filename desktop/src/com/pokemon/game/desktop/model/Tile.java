package com.pokemon.game.desktop.model;

public class Tile {
  
    private TERRAIN terrain;
    private Actor actor;
    private Treinador  treinador;
    private CentroPokemon centro_pokemon;
    private LojaPokemon lojaPokemon;
    private Pokemon pokemon;
    private String tipo_objeto;
    
    public String getTipo_Objeto()
    {
        return tipo_objeto;
    }

    public Pokemon getPokemon() {
        return pokemon;
    }

    public void setPokemon(Pokemon pokemon) {
        this.pokemon = pokemon;
        tipo_objeto = "pokemon";
    }

    public LojaPokemon getLojaPokemon() {
        return lojaPokemon;
    }

    public void setLoja(LojaPokemon lojaPokemon) {
        this.lojaPokemon = lojaPokemon;
        tipo_objeto = "loja";
    }

    public CentroPokemon getCentro_pokemon() {
        return centro_pokemon;
    }

    public void setCentroPokemon(CentroPokemon centro_pokemon) {
        this.centro_pokemon = centro_pokemon;
        tipo_objeto = "centroP";
    }
       
    public Treinador getTreinador() {
        return treinador;
    }

    public void setTreinador(Treinador treinador) {
        this.treinador = treinador;
        tipo_objeto = "treinador";
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

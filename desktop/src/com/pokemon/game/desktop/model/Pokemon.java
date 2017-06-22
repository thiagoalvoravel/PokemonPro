package com.pokemon.game.desktop.model;

import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.TextureRegion;
import com.badlogic.gdx.math.Interpolation;
import com.pokemon.game.desktop.util.AnimationSet;

public class Pokemon {
   
   private TileMap map; 
   private int x;
   private int y;
   private DIRECTION facing;
   private Texture sprite;  
   private float worldX, worldY;
   
   private String nome;
   private String numero;
   private String[] tipo = new String[2];
   //private String tipo2;
   private boolean visibilidade=true;
   private String energia;

    public void setNome(String nome) {
        this.nome = nome;
    }

    public void setEnergia(String energia) {
        this.energia = energia;
    }

    public String getEnergia(){
        return this.energia;
    }
    
    public Pokemon(TileMap map, int x, int y, String info_pokemon) {
        this.map = map;
        this.x = x;
        this.y = y;
        this.worldX = x;
        this.worldY = y;
        
        String[] dados_pokemon = info_pokemon.split("-");
        this.nome = dados_pokemon[0].toUpperCase();
        this.tipo = dados_pokemon[1].split(";");
        this.numero = dados_pokemon[2];
        //tipo2 = dados_pokemon[1].split(";")[0];
        
        sprite = new Texture("Pokemons/"+getNome()+".png");
                  
        map.getTerrenos(x, y).setPokemon(this);
    }

    public Pokemon() {
    }

    public void setX(int x) {
        this.x = x;
    }

    public void setY(int y) {
        this.y = y;
    }
    
    public boolean isVisibilidade() {
        return visibilidade;
    }

    public void setVisibilidade(boolean visibilidade) {
        this.visibilidade = visibilidade;
    }
    
    public String getNome() {
        return nome;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }
    
    public String[] getTipo() {
        return tipo;
    }
    
    public Texture getSprite(){
        return sprite;
    }
     
    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }
    
    public float getWorldX() {
        return worldX;
    }

    public float getWorldY() {
        return worldY;
    }   
}

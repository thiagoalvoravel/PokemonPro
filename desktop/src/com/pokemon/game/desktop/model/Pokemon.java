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
   private int numero = 2;
   private String[] tipo = new String[2];
   private String tipo2;
   private boolean visibilidade=true;

  
    public Pokemon(TileMap map, int x, int y, String info_pokemon) {
        this.map = map;
        this.x = x;
        this.y = y;
        this.worldX = x;
        this.worldY = y;
        
        String[] dados_pokemon = info_pokemon.split("-");
        this.nome = dados_pokemon[0];
        //tipo = dados_pokemon[1].split(";");
        tipo2 = dados_pokemon[1].split(";")[0];
        
        sprite = new Texture("Pokemons/"+getNome()+".png");
                  
        map.getTerrenos(x, y).setPokemon(this);
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

    public int getNumero() {
        return numero;
    }

    public void setNumero(int numero) {
        this.numero = numero;
    }
    
    public String[] getTipo() {
        return tipo;
    }
    
    public Texture getSprite(){
        return sprite;
    }
     
    public String getTipo2(){
        return tipo2;
    }
    
    public void setTipo2(String tipo2){
        this.tipo2 = tipo2;
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

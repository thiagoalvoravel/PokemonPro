package com.pokemon.game.desktop.model;

import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.TextureRegion;
import com.badlogic.gdx.math.Interpolation;
import com.pokemon.game.desktop.util.AnimationSet;

public class CentroPokemon {
   
   private TileMap map; 
   private int x;
   private int y;
   private DIRECTION facing;
   private Texture sprite;
   private int direcao;
   
   private float worldX, worldY;
   

    public CentroPokemon(TileMap map, int x, int y) {
        this.map = map;
        this.x = x;
        this.y = y;
        this.worldX = x;
        this.worldY = y;
        
        sprite = new Texture("pokecenter.png");
                  
       map.getTerrenos(x, y).setCentroPokemon(this);
    }
    
    public int getDirecao()
    {
        return direcao;
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



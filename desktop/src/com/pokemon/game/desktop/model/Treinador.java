package com.pokemon.game.desktop.model;


import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.TextureRegion;
import com.badlogic.gdx.math.Interpolation;
import com.pokemon.game.desktop.util.AnimationSet;

public class Treinador {
   
   private TileMap map; 
   private int x;
   private int y;
   private DIRECTION facing;
   private Texture sprite;
   private int direcao;
   
   private float worldX, worldY;
   private boolean visibilidade=true;

   
    public Treinador(TileMap map, int x, int y, int direcao, int tipo_treinador) {
        this.map = map;
        this.x = x;
        this.y = y;
        this.worldX = x;
        this.worldY = y;
        this.direcao = direcao;
        
      switch(tipo_treinador)  
      {  
          case 1:  
             switch(direcao)
             {
               case 1:
                sprite = new Texture("brendan_stand_north.png");
               break;
               case 2:
                sprite = new Texture("brendan_stand_south.png");  
               break;
               case 3:
                sprite = new Texture("brendan_stand_east.png");  
               break;
               case 4:
                sprite = new Texture("brendan_stand_west.png");  
               break;    
             }
          break;
          
          case 2:  
            switch(direcao)
              {
                 case 1:
                  sprite = new Texture("punk_north.png");
                 break;
                 case 2:
                  sprite = new Texture("punk_south.png");  
                 break;
                 case 3:
                  sprite = new Texture("punk_west.png");  
                 break;
                 case 4:
                  sprite = new Texture("punk_south.png");  
                 break;    
              }
            break;
                 
           case 3:  
              switch(direcao)
              {
                 case 1:
                  sprite = new Texture("girl_north.png");
                 break;
                 case 2:
                  sprite = new Texture("girl_south.png");  
                 break;
                 case 3:
                  sprite = new Texture("girl_east.png");  
                 break;
                 case 4:
                  sprite = new Texture("girl_south.png");  
                 break;    
            }
           break;
            
           case 4:  
               switch(direcao)
               {
                 case 1:
                  sprite = new Texture("monge_north.png");
                 break;
                 case 2:
                  sprite = new Texture("monge_south.png");  
                 break;
                 case 3:
                  sprite = new Texture("monge_east.png");  
                 break;
                 case 4:
                  sprite = new Texture("monge_south.png");  
                 break;    
               }
            break;
             
           case 5:  
               switch(direcao)
               {
                  case 1:
                   sprite = new Texture("pokefa_north.png");
                  break;
                  case 2:
                   sprite = new Texture("pokefa_south.png");  
                  break;
                  case 3:
                   sprite = new Texture("pokefa_east.png");  
                  break;
                  case 4:
                   sprite = new Texture("pokefa_south.png");  
                  break;    
               }
           break;
            
           case 6:  
               switch(direcao)
               {
                  case 1:
                   sprite = new Texture("farmer_north.png");
                  break;
                  case 2:
                   sprite = new Texture("farmer_south.png");  
                  break;
                  case 3:
                   sprite = new Texture("farmer_east.png");  
                  break;
                  case 4:
                   sprite = new Texture("farmer_south.png");  
                  break;    
            }
           break; 
      } 
               
       map.getTerrenos(x, y).setTreinador(this);   
    }
    
    public boolean isVisibilidade() {
        return visibilidade;
    }

    public void setVisibilidade(boolean visibilidade) {
        this.visibilidade = visibilidade;
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


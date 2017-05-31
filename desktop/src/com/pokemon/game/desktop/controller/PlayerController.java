package com.pokemon.game.desktop.controller;

import com.badlogic.gdx.Input;
import com.badlogic.gdx.Input.Keys;
import com.badlogic.gdx.InputAdapter;
import com.pokemon.game.desktop.model.Actor;
import com.pokemon.game.desktop.model.DIRECTION;
import com.pokemon.game.desktop.model.Tile;
import com.pokemon.game.desktop.model.TileMap;

public class PlayerController extends InputAdapter {

    private Actor player;
    private boolean up, down, left, right;

    public PlayerController(Actor p) {
        this.player = p;
    }

    /*@Override
    public boolean keyDown(int keycode) {
        if (keycode == Keys.UP) {
            up = true;
        }
        if (keycode == Keys.DOWN) {
            down = true;
        }
        if (keycode == Keys.LEFT) {
            left = true;
        }
        if (keycode == Keys.RIGHT) {
            right = true;
        }

        return false;
    }*/

    /*@Override
    public boolean keyUp(int keycode) {
        if (keycode == Keys.UP) {
            up = false;
        }
        if (keycode == Keys.DOWN) {
            down = false;
        }
        if (keycode == Keys.LEFT) {
            left = false;
        }
        if (keycode == Keys.RIGHT) {
            right = false;
        }

        return false;
    } */

    public void update(float delta, String direcao) {
        
      if(direcao.equals("up"))  
      {
       // if (up) {
            if (this.player.getFacing() == DIRECTION.NORTH) {        
                player.move(DIRECTION.NORTH);
            }else{
                this.player.setState(Actor.ACTOR_STATE.STANDING);
                this.player.setFacing(DIRECTION.NORTH);
                this.up = false;
                //int posicaoX = player.getX();
                //int posicaoY = player.getY();
                //String objeto_mapa = player.getMap().getTile(posicaoX, posicaoY).getTipo_Objeto();
                
                //Calcualr custo da ação
            }
            return;
        }
       else if (direcao.equals("down")) {
            if (this.player.getFacing() == DIRECTION.SOUTH) {    
                
                player.move(DIRECTION.SOUTH);
            }else{
                this.player.setState(Actor.ACTOR_STATE.STANDING);
                this.player.setFacing(DIRECTION.SOUTH);
                this.down = false;
                //Calcualr custo da ação
            }
            return;
        }
       else if (direcao.equals("left")) {
            if (this.player.getFacing() == DIRECTION.WEST) {                 
                player.move(DIRECTION.WEST);
            }else{
                this.player.setState(Actor.ACTOR_STATE.STANDING);
                this.player.setFacing(DIRECTION.WEST);
                this.left = false;
                //Calcualr custo da ação
            }
            return;
        }
       else if (direcao.equals("right")) {
            if (this.player.getFacing() == DIRECTION.EAST) {                                  
                player.move(DIRECTION.EAST);
            }else{
                this.player.setState(Actor.ACTOR_STATE.STANDING);
                this.player.setFacing(DIRECTION.EAST);
                this.right = false;
                //Calcualr custo da ação
            }
            return;
        }
    }
    
}

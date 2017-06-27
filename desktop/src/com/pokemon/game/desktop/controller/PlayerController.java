package com.pokemon.game.desktop.controller;

import com.badlogic.gdx.Input;
import com.badlogic.gdx.Input.Keys;
import com.badlogic.gdx.InputAdapter;
import com.pokemon.game.desktop.model.Actor;
import com.pokemon.game.desktop.model.BasePokemon;
import com.pokemon.game.desktop.model.DIRECTION;
import com.pokemon.game.desktop.model.Tile;
import com.pokemon.game.desktop.model.TileMap;
import java.util.ArrayList;
import java.util.Map;
import org.jpl7.Query;
import org.jpl7.Term;

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
        
      if(direcao.equals("norte"))  
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
       else if (direcao.equals("sul")) {
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
       else if (direcao.equals("oeste")) {
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
       else if (direcao.equals("leste")) {
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
    
    /**
     * Fazer o agente ir para determinado local no mapa
     * @param player Personagem
     * @param coordX coordenada X do objeto
     * @param coordY coordenada Y do objeto
     */
    public void irParaObjetivo(TileMap map, Actor player, int coordX, int coordY){
        
        /*int intervalo = Math.abs(coordX - player.getX());
        int count = 1;
        int temp = 0;
        int intervalo2 = Math.abs(player.getY() - coordY);
        int count2 = 1;
        
        BasePokemon basePokemon = new BasePokemon();
        
        for(int x = player.getX(); count <= intervalo; count++){
            if(basePokemon.podeMover(map, player).equals("sim")){
                if(coordX > player.getX()){
                    temp = intervalo + count;
                }else{
                    temp = intervalo - count;
                }
            }else{
                if(coordY > player.getY()){
                    if(basePokemon.podeMoverDirecao(map, player, "norte").equals("sim")){
                        
                    }
                }else{
                    if(basePokemon.podeMoverDirecao(map, player, "sul").equals("sim")){
                        
                    }
                }
            }
            int novaPosicao = temp + intervalo;
            player.setX(novaPosicao);
            System.out.println(player.getX());
        }
        
        for(int y = player.getY(); count2 <= intervalo2; count2++){
            if(coordY > player.getY()){
                player.setY(player.getY()+1);
            }else{
                player.setY(player.getY()-1);
            }
            System.out.println(player.getY());
        }*/
        
        
        
        
        
    }
    //Teste
    /*public static void getPaths(int[][]A, int i, int j, ArrayList<Integer> path, ArrayList<ArrayList<Integer>> allPaths) {
        int n = A.length;
        if (i>=n || j>=n) return;

        path.add(A[i][j]);

        if (i==n-1 && j==n-1) {
            allPaths.add(path);
            return;
        }
        getPaths(A, i, j+1, path, allPaths);
        getPaths(A, i+1, j, path, allPaths);
    }

    public static void main(String[] args) {
        ArrayList<ArrayList<Integer>> allPaths = new ArrayList<>();
        getPaths(new int[][] { {1,2,3},{4,5,6},{7,8,9}}, 0,0, new ArrayList<Integer>(), allPaths );
        System.out.println(allPaths);
    }*/
    
}

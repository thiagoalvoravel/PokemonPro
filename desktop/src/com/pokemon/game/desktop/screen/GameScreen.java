package com.pokemon.game.desktop.screen;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.Animation;
import com.badlogic.gdx.graphics.g2d.Animation.PlayMode;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.badlogic.gdx.graphics.g2d.TextureAtlas;
import com.pokemon.game.desktop.Pokemon;
import com.pokemon.game.desktop.Settings;
import com.pokemon.game.desktop.controller.PlayerController;
import com.pokemon.game.desktop.model.Actor;
import com.pokemon.game.desktop.model.Camera;
import com.pokemon.game.desktop.model.CentroPokemon;
import com.pokemon.game.desktop.model.LojaPokemon;
import com.pokemon.game.desktop.model.TERRAIN;
import com.pokemon.game.desktop.model.Tile;
import com.pokemon.game.desktop.model.TileMap;
import com.pokemon.game.desktop.model.Treinador;
import com.pokemon.game.desktop.util.AnimationSet;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.Scanner;

public class GameScreen extends AbstractScreen {

    private PlayerController controller;
    private Camera camera;
    private Actor player;
    private Treinador treinador;
    private CentroPokemon centropokemon;
    private LojaPokemon lojaPokemon;
    private TileMap map;
    private SpriteBatch batch;
    private Texture redStandingSouth;
    private Texture grass1;
    private Texture grass2;
    private Texture montanha;
    private Texture caverna;
    private Texture agua;
    private Texture vulcao;
    public int[][] terrenos = new int[42][42];
    private Texture render; 
    private Texture sprite_treinador;
    private int em_usoX;
    private int em_usoY;
    private int[][] posicoes_usadasPC = new int[42][42];
    private int direcao_mapa_x;
    private int direcao_mapa_y;
    private List<Treinador> sprites_treinador = new ArrayList<Treinador>();
    private List<CentroPokemon> sprites_pokecenter = new ArrayList<CentroPokemon>();
    private List<LojaPokemon> sprites_pokemart = new ArrayList<LojaPokemon>();
     
    List<Integer> list = new ArrayList<Integer>();

    /*Constantes para indicar que os valores numéricos no array: valores_arquivo 
    correspondem aos nomes dos 5 tipos de terrenos.
     */
    public static final int GRAMA = 1;
    public static final int MONTANHA = 2;
    public static final int CAVERNA = 3;
    public static final int AGUA = 4;
    public static final int VULCAO = 5;

    public GameScreen(Pokemon app) {
        super(app);
        redStandingSouth = new Texture("ash_south_stand.png");
        grass1 = new Texture("grass1.png");
        grass2 = new Texture("grass2.png");
        montanha = new Texture("mountain.png");
        caverna = new Texture("cave.png");
        agua = new Texture("water.png");
        vulcao = new Texture("volcano.png");
          
        batch = new SpriteBatch();

        TextureAtlas atlas = app.getAssetManager().get("packed/textures.atlas", TextureAtlas.class);

        AnimationSet animations = new AnimationSet(
                new Animation(0.3f / 2f, atlas.findRegions("ash_north_walk"), PlayMode.LOOP_PINGPONG),
                new Animation(0.3f / 2f, atlas.findRegions("ash_south_walk"), PlayMode.LOOP_PINGPONG),
                new Animation(0.3f / 2f, atlas.findRegions("ash_east_walk"), PlayMode.LOOP_PINGPONG),
                new Animation(0.3f / 2f, atlas.findRegions("ash_west_walk"), PlayMode.LOOP_PINGPONG),
                atlas.findRegion("ash_north_stand"),
                atlas.findRegion("ash_south_stand"),
                atlas.findRegion("ash_east_stand"),
                atlas.findRegion("ash_west_stand")
        );

        map = new TileMap(42, 42);
        player = new Actor(map, 24, 22, animations);
        
        
       //Gera treinadores aleatórios e guarda as instâncias deles   
       for(int x=0;x<50;x++){
          int direcao_face = (int )(Math.random() * 4 + 1);
          int tipo_treinador = (int )(Math.random() * 6 + 1);
          direcao_mapa_x = (int )(Math.random() * 41 + 0);
          direcao_mapa_y = (int )(Math.random() * 41 + 0);            
          treinador = new Treinador(map,direcao_mapa_x,direcao_mapa_y,direcao_face, tipo_treinador);
          
          sprites_treinador.add(treinador);
       } 
       
       //Gera as instâncias dos centros pokemon
       for(int x=0; x < 20;x++)
       {
          direcao_mapa_x = (int )(Math.random() * 41 + 0);
          direcao_mapa_y = (int )(Math.random() * 41 + 0);
          
          if(x==0){
            em_usoX = direcao_mapa_x;
            em_usoY = direcao_mapa_y;
          }
          
          if(x==0) posicoes_usadasPC[direcao_mapa_x][direcao_mapa_y] = 1;
          
          if(x > 0)
          {         
            do{
              direcao_mapa_x = (int )(Math.random() * 41 + 0);
              direcao_mapa_y = (int )(Math.random() * 41 + 0);
            }while(direcao_mapa_x == em_usoX && direcao_mapa_y == em_usoY); 
          }
          em_usoX = direcao_mapa_x;
          em_usoY = direcao_mapa_y;
          posicoes_usadasPC[direcao_mapa_x][direcao_mapa_y] = 1;
          centropokemon = new CentroPokemon(map,direcao_mapa_x,direcao_mapa_y);
          sprites_pokecenter.add(centropokemon);
       }   
       
       //Gera as instâncias das Lojas Pokemon
       for(int x=0;x <15;x++)
       {       
            direcao_mapa_x = (int )(Math.random() * 41 + 0);
            direcao_mapa_y = (int )(Math.random() * 41 + 0);
             
            if(posicoes_usadasPC[direcao_mapa_x][direcao_mapa_y] != 1)
            {
               em_usoX = direcao_mapa_x;
               em_usoY = direcao_mapa_y;
                    
               if(x > 0)
               {           
                  do{
                    direcao_mapa_x = (int )(Math.random() * 41 + 0);
                    direcao_mapa_y = (int )(Math.random() * 41 + 0);                
                  }while(direcao_mapa_x == em_usoX && direcao_mapa_y == em_usoY); 
               }
               if(posicoes_usadasPC[direcao_mapa_x][direcao_mapa_y] != 1)
               {
                  em_usoX = direcao_mapa_x;
                  em_usoY = direcao_mapa_y;
                  lojaPokemon = new LojaPokemon(map,direcao_mapa_x,direcao_mapa_y);
                  sprites_pokemart.add(lojaPokemon);
               }
           }
        
       } 
         
        camera = new Camera();
        
        controller = new PlayerController(player);
    }

    @Override
    public void show() {
        Gdx.input.setInputProcessor(controller);
    }

    @Override
    public void render(float delta) {
        controller.update(delta);

        player.update(delta);
        
        //Descomente para movimentar a câmera
        //camera.update(player.getWorldX() + 0.5f, player.getWorldY() + 0.5f);

        batch.begin();
        
        float worldStartX = Gdx.graphics.getWidth() / 14 - camera.getCameraX() * Settings.SCALED_TILE_SIZE;
        float worldStartY = Gdx.graphics.getHeight() / 14 - camera.getCameraY() * Settings.SCALED_TILE_SIZE;

        for (int x = 0; x < map.getWidth(); x++) {
            for (int y = 0; y < map.getHeight(); y++) {
                            
                switch (map.getTerrenos(x, y).getTerrain()) {
                    case GRASS_2:
                        render = grass2;
                        break;
                    case MONTANHA:
                        render = montanha;
                        break;
                    case CAVERNA:
                        render = caverna;
                        break;
                    case AGUA:
                        render = agua;
                        break;
                    case VULCAO:
                        render = vulcao;
                        break;
                    default:
                        break;
                }
                            
                batch.draw(render,
                        worldStartX + x * Settings.SCALED_TILE_SIZE,
                        worldStartY + y * Settings.SCALED_TILE_SIZE,
                        Settings.SCALED_TILE_SIZE,
                        Settings.SCALED_TILE_SIZE);
            }

        }

        batch.draw(player.getSprite(),
                worldStartX + player.getWorldX() * Settings.SCALED_TILE_SIZE,
                worldStartY + player.getWorldY() * Settings.SCALED_TILE_SIZE,
                Settings.SCALED_TILE_SIZE,
                Settings.SCALED_TILE_SIZE * 1.5f);
        
       //Desenha os treinadores na tela 
       for(Treinador trainer: sprites_treinador)  
       {
              batch.draw(trainer.getSprite(),
              worldStartX + trainer.getWorldX() * Settings.SCALED_TILE_SIZE,
              worldStartY + trainer.getWorldY() * Settings.SCALED_TILE_SIZE,
              Settings.SCALED_TILE_SIZE,
              Settings.SCALED_TILE_SIZE * 1.5f);
       }
       
       //Desenha os centros pokemon na tela 
       for(CentroPokemon pokecenter: sprites_pokecenter)  
       {
              batch.draw(pokecenter.getSprite(),
              worldStartX + pokecenter.getWorldX() * Settings.SCALED_TILE_SIZE,
              worldStartY + pokecenter.getWorldY() * Settings.SCALED_TILE_SIZE
              );
       }
       
       
       //Desenha as Lojas Pokemon na tela 
       for(LojaPokemon pokemart: sprites_pokemart)  
       {
              batch.draw(pokemart.getSprite(),
              worldStartX + pokemart.getWorldX() * Settings.SCALED_TILE_SIZE,
              worldStartY + pokemart.getWorldY() * Settings.SCALED_TILE_SIZE
              );
       }  
         
       
       
        batch.end();
    }

    public Texture getGrass2() {
        return grass2;
    }

    public Texture getMontanha() {
        return montanha;
    }

    public Texture getCaverna() {
        return caverna;
    }

    public Texture getAgua() {
        return agua;
    }

    public Texture getVulcao() {
        return vulcao;
    }
    
    @Override
    public void resize(int width, int height) {

    }

    @Override
    public void pause() {

    }

    @Override
    public void resume() {

    }

    @Override
    public void hide() {

    }

    @Override
    public void dispose() {

    }

}

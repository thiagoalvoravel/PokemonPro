package com.pokemon.game.desktop.model;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class TileMap {
    
    private int width, height;
    private Tile[][] tiles;
    private Tile[][] terrenos;
    public int[][] terrenos_arquivo = new int[42][42];
   
    public TileMap(int width, int height) {
        this.width = width;
        this.height = height;
        tiles = new Tile[width][height];
        terrenos = new Tile[width][height];
        
        ler_Arquivo();     
    }
    
    public void ler_Arquivo() {
        try {
            File arquivo_mapa = new File("Construtor_Mapa.txt");       
            int x=0;
            int y=0;
            
            Scanner scanner = new Scanner(arquivo_mapa);
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                String[] valor_terreno = line.split("-");
                
              if(x < 42)  
              {  
                for(int z=0; z < valor_terreno.length;z++)
                {           
                       if(valor_terreno[z].equals("m")){                        
                             terrenos[x][y] = new Tile(TERRAIN.MONTANHA);
                             y++;                           
                       } 
                       if(valor_terreno[z].equals("g")){
                           terrenos[x][y] = new Tile(TERRAIN.GRASS_2);
                           y++;                         
                       }
                           
                       if(valor_terreno[z].equals("c"))
                       {
                          terrenos[x][y] = new Tile(TERRAIN.CAVERNA);
                          y++;                       
                       }
                           
                       if(valor_terreno[z].equals("a")){
                          terrenos[x][y] = new Tile(TERRAIN.AGUA); 
                          y++;                        
                       }
                           
                       if(valor_terreno[z].equals("v")){
                          terrenos[x][y] = new Tile(TERRAIN.VULCAO); 
                          y++;                       
                       }                                                                                                             
                }
              } 
              y=0;
             x++;  
           }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    public Tile getTile(int x, int y) {
        return tiles[x][y];
    }
    
    public Tile getTerrenos(int x, int y)
    {
        return terrenos[x][y];
    }
    
    public int getWidth() {
        return width;
    }
    
    public int getHeight() {
        return height;
    }

}

package com.pokemon.game.desktop.util;

import com.badlogic.gdx.tools.texturepacker.TexturePacker;

public class TexturePackerTool {
    
   public static void main(String[] args) {
       TexturePacker.process(
               "unpacked", 
               "packed", 
               "textures");
   } 
   
}

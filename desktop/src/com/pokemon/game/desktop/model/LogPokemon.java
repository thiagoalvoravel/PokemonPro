package com.pokemon.game.desktop.model;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.files.FileHandle;

public class LogPokemon {
    private FileHandle logFile = Gdx.files.local("log.txt");
 
   public LogPokemon(){
       if(logFile.exists()) {
           logFile.delete();
           logFile = Gdx.files.local("log.txt");
       }   
   }

   public void writeLogs(String log) {
      logFile.writeString(log + "\n", true);
      //logFile.writeString("\n", true);
   }   

  public String readLog() {
      return logFile.readString();
  } 













}

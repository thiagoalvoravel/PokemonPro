package com.pokemon.game.desktop;

import com.badlogic.gdx.backends.lwjgl.LwjglApplication;
import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration;
//import com.pokemon.game.Main;

public class DesktopLauncher {
	public static void main (String[] arg) {
		LwjglApplicationConfiguration config = new LwjglApplicationConfiguration();
		
                config.title = "Pokemon Game";
                config.height = 680;
                config.width = 680;
                config.vSyncEnabled = true;
                
                new LwjglApplication(new Pokemon(), config);
	}
}

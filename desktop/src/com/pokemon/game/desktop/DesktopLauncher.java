package com.pokemon.game.desktop;

import com.badlogic.gdx.backends.lwjgl.LwjglApplication;
import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration;
//import com.pokemon.game.Main;

public class DesktopLauncher {
	public static void main (String[] arg) {
		LwjglApplicationConfiguration config = new LwjglApplicationConfiguration();
		
                config.title = "Pokemon Game";
                config.height = 980;
                config.width = 980;
                config.vSyncEnabled = true;
                
                new LwjglApplication(new Iniciar(), config);
	}
}

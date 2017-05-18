package com.pokemon.game.desktop.screen;

import com.badlogic.gdx.Screen;
import com.pokemon.game.desktop.Iniciar;

public abstract class AbstractScreen implements Screen {
    private Iniciar app;
     
    public AbstractScreen(Iniciar app){
      this.app = app;
    }

    @Override
    public abstract void show();

    @Override
    public abstract  void render(float delta);

    @Override
    public abstract void resize(int width, int height);

    @Override
    public abstract void pause();

    @Override
    public abstract void resume();

    @Override
    public abstract void hide();

    @Override
    public abstract void dispose();
    
    public Iniciar getApp() {
        return app;
    }
    
}

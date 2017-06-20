package com.pokemon.game.desktop.model;

import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.TextureRegion;
import com.badlogic.gdx.math.Interpolation;
import com.pokemon.game.desktop.util.AnimationSet;

public class LojaPokemon {

    private TileMap map;
    private int x;
    private int y;
    private int qtdPokebolas = 25;

    private DIRECTION facing;
    private Texture sprite;

    private float worldX, worldY;

    public LojaPokemon(TileMap map, int x, int y) {
        this.map = map;
        this.x = x;
        this.y = y;
        this.worldX = x;
        this.worldY = y;

        sprite = new Texture("pokemart.png");

        map.getTerrenos(x, y).setLoja(this);
    }

    public int getQtdPokebolas() {
        return qtdPokebolas;
    }

    public void setQtdPokebolas(int qtdPokebolas) {
        this.qtdPokebolas = qtdPokebolas;
    }

    public Texture getSprite() {
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

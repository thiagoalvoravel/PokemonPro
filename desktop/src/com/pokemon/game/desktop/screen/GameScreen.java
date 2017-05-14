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
import com.pokemon.game.desktop.model.TERRAIN;
import com.pokemon.game.desktop.model.TileMap;
import com.pokemon.game.desktop.util.AnimationSet;

public class GameScreen extends AbstractScreen {

    private PlayerController controller;
    private Camera camera;
    private Actor player;
    private TileMap map;
    private SpriteBatch batch;
    private Texture redStandingSouth;
    private Texture grass1;
    private Texture grass2;

    public GameScreen(Pokemon app) {
        super(app);
        redStandingSouth = new Texture("ash_south_stand.png");
        grass1 = new Texture("grass1.png");
        grass2 = new Texture("grass2.png");
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
        player = new Actor(map, 0, 0, animations);
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
                Texture render;
                if (map.getTile(x, y).getTerrain() == TERRAIN.GRASS_1) {
                    render = grass1;
                } else {
                    render = grass2;
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
        batch.end();
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

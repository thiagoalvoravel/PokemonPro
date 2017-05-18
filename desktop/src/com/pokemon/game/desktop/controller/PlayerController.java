package com.pokemon.game.desktop.controller;

import com.badlogic.gdx.Input;
import com.badlogic.gdx.Input.Keys;
import com.badlogic.gdx.InputAdapter;
import com.pokemon.game.desktop.model.Actor;
import com.pokemon.game.desktop.model.DIRECTION;

public class PlayerController extends InputAdapter {

    private Actor player;
    private boolean up, down, left, right;

    public PlayerController(Actor p) {
        this.player = p;
    }

    @Override
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
    }

    @Override
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
    }

    public void update(float delta) {
        if (up) {
            if (this.player.getFacing() == DIRECTION.NORTH) {
                player.move(DIRECTION.NORTH);
            }else{
                this.player.setState(Actor.ACTOR_STATE.STANDING);
                this.player.setFacing(DIRECTION.NORTH);
                this.up = false;
                //Calcualr custo da ação
            }
            return;
        }
        if (down) {
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
        if (left) {
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
        if (right) {
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

}

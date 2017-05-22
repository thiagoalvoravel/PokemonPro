package com.pokemon.game.desktop.model;

import com.badlogic.gdx.graphics.g2d.TextureRegion;
import com.badlogic.gdx.math.Interpolation;
import com.pokemon.game.desktop.util.AnimationSet;

public class Actor {

    private TileMap map;
    private int x;
    private int y;
    private DIRECTION facing;

    private float worldX, worldY;
    private int srcX, srcY;
    private int destX, destY;
    private float animTimer;
    private float ANIM_TIME = 0.3f;

    private float walkTimer;
    private boolean moveRequestThisFrame;

    private ACTOR_STATE state;

    private AnimationSet animations;

    public Actor(TileMap map, int x, int y, AnimationSet animations) {
        this.map = map;
        this.x = x;
        this.y = y;
        this.worldX = x;
        this.worldY = y;
        this.animations = animations;
        map.getTerrenos(x, y).setActor(this);
        this.state = ACTOR_STATE.STANDING;
        this.facing = DIRECTION.SOUTH;
    }

    public enum ACTOR_STATE {
        WALKING,
        STANDING,;
    }
    
    public ACTOR_STATE getState() {
        return state;
    }

    public void update(float delta) {   
        if (state == ACTOR_STATE.WALKING) {
            animTimer += delta;
            walkTimer += delta;
            worldX = Interpolation.linear.apply(srcX, destX, animTimer / ANIM_TIME);
            worldY = Interpolation.linear.apply(srcY, destY, animTimer / ANIM_TIME);
            if (animTimer > ANIM_TIME) {
                float leftOverTime = animTimer - ANIM_TIME;
                walkTimer -= leftOverTime;
                finishMove();
                if (moveRequestThisFrame) {
                    move(facing);
                } else {
                    walkTimer = 0f;
                }
            }
        }
        moveRequestThisFrame = false;
    }

    public float getWorldX() {
        return worldX;
    }

    public float getWorldY() {
        return worldY;
    }

    public TextureRegion getSprite() {
        if (state == ACTOR_STATE.WALKING) {
            return (TextureRegion) animations.getWalking(facing).getKeyFrame(walkTimer);
        } else if (state == ACTOR_STATE.STANDING) {
            return animations.getStanding(facing);
        }
        return animations.getStanding(DIRECTION.SOUTH);
    }

    public boolean move(DIRECTION dir) {
        if (state == ACTOR_STATE.WALKING) {
            if (facing == dir) {
                moveRequestThisFrame = true;
            }
            return false;
        }
        if (x + dir.getDX() >= map.getWidth() || x + dir.getDX() < 0 || y + dir.getDY() >= map.getHeight() || y + dir.getDY() < 0) {
            return false;
        }
        if (map.getTerrenos(x + dir.getDX(), y + dir.getDY()).getActor() != null) {
            return false;
        }
        initializeMove(dir);

        map.getTerrenos(x, y).setActor(null);
        x += dir.getDX();
        y += dir.getDY();
        map.getTerrenos(x, y).setActor(this);
        return true;
    }

    private void initializeMove(DIRECTION dir) {
        this.facing = dir;
        this.srcX = x;
        this.srcY = y;
        this.destX = x + dir.getDX();
        this.destY = y + dir.getDY();
        this.worldX = x;
        this.worldY = y;
        animTimer = 0f;
        state = ACTOR_STATE.WALKING;
    }

    private void finishMove() {
        state = ACTOR_STATE.STANDING;
        this.worldX = destX;
        this.worldY = destY;
        this.srcX = 0;
        this.srcY = 0;
        this.destX = 0;
        this.destY = 0;

    }

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }

    public void setX(int x_) {
        this.x = x_;
    }

    public void setY(int y_) {
        this.y = y_;
    }

    public DIRECTION getFacing() {
        return this.facing;
    }

    public void setFacing(DIRECTION dir) {
        this.facing = dir;
    }

    public void setState(ACTOR_STATE state_) {
        this.state = state_;
    }
    
    public int getSrcX() {
        return srcX;
    }

    public void setSrcX(int srcX) {
        this.srcX = srcX;
    }

    public int getSrcY() {
        return srcY;
    }

    public void setSrcY(int srcY) {
        this.srcY = srcY;
    }

    public int getDestX() {
        return destX;
    }

    public void setDestX(int destX) {
        this.destX = destX;
    }

    public int getDestY() {
        return destY;
    }

    public void setDestY(int destY) {
        this.destY = destY;
    }
    
    public boolean isMoveRequestThisFrame() {
        return moveRequestThisFrame;
    }

    public void setMoveRequestThisFrame(boolean moveRequestThisFrame) {
        this.moveRequestThisFrame = moveRequestThisFrame;
    }
    
     public TileMap getMap() {
        return map;
    }

}

package com.pokemon.game.desktop.screen;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.Color;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.Animation;
import com.badlogic.gdx.graphics.g2d.Animation.PlayMode;
import com.badlogic.gdx.graphics.g2d.BitmapFont;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.badlogic.gdx.graphics.g2d.TextureAtlas;
import com.badlogic.gdx.graphics.g2d.freetype.FreeTypeFontGenerator;
import com.badlogic.gdx.graphics.g2d.freetype.FreeTypeFontGenerator.FreeTypeFontParameter;
import com.badlogic.gdx.scenes.scene2d.Group;
import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.scenes.scene2d.ui.Image;
import com.badlogic.gdx.scenes.scene2d.ui.Label;
import com.badlogic.gdx.scenes.scene2d.ui.Skin;
import com.badlogic.gdx.scenes.scene2d.ui.TextButton;
import com.badlogic.gdx.scenes.scene2d.ui.TextButton.TextButtonStyle;
import com.badlogic.gdx.scenes.scene2d.ui.TextField;
import com.badlogic.gdx.utils.Align;
import com.badlogic.gdx.utils.viewport.StretchViewport;
import com.pokemon.game.desktop.Iniciar;
import com.pokemon.game.desktop.Settings;
import com.pokemon.game.desktop.controller.PlayerController;
import com.pokemon.game.desktop.model.Actor;
import com.pokemon.game.desktop.model.BasePokemon;
import com.pokemon.game.desktop.model.Camera;
import com.pokemon.game.desktop.model.CentroPokemon;
import com.pokemon.game.desktop.model.LogPokemon;
import com.pokemon.game.desktop.model.LojaPokemon;
import com.pokemon.game.desktop.model.PONTOSACAO;
import com.pokemon.game.desktop.model.Pokemon;
import com.pokemon.game.desktop.model.Pontuacao;
import com.pokemon.game.desktop.model.TERRAIN;
import com.pokemon.game.desktop.model.Tile;
import com.pokemon.game.desktop.model.TileMap;
import com.pokemon.game.desktop.model.Treinador;
import com.pokemon.game.desktop.util.AnimationSet;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Scanner;
import java.util.concurrent.TimeUnit;
import org.jpl7.Query;
import org.jpl7.Term;

public class GameScreen extends AbstractScreen {

    private PlayerController controller;
    private Camera camera;
    private Actor player;
    private Pontuacao pontuacao;
    private Treinador treinador;
    private CentroPokemon centropokemon;
    private LojaPokemon lojaPokemon;
    private Pokemon pokemon;
    private TileMap map;
    private SpriteBatch batch;
    private Texture redStandingSouth;
    private Texture grass1;
    private Texture grass2;
    private Texture montanha;
    private Texture caverna;
    private Texture agua;
    private Texture vulcao;
    private Texture backgroud_image;
    private Label textLabel;
    public int[][] terrenos = new int[42][42];
    private Texture render;
    private Texture sprite_treinador;
    private Texture backgrounDisplay;
    private int em_usoX;
    private int em_usoY;
    private int[][] posicoes_usadasPC = new int[42][42];
    private int[][] posicoes_usadasPM = new int[42][42];
    private int[][] posicoes_ocupadas_pokemons = new int[42][42];
    private int[][] posicoes_ocupadas_PM = new int[42][42];
    private int[][] posicoes_ocupadas_PC = new int[42][42];
    private int[][] posicoes_ocupadas_Treinador = new int[42][42];

    private int direcao_mapa_x;
    private int direcao_mapa_y;
    private List<Treinador> sprites_treinador = new ArrayList<Treinador>();
    private List<CentroPokemon> sprites_pokecenter = new ArrayList<CentroPokemon>();
    private List<LojaPokemon> sprites_pokemart = new ArrayList<LojaPokemon>();
    private List<Pokemon> sprites_pokemons = new ArrayList<Pokemon>();
    private List<String> nomes_pokemons = new ArrayList<String>();

    List<Integer> list = new ArrayList<Integer>();
    private TextField txtDisplay;

    private int score;
    private int score2;
    private String pontuacao_atual;
    private String pontuacao_total;
    BitmapFont fonte;
    BitmapFont fonte2;
    Group grp = new Group();
    private Stage stage;
    private Image img;

    /*Constantes para indicar que os valores numéricos no array: valores_arquivo 
    correspondem aos nomes dos 5 tipos de terrenos.
     */
    public static final int GRAMA = 1;
    public static final int MONTANHA = 2;
    public static final int CAVERNA = 3;
    public static final int AGUA = 4;
    public static final int VULCAO = 5;

    private BitmapFont font;
    private TextureAtlas buttonsAtlas; //** image of buttons **//
    private Skin buttonSkin; //** images are used as skins of the button **//
    private TextButton button;
    private TextButtonStyle textButtonStyle;
    private BasePokemon agente = new BasePokemon(); 
   
    /*private String nome_arquivo;
    private Query compilar_arquivo;
    private String regra;
    private Query executar_regra;*/
    private String direcao;
    //private Map<String, Term> resultado_regra;
    
    private TextButton btnQtdPokemons;
    private TextButton btnScoreTotal;
    private TextButton btnScoreAtual;
    private TextButton btnNomePokemon;
    private TextButton btnNumPokemon;
    private TextButton btnAcaoAtual;
    
    //public static final String FONT_CHARACTERS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789][_!$%#@|\\/?-+=()*&.;,{}\"´`'<>";
      
    public GameScreen(Iniciar app) {
        super(app);
        redStandingSouth = new Texture("ash_south_stand.png");
        grass1 = new Texture("grass1.png");
        grass2 = new Texture("grass2.png");
        montanha = new Texture("mountain.png");
        caverna = new Texture("cave.png");
        agua = new Texture("water.png");
        vulcao = new Texture("volcano.png");

        batch = new SpriteBatch();

        stage = new Stage(new StretchViewport(800, 800));
         font = new BitmapFont(Gdx.files.internal("fontes/small_letters_font.fnt"),
                Gdx.files.internal("fontes/small_letters_font.png"), false);
         
        
        /*FreeTypeFontGenerator generator = new FreeTypeFontGenerator(Gdx.files.internal("fontes/pkmnrsi.ttf")); 
        FreeTypeFontParameter parameter = new FreeTypeFontParameter();
        parameter.size = 12; 
        BitmapFont font = generator.generateFont(parameter); // font size 12 pixels generator.dispose(); // don't forget to dispose to avoid memory leaks!*/
        
        
        
        
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
        player = new Actor(map, 24, 22, animations);
        pontuacao = new Pontuacao(0);
        agente.setPokebolas(25);

        //Gera as instâncias dos centros pokemon
        gerar_centros_pokemon();

        //Gera as instâncias das Lojas Pokemon   
        gerar_lojas_pokemon();

        //Define a lista de nomes de pokemons e seus tipos
        adicionar_nomes_pokemon();

        //Gera Pokémons aleatórios e guarda as instâncias deles
        gerar_pokemons();

        //Gera treinadores aleatórios e guarda as instâncias deles   
        gerar_Treinador();
        
        //Atualizar a pontuacao com base nas ações 
        //Recebe objeto Pontuacao para mostrar o valor da Pontuacao
        
        font.getData().setScale(1.5f);
        buttonSkin = new Skin();
        buttonsAtlas = new TextureAtlas(Gdx.files.internal("packed2/uipack.atlas"));
        buttonSkin.addRegions(buttonsAtlas);
        textButtonStyle = new TextButtonStyle();
        textButtonStyle.font = font;
        textButtonStyle.up = buttonSkin.getDrawable("dialoguebox");
        
        mostrar_Pontuacao_Atual(pontuacao);
        mostrar_Pontuacao_Total(pontuacao);

        //Mostrar Pokémons Capturados!
        player.setPokemons_capturados(0);
        mostrar_Qtd_Pokemons(pontuacao);
        mostrar_Nome_Pokemons();
        mostrar_Numero_Pokemons();
        mostrar_Acao_Agente();

        camera = new Camera();

        controller = new PlayerController(player);
    }
    
    public void mostrar_Qtd_Pokemons(Pontuacao pontuacao_poke) {
        btnQtdPokemons = new TextButton("Capturados: " + player.getPokemons_capturados(), textButtonStyle);
        btnQtdPokemons.setPosition(612, 500);
        stage.addActor(btnQtdPokemons);

    }

    public void mostrar_Pontuacao_Atual(Pontuacao pontuacao_atual) {
        btnScoreAtual = new TextButton("Custo da Acao: " + pontuacao_atual.getPontuacaoAtual(), textButtonStyle);
        btnScoreAtual.setPosition(612, 700);
        stage.addActor(btnScoreAtual);

    }

    public void mostrar_Pontuacao_Total(Pontuacao valor_Pontuacao) {
        btnScoreTotal = new TextButton("Pontuacao Total: " + valor_Pontuacao.getPontuacaoTotal(), textButtonStyle);
        btnScoreTotal.setPosition(612, 600);
        stage.addActor(btnScoreTotal);

    }
    
    public void mostrar_Nome_Pokemons() {
        btnNomePokemon = new TextButton("Nome: " , textButtonStyle);
        btnNomePokemon.setPosition(612, 400);
        stage.addActor(btnNomePokemon);

    }
    
    public void mostrar_Numero_Pokemons() {
        btnNumPokemon = new TextButton("Numero: " , textButtonStyle);
        btnNumPokemon.setPosition(612, 300);
        stage.addActor(btnNumPokemon);

    }
    
    public void mostrar_Acao_Agente() {
        btnAcaoAtual = new TextButton("Acao: " , textButtonStyle);
        btnAcaoAtual.setPosition(612, 200);
        stage.addActor(btnAcaoAtual);

    }

    public void gerar_Treinador() {
        for (int x = 0; x < 50; x++) {
            int direcao_face = (int) (Math.random() * 4 + 1);
            int tipo_treinador = (int) (Math.random() * 6 + 1);
            direcao_mapa_x = (int) (Math.random() * 41 + 0);
            direcao_mapa_y = (int) (Math.random() * 41 + 0);

            if (posicoes_usadasPC[direcao_mapa_x][direcao_mapa_y] != 1
                    || posicoes_usadasPM[direcao_mapa_x][direcao_mapa_y] != 1
                    || posicoes_ocupadas_pokemons[direcao_mapa_x][direcao_mapa_y] != 1) {

                if (x == 0) {
                    posicoes_ocupadas_Treinador[direcao_mapa_x][direcao_mapa_y] = 1;
                }

                if (x > 0) {
                    while (!getposicao_treinador_ocupada(direcao_mapa_x, direcao_mapa_y)
                            || !getposicao_pokemon_ocupada(direcao_mapa_x, direcao_mapa_y)
                            || !getposicao_PC_ocupada(direcao_mapa_x, direcao_mapa_y)
                            || !getposicao_PM_ocupada(direcao_mapa_x, direcao_mapa_y)) {
                        direcao_mapa_x = (int) (Math.random() * 41 + 0);
                        direcao_mapa_y = (int) (Math.random() * 41 + 0);
                    }
                    posicoes_ocupadas_Treinador[direcao_mapa_x][direcao_mapa_y] = 1;
                }

                if (getposicao_treinador_ocupada(direcao_mapa_x, direcao_mapa_y)
                            || getposicao_pokemon_ocupada(direcao_mapa_x, direcao_mapa_y)
                            || getposicao_PC_ocupada(direcao_mapa_x, direcao_mapa_y)
                            || getposicao_PM_ocupada(direcao_mapa_x, direcao_mapa_y)) 
                {
                    treinador = new Treinador(map, direcao_mapa_x, direcao_mapa_y, direcao_face, tipo_treinador);
                    sprites_treinador.add(treinador);
                } else {
                    posicoes_ocupadas_Treinador[direcao_mapa_x][direcao_mapa_y] = 0;
                    x--;
                }
            } else {
                x--;
            }
        }
    }

    public void gerar_pokemons() {
        for (int x = 0; x < 150; x++) {
            direcao_mapa_x = (int) (Math.random() * 41 + 0);
            direcao_mapa_y = (int) (Math.random() * 41 + 0);

            if (posicoes_usadasPC[direcao_mapa_x][direcao_mapa_y] != 1
                    || posicoes_usadasPM[direcao_mapa_x][direcao_mapa_y] != 1) {

                if (x == 0) {
                    posicoes_ocupadas_pokemons[direcao_mapa_x][direcao_mapa_y] = 1;
                }

                if (x > 0) {
                    while (!getposicao_pokemon_ocupada(direcao_mapa_x, direcao_mapa_y)
                            || !getposicao_PC_ocupada(direcao_mapa_x, direcao_mapa_y)
                            || !getposicao_PM_ocupada(direcao_mapa_x, direcao_mapa_y)) {
                        direcao_mapa_x = (int) (Math.random() * 41 + 0);
                        direcao_mapa_y = (int) (Math.random() * 41 + 0);
                    }
                    posicoes_ocupadas_pokemons[direcao_mapa_x][direcao_mapa_y] = 1;
                }

                if (getposicao_treinador_ocupada(direcao_mapa_x, direcao_mapa_y) ||
                        getposicao_pokemon_ocupada(direcao_mapa_x, direcao_mapa_y)
                            || getposicao_PC_ocupada(direcao_mapa_x, direcao_mapa_y)
                            || getposicao_PM_ocupada(direcao_mapa_x, direcao_mapa_y))                              
                {
                    /*if(nomes_pokemons.get(x).equals("pidgey-normal;voador")){
                        direcao_mapa_x = 24;
                        direcao_mapa_y = 21;
                    }*/
                    pokemon = new Pokemon(map, direcao_mapa_x, direcao_mapa_y,
                            nomes_pokemons.get(x));
                    sprites_pokemons.add(pokemon);
                } else {
                    posicoes_ocupadas_pokemons[direcao_mapa_x][direcao_mapa_y] = 0;
                    x--;
                }
            } else {
                x--;
            }
        }
    }

    public void gerar_lojas_pokemon() {

        for (int x = 0; x < 15; x++) {
            direcao_mapa_x = (int) (Math.random() * 41 + 0);
            direcao_mapa_y = (int) (Math.random() * 41 + 0);

            if (posicoes_usadasPC[direcao_mapa_x][direcao_mapa_y] != 1) {
                if (x == 0) {
                    posicoes_ocupadas_PM[direcao_mapa_x][direcao_mapa_y] = 1;
                }

                if (x > 0) {
                    while (!getposicao_PC_ocupada(direcao_mapa_x, direcao_mapa_y)
                            || !getposicao_PM_ocupada(direcao_mapa_x, direcao_mapa_y)) {
                        direcao_mapa_x = (int) (Math.random() * 41 + 0);
                        direcao_mapa_y = (int) (Math.random() * 41 + 0);
                    }
                    posicoes_ocupadas_PM[direcao_mapa_x][direcao_mapa_y] = 1;
                }
                if (posicoes_usadasPC[direcao_mapa_x][direcao_mapa_y] != 1) {
                    lojaPokemon = new LojaPokemon(map, direcao_mapa_x, direcao_mapa_y);
                    sprites_pokemart.add(lojaPokemon);
                } else {
                    posicoes_ocupadas_PM[direcao_mapa_x][direcao_mapa_y] = 0;
                    x--;
                }
            } else {
                x--;
            }
        }
    }

    public void gerar_centros_pokemon() {

        for (int x = 0; x < 20; x++) {
            direcao_mapa_x = (int) (Math.random() * 41 + 0);
            direcao_mapa_y = (int) (Math.random() * 41 + 0);

            if (x == 0) {
                posicoes_ocupadas_PC[direcao_mapa_x][direcao_mapa_y] = 1;
            }

            if (x > 0) {
                while (!getposicao_treinador_ocupada(direcao_mapa_x, direcao_mapa_y)
                        || !getposicao_pokemon_ocupada(direcao_mapa_x, direcao_mapa_y)
                        || !getposicao_PC_ocupada(direcao_mapa_x, direcao_mapa_y)
                        || !getposicao_PM_ocupada(direcao_mapa_x, direcao_mapa_y)) {
                    direcao_mapa_x = (int) (Math.random() * 41 + 0);
                    direcao_mapa_y = (int) (Math.random() * 41 + 0);
                }
                posicoes_ocupadas_PC[direcao_mapa_x][direcao_mapa_y] = 1;
            }

            centropokemon = new CentroPokemon(map, direcao_mapa_x, direcao_mapa_y);
            sprites_pokecenter.add(centropokemon);
        }
    }

    public boolean getposicao_PC_ocupada(int x, int y) {
        for (int l = 0; l < 42; l++) {
            for (int c = 0; c < 42; c++) {
                if (posicoes_ocupadas_PC[x][y] == 1) {
                    return false;
                }
            }
        }

        return true;
    }

    public boolean getposicao_PM_ocupada(int x, int y) {
        for (int l = 0; l < 42; l++) {
            for (int c = 0; c < 42; c++) {
                if (posicoes_ocupadas_PM[x][y] == 1) {
                    return false;
                }
            }
        }

        return true;
    }

    public boolean getposicao_pokemon_ocupada(int x, int y) {
        for (int l = 0; l < 42; l++) {
            for (int c = 0; c < 42; c++) {
                if (posicoes_ocupadas_pokemons[x][y] == 1) {
                    return false;
                }
            }
        }

        return true;
    }

    public boolean getposicao_treinador_ocupada(int x, int y) {
        for (int l = 0; l < 42; l++) {
            for (int c = 0; c < 42; c++) {
                if (posicoes_ocupadas_Treinador[x][y] == 1) {
                    return false;
                }
            }
        }

        return true;
    }

    public void adicionar_nomes_pokemon() {
        nomes_pokemons.add("abra-psiquico;N-63");
        nomes_pokemons.add("alakazam-psiquico;N-65");
        nomes_pokemons.add("aerodactyl-pedra;voador-142");
        nomes_pokemons.add("arbok-venenoso;N-24");
        nomes_pokemons.add("arcanine-fogo;N-59");
        nomes_pokemons.add("articuno-gelo;voador-144");
        nomes_pokemons.add("beedrill-inseto;voador-15");
        nomes_pokemons.add("bellsprout-grama;venenoso-69");
        nomes_pokemons.add("blastoise-agua;N-9");
        nomes_pokemons.add("bulbasaur-grama;venenoso-1");
        nomes_pokemons.add("butterfree-inseto;voador-12");
        nomes_pokemons.add("caterpie-inseto;N-10");
        nomes_pokemons.add("chansey-normal;N-113");
        nomes_pokemons.add("charizard-fogo;voador-6");
        nomes_pokemons.add("charmander-fogo;N-4");
        nomes_pokemons.add("charmeleon-fogo;N-5");
        nomes_pokemons.add("clefable-normal;N-36");
        nomes_pokemons.add("clefairy-normal;N-35");
        nomes_pokemons.add("cloyster-agua;gelo-91");
        nomes_pokemons.add("cubone-terra;N-104");
        nomes_pokemons.add("dewgong-agua;gelo-87");
        nomes_pokemons.add("diglett-terra;N-50");
        nomes_pokemons.add("ditto-normal;N-132");
        nomes_pokemons.add("dodrio-normal;voador-85");
        nomes_pokemons.add("doduo-normal;voador-84");
        nomes_pokemons.add("dragonair-dragao;N-148");
        nomes_pokemons.add("dragonite-dragao;voador-149");
        nomes_pokemons.add("dratini-dragao;N-147");
        nomes_pokemons.add("drowzee-psiquico;N-96");
        nomes_pokemons.add("dugtrio-terra;N-51");
        nomes_pokemons.add("eevee-normal;N-133");
        nomes_pokemons.add("ekans-venenoso;N-23");
        nomes_pokemons.add("electabuzz-eletrico;N-125");
        nomes_pokemons.add("electrode-eletrico;N-101");
        nomes_pokemons.add("exeggcute-grama;psiquico-102");
        nomes_pokemons.add("exeggutor-grama;psiquico-103");
        nomes_pokemons.add("farfetchd-normal;voador-83");
        nomes_pokemons.add("fearow-normal;voador-22");
        nomes_pokemons.add("flareon-fogo;N-136");
        nomes_pokemons.add("gastly-fantasma;venenoso-92");
        nomes_pokemons.add("gengar-fantasma;venenoso-94");
        nomes_pokemons.add("geodude-pedra;terra-74");
        nomes_pokemons.add("gloom-grama;venenoso-44");
        nomes_pokemons.add("golbat-venenoso;voador-42");
        nomes_pokemons.add("goldeen-agua;N-118");
        nomes_pokemons.add("golduck-agua;N-55");
        nomes_pokemons.add("golem-pedra;terra-76");
        nomes_pokemons.add("graveler-pedra;terra-75");
        nomes_pokemons.add("grimer-venenoso;N-88");
        nomes_pokemons.add("growlithe-fogo;N-58");
        nomes_pokemons.add("gyarados-agua;voador-130");
        nomes_pokemons.add("haunter-fantasma;venenoso-93");
        nomes_pokemons.add("hitmonchan-lutador;N-107");
        nomes_pokemons.add("hitmonlee-lutador;N-106");
        nomes_pokemons.add("horsea-agua;N-116");
        nomes_pokemons.add("hypno-psiquico;N-97");
        nomes_pokemons.add("ivysaur-grama;venenoso-2");
        nomes_pokemons.add("jigglypuff-normal;N-39");
        nomes_pokemons.add("jolteon-eletrico;N-135");
        nomes_pokemons.add("jynx-gelo;psiquico-124");
        nomes_pokemons.add("kabuto-pedra;agua-140");
        nomes_pokemons.add("kabutops-pedra;agua-141");
        nomes_pokemons.add("kadabra-psiquico;N-64");
        nomes_pokemons.add("kakuna-inseto;venenoso-14");
        nomes_pokemons.add("kangaskhan-normal;N-115");
        nomes_pokemons.add("kingler-agua;N-99");
        nomes_pokemons.add("koffing-venenoso;N-109");
        nomes_pokemons.add("krabby-agua;N-98");
        nomes_pokemons.add("lapras-agua;gelo-131");
        nomes_pokemons.add("lickitung-normal;N-108");
        nomes_pokemons.add("machamp-lutador;N-68");
        nomes_pokemons.add("machoke-lutador;N-67");
        nomes_pokemons.add("machop-lutador;N-66");
        nomes_pokemons.add("magikarp-agua;N-129");
        nomes_pokemons.add("magmar-fogo;N-126");
        nomes_pokemons.add("magnemite-eletrico;aco-81");
        nomes_pokemons.add("magneton-eletrico;aco-82");
        nomes_pokemons.add("mankey-lutador;N-56");
        nomes_pokemons.add("marowak-terra;N-105");
        nomes_pokemons.add("meowth-normal;N-52");
        nomes_pokemons.add("metapod-inseto;N-11");
        nomes_pokemons.add("mewtwo-psiquico;N-150");
        nomes_pokemons.add("moltres-fogo;voador-146");
        nomes_pokemons.add("mrMime-psiquico;N-122");
        nomes_pokemons.add("muk-venenoso;N-89");
        nomes_pokemons.add("nidoking-venenoso;terra-34");
        nomes_pokemons.add("nidoqueen-venenoso;terra-31");
        nomes_pokemons.add("nidoranf-venenoso;N-29");
        nomes_pokemons.add("nidoranm-venenoso;N-32");
        nomes_pokemons.add("nidorina-venenoso;N-30");
        nomes_pokemons.add("nidorino-venenoso;N-33");
        nomes_pokemons.add("ninetales-fogo;N-38");
        nomes_pokemons.add("oddish-grama;venenoso-43");
        nomes_pokemons.add("omanyte-pedra;agua-138");
        nomes_pokemons.add("omastar-pedra;agua-139");
        nomes_pokemons.add("onix-pedra;terra-95");
        nomes_pokemons.add("paras-inseto;grama-46");
        nomes_pokemons.add("parasect-inseto;grama-47");
        nomes_pokemons.add("persian-normal;N-53");
        nomes_pokemons.add("pidgeot-normal;voador-18");
        nomes_pokemons.add("pidgeotto-normal;voador-17");
        nomes_pokemons.add("pidgey-normal;voador-16");
        nomes_pokemons.add("pikachu-eletrico;N-25");
        nomes_pokemons.add("pinsir-inseto;N-127");
        nomes_pokemons.add("poliwag-agua;N-60");
        nomes_pokemons.add("poliwhirl-agua;N-61");
        nomes_pokemons.add("poliwrath-agua;lutador-62");
        nomes_pokemons.add("ponyta-fogo;N-77");
        nomes_pokemons.add("porygon-normal;N-137");
        nomes_pokemons.add("primeape-lutador;N-57");
        nomes_pokemons.add("psyduck-agua;N-54");
        nomes_pokemons.add("raichu-eletrico;N-26");
        nomes_pokemons.add("rapidash-fogo;N-78");
        nomes_pokemons.add("raticate-normal;N-20");
        nomes_pokemons.add("rattata-normal;N-19");
        nomes_pokemons.add("rhydon-terra;pedra-112");
        nomes_pokemons.add("rhyhorn-terra;pedra-111");
        nomes_pokemons.add("sandshrew-terra;N-27");
        nomes_pokemons.add("sandslash-terra;N-28");
        nomes_pokemons.add("scyther-inseto;voador-123");
        nomes_pokemons.add("seadra-agua;N-117");
        nomes_pokemons.add("seaking-agua;N-119");
        nomes_pokemons.add("seel-agua;N-86");
        nomes_pokemons.add("shellder-agua;N-90");
        nomes_pokemons.add("slowbro-agua;psiquico-80");
        nomes_pokemons.add("slowpoke-agua;psiquico-79");
        nomes_pokemons.add("snorlax-normal;N-143");
        nomes_pokemons.add("spearow-normal;voador-21");
        nomes_pokemons.add("squirtle-agua;N-7");
        nomes_pokemons.add("starmie-agua;psiquico-121");
        nomes_pokemons.add("staryu-agua;N-120");
        nomes_pokemons.add("tangela-grama;N-114");
        nomes_pokemons.add("tauros-normal;N-128");
        nomes_pokemons.add("tentacool-agua;venenoso-72");
        nomes_pokemons.add("tentacruel-agua;venenoso-73");
        nomes_pokemons.add("vaporeon-agua;N-134");
        nomes_pokemons.add("venomoth-inseto;venenoso-49");
        nomes_pokemons.add("venonat-inseto;venenoso-48");
        nomes_pokemons.add("venusaur-grama;venenoso-3");
        nomes_pokemons.add("victreebel-grama;venenoso-71");
        nomes_pokemons.add("vileplume-grama;venenoso-45");
        nomes_pokemons.add("voltorb-eletrico;N-100");
        nomes_pokemons.add("vulpix-fogo;N-37");
        nomes_pokemons.add("wartortle-agua;N-8");
        nomes_pokemons.add("weedle-inseto;venenoso-13");
        nomes_pokemons.add("weepinbell-grama;venenoso-70");
        nomes_pokemons.add("weezing-venenoso;N-110");
        nomes_pokemons.add("wigglytuff-normal;N-40");
        nomes_pokemons.add("zapdos-eletrico;voador-145");
        nomes_pokemons.add("zubat-venenoso;voador-41");
    }
    
    @Override
    public void show() {
        Gdx.input.setInputProcessor(controller);

    }
    
    @Override
    public void render(float delta) {

        player.setX(20);
        controller.irParaObjetivo(player, 10, 10);
        
        
        //(LEIA AQUI) Retorna o que tem na posição atual e nas adjacentes    
        System.out.println(map.getTerrenos(player.getX(), player.getY()).getTipo_Objeto());
        
        /*if(player.getY() < 41 && player.getX() < 41 && player.getY() > 0 && player.getX() > 0){
            System.out.println("Norte: " + map.getTerrenos(player.getX(), player.getY() + 1).getTipo_Objeto());
            System.out.println("Sul: " + map.getTerrenos(player.getX(), player.getY() -1).getTipo_Objeto());
            System.out.println("Leste: " + map.getTerrenos(player.getX() + 1, player.getY()).getTipo_Objeto());
            System.out.println("Oeste: " + map.getTerrenos(player.getX() - 1, player.getY()).getTipo_Objeto());
        }*/

        String objeto = map.getTerrenos(player.getX(), player.getY()).getTipo_Objeto();

        if (objeto.equals("treinador")) {
            System.out.println("######Chamada#####");
            if(agente.verificarLutaTreinador(map.getTerrenos(player.getX(), player.getY()).getTreinador())){
                map.getTerrenos(player.getX(), player.getY()).getTreinador().setVisibilidade(false);
                agente.inserirTreinadorNaBase(map.getTerrenos(player.getX(), player.getY()).getTreinador());
                if(agente.enfrentarTreinador()){
                    pontuacao.ganharBatalha();
                    btnScoreTotal.setText("Pontuacao Total: " + pontuacao.getPontuacaoTotal());
                    btnScoreAtual.setText("Custo da Acao: " + pontuacao.getPontuacaoAtual());                  
                    btnAcaoAtual.setText("Acao: Lutar - Vitoria");                                      
                    //System.out.println("Ganhar Batalha");
                }else{
                    pontuacao.perderBatalha();
                    btnScoreTotal.setText("Pontuacao Total: " + pontuacao.getPontuacaoTotal());
                    btnScoreAtual.setText("Custo da Acao: " + pontuacao.getPontuacaoAtual());
                    btnAcaoAtual.setText("Acao: Lutar - Derrota");                
                    System.out.println("Perder Batalha");                    
                }
                agente.atualizarPokemonNaBase();
                //agente.listarPokemonsNaBase();
            }
        } else if (objeto.equals("pokemon")) {
            if(!agente.verificarPokemonNaBase(map.getTerrenos(player.getX(), player.getY()).getPokemon()) &&
               agente.qtdPokebolas() > 0){
                Pokemon pokemon = new Pokemon();
                pokemon = map.getTerrenos(player.getX(), player.getY()).getPokemon();
                map.getTerrenos(player.getX(), player.getY()).getPokemon().setVisibilidade(false);
                //agente.inserirPokemonNaBase(map.getTerrenos(player.getX(), player.getY()).getPokemon());  
                agente.inserirPokemonNaBase(pokemon);  
                player.setPokemons_capturados(1);
                pontuacao.usarPokebola();
                btnScoreTotal.setText("Pontuacao Total: " + pontuacao.getPontuacaoTotal());
                btnScoreAtual.setText("Custo da Acao: " + pontuacao.getPontuacaoAtual());
                btnQtdPokemons.setText("Capturados: " + player.getPokemons_capturados());
                btnNomePokemon.setText("Nome: " + pokemon.getNome());
                btnNumPokemon.setText("Numero: " + pokemon.getNumero());
                //agente.listarPokemonsNaBase();
                Gdx.app.log("Pokemon", "Capturar pokemon");
            }
        } else if(objeto.equals("loja")){
            if(agente.verificarLoja(map.getTerrenos(player.getX(), player.getY()).getLojaPokemon())){
                pontuacao.pegarPokebola();
                btnScoreTotal.setText("Pontuacao Total: " + pontuacao.getPontuacaoTotal());
                btnScoreAtual.setText("Custo da Acao: " + pontuacao.getPontuacaoAtual());
                agente.pegarPokebolas(map.getTerrenos(player.getX(), player.getY()).getLojaPokemon());
                agente.inserirLojaNaBase(map.getTerrenos(player.getX(), player.getY()).getLojaPokemon());
                System.out.println("Recuperar pokebolas");
            }
        } else if(objeto.equals("centroP")){
            agente.inserirCentroNaBase(map.getTerrenos(player.getX(), player.getY()).getCentro_pokemon());
            agente.recuperarPokemons();
            pontuacao.recuprarPokemons();
            btnScoreTotal.setText("Pontuacao Total: " + pontuacao.getPontuacaoTotal());
            btnScoreAtual.setText("Custo da Acao: " + pontuacao.getPontuacaoAtual());
            System.out.println("Recuperar energia dos pokemons");
        } else {
            objeto = "null";
        }
        
        direcao = agente.buscarNaBase(map, player);
        
        if(!direcao.equals("parado")){
            controller.update(delta, direcao);
            player.update(delta);
            pontuacao.mover();
            btnAcaoAtual.setText("Acao: Andando");
            System.out.println("Andar");
        }else{
            pontuacao.virarDireita();
            btnAcaoAtual.setText("Acao: Virar");
        }

        //Descomente para movimentar a câmera
        //camera.update(player.getWorldX() + 0.5f, player.getWorldY() + 0.5f);
        batch.begin();

        float worldStartX = Gdx.graphics.getWidth() / 14 - camera.getCameraX() * Settings.SCALED_TILE_SIZE;
        float worldStartY = Gdx.graphics.getHeight() / 14 - camera.getCameraY() * Settings.SCALED_TILE_SIZE;

        for (int x = 0; x < map.getWidth(); x++) {
            for (int y = 0; y < map.getHeight(); y++) {

                switch (map.getTerrenos(x, y).getTerrain()) {
                    case GRASS_2:
                        render = grass2;
                        break;
                    case MONTANHA:
                        render = montanha;
                        break;
                    case CAVERNA:
                        render = caverna;
                        break;
                    case AGUA:
                        render = agua;
                        break;
                    case VULCAO:
                        render = vulcao;
                        break;
                    default:
                        break;
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

        //Desenha os treinadores na tela 
        for (Treinador trainer : sprites_treinador) {
            if (trainer.isVisibilidade()) {
                batch.draw(trainer.getSprite(),
                        worldStartX + trainer.getWorldX() * Settings.SCALED_TILE_SIZE,
                        worldStartY + trainer.getWorldY() * Settings.SCALED_TILE_SIZE,
                        Settings.SCALED_TILE_SIZE,
                        Settings.SCALED_TILE_SIZE * 1.5f);
            } else {
                switch (map.getTerrenos(trainer.getX(), trainer.getY()).getTerrain()) 
                {
                    case GRASS_2:
                        render = grass2;
                        break;
                    case MONTANHA:
                        render = montanha;
                        break;
                    case CAVERNA:
                        render = caverna;
                        break;
                    case AGUA:
                        render = agua;
                        break;
                    case VULCAO:
                        render = vulcao;
                        break;
                    default:
                        break;                        
                }
                
                batch.draw(render,
                        worldStartX + trainer.getX() * Settings.SCALED_TILE_SIZE,
                        worldStartY + trainer.getY() * Settings.SCALED_TILE_SIZE,
                        Settings.SCALED_TILE_SIZE,
                        Settings.SCALED_TILE_SIZE);
            }
        }

        //Desenha os centros pokemon na tela 
        for (CentroPokemon pokecenter : sprites_pokecenter) {
            batch.draw(pokecenter.getSprite(),
                    worldStartX + pokecenter.getWorldX() * Settings.SCALED_TILE_SIZE,
                    worldStartY + pokecenter.getWorldY() * Settings.SCALED_TILE_SIZE,
                    Settings.SCALED_TILE_SIZE,
                    Settings.SCALED_TILE_SIZE * 1.5f
            );
        }

        //Desenha as Lojas Pokemon na tela 
        for (LojaPokemon pokemart : sprites_pokemart) {
            batch.draw(pokemart.getSprite(),
                    worldStartX + pokemart.getWorldX() * Settings.SCALED_TILE_SIZE,
                    worldStartY + pokemart.getWorldY() * Settings.SCALED_TILE_SIZE,
                    Settings.SCALED_TILE_SIZE,
                    Settings.SCALED_TILE_SIZE * 1.5f
            );
        }

        //Desenha os Pokemons na tela 
        for (Pokemon pokemon : sprites_pokemons) {
            
            if(pokemon.isVisibilidade()){
                batch.draw(pokemon.getSprite(),
                        worldStartX + pokemon.getWorldX() * Settings.SCALED_TILE_SIZE,
                        worldStartY + pokemon.getWorldY() * Settings.SCALED_TILE_SIZE,
                        Settings.SCALED_TILE_SIZE,
                        Settings.SCALED_TILE_SIZE * 1.5f
                );
            }else {
                switch (map.getTerrenos(pokemon.getX(), pokemon.getY()).getTerrain()) 
                {
                    case GRASS_2:
                        render = grass2;
                        break;
                    case MONTANHA:
                        render = montanha;
                        break;
                    case CAVERNA:
                        render = caverna;
                        break;
                    case AGUA:
                        render = agua;
                        break;
                    case VULCAO:
                        render = vulcao;
                        break;
                    default:
                        break;                        
                }
                
                batch.draw(render,
                        worldStartX + pokemon.getX() * Settings.SCALED_TILE_SIZE,
                        worldStartY + pokemon.getY() * Settings.SCALED_TILE_SIZE,
                        Settings.SCALED_TILE_SIZE,
                        Settings.SCALED_TILE_SIZE);
            }
        }
        batch.end();

        stage.draw();
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

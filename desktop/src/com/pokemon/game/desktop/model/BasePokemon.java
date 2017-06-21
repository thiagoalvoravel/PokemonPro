package com.pokemon.game.desktop.model;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.jpl7.Atom;

import org.jpl7.Integer;

import org.jpl7.JPLException;
import org.jpl7.Query;
import org.jpl7.Term;

public class BasePokemon {

    private String nome_arquivo;
    private Query compilar_arquivo;
    /*private String regra;
    private Query executar_regra;
    private Query executar_regra2;
    private Map<String, Term> resultado_regra;
    private Map<String, Term> resultado_regra2;
    private Map<String, Term> resultado_regra3;*/
    private String tipo = "";

    public BasePokemon() {
        
    }
    
    /**
     * Verifica para qual direção o agente pode se mover
     * @param map = Mapa do jogo
     * @param player = Personagem controlado pela IA
     */
    public String buscarNaBase(TileMap map, Actor player) {
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        String regra;
        Query executar_regra;
        Map<String, Term> resultado_regra;
        
        regra = "pode_mover('" + map.getTerrenos(player.getX(), player.getY()).getTerrain().getNome() + "', Pode)";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
        
        if(resultado_regra.get("Pode").name().equals("sim")){            
            regra = "andar(Direcao, 0, -1)";
            executar_regra = new Query(regra);
            resultado_regra = executar_regra.oneSolution();
            tipo = resultado_regra.get("Direcao").name();
        }else{
            //tipo = resultado_regra.get("Pode").name();
            tipo = "oeste";
        }
        return tipo;
    }
    
    /**
     * Método genérico para inserir objetos (pokemon, loja, treinador ou centro) na base
     * @param objeto = Tipo do objeto
     * @param coordX = Coordenada X do objeto no mapa
     * @param coordY = Coordenada Y do objeto no mapa
     */
    public void inserirObjetoNaBase(String objeto, int coordX, int coordY){
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        String regra;
        Query executar_regra;
        Map<String, Term> resultado_regra;
        
        regra = "assert(objeto('"+objeto+"', '"+coordX+"', '"+coordY+"'))";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
    }
    
    /**
     * Capturar o pokemon que o agente encontra
     * @param pokemon = Pokemon para capturar
     */
    public void inserirPokemonNaBase(Pokemon pokemon){
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        String regra;
        Query executar_regra;
        Map<String, Term> resultado_regra;
        
        regra = "assert(pokemon('"+pokemon.getNome()+"', '"+pokemon.getNumero()+"', 'cheia'))";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
        
        regra = "assert(pokemon_tipo('"+pokemon.getNome()+"', '"+pokemon.getTipo()[0]+"', 1))";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
        
        if(!pokemon.getTipo()[1].equals("N")){
            regra = "assert(pokemon_tipo('"+pokemon.getNome()+"', '"+pokemon.getTipo()[1]+"', 2))";
            executar_regra = new Query(regra);
            resultado_regra = executar_regra.oneSolution();
        }
        
        inserirObjetoNaBase("pokemon", pokemon.getX(), pokemon.getY());
        usarPokebola();
    }
    
    /**
     * Atualizar a energia dos pokemons do agente para vazia
     */
    public void atualizarPokemonNaBase(){
        List<Pokemon> pokemons_base = new ArrayList<Pokemon>();
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        String regra;
        Query executar_regra;
        Query executar_regra2;
        Map<String, Term> resultado_regra;
        Map<String, Term> resultado_regra2;
        Map<String, Term> resultado_regra3;
        
        //Integer valor;
        String nome, temp;
        
        //int contador = 1;
        //Integer a;
        
        regra = "get_pokemon(Pokemon, Numero, 'cheia')";
        executar_regra = new Query(regra);
        
        while(executar_regra.hasMoreSolutions()) 
        {
            resultado_regra2 = executar_regra.nextSolution();
            
            if(resultado_regra2.isEmpty()){
                break;
            }
            
            //System.out.println(contador+" - "+resultado_regra2.get("Pokemon").name()+" - "+resultado_regra2.get("Numero").name());
            //contador++;
            
            nome = resultado_regra2.get("Pokemon").name();
            temp = resultado_regra2.get("Numero").name();
            
            Pokemon pokemon_aux = new Pokemon();
            
            pokemon_aux.setNumero(temp);
            pokemon_aux.setNome(nome);
            
            pokemons_base.add(pokemon_aux);
        } 
        
        regra = "retractall(pokemon(_ , _, 'cheia'))";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
        
        regra = "";
        
        //Iterator it = pokemons_base.iterator();
        //while (it.hasNext()){
        for(int i = 0; i < pokemons_base.size(); i++){
            Pokemon p = pokemons_base.get(i);
            //System.out.println("&Interator\n\n\n\n\n");
            regra = "assert(pokemon('"+p.getNome()+"', '"+p.getNumero()+"', 'vazia'))";
            executar_regra2 = new Query(regra);
            resultado_regra3 = executar_regra2.oneSolution();
        }    

        //System.out.println("&Antes\n\n\n\n\n");
         
    }
    
    /**
     * Inserir um treinador na base do agente
     * @param treinador = Pokemon para verificar
     */
    public void inserirTreinadorNaBase(Treinador treinador){
        inserirObjetoNaBase("treinador", treinador.getX(), treinador.getY());        
    }
    
    /**
     * Verificar se o agente irá batahar contra um determinado treinador
     * @param treinador = Treinador para verificar
     */
    public boolean verificarLutaTreinador(Treinador treinador){
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        String regra;
        Query executar_regra;
        Map<String, Term> resultado_regra;
        
        regra = "verificar_treinador_enfrentado('treinador', '"+treinador.getX()+"', '"+treinador.getY()+"', Luta)";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
        
        if(resultado_regra.get("Luta").name().equals("sim")){
            return true;
        }else{ 
            return false;
        }        
        
    }
    
    /**
     * O agente irá batahar contra um determinado treinador
     */
    public boolean enfrentarTreinador(){
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        String regra;
        Query executar_regra;
        Map<String, Term> resultado_regra;
        
        regra = "enfrentar_treinador(Resultado)";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
        
        System.out.println("&&&&&&&&&&&&&&&&&&&\n"+resultado_regra.get("Resultado").name()+"\n&&&&&&&&&&&&&&&&&&&");
        
        if(resultado_regra.get("Resultado").name().equals("vitoria")){
            return true;
        }else{ 
            return false;
        } 
        
    }
    
    /**
     * Acrescentar mais pokebolas do agente quando ele passar por uma loja
     * @param loja = Loja aonde o agente pegar pokebolas
     */
    public void pegarPokebolas(LojaPokemon loja){
        int qtdPokebolas;
        
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        String regra;
        Query executar_regra;
        Map<String, Term> resultado_regra;
        
        regra = "get_pokebolas(Quantidade)";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
        
        qtdPokebolas = resultado_regra.get("Quantidade").intValue();
        
        regra = "retractall(pokebolas(_))";
        executar_regra = new Query(regra);
        executar_regra.oneSolution();
        
        qtdPokebolas += loja.getQtdPokebolas();
        
        regra = "assert(pokebolas("+qtdPokebolas+"))";
        executar_regra = new Query(regra);
        executar_regra.oneSolution();
        
    }
    
    /**
     * Usar pokebola para capturar um pokemon
     */
    public void usarPokebola(){
        int qtdPokebolas;
        
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        String regra;
        Query executar_regra;
        Map<String, Term> resultado_regra;
        
        regra = "get_pokebolas(Quantidade)";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
        
        qtdPokebolas = resultado_regra.get("Quantidade").intValue();
        
        regra = "retractall(pokebolas(_))";
        executar_regra = new Query(regra);
        executar_regra.oneSolution();
        
        qtdPokebolas--;
        
        regra = "assert(pokebolas("+qtdPokebolas+"))";
        executar_regra = new Query(regra);
        executar_regra.oneSolution();
    }
    
    /**
     * Verifica se tem determinada loja na base do agente
     * @param loja = Loja para verificar
     */
    public boolean verificarLoja(LojaPokemon loja){
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        String regra;
        Query executar_regra;
        Map<String, Term> resultado_regra;
        
        regra = "verificar_loja('loja', '"+loja.getX()+"', '"+loja.getY()+"', Pegar)";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
        
        if(resultado_regra.get("Pegar").name().equals("sim")){
            return true;
        }else{ 
            return false;
        } 
        
    }
    
    /**
     * Insere um objeto do tipo loja na base do agente
     * @param loja = Loja a ser inserida na base
     */
    public void inserirLojaNaBase(LojaPokemon loja){
        inserirObjetoNaBase("loja", loja.getX(), loja.getY());        
    }
    
    /**
     * Listar todos os pokemons que estão na base
     */
    public void listarPokemonsNaBase(){
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        String regra;
        Query executar_regra;
        Map<String, Term> resultado_regra;
        
        regra = "aggregate_all(count, pokemon(Nome, Num, Energia), Count)";
        executar_regra = new Query(regra);
        System.out.println("\n********* Total pokemons:" + executar_regra.oneSolution().get("Count")+"*********");
        
        regra = "get_pokemon(Pokemon, Numero, Energia)";
        executar_regra = new Query(regra);
        
        while(executar_regra.hasMoreSolutions()) 
        {
            resultado_regra = executar_regra.nextSolution();
            
            if(resultado_regra.isEmpty()){
                break;
            }
            
            System.out.println("###########################\n"+
                               resultado_regra.get("Pokemon").name()+" - "+
                               resultado_regra.get("Numero").name()+" - "+
                               resultado_regra.get("Energia").name()+
                               "###########################\n");

        }
        
    }
    
    /**
     * Verifica se tem determinado pokemon na base do agente
     * @param pokemon = Pokemon para verificar
     */
    public boolean verificarPokemonNaBase(Pokemon pokemon){
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        String regra;
        Query executar_regra;
        Map<String, Term> resultado_regra;
        
        regra = "tem_pokemon('"+pokemon.getNome()+"', Tem)";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
        
        if(resultado_regra.get("Tem").name().equals("nao")){
            return false;
        }
        else{
            return true;
        }
    }
    
    /**
     * Buscar quantidade de pokebolas atuais
     */
    public int qtdPokebolas(){
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        String regra;
        Query executar_regra;
        Map<String, Term> resultado_regra;
        
        regra = "get_pokebolas(Quantidade)";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
        
        return resultado_regra.get("Quantidade").intValue();
        
    }
    
    /**
     * Iniciar o programa com a quantidade inicial de pokebolas
     * @param qtdInicial = Quantidade de pokeboals inicial 
     */
    public void setPokebolas(int qtdInicial){
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        String regra;
        Query executar_regra;
        Map<String, Term> resultado_regra;
        
        regra = "assert(pokebolas("+qtdInicial+"))";
        executar_regra = new Query(regra);
        executar_regra.oneSolution();
        
    }
    
    /**
     * Inserir um centro pokemon na base do agente
     * @param centroPokemon = Pokemon para verificar
     */
    public void inserirCentroNaBase(CentroPokemon centroPokemon){
        inserirObjetoNaBase("centro", centroPokemon.getX(), centroPokemon.getY());        
    }
    
    /**
     * Recuperar a energia dos pokemons
     */
    public void recuperarPokemons(){
        List<Pokemon> pokemons_base = new ArrayList<Pokemon>();
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        String regra;
        Query executar_regra;
        Query executar_regra2;
        Map<String, Term> resultado_regra2;

        String nome, temp;
        
        regra = "get_pokemon(Pokemon, Numero, 'vazia')";
        executar_regra = new Query(regra);
        
        while(executar_regra.hasMoreSolutions()) 
        {
            resultado_regra2 = executar_regra.nextSolution();
            
            if(resultado_regra2.isEmpty()){
                break;
            }
            
            nome = resultado_regra2.get("Pokemon").name();
            temp = resultado_regra2.get("Numero").name();
            
            Pokemon pokemon_aux = new Pokemon();
            
            pokemon_aux.setNumero(temp);
            pokemon_aux.setNome(nome);
            
            pokemons_base.add(pokemon_aux);
        } 
        
        regra = "retractall(pokemon(_ , _, 'vazia'))";
        executar_regra = new Query(regra);
        executar_regra.oneSolution();
        
        regra = "";
        
        for(int i = 0; i < pokemons_base.size(); i++){
            Pokemon p = pokemons_base.get(i);
            regra = "assert(pokemon('"+p.getNome()+"', '"+p.getNumero()+"', 'cheia'))";
            executar_regra2 = new Query(regra);
            executar_regra2.oneSolution();
        }
    }
    

}

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
            tipo = resultado_regra.get("Pode").name();
        }
        return tipo;
    }
    
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
    }
    
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
        
        Integer valor;
        String nome, temp;
        
        int contador = 1;
        Integer a;
        
        regra = "get_pokemon(Pokemon, Numero, Energia)";
        executar_regra = new Query(regra);
        
        while(executar_regra.hasMoreSolutions()) 
        {
            resultado_regra2 = executar_regra.nextSolution();
            
            if(resultado_regra2.isEmpty()){
                break;
            }
            
            System.out.println(contador+" - "+resultado_regra2.get("Pokemon").name()+" - "+resultado_regra2.get("Numero").name());
            contador++;
            
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
            System.out.println("&Interator\n\n\n\n\n");
            regra = "assert(pokemon('"+p.getNome()+"', '"+p.getNumero()+"', 'vazia'))";
            executar_regra2 = new Query(regra);
            resultado_regra3 = executar_regra2.oneSolution();
        }    

        System.out.println("&Antes\n\n\n\n\n");
         
    }
    
    public void imprimirResultado(){
        /*nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        regra = "get_pokemon(Pokemon, Numero, Energia)";
        executar_regra2 = new Query(regra);
        
        while(executar_regra2.hasMoreSolutions()) 
        {
            
            resultado_regra3 = executar_regra2.nextSolution();
            
            if(!resultado_regra3.isEmpty()){
                break;
            }
            
            System.out.println("###########################\n"+
                               resultado_regra3.get("Pokemon").name()+" - "+
                               resultado_regra3.get("Numero").name()+" - "+
                               resultado_regra3.get("Energia").name()+
                               "###########################\n");
            
        }*/
        System.out.println("!!!Imprimindo!!!");
        
    }
    
    public void inserirTreinadorNaBase(Treinador treinador){
        inserirObjetoNaBase("treinador", treinador.getX(), treinador.getY());        
    }
    
    public boolean enfrentarTreinador(Treinador treinador){
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
    
    public void listarPokemonsNaBase(){
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        String regra;
        Query executar_regra;
        Map<String, Term> resultado_regra;
        
        regra = "get_pokemon(Pokemon, Numero, Energia)";
        executar_regra = new Query(regra);
        
        while(executar_regra.hasMoreSolutions()) 
        {
            
            resultado_regra = executar_regra.nextSolution();
            
            System.out.println("###########################\n"+
                               resultado_regra.get("Pokemon").name()+" - "+
                               resultado_regra.get("Numero").name()+" - "+
                               resultado_regra.get("Energia").name()+
                               "###########################\n");

        }
        
    }
    
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
        
        if(resultado_regra.get("Tem").name().equals("nao")) return false;
        else return true;
    }
    
    

}

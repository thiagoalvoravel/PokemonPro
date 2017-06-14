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
    private String regra;
    private Query executar_regra;
    private Map<String, Term> resultado_regra;
    private Map<String, Term> resultado_regra2;
    private String tipo = "";

    public BasePokemon() {
        
    }

    public String buscarNaBase(TileMap map, Actor player) {
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        regra = "pode_mover('" + map.getTerrenos(player.getX(), player.getY()).getTerrain().getNome() + "', Pode)";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
        
        /*regra = "tem_pokemon('flareson', Tem)";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
        System.out.println(resultado_regra.get("Tem").name());*/
        
        if(resultado_regra.get("Pode").name().equals("sim")){            
            regra = "andar(Direcao, -1, 0)";
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
        
        regra = "assert(objeto("+objeto+", "+coordX+", '"+coordY+"'))";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
    }
    
    public void inserirPokemonNaBase(Pokemon pokemon){
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        regra = "assert(pokemon('"+pokemon.getNome()+"', "+pokemon.getNumero()+", 'cheia'))";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
        
        regra = "assert(pokemon('"+pokemon.getNome()+"', '"+pokemon.getTipo()[0]+"', 1))";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
        
        if(!pokemon.getTipo()[1].equals("N")){
            regra = "assert(pokemon('"+pokemon.getNome()+"', '"+pokemon.getTipo()[1]+"', 2))";
            executar_regra = new Query(regra);
            resultado_regra = executar_regra.oneSolution();
        }
        
        inserirObjetoNaBase("pokemon", pokemon.getX(), pokemon.getY());
    }
    
    public void atualizarPokemonNaBase(Pokemon pokemon){
        List<Pokemon> pokemons_base = new ArrayList<Pokemon>();
        Pokemon pokemon_aux = new Pokemon();
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
       
        regra = "get_pokemon(Pokemon, Numero, Energia)";
        executar_regra = new Query(regra);
        
        Integer valor;
        String nome;
        
        int temp, contador = 1;
        Integer a;
        
        while(executar_regra.hasMoreSolutions()) 
        {
            resultado_regra2 = executar_regra.nextSolution();
            
            if(!resultado_regra2.isEmpty()){
                break;
            }
            
            System.out.println(contador+" - "+resultado_regra2.get("Pokemon").name()+" - "+resultado_regra2.get("Numero").intValue());
            contador++;
            
            nome = resultado_regra2.get("Pokemon").name();
            temp = resultado_regra2.get("Numero").intValue();
            
            //System.out.println(resultado_regra.get("Numero").isFloat());
            //System.out.println(at.intValue());
            //break;
            pokemon_aux.setNumero(temp);
            pokemon_aux.setNome(nome);
            
            pokemons_base.add(pokemon_aux);
        } 
        
        regra = "retractall(pokemon(_ , _, 'cheia'))";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
        
        Iterator it = pokemons_base.iterator();
        int count=1;
        while (it.hasNext()){
            Pokemon p =(Pokemon) it.next();
            
            regra = "assert(pokemon('"+p.getNome()+"', "+p.getNumero()+", 'vazia'))";
            executar_regra = new Query(regra);
            resultado_regra = executar_regra.oneSolution();
            
            count++;
        }    
        
        regra = "get_pokemon(Pokemon, Numero, Energia)";
        executar_regra = new Query(regra);
        
        while(executar_regra.hasMoreSolutions()) 
        {
            resultado_regra2 = executar_regra.nextSolution();
            
            if(!resultado_regra2.isEmpty()){
                break;
            }
            
            System.out.println("###########################\n"+
                               resultado_regra2.get("Pokemon").name()+" - "+
                               resultado_regra2.get("Numero").name()+" - "+
                               resultado_regra2.get("Energia").name()+
                               "###########################\n");
        } 
    }
    
    

}

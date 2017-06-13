package com.pokemon.game.desktop.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.jpl7.JPLException;
import org.jpl7.Query;
import org.jpl7.Term;

public class BasePokemon {

    private String nome_arquivo;
    private Query compilar_arquivo;
    private String regra;
    private Query executar_regra;
    private Map<String, Term> resultado_regra;
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
    
    public void inserirPokemonNaBase(Pokemon pokemon){
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        regra = "assert(pokemon('"+pokemon.getNome()+"', "+pokemon.getNumero()+", cheia))";
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
        
        String obj = "pokemon";
        
        regra = "assert(objeto("+pokemon.getX()+", "+pokemon.getY()+", '"+obj+"'))";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
    }
    
    public void atualizarPokemonNaBase(Pokemon pokemon){
        List<Pokemon> pokemons_base = new ArrayList<Pokemon>();
        Pokemon pokemon_aux = new Pokemon();
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
                
        regra = "pokemon(Pokemon, Numero, Energia)";
        executar_regra = new Query(regra);
        
        //Map<String, Term> resultado_regra;
        
        //resultado_regra = executar_regra.oneSolution();
        //String direcao = resultado_regra.get("Direcao");
        
        while(executar_regra.hasMoreSolutions()) 
        {
            resultado_regra = executar_regra.nextSolution();
            pokemon_aux.setNumero(Integer.parseInt(resultado_regra.get("Numero").name()));
            pokemon_aux.setNome(resultado_regra.get("Pokemon").name());
            pokemon_aux.setEnergia(resultado_regra.get("Energia").name());
            
            pokemons_base.add(pokemon_aux);
        } 
        
        regra = "retractall(pokemon(_ , _, _))";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
    }

}

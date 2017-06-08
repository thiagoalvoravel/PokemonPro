package com.pokemon.game.desktop.model;

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
    
    public void atualizarPokemonNaBase(Pokemon pokemon){
        nome_arquivo = "consult('basepokemon.pl')";
        compilar_arquivo = new Query(nome_arquivo);
        compilar_arquivo.hasSolution();
        
        regra = "assert(pokemon('"+pokemon.getNome()+"', '"+pokemon.getTipo2()+"', "+pokemon.getNumero()+"))";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
        
        String obj = "pokemon";
        
        regra = "assert(objeto("+pokemon.getX()+", "+pokemon.getY()+", '"+obj+"'))";
        executar_regra = new Query(regra);
        resultado_regra = executar_regra.oneSolution();
    }

}

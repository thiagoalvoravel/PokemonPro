package com.pokemon.game.desktop.model;

import java.util.Hashtable;
import java.util.Map;
import org.jpl7.Query;
import org.jpl7.Term;



public class BasePokemon {
    private String nome_arquivo;
    private Query compilar_arquivo;
    private String regra;
    private Query executar_regra;
    private Map<String, Term> resultado_regra;
    
    public BasePokemon()
    {
         nome_arquivo = "consult('basepokemon.pl')";
         compilar_arquivo = new Query(nome_arquivo);
    }
    
    public String buscarNaBase()
    {
        regra = "andar(Direcao, 0, -1)";
        executar_regra = new Query(regra);
        
        resultado_regra = executar_regra.oneSolution();
        //String direcao = resultado_regra.get("Direcao");
        
        //System.out.println(direcao + "\n");
       
        return "down";
    }
    
    
    public static void main(String[] args) 
    {
        String  t1 = "consult('basepokemon.pl')";
        Query q1 = new Query(t1);
        System.out.println(t1 + " " + (q1.hasSolution() ? "correto" : "fallo"));
              
       /* String t2 = "andar(sul)";
        Query q2 = new Query(t2);
        System.out.println(t2 + " is " + (q2.hasSolution() ? "probado": "no probado")); */
             
        String t4 = "andar(Direcao, 0, -1)";
        Query q4 = new Query(t4);
        System.out.println("Solucion para t4 " + t4);
        //Map<String, Term> s4 = q4.oneSolution();
        //String direcao = s4.get("sul");
        
        //System.out.println(s4.get("Direcao"));
        
        
        while( q4.hasMoreSolutions() ) 
        {
            Map<String, Term> s4 = q4.nextSolution();
            //System.out.println("X = " + s4.get("X") + ", Y = " + s4.get("Y"));
            System.out.println(s4.get("Direcao"));
        }  
    }
    
}

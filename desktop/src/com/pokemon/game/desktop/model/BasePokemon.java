package com.pokemon.game.desktop.model;

import java.util.Hashtable;
import java.util.Map;
import org.jpl7.Query;
import org.jpl7.Term;



public class BasePokemon {

    public static void main(String[] args) 
    {
        String  t1 = "consult('bloques.pl')";
        Query q1 = new Query(t1);
        System.out.println(t1 + " " + (q1.hasSolution() ? "correto" : "fallo"));
        String t2 = "encima_de(a,b)";
        Query q2 = new Query(t2);
        System.out.println(t2 + " is " + (q2.hasSolution() ? "probado": "no probado"));
        String t4 = "mas_arriba_de(X,Y)";
        Query q4 = new Query(t4);
        System.out.println("Solucion para t4 " + t4);
        while( q4.hasMoreSolutions() ) 
        {
            Map<String, Term> s4 = q4.nextSolution();
           System.out.println("X = " + s4.get("X") + ", Y = " + s4.get("Y"));
        }   
    }
    
}


package com.pokemon.game.desktop.model;

public class Pontuacao {
    
    private int pontuacaoTotal;
    private PONTOSACAO pontosAcao;

    public Pontuacao() {
    }
    
    public Pontuacao(int pontuacao) {
        this.pontuacaoTotal = pontuacao;
    }
    
    public int getPontuacaoTotal() {
        return this.pontuacaoTotal;
    }

    public void setPontuacaoTotal(int pontuacaoTotal) {
        this.pontuacaoTotal = pontuacaoTotal;
    }
    
    //Métodos para atualizar a pontuacao com base nas ações
    public void ganharBatalha(){
        this.atualizarPontuacao(PONTOSACAO.DERROTAR_TREINADOR);
    }
    
    public void perderBatalha(){
        this.atualizarPontuacao(PONTOSACAO.PERDER_TREINADOR);
    }
    
    public void mover(){
        this.atualizarPontuacao(PONTOSACAO.MOVER);
    }
    
    public void virarEsquerda(){
        this.atualizarPontuacao(PONTOSACAO.VIRAR_ESQUERDA);
    }
    
    public void virarDireita(){
        this.atualizarPontuacao(PONTOSACAO.VIRAR_DIREITA);
    }
    
    public void usarPokebola(){
        this.atualizarPontuacao(PONTOSACAO.USAR_POKEBOLA);
    }
    
    public void pegarPokebola(){
        this.atualizarPontuacao(PONTOSACAO.PEGAR_POKEBOLAS);
    }
    
    public void recuprarPokemons(){
        this.atualizarPontuacao(PONTOSACAO.RECUPERAR_POKEMONS);
    }
    
    public void atualizarPontuacao(PONTOSACAO pontosAcao){
        this.pontuacaoTotal += pontosAcao.getCusto();
    }
    
}

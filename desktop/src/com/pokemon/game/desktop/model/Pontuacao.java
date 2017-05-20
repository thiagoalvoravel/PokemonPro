
package com.pokemon.game.desktop.model;

public class Pontuacao {
    
    private int pontuacaoTotal;
    private int pontuacaoAtual;
    private PONTOSACAO pontosAcao;
    private int pokemons_capturados;

    
    public int getPokemons_capturados() {
        return pokemons_capturados;
    }

    public void setPokemons_capturados(int pokemons_capturados) {
        this.pokemons_capturados = pokemons_capturados;
    }

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
        pontuacaoAtual = 150;
    }
    
    public void perderBatalha(){
        this.atualizarPontuacao(PONTOSACAO.PERDER_TREINADOR);
        pontuacaoAtual = -1000;
    }
    
    public void mover(){
        this.atualizarPontuacao(PONTOSACAO.MOVER);
        pontuacaoAtual = -1;
    }
    
    public void virarEsquerda(){
        this.atualizarPontuacao(PONTOSACAO.VIRAR_ESQUERDA);
        pontuacaoAtual = -1;
    }
    
    public void virarDireita(){
        this.atualizarPontuacao(PONTOSACAO.VIRAR_DIREITA);
        pontuacaoAtual = -1;
    }
    
    public void usarPokebola(){
        this.atualizarPontuacao(PONTOSACAO.USAR_POKEBOLA);
        pontuacaoAtual = -5;
    }
    
    public void pegarPokebola(){
        this.atualizarPontuacao(PONTOSACAO.PEGAR_POKEBOLAS);
        pontuacaoAtual = -10;
    }
    
    public void recuprarPokemons(){
        this.atualizarPontuacao(PONTOSACAO.RECUPERAR_POKEMONS);
        pontuacaoAtual = -100;
    }
    
    public void atualizarPontuacao(PONTOSACAO pontosAcao){
        this.pontuacaoTotal += pontosAcao.getCusto();
    }
    
    public int getPontuacaoAtual()
    {
        return pontuacaoAtual;
    }
    
}

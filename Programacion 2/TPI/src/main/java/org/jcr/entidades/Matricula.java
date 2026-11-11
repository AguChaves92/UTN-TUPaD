package org.jcr.entidades;

public class Matricula {

    private final String numero;

    public Matricula(String numero) {
        this.numero = Validaciones.validarMatricula(numero);
    }

    public String getNumero() {
        return numero;
    }
}

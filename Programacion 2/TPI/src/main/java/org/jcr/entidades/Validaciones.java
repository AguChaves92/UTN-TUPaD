package org.jcr.entidades;

final class Validaciones {

    private Validaciones() {
    }

    static String validarString(String valor, String mensajeError) {
        if (valor == null || valor.isBlank()) {
            throw new IllegalArgumentException(mensajeError);
        }
        return valor.trim();
    }

    static String validarDni(String dni) {
        if (dni == null || !dni.matches("\\d{7,8}")) {
            throw new IllegalArgumentException("El DNI debe tener 7 u 8 dígitos");
        }
        return dni;
    }

    static String validarMatricula(String numero) {
        if (numero == null || !numero.matches("MP-\\d{4,6}")) {
            throw new IllegalArgumentException(
                    "La matrícula debe tener el formato MP- seguido de 4 a 6 dígitos");
        }
        return numero;
    }

    static void noNulo(Object valor, String mensajeError) {
        if (valor == null) {
            throw new IllegalArgumentException(mensajeError);
        }
    }
}

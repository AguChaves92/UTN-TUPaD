package org.jcr.entidades;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Sala {

    private final String numero;
    private final String tipo;
    private final Departamento departamento;
    private final List<Cita> citas = new ArrayList<>();

    Sala(String numero, String tipo, Departamento departamento) {
        this.numero = Validaciones.validarString(numero, "El número de la sala no puede estar vacío");
        this.tipo = Validaciones.validarString(tipo, "El tipo de la sala no puede estar vacío");
        if (departamento == null) {
            throw new IllegalArgumentException("El departamento de la sala no puede ser nulo");
        }
        this.departamento = departamento;
    }

    public String getNumero() {
        return numero;
    }

    public String getTipo() {
        return tipo;
    }

    public Departamento getDepartamento() {
        return departamento;
    }

    public void addCita(Cita cita) {
        if (cita == null) {
            throw new IllegalArgumentException("La cita no puede ser nula");
        }
        if (!citas.contains(cita)) {
            citas.add(cita);
        }
    }

    public List<Cita> getCitas() {
        return Collections.unmodifiableList(citas);
    }
}

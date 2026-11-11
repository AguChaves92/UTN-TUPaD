package org.jcr.entidades;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class HistoriaClinica {

    private final String numeroHistoria;
    private final Paciente paciente;
    private final LocalDate fechaCreacion;
    private final List<String> diagnosticos = new ArrayList<>();
    private final List<String> tratamientos = new ArrayList<>();
    private final List<String> alergias = new ArrayList<>();

    HistoriaClinica(Paciente paciente) {
        this.paciente = paciente;
        this.fechaCreacion = LocalDate.now();
        this.numeroHistoria = generarNumeroHistoria(paciente.getDni(), fechaCreacion);
    }

    private static String generarNumeroHistoria(String dni, LocalDate fechaCreacion) {
        return "HC-" + dni + "-" + fechaCreacion.getYear();
    }

    public String getNumeroHistoria() {
        return numeroHistoria;
    }

    public Paciente getPaciente() {
        return paciente;
    }

    public void agregarDiagnostico(String diagnostico) {
        agregarSiTieneTexto(diagnosticos, diagnostico);
    }

    public void agregarTratamiento(String tratamiento) {
        agregarSiTieneTexto(tratamientos, tratamiento);
    }

    public void agregarAlergia(String alergia) {
        agregarSiTieneTexto(alergias, alergia);
    }

    public List<String> getDiagnosticos() {
        return Collections.unmodifiableList(diagnosticos);
    }

    public List<String> getTratamientos() {
        return Collections.unmodifiableList(tratamientos);
    }

    public List<String> getAlergias() {
        return Collections.unmodifiableList(alergias);
    }

    private static void agregarSiTieneTexto(List<String> lista, String valor) {
        if (valor != null && !valor.isBlank()) {
            lista.add(valor.trim());
        }
    }
}

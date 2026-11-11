package org.jcr.entidades;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Hospital {

    private final String nombre;
    private final String direccion;
    private final String telefono;
    private final List<Paciente> pacientes = new ArrayList<>();

    public Hospital(String nombre, String direccion, String telefono) {
        this.nombre = Validaciones.validarString(nombre, "El nombre del hospital no puede estar vacío");
        this.direccion = Validaciones.validarString(direccion, "La dirección del hospital no puede estar vacía");
        this.telefono = Validaciones.validarString(telefono, "El teléfono del hospital no puede estar vacío");
    }

    public String getNombre() {
        return nombre;
    }

    public String getDireccion() {
        return direccion;
    }

    public String getTelefono() {
        return telefono;
    }

    public void agregarPaciente(Paciente paciente) {
        if (paciente == null) {
            throw new IllegalArgumentException("El paciente no puede ser nulo");
        }
        paciente.setHospital(this);
    }

    public List<Paciente> getPacientes() {
        return Collections.unmodifiableList(pacientes);
    }

    void vincularPaciente(Paciente paciente) {
        if (!pacientes.contains(paciente)) {
            pacientes.add(paciente);
        }
    }

    void desvincularPaciente(Paciente paciente) {
        pacientes.remove(paciente);
    }
}

package org.jcr.entidades;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Hospital {

    private final String nombre;
    private final String direccion;
    private final String telefono;
    private final List<Departamento> departamentos = new ArrayList<>();
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

    public void agregarDepartamento(Departamento departamento) {
        if (departamento == null) {
            throw new IllegalArgumentException("El departamento no puede ser nulo");
        }
        departamento.setHospital(this);
    }

    public List<Departamento> getDepartamentos() {
        return Collections.unmodifiableList(departamentos);
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

    void vincularDepartamento(Departamento departamento) {
        if (!departamentos.contains(departamento)) {
            departamentos.add(departamento);
        }
    }

    void desvincularDepartamento(Departamento departamento) {
        departamentos.remove(departamento);
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

package org.jcr.entidades;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import org.jcr.enums.EspecialidadMedica;

public class Departamento {

    private final String nombre;
    private final EspecialidadMedica especialidad;
    private Hospital hospital;
    private final List<Medico> medicos = new ArrayList<>();
    private final List<Sala> salas = new ArrayList<>();

    public Departamento(String nombre, EspecialidadMedica especialidad) {
        this.nombre = Validaciones.validarString(nombre, "El nombre del departamento no puede estar vacío");
        if (especialidad == null) {
            throw new IllegalArgumentException("La especialidad no puede ser nula");
        }
        this.especialidad = especialidad;
    }

    public String getNombre() {
        return nombre;
    }

    public EspecialidadMedica getEspecialidad() {
        return especialidad;
    }

    public Hospital getHospital() {
        return hospital;
    }

    public void setHospital(Hospital hospital) {
        if (this.hospital == hospital) {
            return;
        }
        if (this.hospital != null) {
            this.hospital.desvincularDepartamento(this);
        }
        this.hospital = hospital;
        if (hospital != null) {
            hospital.vincularDepartamento(this);
        }
    }

    public void agregarMedico(Medico medico) {
        if (medico == null) {
            throw new IllegalArgumentException("El médico no puede ser nulo");
        }
        medico.setDepartamento(this);
    }

    public List<Medico> getMedicos() {
        return Collections.unmodifiableList(medicos);
    }

    public Sala crearSala(String numero, String tipo) {
        Sala sala = new Sala(numero, tipo, this);
        salas.add(sala);
        return sala;
    }

    public List<Sala> getSalas() {
        return Collections.unmodifiableList(salas);
    }

    void vincularMedico(Medico medico) {
        if (!medicos.contains(medico)) {
            medicos.add(medico);
        }
    }

    void desvincularMedico(Medico medico) {
        medicos.remove(medico);
    }
}

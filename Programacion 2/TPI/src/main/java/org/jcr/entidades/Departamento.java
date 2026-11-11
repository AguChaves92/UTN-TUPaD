package org.jcr.entidades;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import org.jcr.enums.EspecialidadMedica;

public class Departamento {

    private final String nombre;
    private final EspecialidadMedica especialidad;
    private final List<Medico> medicos = new ArrayList<>();

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

    public void agregarMedico(Medico medico) {
        if (medico == null) {
            throw new IllegalArgumentException("El médico no puede ser nulo");
        }
        medico.setDepartamento(this);
    }

    public List<Medico> getMedicos() {
        return Collections.unmodifiableList(medicos);
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

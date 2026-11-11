package org.jcr.entidades;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import org.jcr.enums.TipoSangre;

public class Paciente extends Persona {

    private final HistoriaClinica historiaClinica;
    private final String telefono;
    private final String direccion;
    private Hospital hospital;
    private final List<Cita> citas = new ArrayList<>();

    public Paciente(String nombre, String apellido, String dni, LocalDate fechaNacimiento,
                    TipoSangre tipoSangre, String telefono, String direccion) {
        super(nombre, apellido, dni, fechaNacimiento, tipoSangre);
        this.telefono = Validaciones.validarString(telefono, "El teléfono no puede estar vacío");
        this.direccion = Validaciones.validarString(direccion, "La dirección no puede estar vacía");
        this.historiaClinica = new HistoriaClinica(this);
    }

    public HistoriaClinica getHistoriaClinica() {
        return historiaClinica;
    }

    public String getTelefono() {
        return telefono;
    }

    public String getDireccion() {
        return direccion;
    }

    public Hospital getHospital() {
        return hospital;
    }

    public void setHospital(Hospital hospital) {
        if (this.hospital == hospital) {
            return;
        }
        if (this.hospital != null) {
            this.hospital.desvincularPaciente(this);
        }
        this.hospital = hospital;
        if (hospital != null) {
            hospital.vincularPaciente(this);
        }
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

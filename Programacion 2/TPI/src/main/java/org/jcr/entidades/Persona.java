package org.jcr.entidades;

import java.time.LocalDate;
import java.time.Period;
import org.jcr.enums.TipoSangre;

public abstract class Persona {

    private final String nombre;
    private final String apellido;
    private final String dni;
    private final LocalDate fechaNacimiento;
    private final TipoSangre tipoSangre;

    public Persona(String nombre, String apellido, String dni, LocalDate fechaNacimiento, TipoSangre tipoSangre) {
        this.nombre = Validaciones.validarString(nombre, "El nombre no puede estar vacío");
        this.apellido = Validaciones.validarString(apellido, "El apellido no puede estar vacío");
        this.dni = Validaciones.validarDni(dni);
        if (fechaNacimiento == null) {
            throw new IllegalArgumentException("La fecha de nacimiento no puede ser nula");
        }
        if (tipoSangre == null) {
            throw new IllegalArgumentException("El tipo de sangre no puede ser nulo");
        }
        this.fechaNacimiento = fechaNacimiento;
        this.tipoSangre = tipoSangre;
    }

    public String getNombre() {
        return nombre;
    }

    public String getApellido() {
        return apellido;
    }

    public String getDni() {
        return dni;
    }

    public LocalDate getFechaNacimiento() {
        return fechaNacimiento;
    }

    public TipoSangre getTipoSangre() {
        return tipoSangre;
    }

    public String getNombreCompleto() {
        return nombre + " " + apellido;
    }

    public int getEdad() {
        return Period.between(fechaNacimiento, LocalDate.now()).getYears();
    }
}

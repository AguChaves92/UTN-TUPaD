package org.jcr.entidades;

import java.time.LocalDate;
import org.jcr.enums.TipoSangre;

public abstract class Persona {

    private String nombre;
    private String apellido;
    private String dni;
    private LocalDate fechaNacimiento;
    private TipoSangre tipoSangre;

    public Persona(String nombre, String apellido, String dni, LocalDate fechaNacimiento, TipoSangre tipoSangre) {
        this.nombre = nombre;
        this.apellido = apellido;
        this.dni = dni;
        this.fechaNacimiento = fechaNacimiento;
        this.tipoSangre = tipoSangre;
    }
}

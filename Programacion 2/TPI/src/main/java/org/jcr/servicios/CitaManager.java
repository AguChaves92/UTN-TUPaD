package org.jcr.servicios;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import org.jcr.entidades.Cita;
import org.jcr.entidades.Medico;
import org.jcr.entidades.Paciente;
import org.jcr.entidades.Sala;
import org.jcr.excepciones.CitaException;

public class CitaManager implements CitaService {

    private static final int HORAS_ENTRE_CITAS = 2;
    private final List<Cita> citas = new ArrayList<>();

    @Override
    public Cita programarCita(Paciente paciente, Medico medico, Sala sala,
                              LocalDateTime fechaHora, double costo) throws CitaException {
        throw new CitaException("La programación de citas todavía no está implementada");
    }

    @Override
    public List<Cita> getCitasPorPaciente(Paciente paciente) {
        List<Cita> resultado = new ArrayList<>();
        for (Cita cita : citas) {
            if (cita.getPaciente() == paciente) {
                resultado.add(cita);
            }
        }
        return Collections.unmodifiableList(resultado);
    }

    @Override
    public List<Cita> getCitasPorMedico(Medico medico) {
        List<Cita> resultado = new ArrayList<>();
        for (Cita cita : citas) {
            if (cita.getMedico() == medico) {
                resultado.add(cita);
            }
        }
        return Collections.unmodifiableList(resultado);
    }

    @Override
    public List<Cita> getCitasPorSala(Sala sala) {
        List<Cita> resultado = new ArrayList<>();
        for (Cita cita : citas) {
            if (cita.getSala() == sala) {
                resultado.add(cita);
            }
        }
        return Collections.unmodifiableList(resultado);
    }
}

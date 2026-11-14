package org.jcr.servicios;

import java.time.Duration;
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
        if (paciente == null || medico == null || sala == null) {
            throw new CitaException("El paciente, el médico y la sala son obligatorios");
        }
        if (fechaHora == null || fechaHora.isBefore(LocalDateTime.now())) {
            throw new CitaException("La fecha de la cita debe ser futura");
        }
        if (costo <= 0) {
            throw new CitaException("El costo debe ser mayor que cero");
        }
        if (medico.getEspecialidad() != sala.getDepartamento().getEspecialidad()) {
            throw new CitaException("La especialidad del médico no coincide con la del departamento de la sala");
        }
        if (hayCitaDemasiadoCerca(getCitasPorMedico(medico), fechaHora)) {
            throw new CitaException("El médico ya tiene una cita a menos de " + HORAS_ENTRE_CITAS + " horas");
        }
        if (hayCitaDemasiadoCerca(getCitasPorSala(sala), fechaHora)) {
            throw new CitaException("La sala ya tiene una cita a menos de " + HORAS_ENTRE_CITAS + " horas");
        }

        Cita cita = new Cita(paciente, medico, sala, fechaHora, costo);
        citas.add(cita);
        paciente.addCita(cita);
        medico.addCita(cita);
        sala.addCita(cita);
        return cita;
    }

    private boolean hayCitaDemasiadoCerca(List<Cita> existentes, LocalDateTime fechaHora) {
        Duration minimo = Duration.ofHours(HORAS_ENTRE_CITAS);
        for (Cita existente : existentes) {
            Duration diferencia = Duration.between(existente.getFechaHora(), fechaHora).abs();
            if (diferencia.compareTo(minimo) < 0) {
                return true;
            }
        }
        return false;
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

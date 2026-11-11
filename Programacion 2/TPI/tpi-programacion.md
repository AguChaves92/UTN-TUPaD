# TPI — Programación 2: Sistema de Gestión Hospitalaria

Documento de trabajo armado a partir del enunciado `Programacion_2_TPI.pdf`. Resume qué hay que construir, con qué firmas y bajo qué reglas. No reemplaza el enunciado ni el diagrama completo (`UmlHospital.png`), que se publica aparte y no vino en el PDF.

## 1. De qué se trata

Hay que implementar en Java el modelo de objetos de un hospital y dejarlo listo para el programa de pruebas de la cátedra.

El hospital organiza departamentos, salas, médicos y pacientes, y programa citas médicas sin superposiciones de horario. Las clases respetan el diagrama de la sección 3 del enunciado y las reglas de la sección 4.

El sistema trabaja solo en memoria. Los datos existen mientras el programa se ejecuta. No se guardan en archivos ni en bases de datos.

La cátedra entrega `MainPruebas.java`. Ese archivo crea objetos, ejecuta operaciones y verifica los resultados. El proyecto tiene que compilar junto con ese archivo y mostrar todas sus verificaciones en `[OK]`. Solo se puede adaptar `package` e `imports`.

El trabajo puede hacerse de forma individual o en pareja. La pareja es opcional. La entrega es individual: cada estudiante sube su propio ZIP y su propio video.

## 2. Qué se practica

| Unidad | Contenido | Dónde aparece |
| --- | --- | --- |
| U3 · Introducción a POO | Atributos privados, getters, validación en el constructor | Todas las clases de entidades |
| U4 · POO | Constructores, `this`, constantes `static` | Constructores con validación; `HORAS_ENTRE_CITAS` en `CitaManager` |
| U5 · UML básico | Asociación, agregación, composición, relaciones bidireccionales | Hospital–Departamento, Departamento–Sala, Paciente–HistoriaClinica, Cita |
| U6 · Colecciones | `ArrayList`, for-each, búsqueda y filtrado, enumeraciones | Listas de cada clase; `getCitasPorPaciente()`; `TipoSangre`, `EspecialidadMedica`, `EstadoCita` |
| U7 · Herencia y polimorfismo | Clase abstracta, herencia, `super`, interfaces | `Persona`, `Paciente`, `Medico`; `CitaService` y `CitaManager` |
| U8 · Interfaces y excepciones | Lanzar, capturar y definir excepciones; verificadas y no verificadas | `IllegalArgumentException` en constructores; `CitaException` en `programarCita()` |

## 3. Reglas técnicas

### 3.1 Qué se usa

- Java 17 o superior, solo la biblioteca estándar.
- Colecciones: `ArrayList`, `List` y `Collections` (`java.util`).
- Fechas: `LocalDate` y `LocalDateTime` (`java.time`).

Métodos de fecha que alcanza usar:

| Método | Qué hace |
| --- | --- |
| `LocalDate.now()` / `LocalDateTime.now()` | Fecha, o fecha y hora, actuales |
| `LocalDate.of(1985, 12, 5)` | Crea una fecha: año, mes, día |
| `fecha.getYear()` | Año de la fecha |
| `fecha.plusYears(n)` | Fecha nueva, n años después |
| `momento.plusHours(n)` / `momento.minusHours(n)` | Momento nuevo, n horas después o antes |
| `a.isBefore(b)` / `a.isAfter(b)` | Indica si `a` es anterior o posterior a `b` |

Esos métodos no modifican el objeto original: siempre devuelven uno nuevo.

```java
LocalDateTime turno = LocalDateTime.of(2026, 11, 20, 10, 0); // 20/11/2026 10:00
LocalDateTime dosHorasDespues = turno.plusHours(2);          // 20/11/2026 12:00
boolean esPasado = turno.isBefore(LocalDateTime.now());
```

Para saber si un carácter es dígito: `Character.isDigit(c)`. Para el prefijo de la matrícula: `numero.startsWith("MP-")`. No hacen falta expresiones regulares.

### 3.2 Qué queda fuera

- Archivos, bases de datos y cualquier otra persistencia.
- Bibliotecas externas (por ejemplo Lombok, JPA o Hibernate).
- `Map`, streams, expresiones lambda y clases genéricas propias. El trabajo se resuelve con lo visto hasta la Unidad 8.

Las reglas tienen que resolverse en general. Una regla que reconoce los datos de `MainPruebas` para dar la respuesta esperada no suma puntos.

## 4. Organización del proyecto

El paquete base de referencia es `org.jcr`. Con esa estructura, `MainPruebas.java` se usa sin adaptar imports. El nombre del proyecto y el paquete base son libres. Si se cambia el paquete base, se ajustan solo `package` e `imports` de `MainPruebas.java`.

```text
src/main/java/org/jcr/
├── MainPruebas.java          (provisto por la cátedra)
├── entidades/
│   Persona, Paciente, Medico, Matricula, HistoriaClinica,
│   Hospital, Departamento, Sala, Cita
├── enums/
│   TipoSangre, EspecialidadMedica, EstadoCita
├── servicios/
│   CitaService, CitaManager
└── excepciones/
    CitaException
```

Se pueden agregar clases auxiliares. Se conservan las pruebas y los nombres y firmas de clases, constructores y métodos de la sección 3.

Los nombres del enunciado están en español (`Paciente`, `programarCita`, `agregarDepartamento`). Esas firmas son las que `MainPruebas` va a buscar.

## 5. Modelo de clases

Leyenda del diagrama:

- Rombo lleno: composición. La parte no existe sin el todo.
- Rombo vacío: agregación.
- Triángulo: herencia.
- Línea punteada con triángulo: una clase implementa una interfaz.

El diagrama completo, con todos los atributos y métodos, está en `UmlHospital.png`. Las tablas de abajo son lo que el PDF exige que cada clase ofrezca. Si el PNG agrega algún miembro, manda el PNG junto con estas firmas.

### 5.1 Estructura del hospital

```text
Persona (abstracta)
├── Paciente
└── Medico

Hospital 1 ──contiene (agregación)── 0..* Departamento
Hospital 1 ──registra (agregación)── 0..* Paciente

Departamento 0..1 ──emplea (agregación)── 0..* Medico
Departamento ──tiene (composición)── 0..* Sala

Paciente 1 ──posee (composición)── 1 HistoriaClinica
Medico   1 ──tiene (composición)── 1 Matricula
```

Un departamento pertenece a lo sumo a un hospital. Un paciente, también. Un médico pertenece a lo sumo a un departamento. La sala, la historia clínica y la matrícula las crea su dueño.

### 5.2 Citas y servicio

```text
CitaService (interfaz)
    ▲
    │ implementa
CitaManager ──gestiona── 0..* Cita
    │ «throws»
    ▼
CitaException ──extiende── Exception

Paciente 1 ── 0..* Cita
Medico   1 ── 0..* Cita
Sala     1 ── 0..* Cita
Cita ──usa── EstadoCita
```

Atributos de `Cita` que muestra el diagrama:

- `paciente: Paciente`
- `medico: Medico`
- `sala: Sala`
- `fechaHora: LocalDateTime`
- `costo: double`
- `estado: EstadoCita`
- `observaciones: String`

## 6. Enumeraciones (`org.jcr.enums`)

Cada constante guarda una descripción, que se obtiene con `getDescripcion()`.

### `TipoSangre`

| Constante | Descripción |
| --- | --- |
| `A_POSITIVO` | A+ |
| `A_NEGATIVO` | A- |
| `B_POSITIVO` | B+ |
| `B_NEGATIVO` | B- |
| `AB_POSITIVO` | AB+ |
| `AB_NEGATIVO` | AB- |
| `O_POSITIVO` | O+ |
| `O_NEGATIVO` | O- |

### `EspecialidadMedica`

| Constante | Descripción |
| --- | --- |
| `CARDIOLOGIA` | Cardiología |
| `NEUROLOGIA` | Neurología |
| `PEDIATRIA` | Pediatría |
| `TRAUMATOLOGIA` | Traumatología |
| `GINECOLOGIA` | Ginecología |
| `UROLOGIA` | Urología |
| `OFTALMOLOGIA` | Oftalmología |
| `DERMATOLOGIA` | Dermatología |
| `PSIQUIATRIA` | Psiquiatría |
| `MEDICINA_GENERAL` | Medicina General |
| `CIRUGIA_GENERAL` | Cirugía General |
| `ANESTESIOLOGIA` | Anestesiología |

### `EstadoCita`

| Constante | Descripción |
| --- | --- |
| `PROGRAMADA` | Programada |
| `EN_CURSO` | En Curso |
| `COMPLETADA` | Completada |
| `CANCELADA` | Cancelada |
| `NO_ASISTIO` | No Asistió |

## 7. Clases y firmas

### 7.1 Personas (`org.jcr.entidades`)

**`Persona` (abstracta)**

```text
Persona(String nombre, String apellido, String dni, LocalDate fechaNacimiento, TipoSangre tipoSangre)
```

- Getters de los cinco datos.
- `getNombreCompleto()`: nombre y apellido separados por un espacio.
- `getEdad()`: años cumplidos hoy. Si este año el cumpleaños todavía no llegó, devuelve un año menos.

La checklist del enunciado permite atributos privados, o protegidos en `Persona`. El criterio de herencia pide atributos privados con getters.

**`Paciente` extiende `Persona`**

Constructor con los datos de `Persona` más `String telefono` y `String direccion`. Al crearse, crea su propia `HistoriaClinica`.

- `getHistoriaClinica()`
- `getTelefono()`
- `getDireccion()`
- `getHospital()`
- `setHospital(Hospital)`
- `addCita(Cita)`
- `getCitas()`

**`Medico` extiende `Persona`**

Constructor con los datos de `Persona` más `String numeroMatricula` y `EspecialidadMedica especialidad`. Al crearse, crea su propia `Matricula`.

- `getMatricula()`
- `getEspecialidad()`
- `getDepartamento()`
- `setDepartamento(Departamento)`
- `addCita(Cita)`
- `getCitas()`

**`Matricula`**

La crea el médico.

```text
Matricula(String numero)
getNumero()
```

**`HistoriaClinica`**

La crea solo el paciente. Su constructor no es público.

- `getNumeroHistoria()` devuelve `HC-` + DNI + `-` + año de creación. Ejemplo: `HC-11111111-2026`.
- `getPaciente()`
- `agregarDiagnostico(String)`
- `agregarTratamiento(String)`
- `agregarAlergia(String)`
- Getters de las tres listas.

### 7.2 Hospital, departamentos y salas (`org.jcr.entidades`)

**`Hospital`**

```text
Hospital(String nombre, String direccion, String telefono)
```

Getters de esos tres datos, más:

- `agregarDepartamento(Departamento)`
- `agregarPaciente(Paciente)`
- `getDepartamentos()`
- `getPacientes()`

**`Departamento`**

```text
Departamento(String nombre, EspecialidadMedica especialidad)
```

- `getNombre()`
- `getEspecialidad()`
- `getHospital()`
- `setHospital(Hospital)`
- `agregarMedico(Medico)`
- `crearSala(String numero, String tipo)`: devuelve la sala creada
- `getMedicos()`
- `getSalas()`

**`Sala`**

La crea solo `Departamento.crearSala()`. Su constructor no es público.

- `getNumero()`
- `getTipo()`
- `getDepartamento()`
- `addCita(Cita)`
- `getCitas()`

### 7.3 Citas (`entidades`, `servicios`, `excepciones`)

**`Cita`**

```text
Cita(Paciente paciente, Medico medico, Sala sala, LocalDateTime fechaHora, double costo)
```

Empieza en estado `PROGRAMADA` y con observaciones vacías (`""`).

- Getters de todos los datos.
- `setEstado(EstadoCita)`
- `setObservaciones(String)`

**`CitaService` (interfaz)**

```text
Cita programarCita(Paciente, Medico, Sala, LocalDateTime fechaHora, double costo) throws CitaException
List<Cita> getCitasPorPaciente(Paciente)
List<Cita> getCitasPorMedico(Medico)
List<Cita> getCitasPorSala(Sala)
```

**`CitaManager`**

Implementa `CitaService` y guarda las citas en un `ArrayList`. Acá vive la constante `static` `HORAS_ENTRE_CITAS`.

**`CitaException`**

Excepción verificada: extiende `Exception`.

```text
CitaException(String message)
CitaException(String message, Throwable cause)
```

## 8. Reglas del sistema

### 8.1 Validaciones al crear y modificar

El dato inválido se rechaza en el momento. El objeto no llega a crearse. Si el rechazo es en un setter, el estado anterior se conserva.

| Situación | Qué pasa |
| --- | --- |
| Texto obligatorio nulo, vacío o con solo espacios: nombre, apellido, teléfono, dirección, nombre del hospital o del departamento, número o tipo de sala | `IllegalArgumentException` |
| El DNI no tiene 7 u 8 caracteres, o alguno no es un dígito | `IllegalArgumentException` |
| La matrícula no es `MP-` seguido de 4 a 6 dígitos (válidas: `MP-1234`, `MP-123456`) | `IllegalArgumentException` |
| La fecha de nacimiento, el tipo de sangre o la especialidad son nulos | `IllegalArgumentException` |
| Se crea una `Cita` con paciente, médico, sala o fecha nulos | `IllegalArgumentException` |
| `setEstado(null)` en una cita | `IllegalArgumentException`; el estado anterior no cambia |
| `setObservaciones(null)` en una cita | Sin excepción; las observaciones quedan vacías (`""`) |
| Diagnóstico, tratamiento o alergia nulos o vacíos | Sin excepción; no se registran |

### 8.2 Relaciones bidireccionales

En Hospital–Departamento, Hospital–Paciente y Departamento–Médico, las dos puntas se mantienen sincronizadas.

- `hospital.agregarDepartamento(d)` deja a `d` una sola vez en la lista del hospital, y `d.getHospital()` devuelve ese hospital. Agregarlo dos veces no lo duplica.
- Cambiar desde la otra punta también funciona: `d.setHospital(otro)` saca a `d` de la lista del hospital anterior y lo agrega a la del nuevo. Lo mismo vale para pacientes y para médicos.
- Un médico solo puede entrar en un departamento de su misma especialidad. Si no coincide, se lanza `IllegalArgumentException` y el médico no cambia de departamento.

Una forma de resolverlo es que el método de una punta delegue en el de la otra, y que un solo método actualice las dos listas:

```java
public void setHospital(Hospital hospital) {
    if (this.hospital != hospital) {
        // 1. Salir de la lista del hospital anterior (si había)
        // 2. Guardar la nueva referencia
        // 3. Entrar en la lista del nuevo hospital (si no es null)
    }
}
```

En las composiciones, la parte la crea su dueño:

- `Paciente` crea su `HistoriaClinica`.
- `Medico` crea su `Matricula`.
- `Departamento` crea sus salas con `crearSala()`.

Las listas que devuelven los getters no permiten modificar el objeto desde afuera. Se puede devolver `Collections.unmodifiableList(lista)` o una copia de la lista.

### 8.3 Programación de citas

`programarCita()` lanza `CitaException` y no registra nada cuando:

- el paciente, el médico o la sala son nulos;
- la fecha es nula o ya pasó;
- el costo es 0 o negativo;
- la especialidad del médico no coincide con la del departamento de la sala;
- el médico ya tiene otra cita a menos de 2 horas, antes o después;
- la sala ya tiene otra cita a menos de 2 horas, antes o después.

Si todo es válido, crea la cita, la guarda y la registra en el paciente, el médico y la sala con `addCita()`.

`getCitasPorPaciente`, `getCitasPorMedico` y `getCitasPorSala` devuelven una lista vacía cuando no hay citas. Nunca devuelven `null`.

La separación de 2 horas se mide en las dos direcciones. Si el médico tiene una cita a las 10:00:

| Nueva cita del mismo médico | Resultado |
| --- | --- |
| 8:30 u 11:30 (1 h 30 min de diferencia) | Se rechaza con `CitaException` |
| 8:00 o 12:00 (exactamente 2 horas) | Se acepta |
| 10:00 del día siguiente | Se acepta |

## 9. Programa de pruebas

`MainPruebas.java` se publica junto con el enunciado. La ruta de referencia es `src/main/java/org/jcr/`. Con otro paquete base, se adaptan `package` e `imports` y se ejecuta desde el IDE.

- Solo se adaptan `package` e `imports`. La lógica de las pruebas no cambia.
- Si no compila, el mensaje del compilador (por ejemplo `cannot find symbol`) indica qué clase o método falta, o qué firma no coincide con la sección 3.
- Hace 106 verificaciones agrupadas en 10 temas: enumeraciones, herencia, validaciones, matrícula, historia clínica, relaciones bidireccionales, departamentos y salas, citas, programación de citas y disponibilidad.
- Si un grupo lanza una excepción inesperada, se cuenta como falla y se sigue con el próximo.

Salida esperada, de forma esquemática:

```text
===== PRUEBAS DEL SISTEMA DE GESTIÓN HOSPITALARIA =====
--- 1. Enumeraciones ---
[OK]    TipoSangre tiene 8 valores
[OK]    TipoSangre.A_POSITIVO se describe como "A+"
...
--- 10. Disponibilidad de médicos y salas (2 horas entre citas) ---
[OK]    El mismo médico 1 h 30 min después lanza CitaException
[FALLA] El mismo médico exactamente 2 horas después debería aceptarse
...
===== RESULTADO: 105 de 106 verificaciones correctas =====
Hay 1 verificación con [FALLA]. Revisarla arriba.
```

Cada `[FALLA]` describe qué se esperaba. Conviene corregir los grupos en orden: un error en las primeras clases suele arrastrar fallas en los grupos siguientes.

Pasar todas las pruebas es necesario, y la corrección también revisa el diseño del código.

## 10. Entrega

- Un único archivo `Apellido_TPI_P2.zip`, con el apellido de quien entrega.
- Contiene el proyecto completo y `MainPruebas.java`.
- Sin carpetas generadas por el IDE o la compilación: `build`, `bin`, `out`, `.idea`.
- Un video explicativo de 10 a 15 minutos, publicado en YouTube o Drive.
- Cada estudiante sube su ZIP y, en los comentarios de la entrega, deja el link del video en la fecha que publique la cátedra.

El video muestra el sistema en funcionamiento:

- La corrida de `MainPruebas` con sus resultados.
- Cómo está resuelto el código: las clases, sus relaciones y las reglas de la sección 4.
- Es individual, aunque hayan colaborado en pareja.
- Conviene mostrar el código con tamaño de letra de 20 o más y fondo blanco, para que se lea en el video.

## 11. Evaluación

El trabajo se controla en dos instancias, en este orden.

| Instancia | Qué se controla | Si no se cumple |
| --- | --- | --- |
| 1. Admisión | El proyecto compila con `MainPruebas.java`, pruebas intactas, solo `package` e `imports` adaptados. Se entrega el video. | El trabajo no se evalúa |
| 2. Calificación | Criterios de abajo. Total: 100 puntos | Se aprueba con 60 puntos o más |

La calificación se hace leyendo el código contra las reglas de las secciones 2, 3 y 4. Son las mismas reglas que comprueba `MainPruebas`. Un trabajo que pasa todas las pruebas tiene cubierto el funcionamiento. El resto del puntaje depende de cómo está construido.

| Criterio | Qué se valora | Puntos |
| --- | --- | --- |
| Estructura y enumeraciones | Paquetes coherentes; clases y constructores con nombres y firmas exigidos; enumeraciones completas con su descripción | 10 |
| Herencia y encapsulamiento | `Persona` abstracta con `Paciente` y `Medico` que la extienden; atributos privados con getters; nombre completo, edad y número de historia bien calculados | 15 |
| Validaciones | Textos obligatorios, DNI, matrícula y objetos obligatorios rechazados con `IllegalArgumentException`; estado y observaciones de la cita | 20 |
| Relaciones y composición | Relaciones bidireccionales sin duplicados desde las dos puntas; control de especialidad; composiciones creadas por su dueño; listas protegidas | 20 |
| Programación de citas | `CitaService`, `CitaManager`, `CitaException` verificada; validaciones de `programarCita()` y regla de las 2 horas | 25 |
| Restricciones y legibilidad | Sin persistencia ni bibliotecas externas; nombres claros; sin código repetido ni código sin usar | 10 |

## 12. Lista de control antes de entregar

- Los paquetes coinciden con sus imports. Clases y firmas respetan la sección 3.
- No se usan archivos, bases de datos ni bibliotecas externas.
- Todos los atributos son privados (o protegidos en `Persona`) y se validan en el constructor.
- Las relaciones bidireccionales se actualizan desde las dos puntas y no duplican elementos.
- `CitaException` extiende `Exception` y `programarCita()` la declara con `throws`.
- `MainPruebas` conserva sus pruebas y muestra 106 verificaciones correctas.
- El ZIP se llama `Apellido_TPI_P2.zip` y no tiene carpetas generadas por el IDE.
- El video es propio, dura entre 10 y 15 minutos y muestra el programa funcionando.

## 13. Material que falta para implementar

El PDF remite a dos archivos que se publican junto con el enunciado y no estaban adjuntos:

- `UmlHospital.png`: diagrama completo, con todos los atributos y métodos.
- `MainPruebas.java`: las 106 verificaciones. Es el contrato real de nombres y firmas.

## 14. Bibliografía del enunciado

- Deitel, P. J., y Deitel, H. M. (2016). *Cómo programar en Java* (10.ª ed.). Pearson Educación.
- Oracle. *Class LocalDate* (Java SE 17 & JDK 17).
- Oracle. *Class LocalDateTime* (Java SE 17 & JDK 17).
- Oracle. *Lesson: Exceptions*. The Java Tutorials.

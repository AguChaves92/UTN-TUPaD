# Diccionario del dataset — Gran Córdoba (Aglomerado 13)

**Fuente de datos:** `TAI-aglomerado13.xlsx`  
**Encuesta:** EPH — 1° Trimestre 2025 (INDEC)  
**Unidad de análisis:** hogar (base Hogar)  
**Filas / columnas:** 330 hogares × 98 variables  

**Documentación de apoyo (origen):** diseño de registros EPH 1° Trim 2025 (INDEC).  
Los PDFs no se guardan en el repo; este diccionario concentra lo necesario para el dataset.

---

## 1. Cómo leer este dataset

| Concepto | Detalle |
|---|---|
| Qué es cada fila | Un **hogar** encuestado en Gran Córdoba |
| Identificador de vivienda | `CODUSU` |
| Identificador de hogar | `CODUSU` + `NRO_HOGAR` |
| Filtro del archivo | Solo `AGLOMERADO = 13` (Gran Córdoba) |
| Año / trimestre | `ANO4 = 2025`, `TRIMESTRE = 1` |
| Región | `REGION = 43` → Pampeana |
| Tamaño | `MAS_500 = S` → aglomerado de 500.000 y más habitantes |

### Reglas generales de códigos (INDEC)

| Código | Significado habitual |
|---|---|
| `1` / `2` en preguntas Sí/No | **1 = Sí**, **2 = No** |
| `0` | No corresponde / no aplica a esa secuencia |
| `9`, `99`, `999`, `9999` | No sabe / No responde (salvo indicación contraria) |
| `-9` en montos de ingreso | No respuesta de ingresos |
| Deciles `00` | Sin ingresos |
| Deciles `12` | No respuesta de ingresos |
| Deciles `13` | Entrevista individual no realizada |

### Ponderadores (importante para inferencia)

| Campo | Uso |
|---|---|
| `PONDERA` | Expansión general de la muestra (sin corrección por no respuesta de ingresos) |
| `PONDIH` | Ponderador **con corrección** para `ITF`, `IPCF` y sus deciles |

Para analizar ingresos / pobreza conviene usar **`PONDIH`**. Para el resto de variables de hogar, **`PONDERA`**.

### Ingresos clave

| Campo | Significado |
|---|---|
| `ITF` | Ingreso total familiar = suma de ingresos individuales de todos los miembros |
| `IPCF` | Ingreso per cápita familiar = `ITF / IX_TOT` |

---

## 2. Variables prioritarias para el caso de estudio

El enunciado apunta a: **ingreso total familiar**, **condiciones habitacionales** y **acceso a servicios básicos**.

### Ingreso

- `ITF`, `IPCF`
- Deciles del hogar (ITF): `DECIFR`, `IDECIFR`, `RDECIFR`, `GDECIFR`, `PDECIFR`, `ADECIFR`
- Deciles per cápita: `DECCFR`, `IDECCFR`, `RDECCFR`, `GDECCFR`, `PDECCFR`, `ADECCFR`
- Para este aglomerado (≥500 mil): suelen usarse más `GDECIFR` / `GDECCFR` y `ADECIFR` / `ADECCFR`. `PDECIFR` y `PDECCFR` vienen vacíos (corresponden a aglomerados chicos).

### Condiciones habitacionales / calidad de vivienda

- Tipo y tamaño: `IV1`, `IV2`, `II1`, `II2`
- Materialidad: `IV3` (pisos), `IV4` (techo), `IV5` (cielorraso)
- Tenencia: `II7`
- Hacinamiento (se puede construir): miembros (`IX_TOT`) vs ambientes para dormir (`II2`)

### Servicios básicos y entorno

- Agua: `IV6`, `IV7`
- Baño / saneamiento: `IV8`, `IV9`, `IV10`, `IV11`, `II9`
- Combustible para cocinar: `II8`
- Entorno: `IV12_1` (basural), `IV12_2` (inundable), `IV12_3` (villa de emergencia)

---

## 3. Diccionario completo de campos (las 98 columnas)

### 3.1 Identificación y expansión

| Campo | En el Excel | Significado | Códigos / notas |
|---|---|---|---|
| CODUSU | texto | ID de vivienda | Único por vivienda; 330 distintos en el archivo |
| ANO4 | 2025 | Año de relevamiento | |
| TRIMESTRE | 1 | Ventana de observación | 1=1°T, 2=2°T, 3=3°T, 4=4°T |
| NRO_HOGAR | 1 o 2 | N° de hogar dentro de la vivienda | Usar con CODUSU |
| REALIZADA | 1 | Entrevista realizada | 1=Sí, 2=No (hogar no respuesta). Acá todos = 1 |
| REGION | 43 | Región | 01 GBA; 40 NOA; 41 NEA; 42 Cuyo; **43 Pampeana**; 44 Patagonia |
| MAS_500 | S | Tamaño del aglomerado | N = &lt;500 mil; **S = ≥500 mil** |
| AGLOMERADO | 13 | Aglomerado urbano | **13 = Gran Córdoba** |
| PONDERA | numérico | Factor de expansión general | |

### 3.2 Características de la vivienda (IV*)

| Campo | Significado | Códigos |
|---|---|---|
| IV1 | Tipo de vivienda (por observación) | 1 Casa; 2 Depto; 3 Pieza inquilinato; 4 Hotel/pensión; 5 Local no habitacional; 6 Otros → ver `IV1_ESP` |
| IV1_ESP | Especificación si IV1=6 | Texto / vacío |
| IV2 | Ambientes totales de la vivienda | Sin baño, cocina, pasillo, lavadero, garage |
| IV3 | Material predominante del piso | 1 Mosaico/baldosa/madera/cerámica/alfombra; 2 Cemento/ladrillo fijo; 3 Ladrillo suelto/tierra; 4 Otros → `IV3_ESP` |
| IV3_ESP | Especificación piso “otros” | |
| IV4 | Cubierta exterior del techo | 1 Membrana/asfáltica; 2 Baldosa/losa sin cubierta; 3 Pizarra/teja; 4 Chapa metal s/cubierta; 5 Fibrocemento/plástico; 6 Cartón; 7 Caña/tabla/paja; 9 N/S depto. PH |
| IV5 | ¿Techo con cielorraso/revestimiento? | 1 Sí; 2 No |
| IV6 | ¿Tiene agua…? | 1 Por cañería dentro; 2 Fuera vivienda / dentro terreno; 3 Fuera del terreno |
| IV7 | Fuente de agua | 1 Red pública; 2 Perforación c/bomba motor; 3 Perforación c/bomba manual; 4 Otra → `IV7_ESP` |
| IV7_ESP | Otra fuente de agua | |
| IV8 | ¿Tiene baño/letrina? | 1 Sí; 2 No |
| IV9 | Ubicación del baño/letrina | 1 Dentro vivienda; 2 Fuera vivienda / dentro terreno; 3 Fuera del terreno |
| IV10 | Tipo de baño | 1 Inodoro c/botón-mochila-cadena y arrastre; 2 Inodoro s/botón (a balde); 3 Letrina s/arrastre |
| IV11 | Desagüe del baño | 1 Red pública (cloaca); 2 Cámara séptica + pozo; 3 Solo pozo ciego; 4 Hoyo/excavación |
| IV12_1 | ¿Cerca de basural (≤3 cuadras)? | 1 Sí; 2 No |
| IV12_2 | ¿Zona inundable (últimos 12 meses)? | 1 Sí; 2 No |
| IV12_3 | ¿Villa de emergencia? (observación) | 1 Sí; 2 No |

### 3.3 Características habitacionales del hogar (II*)

| Campo | Significado | Códigos |
|---|---|---|
| II1 | Ambientes de uso exclusivo del hogar | Sin cocina, baño, pasillos, lavadero, garage |
| II2 | De esos, cuántos se usan para dormir | Numérico |
| II3 | ¿Algún ambiente exclusivo como lugar de trabajo? | 1 Sí; 2 No |
| II3_1 | Si II3=Sí, ¿cuántos? | 0 = no corresponde |
| II4_1 | ¿Tiene cuarto de cocina? | 1 Sí; 2 No |
| II4_2 | ¿Tiene lavadero? | 1 Sí; 2 No |
| II4_3 | ¿Tiene garage? | 1 Sí; 2 No |
| II5 | De cocina/lavadero/garage, ¿usan alguno para dormir? | 1 Sí; 2 No; 0 no corresponde |
| II5_1 | Si II5=Sí, ¿cuántos? | 0 = no corresponde |
| II6 | ¿Usan cocina/lavadero/garage solo como lugar de trabajo? | 1 Sí; 2 No; 0 no corresponde |
| II6_1 | Si II6=Sí, ¿cuántos? | 0 = no corresponde |
| II7 | Régimen de tenencia | 1 Propietario vivienda+terreno; 2 Solo vivienda; 3 Inquilino; 4 Ocupante por impuestos/expensas; 5 Relación de dependencia; 6 Gratuito c/permiso; 7 De hecho s/permiso; 8 Sucesión; 9 Otra → `II7_ESP` |
| II7_ESP | Otra tenencia | Ej.: “EN TRAMITE DE ESCRITURA”, “fiscal”, “PLAN DE CUOTAS” |
| II8 | Combustible principal para cocinar | 1 Gas de red; 2 Gas tubo/garrafa; 3 Kerosene/leña/carbón; 4 Otro → `II8_ESP` |
| II8_ESP | Otro combustible | Ej.: “ELECTRICO” |
| II9 | Uso del baño | 1 Exclusivo del hogar; 2 Compartido c/otro hogar misma vivienda; 3 Compartido c/otra vivienda; 4 No tiene baño |

### 3.4 Estrategias del hogar / fuentes de ingreso no laboral (V*)

Todas (salvo aclaración) son **1 = Sí / 2 = No**. El `0` indica que no corresponde (p. ej. desagregación de jubilaciones cuando `V2 = No`).

| Campo | Pregunta (últimos 3 meses, personas del hogar…) |
|---|---|
| V1 | …vivieron de lo que ganan en el trabajo? |
| V2 | …de alguna jubilación o pensión? |
| V2_01 | Jubilación/pensión por aportes del trabajo |
| V21_01 | Aguinaldo de esa jubilación/pensión (aportes) |
| V22_01 | Retroactivo de esa jubilación/pensión (aportes) |
| V2_02 | Jubilación/pensión “ama de casa” o moratoria |
| V21_02 | Aguinaldo (ama de casa / moratoria) |
| V22_02 | Retroactivo (ama de casa / moratoria) |
| V2_03 | Otras pensiones (discapacidad, Madre de 7 hijos, PUAM, vejez, etc.) |
| V21_03 | Aguinaldo de otras pensiones |
| V22_03 | Retroactivo de otras pensiones |
| V3 | Indemnización por despido |
| V4 | Seguro de desempleo |
| V5_01 | AUH y/o Asignación por Embarazo (incluye Tarjeta Alimentar) |
| V5_02 | Otro plan social / subsidio en dinero del gobierno |
| V5_03 | Ayuda en dinero de iglesias / ONG |
| V6 | Mercaderías/ropa/alimentos de gobierno, iglesias, escuelas, etc. |
| V7 | Mercaderías/ropa/alimentos de familiares, vecinos u otras personas |
| V8 | Cobro de alquiler de propiedad |
| V9 | Ganancias de negocio en el que no trabajan |
| V10 | Intereses/rentas por plazos fijos/inversiones |
| V11_01 | Beca en dinero del gobierno (ej. Progresar) |
| V11_02 | Otra beca de instituciones no gubernamentales |
| V12 | Cuotas de alimentos o ayuda en dinero de personas fuera del hogar |
| V13 | Tuvieron que gastar ahorros |
| V14 | Pedir préstamos a familiares/amigos |
| V15 | Pedir préstamos a bancos/financieras |
| V16 | Compran en cuotas o al fiado (tarjeta/libreta) |
| V17 | Vendieron pertenencias |
| V18 | Otros ingresos en efectivo (limosnas, juegos de azar, etc.) |
| V19_A | Niños &lt;10 ayudan con dinero trabajando |
| V19_B | Niños &lt;10 ayudan con dinero pidiendo |

> Nota: en el diseño INDEC a veces aparecen como `V5_1` / `V11_1`; en este Excel vienen como `V5_01` / `V11_01`.

### 3.5 Resumen del hogar

| Campo | Significado |
|---|---|
| IX_TOT | Cantidad de miembros del hogar |
| IX_MEN10 | Miembros menores de 10 años |
| IX_MAYEQ10 | Miembros de 10 años y más |

Chequeo útil: `IX_TOT = IX_MEN10 + IX_MAYEQ10`.

### 3.6 Ingresos y deciles

| Campo | Significado |
|---|---|
| ITF | Monto ingreso total familiar |
| DECIFR | Decil ITF — total EPH |
| IDECIFR | Decil ITF — interior |
| RDECIFR | Decil ITF — región |
| GDECIFR | Decil ITF — aglomerados ≥500 mil |
| PDECIFR | Decil ITF — aglomerados &lt;500 mil (**vacío en este archivo**) |
| ADECIFR | Decil ITF — del aglomerado (Gran Córdoba) |
| IPCF | Monto ingreso per cápita familiar |
| DECCFR | Decil IPCF — total EPH |
| IDECCFR | Decil IPCF — interior |
| RDECCFR | Decil IPCF — región |
| GDECCFR | Decil IPCF — aglomerados ≥500 mil |
| PDECCFR | Decil IPCF — aglomerados &lt;500 mil (**vacío**) |
| ADECCFR | Decil IPCF — del aglomerado |
| PONDIH | Ponderador de ITF e IPCF (con corrección por no respuesta) |

**Lectura de deciles:** 1 = 10% de menores ingresos … 10 = 10% de mayores ingresos.

### 3.7 Organización del hogar (tareas domésticas)

| Campo | Significado | Códigos especiales |
|---|---|---|
| VII1_1 | Quién realiza tareas de la casa (componente 1) | N° de componente; 96 servicio doméstico; 97 persona fuera del hogar |
| VII1_2 | Quién realiza tareas de la casa (componente 2) | Idem; 0 = no corresponde / no informado |
| VII2_1 … VII2_4 | Otras personas que ayudan | N° componente; 96 servicio; 97 fuera del hogar; **98 = ninguna** |

---

## 4. Panorama rápido de *este* archivo (Aglomerado 13)

Observaciones descriptivas útiles antes de las consignas:

| Aspecto | Qué se ve en los datos |
|---|---|
| Cobertura | 330 hogares, todos con entrevista realizada |
| Agua | `IV7` siempre = 1 (red pública) en esta muestra |
| Baño | `IV8` siempre = 1 (tienen baño/letrina) |
| Entorno | Hay hogares en zona inundable (`IV12_2=1`) y cerca de basural (`IV12_1=1`) |
| Tenencia (`II7`) | Aparecen dueños, inquilinos, sucesión, gratuito, de hecho, etc. |
| Ingresos | `ITF` e `IPCF` con mucha variación; deciles 1–10 presentes |
| Vacíos totales | `IV1_ESP`, `IV3_ESP`, `IV7_ESP`, `PDECIFR`, `PDECCFR` |

---

## 5. Tips prácticos para R (cuando lleguen las consignas)

```r
# Lectura
library(readxl)
hog <- read_excel("TAI-aglomerado13.xlsx")

# Redondeo simétrico a 4 decimales (pauta del TP)
# round() de R usa redondeo a par en .5; para simétrico clásico:
round_sym <- function(x, d = 4) {
  pos <- x >= 0
  base <- trunc(abs(x) * 10^d + 0.5) / 10^d
  ifelse(pos, base, -base)
}

# Etiquetar Sí/No frecuentes
si_no <- c(`1` = "Sí", `2` = "No")

# Ejemplo: agua dentro de la vivienda
table(factor(hog$IV6, levels = 1:3,
            labels = c("Cañería dentro", "Fuera viv./dentro terreno", "Fuera terreno")))
```

Variables candidatas a **factor** (categóricas): casi todas las `IV*`, `II*`, `V*` Sí/No y los deciles.  
Variables **numéricas continuas/discretas de monto o conteo:** `ITF`, `IPCF`, `IV2`, `II1`, `II2`, `IX_*`, `PONDERA`, `PONDIH`.

---

## 6. Mapa mental del caso

```text
Gran Córdoba (AGLO=13)
│
├─ Ingreso familiar ── ITF / IPCF (+ deciles + PONDIH)
│
├─ Habitabilidad ───── tipo vivienda, materiales, ambientes, tenencia
│
└─ Servicios básicos ─ agua, baño, desagüe, combustible, entorno riesgoso
```

Cuando pases las consignas, usamos este diccionario para etiquetar, filtrar y no confundir códigos (sobre todo `0`, `9` y deciles especiales).

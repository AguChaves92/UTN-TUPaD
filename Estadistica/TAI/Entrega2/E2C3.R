# =============================================================================
# Estadística — Entrega 2 | Aglomerado 13 (Gran Córdoba)
# Consigna 3: medidas descriptivas de ITF (cuantitativa continua) e IV1 (nominal)
#
# Este script resume cómo se distribuyen dos variables de la EPH:
#   - ITF: Ingreso Total Familiar (cuánto dinero entra al hogar)
#   - IV1: Tipo de vivienda (casa, departamento, etc.)
# =============================================================================

# Cargo la librería necesaria para leer archivos Excel
library(readxl)

# Busco el mismo Excel de la Entrega 1. Si no está en la carpeta esperada,
# se abre una ventana para elegir el archivo a mano.
candidatos <- c(
  file.path("..", "TAI-aglomerado13.xlsx"),
  file.path("Estadistica", "TAI", "TAI-aglomerado13.xlsx")
)
ruta_excel <- candidatos[file.exists(candidatos)][1]
if (is.na(ruta_excel) || length(ruta_excel) == 0) {
  hog <- read_excel(file.choose())
} else {
  hog <- read_excel(ruta_excel)
}

# Función auxiliar: muestra un número como pesos argentinos
# (por ejemplo 1234567 pasa a verse como $1.234.567)
fmt_pesos <- function(x) {
  paste0(
    "$",
    format(round(x, 0), big.mark = ".", decimal.mark = ",", scientific = FALSE, trim = TRUE)
  )
}

# =============================================================================
# Preparación de ITF (Ingreso Total Familiar)
#
# Antes de calcular promedios y demás, hay que decidir qué hogares entran.
# En la EPH, el código -9 significa "no respondió ingresos". Esos casos
# no se pueden incluir: no son un ingreso real.
# Los ceros sí se dejan: son hogares que declararon no tener ingreso
# Trabajamos con la muestra tal cual (sin ponderar), igual que en el punto 2.
# =============================================================================

# Cantidad total de hogares en el archivo
n_hogares <- nrow(hog)

# Cantidad de hogares que no respondieron el ingreso
n_nr_itf <- sum(hog$ITF == -9, na.rm = TRUE)

# Lista de ingresos a analizar: se sacan los vacíos y los "no responde" (-9)
itf <- hog$ITF[!is.na(hog$ITF) & hog$ITF != -9]

# Cantidad de hogares que sí se usan para las medidas de ITF
n <- length(itf)

# =============================================================================
# Intervalos de ITF — mismos criterios que Entrega 1 (regla de Sturges)
#
# Aplicamos la regla de Sturges para determinar el número de tramos.
# Necesitamos esos tramos para:
#   1) saber en qué rango de ingresos se agrupan más hogares (la "clase modal")
#   2) usar los mismos cortes en el histograma de la consigna 4.1
# =============================================================================

# Cantidad sugerida de tramos según Sturges
k_sturges <- 1 + 3.322 * log10(n)

# Redondeamos a un número entero de tramos
k <- round(k_sturges)

# Ingreso familiar más bajo y más alto de la muestra (ya sin los -9)
xmin <- min(itf)
xmax <- max(itf)

# Ancho de cada tramo (todos miden lo mismo)
amplitud <- round((xmax - xmin) / k)

# Armamos los cortes: desde el mínimo, saltando de "amplitud" en "amplitud"
breaks_itf <- seq(
  from = xmin,
  to = xmin + k * amplitud,
  by = amplitud
)

# Límite inferior y superior de cada tramo
li <- breaks_itf[-length(breaks_itf)]
ls <- breaks_itf[-1]

# Etiquetas para leer cada tramo, por ejemplo [0, 200000)
etiquetas_itf <- paste0(
  "[", format(li, scientific = FALSE, trim = TRUE, big.mark = ""),
  ", ", format(ls, scientific = FALSE, trim = TRUE, big.mark = ""),
  c(rep(")", k - 1), "]")
)

# Clasificamos cada hogar en el tramo de ingresos que le corresponde
clases_itf <- cut(
  itf,
  breaks = breaks_itf,
  right = FALSE,
  include.lowest = TRUE,
  labels = etiquetas_itf
)

# Cuántos hogares hay en cada tramo
fi_itf <- as.numeric(table(clases_itf))

# Clase modal: el tramo donde hay más hogares
clase_modal <- as.character(etiquetas_itf[which.max(fi_itf)])

# =============================================================================
# 3.1 ITF — tendencia central, posición y dispersión
#
# Tendencia central: ¿alrededor de qué valor se concentran los ingresos?
#   Media   = promedio (suma de todos los ingresos / cantidad de hogares)
#   Mediana = el hogar del medio si ordenamos de menor a mayor
#   Moda    = el tramo de ingresos más frecuente
#
# Posición (cuartiles): parten a los hogares en cuatro grupos iguales.
#   Q1 = el 25% más bajo llega como máximo a este monto
#   Q2 = coincide con la mediana (el 50%)
#   Q3 = el 75% llega como máximo a este monto
#
# Dispersión: ¿cuánto se parecen (o se diferencian) los hogares entre sí?
#   Rango              = del más pobre al más rico de la muestra
#   RIC (Q3 − Q1)      = amplitud del 50% "del medio"
#   Varianza y desvío  = qué tan lejos está, en promedio, cada hogar de la media
#   CV (%)             = el desvío comparado con la media (permite decir si
#                        la dispersión es alta o baja en términos relativos)
#
# Todas estas medidas se calculan con los ingresos originales de cada hogar,
# no con el punto medio de cada tramo. Así no se pierde precisión.
# =============================================================================

# Promedio de ingresos familiares
media_itf <- mean(itf)

# Ingreso del hogar que queda justo en el medio
mediana_itf <- median(itf)

# Mínimo, Q1, mediana (Q2), Q3 y máximo
q_itf <- quantile(itf, probs = c(0, 0.25, 0.50, 0.75, 1), names = FALSE)

# Distancia entre el ingreso más alto y el más bajo
rango_itf <- xmax - xmin

# Distancia entre Q3 y Q1: el "ancho" del 50% central de hogares
ric_itf <- q_itf[4] - q_itf[2]

# Varianza y desvío estándar (versión muestral: se divide por n − 1)
varianza_itf <- var(itf)
desvio_itf <- sd(itf)

# Coeficiente de variación: desvío como porcentaje de la media
cv_itf <- desvio_itf / media_itf * 100

# Función auxiliar: formatea números con punto para miles y coma decimal
fmt_num <- function(x, d = 2) {
  format(round(x, d), big.mark = ".", decimal.mark = ",", scientific = FALSE, trim = TRUE)
}

# Tabla resumen para leer todas las medidas juntas
tabla_itf_medidas <- data.frame(
  grupo = c(
    rep("Tendencia central", 3),
    rep("Posición", 5),
    rep("Dispersión", 5)
  ),
  medida = c(
    "Media", "Mediana", "Moda (clase modal)",
    "Mínimo", "Q1", "Q2", "Q3", "Máximo",
    "Rango", "RIC (Q3-Q1)", "Varianza", "Desvío estándar", "CV (%)"
  ),
  valor = c(
    fmt_num(media_itf),
    fmt_num(mediana_itf),
    clase_modal,
    fmt_num(q_itf[1]),
    fmt_num(q_itf[2]),
    fmt_num(q_itf[3]),
    fmt_num(q_itf[4]),
    fmt_num(q_itf[5]),
    fmt_num(rango_itf),
    fmt_num(ric_itf),
    fmt_num(varianza_itf),
    fmt_num(desvio_itf),
    fmt_num(cv_itf)
  ),
  detalle = c(
    "promedio de los ingresos familiares",
    "la mitad de los hogares gana hasta este monto",
    "tramo de ingresos donde hay más hogares",
    "ingreso familiar más bajo de la muestra",
    "el 25% de los hogares gana hasta este monto",
    "coincide con la mediana (el 50%)",
    "el 75% de los hogares gana hasta este monto",
    "ingreso familiar más alto de la muestra",
    "diferencia entre el máximo y el mínimo",
    "amplitud del 50% de hogares que quedan en el medio",
    "qué tan dispersos están los ingresos respecto del promedio",
    "misma idea que la varianza, pero en las mismas unidades que el ITF (pesos)",
    "el desvío expresado como porcentaje del promedio"
  ),
  stringsAsFactors = FALSE
)

cat("=== 3. ITF — medidas descriptivas ===\n")
cat("Hogares en el archivo =", n_hogares, "\n")
cat("Hogares sin respuesta de ingresos (ITF = -9) =", n_nr_itf, "\n")
cat("n usado para las medidas =", n, "\n")
cat("k (Sturges) =", k, "| amplitud =", amplitud, "\n")
cat("Clase modal =", clase_modal, "| fi modal =", max(fi_itf), "\n\n")
print(tabla_itf_medidas, row.names = FALSE)

# =============================================================================
# 3.2 IV1 — Tipo de vivienda (cualitativa nominal)
#
# IV1 no es un número con sentido de "más o menos", sino una categoría:
# casa, departamento, pieza, etc. En ese tipo de variable no tiene sentido
# un promedio ni una mediana. Lo único que corresponde es la moda:
# la categoría que más se repite.
# =============================================================================

# Significado de cada código de tipo de vivienda
etiquetas_iv1 <- c(
  "1 = Casa",
  "2 = Departamento",
  "3 = Pieza en inquilinato",
  "4 = Pieza en hotel/pensión",
  "5 = Local no construido para habitación"
)

# Pasamos los códigos numéricos a etiquetas legibles
iv1_factor <- factor(
  hog$IV1,
  levels = 1:5,
  labels = etiquetas_iv1
)

# Cuántos hogares hay de cada tipo de vivienda
fi_iv1 <- table(iv1_factor)

# Tipo de vivienda más frecuente (puede haber empate)
moda_iv1 <- names(fi_iv1)[fi_iv1 == max(fi_iv1)]

# Cuántos hogares tienen ese tipo de vivienda
fi_moda_iv1 <- max(fi_iv1)

# Qué porcentaje de la muestra representa esa categoría
hi_moda_iv1 <- fi_moda_iv1 / n_hogares

cat("\n=== 3. IV1 — moda ===\n")
cat("Moda =", paste(moda_iv1, collapse = ", "), "\n")
cat("fi =", fi_moda_iv1, "| porcentaje =", round(hi_moda_iv1 * 100, 2), "%\n")

# =============================================================================
# 3.3 Interpretación en el caso (Gran Córdoba, hogares, 1°T 2025)
#
# El texto de abajo se arma solo con los números que acabamos de calcular,
# para que la lectura coincida con la tabla y no haya que copiar a mano.
#
# Ideas que conviene tener presentes al leerlo:
#   - Si la media es mayor que la mediana, unos pocos hogares muy ricos
#     están "empujando" el promedio hacia arriba (asimetría a la derecha).
#     Eso es típico en ingresos.
#   - Un CV alto significa que los hogares se parecen poco entre sí:
#     el promedio, solo, no describe bien a un hogar "típico".
#     En ese caso conviene mirar la mediana y los cuartiles.
# =============================================================================

# Comparamos media y mediana para describir si la distribución está sesgada
asimetria <- if (media_itf > mediana_itf) {
  "La media queda por encima de la mediana: hay asimetría a la derecha. Eso es esperable en ingresos: unos pocos hogares con ITF muy alto empujan el promedio, mientras que la mayoría se concentra en montos más bajos."
} else if (media_itf < mediana_itf) {
  "La media queda por debajo de la mediana: hay asimetría a la izquierda. El promedio está tironeado por hogares de ingresos particularmente bajos."
} else {
  "Media y mediana coinciden: la distribución del ITF se ve simétrica en esta muestra."
}

# Traducimos el CV a un juicio sencillo sobre la dispersión
dispersion_cv <- if (cv_itf >= 50) {
  "muy alta"
} else if (cv_itf >= 30) {
  "alta"
} else {
  "moderada"
}

cat("\n=== Interpretación ===\n\n")

cat(
  "ITF (ingreso total familiar). En la muestra de Gran Córdoba (n = ", n,
  if (n_nr_itf > 0) paste0("; se excluyeron ", n_nr_itf, " hogares con ITF = -9") else "",
  ") el ingreso familiar promedio es ", fmt_pesos(media_itf),
  " y la mediana es ", fmt_pesos(mediana_itf),
  ". La mitad de los hogares percibe como máximo ", fmt_pesos(mediana_itf),
  ". ", asimetria, "\n\n",
  sep = ""
)

cat(
  "La clase más frecuente es ", clase_modal, " (", max(fi_itf),
  " hogares). Ese intervalo es la moda de la variable agrupada con los mismos cortes de Sturges del punto 2; conviene usar esos mismos breaks en el histograma de la consigna 4.1.\n\n",
  sep = ""
)

cat(
  "En cuanto a la posición, el 25% de los hogares tiene un ITF de hasta ",
  fmt_pesos(q_itf[2]), " (Q1) y el 75% de hasta ", fmt_pesos(q_itf[4]),
  " (Q3). El 50% central de la muestra se mueve en un rango intercuartílico de ",
  fmt_pesos(ric_itf), ".\n\n",
  sep = ""
)

cat(
  "La dispersión es ", dispersion_cv, ": el rango va de ",
  fmt_pesos(xmin), " a ", fmt_pesos(xmax),
  " y el desvío estándar es ", fmt_pesos(desvio_itf),
  " (CV = ", round(cv_itf, 2),
  "%). Hay mucha heterogeneidad de ingresos entre hogares del aglomerado; el promedio, por sí solo, no describe bien a un hogar 'típico'. Para hablar de un valor representativo conviene apoyarse en la mediana y en los cuartiles.\n\n",
  sep = ""
)

cat(
  "IV1 (tipo de vivienda). Como es cualitativa nominal, la única medida de tendencia central que corresponde es la moda: ",
  paste(moda_iv1, collapse = " / "), " (", fi_moda_iv1, " hogares; ",
  round(hi_moda_iv1 * 100, 2),
  "%). Ese es el tipo de vivienda más habitual en la muestra de Gran Córdoba. Media, mediana, cuartiles o desvío no se interpretan sobre códigos de categoría.\n",
  sep = ""
)

# =============================================================================
# 4. REPRESENTACIÓN GRÁFICA
# =============================================================================

# =============================================================================
# 4.1 Histograma — Ingreso Total Familiar (ITF)
#
# Se representa la distribución del ITF utilizando frecuencia absoluta.
# Se mantienen los mismos intervalos calculados previamente con la regla de Sturges.
# =============================================================================

# Función para abreviar los valores del eje X
fmt_eje <- function(x) {
  ifelse(
    x < 1000000,
    paste0(round(x / 1000), "K"),
    paste0(round(x / 1000000, 2), "M")
  )
}

# Aumentamos el margen inferior para las etiquetas
par(mar = c(7, 5, 4, 2))

hist(
  itf,
  breaks = breaks_itf,
  right = FALSE,
  include.lowest = TRUE,
  main = "Ingreso Total Familiar — Gran Córdoba",
  xlab = "",
  ylab = "Frecuencia absoluta - Hogares",
  xaxt = "n"
)

axis(
  side = 1,
  at = breaks_itf,
  labels = fmt_eje(breaks_itf),
  las = 2,
  cex.axis = 0.8
)

mtext(
  "Ingreso Total Familiar ($)",
  side = 1,
  line = 5.5
)

# =============================================================================
# 4.2 Diagrama circular — Tipo de vivienda (IV1)
# =============================================================================

# Calculamos el porcentaje de cada tipo de vivienda
porcentaje_iv1 <- fi_iv1 / sum(fi_iv1) * 100

# Nombres simplificados para mostrar en la leyenda
nombres_iv1 <- c(
  "Casa",
  "Departamento",
  "Pieza en inquilinato",
  "Pieza en hotel/pensión",
  "Local no construido para habitación"
)

# Etiquetas del gráfico: mostramos solamente los porcentajes
# Mostramos el porcentaje solamente cuando representa al menos el 1%
etiquetas_porcentaje <- ifelse(
  porcentaje_iv1 >= 1,
  paste0(round(porcentaje_iv1, 4), "%"),
  ""
)

# Dejamos espacio a la derecha para la leyenda
par(mar = c(4, 4, 4, 9), xpd = TRUE)

# Construimos el diagrama circular
pie(
  fi_iv1,
  labels = etiquetas_porcentaje,
  main = "Tipo de vivienda — Gran Córdoba",
  cex = 0.8
)

# Agregamos una leyenda con los nombres de las categorías
legend(
  "right",
  inset = c(-0.65, 0),
  legend = nombres_iv1,
  cex = 0.75,
  bty = "n"
)


# =============================================================================
# 4.3 Análisis de los gráficos
# =============================================================================

# ITF:
# En el histograma del Ingreso Total Familiar se observa que la mayor
# concentración de hogares se encuentra en los primeros intervalos de ingreso.
# El intervalo con mayor frecuencia es [795000, 1530000), en el cual se
# encuentran 128 hogares.
#
# A medida que aumenta el ingreso total familiar, la frecuencia de hogares
# disminuye. Sin embargo, se observan algunos hogares con ingresos
# considerablemente más altos, alcanzando valores cercanos a los $6,7 millones.
#
# La distribución presenta una asimetría hacia la derecha: la mayoría de los
# hogares se concentra en los intervalos de ingresos más bajos, mientras que
# una cantidad reducida presenta ingresos elevados. Esto es consistente con
# las medidas descriptivas obtenidas en el punto 3, donde la media resulta
# superior a la mediana.


# IV1:
# En el diagrama circular correspondiente al Tipo de Vivienda se observa un
# claro predominio de la categoría "Casa", que representa el 63,9394% de los
# hogares de la muestra de Gran Córdoba.
#
# En segundo lugar se encuentra la categoría "Departamento", con un 35,7576%,
# mientras que "Pieza en inquilinato" representa solamente el 0,3030%.
# No se registran hogares correspondientes a las categorías "Pieza en
# hotel/pensión" ni "Local no construido para habitación".
#
# En conjunto, casas y departamentos representan el 99,6970% de los hogares
# relevados. Por lo tanto, el gráfico muestra que prácticamente la totalidad
# de los hogares de la muestra reside en alguno de estos dos tipos de vivienda,
# con un predominio de las casas. Esto coincide con la moda obtenida para IV1
# en el punto 3.
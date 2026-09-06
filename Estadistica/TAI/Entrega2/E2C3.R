# =============================================================================
# Estadística — Entrega 2 | Aglomerado 13 (Gran Córdoba)
# Consigna 3: medidas descriptivas de las variables definidas en el punto (2)
# =============================================================================

library(readxl)

# Mismo Excel de la Entrega 1. Si no está en la carpeta esperada,
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

# =============================================================================
# Diccionario de variables del punto 2 (las que usa la consigna 3)
#
# Punto 2.1 — ITF: cuantitativa continua (ingreso total familiar)
# Punto 2.2 — IV1: cualitativa nominal (tipo de vivienda)
# =============================================================================

codigos_iv1 <- c(
  "1" = "Casa",
  "2" = "Departamento",
  "3" = "Pieza en inquilinato",
  "4" = "Pieza en hotel/pensión",
  "5" = "Local no construido para habitación"
)

diccionario <- data.frame(
  codigo = c("ITF", "IV1"),
  nombre = c("Ingreso total familiar", "Tipo de vivienda"),
  tipo = c("Cuantitativa continua", "Cualitativa nominal"),
  unidad = c("Pesos", "Categoría"),
  punto_origen = c("2.1", "2.2"),
  medidas_consigna_3 = c(
    "Tendencia central, posición y dispersión",
    "Solo moda"
  ),
  nota = c(
    "Suma de ingresos de los miembros del hogar. Código -9 = no respuesta (se excluye).",
    paste(paste0(names(codigos_iv1), " = ", unname(codigos_iv1)), collapse = "; ")
  ),
  stringsAsFactors = FALSE
)

cat("=== Diccionario de variables (punto 2 → consigna 3) ===\n")
print(
  diccionario[, c("codigo", "nombre", "tipo", "unidad", "punto_origen", "medidas_consigna_3")],
  row.names = FALSE,
  right = FALSE
)
cat("\nNotas:\n")
for (i in seq_len(nrow(diccionario))) {
  cat("- ", diccionario$codigo[i], ": ", diccionario$nota[i], "\n", sep = "")
}

# Extraigo del dataset solo las columnas del diccionario
hog3 <- hog[, diccionario$codigo, drop = FALSE]
n_hogares <- nrow(hog3)

# =============================================================================
# ITF — preparación para las medidas
#
# En la EPH, -9 no es un ingreso real: es "no respondió". Se saca del cálculo.
# Muestra sin ponderar, igual que en el punto 2.
# =============================================================================

itf_bruto <- hog3$ITF
n_nr_itf <- sum(itf_bruto == -9, na.rm = TRUE)
itf <- itf_bruto[!is.na(itf_bruto) & itf_bruto != -9]
n <- length(itf)

# La moda de una continua se informa como clase modal. Para eso se agrupa
# con Sturges.
k_sturges <- 1 + 3.322 * log10(n)
k <- round(k_sturges)
xmin <- min(itf)
xmax <- max(itf)
amplitud <- round((xmax - xmin) / k)

breaks_itf <- seq(
  from = xmin,
  to = xmin + k * amplitud,
  by = amplitud
)

li <- breaks_itf[-length(breaks_itf)]
ls <- breaks_itf[-1]
etiquetas_itf <- paste0(
  "[", format(li, scientific = FALSE, trim = TRUE, big.mark = ""),
  ", ", format(ls, scientific = FALSE, trim = TRUE, big.mark = ""),
  c(rep(")", k - 1), "]")
)

clases_itf <- cut(
  itf,
  breaks = breaks_itf,
  right = FALSE,
  include.lowest = TRUE,
  labels = etiquetas_itf
)

fi_itf <- as.numeric(table(clases_itf))
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
#   Q3 = el 75% llega como máximo a este monto
#
# Dispersión: ¿cuánto se parecen (o se diferencian) los hogares entre sí?
#   Rango              = del más pobre al más rico de la muestra
#   RIC (Q3 − Q1)      = amplitud del 50% "del medio"
#   Varianza y desvío  = qué tan lejos está, en promedio, cada hogar de la media
#   CV (%)             = el desvío comparado con la media (permite decir si
#                        la dispersión es alta o baja en términos relativos)
#
# =============================================================================

media_itf <- mean(itf)
mediana_itf <- median(itf)
q_itf <- quantile(itf, probs = c(0, 0.25, 0.50, 0.75, 1), names = FALSE)
rango_itf <- xmax - xmin
ric_itf <- q_itf[4] - q_itf[2]
varianza_itf <- var(itf)
desvio_itf <- sd(itf)
cv_itf <- desvio_itf / media_itf * 100

tabla_itf_medidas <- data.frame(
  medida = c(
    "Media", "Mediana", "Moda (clase modal)",
    "Mínimo", "Q1", "Q2", "Q3", "Máximo",
    "Rango", "RIC (Q3-Q1)", "Varianza", "Desvío estándar", "CV (%)"
  ),
  valor = c(
    round(media_itf, 2),
    round(mediana_itf, 2),
    clase_modal,
    round(q_itf[1], 2),
    round(q_itf[2], 2),
    round(q_itf[3], 2),
    round(q_itf[4], 2),
    round(q_itf[5], 2),
    round(rango_itf, 2),
    round(ric_itf, 2),
    round(varianza_itf, 2),
    round(desvio_itf, 2),
    round(cv_itf, 2)
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

cat("\n=== 3. ITF — medidas descriptivas ===\n")
cat("Hogares en el archivo =", n_hogares, "\n")
cat("Hogares sin respuesta de ingresos (ITF = -9) =", n_nr_itf, "\n")
cat("n usado para las medidas =", n, "\n")
cat("k (Sturges, solo para la clase modal) =", k, "| amplitud =", amplitud, "\n")
cat("Clase modal =", clase_modal, "| fi modal =", max(fi_itf), "\n\n")
op_width <- options(width = 200)
print(tabla_itf_medidas, row.names = FALSE, right = FALSE)
options(op_width)

# =============================================================================
# 3.2 IV1 — Tipo de vivienda (cualitativa nominal)
#
#  En una nominal no hay promedio ni mediana:
# la única medida de tendencia central que corresponde es la moda.
# =============================================================================

iv1_factor <- factor(
  hog3$IV1,
  levels = as.numeric(names(codigos_iv1)),
  labels = paste0(names(codigos_iv1), " = ", unname(codigos_iv1))
)

fi_iv1 <- table(iv1_factor)
moda_iv1 <- names(fi_iv1)[fi_iv1 == max(fi_iv1)]
fi_moda_iv1 <- max(fi_iv1)
hi_moda_iv1 <- fi_moda_iv1 / n_hogares

cat("\n=== 3. IV1 — moda ===\n")
cat("Moda =", paste(moda_iv1, collapse = ", "), "\n")
cat("fi =", fi_moda_iv1, "| porcentaje =", round(hi_moda_iv1 * 100, 2), "%\n")

# =============================================================================
# 3.3 Conclusiones (Gran Córdoba, hogares, 1°T 2025)
#
# ITF
# - Media > mediana: asimetría a la derecha. Pocos hogares con ITF muy alto
#   empujan el promedio; la mayoría se concentra más abajo.
# - La mediana (y los cuartiles) describen mejor a un hogar típico que la media.
# - La clase modal es el tramo de Sturges con más hogares (punto 2.1).
# - RIC grande: ni el 50% central se parece entre sí.
# - CV alto y desvío cercano a la media: mucha heterogeneidad de ingresos.
#
# IV1
# - Variable nominal: la única medida que corresponde es la moda (Casa).
# - Media, mediana, cuartiles o desvío no se interpretan sobre códigos.
# =============================================================================

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
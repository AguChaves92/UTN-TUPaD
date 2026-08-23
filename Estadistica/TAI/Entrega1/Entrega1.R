# =============================================================================
# TAI Estadística — Entrega 1 | Aglomerado 13 (Gran Córdoba)
# EPH 1° Trimestre 2025
# Consignas 2.1 y 2.2: Tablas de frecuencias (ITF e IV1)
# =============================================================================

# Cargo la librería necesaria para leer archivos Excel
library(readxl)

# Selecciono el archivo Excel que vamos a analizar
hog <- read_excel(file.choose())

# Datos que vamos a utilizar para construir los intervalos

# Cantidad de hogares de la muestra
n <- nrow(hog)

# Cantidad óptima de intervalos según la regla de Sturges
k_sturges <- 1 + 3.322 * log10(n)

# Redondeamos la cantidad de intervalos a un número entero
k <- round(k_sturges)

# Valor mínimo del Ingreso Total Familiar
xmin <- min(hog$ITF, na.rm = TRUE)

# Valor máximo del Ingreso Total Familiar
xmax <- max(hog$ITF, na.rm = TRUE)

# Calculamos la amplitud de cada intervalo
amplitud <- round((xmax - xmin) / k)

# Mostramos los resultados obtenidos
cat("=== 2.1 ITF — determinación de intervalos (Sturges) ===\n")
cat("n =", n, "\n")
cat("k (Sturges, sin redondear) =", round(k_sturges, 4), "\n")
cat("k óptimo =", k, "\n")
cat("mínimo ITF =", xmin, "| máximo ITF =", xmax, "\n")
cat("amplitud de clase =", amplitud, "\n\n")

# Generamos los límites de los intervalos
breaks_itf <- seq(
  from = xmin,
  to = xmin + k * amplitud,
  by = amplitud
)

# Obtenemos los límites inferiores y superiores de cada intervalo
li <- breaks_itf[-length(breaks_itf)]
ls <- breaks_itf[-1]
# El último intervalo queda cerrado a derecha por include.lowest + cut
etiquetas_itf <- paste0(
  "[", format(li, scientific = FALSE, trim = TRUE, big.mark = ""),
  ", ", format(ls, scientific = FALSE, trim = TRUE, big.mark = ""),
  c(rep(")", k - 1), "]")
)

# Asignamos cada valor de ITF al intervalo que le corresponde
clases_itf <- cut(
  hog$ITF,
  breaks = breaks_itf,
  right = FALSE,
  include.lowest = TRUE,
  labels = etiquetas_itf
)

# Calculamos las frecuencias
fi_itf <- as.numeric(table(clases_itf)) # Frecuencia absoluta
hi_itf <- fi_itf / n                    # Frecuencia relativa
Fi_itf <- cumsum(fi_itf)                # Frecuencia absoluta acumulada
Hi_itf <- cumsum(hi_itf)                # Frecuencia relativa acumulada

# Construimos la tabla de frecuencias
tabla_itf <- data.frame(
  clase = etiquetas_itf,
  fi = fi_itf,
  Fi = Fi_itf,
  #Agregamos porcentajes para facilitar analisis de los datos
  porcentaje = round(hi_itf * 100, 2),
  hi = round(hi_itf, 4),
  Hi = round(Hi_itf, 4),
  #Agregamos porcentajes para facilitar analisis de los datos
  porcentaje_acumulado = round(Hi_itf * 100, 2)
)

# Mostramos la tabla
cat("=== Tabla de frecuencias — ITF ===\n")
print(tabla_itf, row.names = FALSE)


# =============================================================================
# 2.2 Tipo de vivienda (IV1) — cualitativa nominal
# Frecuencias que corresponden: fi y hi
# (Fi/Hi no se interpretan en variables nominales: no hay orden natural)
# =============================================================================

# Etiquetas para las categorías de Tipo de Vivienda
etiquetas_iv1 <- c(
  "1 = Casa",
  "2 = Departamento",
  "3 = Pieza en inquilinato",
  "4 = Pieza en hotel/pensión",
  "5 = Local no construido para habitación"
)

# Convertimos los códigos de IV1 en categorías con etiquetas legibles
iv1_factor <- factor(
  hog$IV1,
  levels = 1:5,
  labels = etiquetas_iv1
)

# Calculamos las frecuencias
fi_iv1 <- as.numeric(table(iv1_factor)) # Frecuencia absoluta
hi_iv1 <- fi_iv1 / n                    # Frecuencia relativa

# Construimos la tabla de frecuencias
tabla_iv1 <- data.frame(
  categoria = names(table(iv1_factor)),
  fi = fi_iv1,
  hi = round(hi_iv1, 4),
  porcentaje = round(hi_iv1 * 100, 2)
)

# Mostramos la tabla
cat("\n=== Tabla de frecuencias — IV1 (Tipo de vivienda) ===\n")
print(tabla_iv1, row.names = FALSE)
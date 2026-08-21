# =============================================================================
# TAI Estadística — Entrega 1 | Aglomerado 13 (Gran Córdoba)
# EPH 1° Trimestre 2025
# Consignas 2.1 y 2.2: Tablas de frecuencias (ITF e IV1)
# =============================================================================

library(readxl)

# Redondeo simétrico a 4 decimales
round_sym <- function(x, d = 4) {
  pos <- !is.na(x) & x >= 0
  neg <- !is.na(x) & x < 0
  out <- x
  out[pos] <- trunc(abs(x[pos]) * 10^d + 0.5) / 10^d
  out[neg] <- -trunc(abs(x[neg]) * 10^d + 0.5) / 10^d
  out
}


args_cmd <- commandArgs(trailingOnly = FALSE)
file_arg <- sub("^--file=", "", args_cmd[grepl("^--file=", args_cmd)])
dir_script <- if (length(file_arg) > 0) {
  dirname(normalizePath(file_arg))
} else {
  # Si se ejecuta con source() desde Entrega1/
  getwd()
}
ruta_excel <- normalizePath(file.path(dir_script, "..", "TAI-aglomerado13.xlsx"))
hog <- read_excel(ruta_excel)

# =============================================================================
# 2.1 Ingreso Total Familiar (ITF) — cuantitativa continua
# Cantidad óptima de intervalos: regla de Sturges
#   k = 1 + 3.322 * log10(n)
# Frecuencias: fi, hi, Fi, Hi
# =============================================================================

n <- nrow(hog)
k_sturges <- 1 + 3.322 * log10(n)
k <- ceiling(k_sturges) # cantidad óptima de intervalos

xmin <- min(hog$ITF, na.rm = TRUE)
xmax <- max(hog$ITF, na.rm = TRUE)
amplitud <- ceiling((xmax - xmin) / k)
breaks_itf <- seq(xmin, xmin + k * amplitud, by = amplitud)

cat("=== 2.1 ITF — determinación de intervalos (Sturges) ===\n")
cat("n =", n, "\n")
cat("k (Sturges, sin redondear) =", round_sym(k_sturges, 4), "\n")
cat("k óptimo (ceil) =", k, "\n")
cat("mínimo ITF =", xmin, "| máximo ITF =", xmax, "\n")
cat("amplitud de clase =", amplitud, "\n\n")

# Etiquetas legibles de intervalos [LI, LS)
li <- breaks_itf[-length(breaks_itf)]
ls <- breaks_itf[-1]
# El último intervalo queda cerrado a derecha por include.lowest + cut
etiquetas_itf <- paste0(
  "[", format(li, scientific = FALSE, trim = TRUE, big.mark = ""),
  ", ", format(ls, scientific = FALSE, trim = TRUE, big.mark = ""),
  c(rep(")", k - 1), "]")
)

clases_itf <- cut(
  hog$ITF,
  breaks = breaks_itf,
  right = FALSE,
  include.lowest = TRUE,
  labels = etiquetas_itf
)

fi_itf <- as.numeric(table(clases_itf))
hi_itf <- fi_itf / n
Fi_itf <- cumsum(fi_itf)
Hi_itf <- cumsum(hi_itf)

tabla_itf <- data.frame(
  clase = etiquetas_itf,
  fi = fi_itf,
  hi = round_sym(hi_itf, 4),
  Fi = Fi_itf,
  Hi = round_sym(Hi_itf, 4)
)

cat("=== Tabla de frecuencias — ITF ===\n")
print(tabla_itf, row.names = FALSE)

# =============================================================================
# 2.2 Tipo de vivienda (IV1) — cualitativa nominal
# Frecuencias que corresponden: fi y hi
# (Fi/Hi no se interpretan en variables nominales: no hay orden natural)
# =============================================================================

etiquetas_iv1 <- c(
  "1 = Casa",
  "2 = Departamento",
  "3 = Pieza en inquilinato",
  "4 = Pieza en hotel/pensión",
  "5 = Local no construido para habitación"
)

iv1_factor <- factor(
  hog$IV1,
  levels = 1:5,
  labels = etiquetas_iv1
)

fi_iv1 <- as.numeric(table(iv1_factor))
hi_iv1 <- fi_iv1 / n

tabla_iv1 <- data.frame(
  categoria = names(table(iv1_factor)),
  fi = fi_iv1,
  hi = round_sym(hi_iv1, 4)
)

cat("\n=== Tabla de frecuencias — IV1 (Tipo de vivienda) ===\n")
print(tabla_iv1, row.names = FALSE)

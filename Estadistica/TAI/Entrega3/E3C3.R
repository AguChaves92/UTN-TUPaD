# =============================================================================
# Estadística — Entrega 3 | Aglomerado 13 (Gran Córdoba)
# Consigna 5: modelo hipergeométrico (hogares inquilinos, II7)
# Consigna 6: modelo normal (Ingreso Total Familiar, ITF)
# Consigna 7: modelo de Poisson (formularios recibidos por el servidor)
#
# En esta entrega pasamos de describir los datos a calcular probabilidades:
#   - En la 5 elegimos 15 hogares al azar y nos preguntamos cuántos pueden
#     ser inquilinos.
#   - En la 6 suponemos que el ITF sigue una distribución normal y
#     calculamos la probabilidad de que un hogar caiga en cierto rango de ingresos.
#   - En la 7 el servidor recibe formularios a una tasa fija y calculamos
#     cuántos pueden llegar en 15, 30 o 45 minutos.
# =============================================================================

# Cargo la librería necesaria para leer archivos Excel
library(readxl)

# Busco el mismo Excel de las entregas anteriores. Si no está en la carpeta
# esperada, se abre una ventana para elegir el archivo a mano.
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

# Función auxiliar: formatea números con punto para miles y coma decimal
fmt_num <- function(x, d = 4) {
  format(round(x, d), nsmall = d, big.mark = ".", decimal.mark = ",", scientific = FALSE, trim = TRUE)
}

# Función auxiliar: pasa una probabilidad a porcentaje (ej: 0.1714 -> 17,14%)
fmt_pct <- function(p) {
  paste0(fmt_num(p * 100, 2), "%")
}

# =============================================================================
# 5. MODELO HIPERGEOMÉTRICO — Hogares inquilinos
#
# La consigna toma como población a los 330 hogares encuestados y elige
# 15 al azar, sin reposición. Cada hogar elegido puede ser:
#   - Éxito:   inquilino (II7 = 3)
#   - Fracaso: cualquier otro régimen de tenencia
#
# x: cantidad de hogares inquilinos que pueden obtenerse al seleccionar 15
#
# Parámetros del modelo:
#   N = tamaño de la población (330 hogares)
#   K = cantidad de éxitos en la población (hogares inquilinos)
#   n = tamaño de la muestra (15 hogares)
#
# Función de cuantía:
#   P(x = xi) = C(K, xi) * C(N − K, n − xi) / C(N, n)
#
# Criterio de la cátedra: el hipergeométrico es obligatorio cuando el
# muestreo es sin reposición y n/N > 0,05. Acá n/N = 15/330 = 0,0455,
# así que la binomial serviría como aproximación. Igual usamos el
# hipergeométrico porque el muestreo es sin reposición y conocemos el tamaño
# exacto de la población: es el modelo exacto.
#
# En R:
#   dhyper(x, éxitos, fracasos, tamaño de muestra) -> P(x = xi)
#   phyper(x, éxitos, fracasos, tamaño de muestra) -> P(x <= xi)
# Ojo: el tercer argumento son los FRACASOS (N − K).
# =============================================================================

# Cuántos hogares hay en cada régimen de tenencia
table(hog$II7)

# Parámetros
N <- nrow(hog)               # total de hogares de la población
K <- sum(hog$II7 == 3)       # hogares inquilinos (éxitos)
n <- 15                      # hogares seleccionados

# Fracción de muestreo: qué parte de la población entra en la muestra
fraccion <- n / N

# Posibles valores de x: si n <= K, x va de 0 a n; si no, de 0 a K
x_max <- min(n, K)

cat("=== 5. Modelo hipergeométrico ===\n")
cat("N =", N, "| K =", K, "| N - K =", N - K, "| n =", n, "\n")
cat("n/N =", fmt_num(fraccion), "\n")
cat("x puede tomar valores de 0 a", x_max, "\n\n")

# -----------------------------------------------------------------------------
# 5.1 ¿Probabilidad de que 4 de los hogares seleccionados sean inquilinos?
#     P(x = 4) = C(101, 4) * C(229, 11) / C(330, 15)
# -----------------------------------------------------------------------------
p_5_1 <- dhyper(4, K, N - K, n)

# -----------------------------------------------------------------------------
# 5.2 ¿Probabilidad de que más de 8 sean inquilinos?
#     "Más de 8" = 9 o más -> P(x > 8) = P(x = 9) + ... + P(x = 15)
#     lower.tail = FALSE da directamente el área "mayor que"
# -----------------------------------------------------------------------------
p_5_2 <- phyper(8, K, N - K, n, lower.tail = FALSE)

# -----------------------------------------------------------------------------
# 5.3 ¿Probabilidad de que a lo sumo 6 sean inquilinos?
#     "A lo sumo 6" = 6 o menos (incluye el 0)
#     P(x <= 6) = P(x = 0) + P(x = 1) + ... + P(x = 6)
# -----------------------------------------------------------------------------
p_5_3 <- phyper(6, K, N - K, n, lower.tail = TRUE)

# Tabla resumen del punto 5
tabla_5 <- data.frame(
  Consigna = c("5.1 P(x = 4)", "5.2 P(x > 8)", "5.3 P(x <= 6)"),
  Tipo = c("valor exacto -> dhyper", "más de 8 -> suma de 9 a 15", "a lo sumo 6 -> suma de 0 a 6"),
  Resultado = c(fmt_num(p_5_1), fmt_num(p_5_2), fmt_num(p_5_3)),
  Porcentaje = c(fmt_pct(p_5_1), fmt_pct(p_5_2), fmt_pct(p_5_3)),
  stringsAsFactors = FALSE
)

cat("=== Resumen del punto 5 ===\n")
print(tabla_5, row.names = FALSE, right = FALSE)

# =============================================================================
# 6. MODELO NORMAL — Ingreso Total Familiar (ITF)
#
# x: Ingreso Total Familiar de un hogar seleccionado aleatoriamente
#
# Parámetros (calculados con los 330 hogares):
#   μ = media del ITF
#   σ = desvío estándar del ITF (muestral, igual que en la Entrega 2)
#
# Se excluyen los hogares con ITF = -9 ("no respondió").
# Como la variable es continua, P(x >= a) es lo mismo que P(x > a).
#
# Cálculo a mano (para entender qué hace pnorm):
#   z = (x − μ) / σ -> a cuántos desvíos del promedio está el valor
#   Con z se busca en la tabla de la normal estándar el área a la izquierda.
# pnorm hace la estandarización y la búsqueda en un solo paso, con el z exacto.
# =============================================================================

# Lista de ingresos a analizar: se sacan los vacíos y los "no responde" (-9)
itf <- hog$ITF[!is.na(hog$ITF) & hog$ITF != -9]

# Parámetros de la normal, redondeados a 4 decimales como pide la consigna
media <- round(mean(itf), 4)
desv  <- round(sd(itf), 4)

# Función auxiliar: calcula z (a cuántos desvíos de la media está un valor),
# redondeado a 2 decimales como se busca en la tabla de la normal estándar
calcular_z <- function(valor) {
  fmt_num((valor - media) / desv, 2)
}

# Secuencia de valores para dibujar la curva: de media − 4 desvíos a media + 4
# desvíos, que cubre prácticamente toda la distribución
x <- seq(media - 4*desv, media + 4*desv, length = 200)
y <- dnorm(x, mean = media, sd = desv)

# Función para mostrar montos cortos en el gráfico (ej: 1500000 -> $1,5M)
fmt_eje <- function(x) {
  signo <- ifelse(x < 0, "-", "")
  monto <- abs(x)
  texto <- ifelse(
    monto == 0, "0",
    ifelse(
      monto < 1000000,
      paste0(round(monto / 1000), "K"),
      paste0(format(round(monto / 1000000, 1), decimal.mark = ",", trim = TRUE), "M")
    )
  )
  paste0(signo, "$", texto)
}

# Función que dibuja la campana normal y sombrea el área pedida
#   desde, hasta: límites del área sombreada
#   cortes:       valor/es de la consigna, para marcarlos en el gráfico
#   titulo:       texto del título
#   color:        color del sombreado
graficar_normal <- function(desde, hasta, cortes, titulo, color) {
  par(mar = c(5, 2, 4, 2))
  
  # Curva sin ejes (los armamos a mano para que se lean mejor)
  plot(x, y, type = 'l', lwd = 2, col = 'black',
       main = titulo, xlab = 'Ingreso Total Familiar ($)', ylab = '',
       xaxt = 'n', yaxt = 'n', bty = 'n')
  
  # Eje X en millones redondos
  marcas <- seq(-2000000, 5000000, by = 1000000)
  axis(side = 1, at = marcas, labels = fmt_eje(marcas), cex.axis = 0.85)
  
  # Área sombreada
  x_sombreado <- seq(desde, hasta, length = 100)
  y_sombreado <- dnorm(x_sombreado, mean = media, sd = desv)
  polygon(c(desde, x_sombreado, hasta), c(0, y_sombreado, 0), col = color, border = NA)
  
  # Línea punteada en la media, con su etiqueta
  abline(v = media, lty = 2, col = 'gray40')
  text(media, max(y), paste0("media = ", fmt_eje(media)), pos = 4, cex = 0.8, col = 'gray30')
  
  # Etiqueta con el valor de corte de la consigna
  # (si hay dos cortes, uno va a la izquierda y otro a la derecha para que no se pisen)
  posiciones <- c(2, 4)
  for (i in seq_along(cortes)) {
    text(cortes[i], dnorm(cortes[i], mean = media, sd = desv), fmt_eje(cortes[i]),
         pos = posiciones[i], cex = 0.8, font = 2)
  }
}

# -----------------------------------------------------------------------------
# 6.1 P(x >= 350.000) — caso "mayor que" (área a la derecha)
# -----------------------------------------------------------------------------
valor_6_1 <- 350000
p_6_1 <- pnorm(valor_6_1, mean = media, sd = desv, lower.tail = FALSE)

graficar_normal(
  desde = valor_6_1, hasta = media + 4*desv, cortes = valor_6_1,
  titulo = paste0('P(X >= ', fmt_pesos(valor_6_1), ') = ', fmt_num(p_6_1), ' (', fmt_pct(p_6_1), ')'),
  color = '#FF7F00'
)

# -----------------------------------------------------------------------------
# 6.2 P(250.000 < x < 300.000) — caso "entre" (resta de dos áreas)
# -----------------------------------------------------------------------------
valor1_6_2 <- 250000
valor2_6_2 <- 300000
p_6_2 <- pnorm(valor2_6_2, mean = media, sd = desv) - pnorm(valor1_6_2, mean = media, sd = desv)

# (la franja queda finita porque $50.000 es poco comparado con el desvío)
graficar_normal(
  desde = valor1_6_2, hasta = valor2_6_2, cortes = c(valor1_6_2, valor2_6_2),
  titulo = paste0('P(', fmt_pesos(valor1_6_2), ' < X < ', fmt_pesos(valor2_6_2), ') = ',
                  fmt_num(p_6_2), ' (', fmt_pct(p_6_2), ')'),
  color = '#b8860b'
)

# -----------------------------------------------------------------------------
# 6.3 P(x < 450.000) — caso "menor que" (área a la izquierda)
# -----------------------------------------------------------------------------
valor_6_3 <- 450000
p_6_3 <- pnorm(valor_6_3, mean = media, sd = desv, lower.tail = TRUE)

graficar_normal(
  desde = media - 4*desv, hasta = valor_6_3, cortes = valor_6_3,
  titulo = paste0('P(X < ', fmt_pesos(valor_6_3), ') = ', fmt_num(p_6_3), ' (', fmt_pct(p_6_3), ')'),
  color = '#309076'
)

# Tabla resumen del punto 6
tabla_6 <- data.frame(
  Consigna = c("6.1 P(x >= 350.000)", "6.2 P(250.000 < x < 300.000)", "6.3 P(x < 450.000)"),
  Tipo = c("mayor que -> 1 - tabla", "entre -> resta", "menor que -> tabla directa"),
  z = c(
    calcular_z(valor_6_1),
    paste0(calcular_z(valor1_6_2), " y ", calcular_z(valor2_6_2)),
    calcular_z(valor_6_3)
  ),
  Resultado = c(fmt_num(p_6_1), fmt_num(p_6_2), fmt_num(p_6_3)),
  Porcentaje = c(fmt_pct(p_6_1), fmt_pct(p_6_2), fmt_pct(p_6_3)),
  stringsAsFactors = FALSE
)

cat("\n=== Resumen del punto 6 | μ =", fmt_num(media), "| σ =", fmt_num(desv), "===\n")
print(tabla_6, row.names = FALSE, right = FALSE)

# =============================================================================
# 7. MODELO DE POISSON — Formularios que llegan al servidor
#
# x: cantidad de formularios completados que el servidor recibe en un
# intervalo de tiempo.
#
# La consigna da el promedio en una hora: 12 formularios. Cada pregunta
# mira otro intervalo, así que la media de Poisson se achica en la misma
# proporción:
#   λ = 12 * (minutos / 60)
#
#   15 min -> λ = 12 * 15/60 = 3
#   30 min -> λ = 12 * 30/60 = 6
#   45 min -> λ = 12 * 45/60 = 9
#
# x puede ser 0, 1, 2, ... sin un máximo fijo: en un intervalo pueden
# llegar más formularios que el promedio.
#
# Función de cuantía:
#   P(x = xi) = e^(−λ) * λ^xi / xi!
#
# La consigna pide dos supuestos: las recepciones son independientes y la
# tasa promedio se mantiene constante. Con eso el conteo en un intervalo
# fijo sigue una Poisson de media λ.
#
# En R:
#   dpois(x, lambda) -> P(x = xi)
#   ppois(x, lambda) -> P(x <= xi)
# Ojo: en una variable discreta, "menos de 7" es P(x <= 6).
# =============================================================================

# Tasa que da la consigna, en formularios por hora
tasa_hora <- 12

# Cada ítem usa su propio λ, porque el intervalo no es el mismo
lambda_7_1 <- tasa_hora * 15 / 60   # 15 minutos
lambda_7_2 <- tasa_hora * 30 / 60   # 30 minutos
lambda_7_3 <- tasa_hora * 45 / 60   # 45 minutos

cat("\n=== 7. Modelo de Poisson ===\n")
cat("Tasa =", tasa_hora, "formularios por hora\n")
cat("λ(15 min) =", lambda_7_1,
    "| λ(30 min) =", lambda_7_2,
    "| λ(45 min) =", lambda_7_3, "\n\n")

# -----------------------------------------------------------------------------
# 7.1 ¿Probabilidad de que reciba exactamente 4 formularios en 15 minutos?
#     λ = 3
#     P(x = 4) = e^(-3) * 3^4 / 4!
# -----------------------------------------------------------------------------
p_7_1 <- dpois(4, lambda = lambda_7_1)

# -----------------------------------------------------------------------------
# 7.2 ¿Probabilidad de que reciba como máximo 5 formularios en 30 minutos?
#     λ = 6
#     "Como máximo 5" = 5 o menos (incluye el 0)
#     P(x <= 5) = P(x = 0) + P(x = 1) + ... + P(x = 5)
# -----------------------------------------------------------------------------
p_7_2 <- ppois(5, lambda = lambda_7_2, lower.tail = TRUE)

# -----------------------------------------------------------------------------
# 7.3 ¿Probabilidad de que reciba menos de 7 formularios en 45 minutos?
#     λ = 9
#     "Menos de 7" = 6 o menos. El 7 no entra.
#     P(x < 7) = P(x <= 6) = P(x = 0) + ... + P(x = 6)
# -----------------------------------------------------------------------------
p_7_3 <- ppois(6, lambda = lambda_7_3, lower.tail = TRUE)

# Tabla resumen del punto 7
tabla_7 <- data.frame(
  Consigna = c(
    "7.1 P(x = 4) en 15 min",
    "7.2 P(x <= 5) en 30 min",
    "7.3 P(x < 7) en 45 min"
  ),
  Tipo = c(
    "valor exacto -> dpois",
    "como máximo 5 -> suma de 0 a 5",
    "menos de 7 -> suma de 0 a 6"
  ),
  Lambda = c(lambda_7_1, lambda_7_2, lambda_7_3),
  Resultado = c(fmt_num(p_7_1), fmt_num(p_7_2), fmt_num(p_7_3)),
  Porcentaje = c(fmt_pct(p_7_1), fmt_pct(p_7_2), fmt_pct(p_7_3)),
  stringsAsFactors = FALSE
)

cat("=== Resumen del punto 7 ===\n")
print(tabla_7, row.names = FALSE, right = FALSE)
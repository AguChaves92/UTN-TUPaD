library(readxl)

# Cargar archivo Excel
hog <- read_excel(file.choose())

# Cantidad de hogares
nrow(hog)

# Primeros valores de ITF
head(hog$ITF)

# Verificar datos faltantes
sum(is.na(hog$ITF))

# Calcular la media poblacional del ITF - Sera nuestra base para comparar las medias muestrales
media_poblacional <- mean(hog$ITF)

# Mostrar el resultado con 4 decimales
round(media_poblacional, 4)

# Fijamos una semilla para reproducir los resultados
set.seed(123)

# Seleccionamos aleatoriamente 20 hogares con reposición
indices_muestra1 <- sample(
  1:nrow(hog),
  size = 20,
  replace = TRUE
)

# Obtenemos los hogares seleccionados
muestra1 <- hog[indices_muestra1, ]

# Calculamos el ITF promedio de esta muestra
media_muestra1 <- mean(muestra1$ITF)

media_muestra1

# Lista para guardar las 6 muestras
muestras <- vector("list", 6)

# Guardamos la primera muestra
muestras[[1]] <- muestra1

# Generamos las otras 5 muestras
for (i in 2:6) {
  indices <- sample(
    1:nrow(hog),
    size = 20,
    replace = TRUE
  )
  
  muestras[[i]] <- hog[indices, ]
}

# Calculamos los 6 promedios
medias_muestrales <- sapply(
  muestras,
  function(m) mean(m$ITF)
)

# Mostramos los resultados
sprintf("%.4f", medias_muestrales)

# Redondeo simétrico a 4 decimales
round_sym <- function(x, digits = 4) {
  factor <- 10^digits
  sign(x) * floor(abs(x) * factor + 0.5) / factor
}

# Construir tabla comparativa
tabla_comparacion <- data.frame(
  Muestra = 1:6,
  Media_ITF = sprintf("%.4f", round_sym(medias_muestrales)),
  Diferencia = sprintf(
    "%.4f",
    round_sym(medias_muestrales - media_poblacional)
  )
)

print(tabla_comparacion, row.names = FALSE)

#EXTRA

# Definir colores según la comparación con la media poblacional
colores <- ifelse(
  medias_muestrales >= media_poblacional,
  "steelblue",
  "tomato"
)

# Crear el gráfico
plot(
  1:6,
  medias_muestrales,
  pch = 19,
  cex = 1.5,
  col = colores,
  xaxt = "n",
  xlab = "Muestras aleatorias",
  ylab = "ITF promedio ($)",
  main = "Comparación de medias muestrales y poblacional"
)

# Identificar las seis muestras
axis(1, at = 1:6, labels = paste("M", 1:6))

# Agregar línea de la media poblacional
abline(
  h = media_poblacional,
  col = "darkgreen",
  lty = 2,
  lwd = 2
)

# Agregar leyenda
legend(
  "topright",
  legend = c(
    "Media superior a la poblacional",
    "Media inferior a la poblacional",
    "Media poblacional"
  ),
  col = c("steelblue", "tomato", "darkgreen"),
  pch = c(19, 19, NA),
  lty = c(NA, NA, 2),
  bty = "n",
  cex = 0.8
)

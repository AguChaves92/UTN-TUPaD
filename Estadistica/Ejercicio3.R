# Leer el Excel de la práctica (variable nominal / frecuencias)
library(readxl)
datos <- read_excel("Datos Práctica Tabla de Frecuencias en R (V Nominal).xlsx")

# --- Tickets_Soporte: cuantitativa discreta ---
# Frecuencia absoluta (fi), relativa (hi) y acumulada (Fi)
fi_tickets <- table(datos$Tickets_Soporte)
hi_tickets <- prop.table(fi_tickets)
Fi_tickets <- cumsum(fi_tickets)

tabla_tickets <- data.frame(
  xi = as.numeric(names(fi_tickets)),
  fi = as.numeric(fi_tickets),
  hi = round(as.numeric(hi_tickets), 4),
  Fi = as.numeric(Fi_tickets)
)
tabla_tickets

# --- Tiempo_Conexion: cuantitativa continua ---
# Se agrupa en clases con cut(). La cantidad de clases se obtiene con Sturges:
# k = 1 + 3.322 * log10(n)
n <- nrow(datos)
k <- ceiling(1 + 3.322 * log10(n))
xmin <- min(datos$Tiempo_Conexion)
xmax <- max(datos$Tiempo_Conexion)
amplitud <- ceiling((xmax - xmin) / k)
breaks <- seq(xmin, xmin + k * amplitud, by = amplitud)

clases_tiempo <- cut(
  datos$Tiempo_Conexion,
  breaks = breaks,
  right = FALSE,
  include.lowest = TRUE
)

fi_tiempo <- table(clases_tiempo)
hi_tiempo <- prop.table(fi_tiempo)
Fi_tiempo <- cumsum(fi_tiempo)

tabla_tiempo <- data.frame(
  clase = names(fi_tiempo),
  fi = as.numeric(fi_tiempo),
  hi = round(as.numeric(hi_tiempo), 4),
  Fi = as.numeric(Fi_tiempo)
)
tabla_tiempo

# --- Medidas descriptivas: Tickets_Soporte y Tiempo_Conexion ---
# Tickets es discreta: la moda es el valor con mayor fi.
# Tiempo es continua: se informa la clase modal (intervalo con mayor fi).
calcular_moda <- function(x) {
  frec <- table(x)
  paste(names(frec)[frec == max(frec)], collapse = ", ")
}

tickets <- datos$Tickets_Soporte
tiempo <- datos$Tiempo_Conexion
clase_modal <- names(fi_tiempo)[which.max(fi_tiempo)]

tabla_medidas <- data.frame(
  Medida = c("n", "Media", "Mediana", "Moda", "Q1", "Q2", "Q3", "Desvio_estandar", "CV_%"),
  Tickets_Soporte = c(
    length(tickets),
    round(mean(tickets), 2),
    median(tickets),
    calcular_moda(tickets),
    unname(quantile(tickets, 0.25)),
    unname(quantile(tickets, 0.50)),
    unname(quantile(tickets, 0.75)),
    round(sd(tickets), 2),
    round(sd(tickets) / mean(tickets) * 100, 2)
  ),
  Tiempo_Conexion = c(
    length(tiempo),
    round(mean(tiempo), 2),
    round(median(tiempo), 2),
    clase_modal,
    round(unname(quantile(tiempo, 0.25)), 2),
    round(unname(quantile(tiempo, 0.50)), 2),
    round(unname(quantile(tiempo, 0.75)), 2),
    round(sd(tiempo), 2),
    round(sd(tiempo) / mean(tiempo) * 100, 2)
  ),
  stringsAsFactors = FALSE
)
tabla_medidas

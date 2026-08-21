# Leer el Excel
library(readxl)
datos <- read_excel("Datos estudiantes de programación.xlsx")

# 1) Lenguaje_Favorito: variable cualitativa categórica
# table() cuenta cuántos estudiantes eligen cada lenguaje (frecuencias absolutas)
#table(datos$Lenguaje_Favorito)

# 2) Proyectos_Completados: variable cuantitativa discreta
# Tabla de frecuencias: xi (valor), fi (absoluta), hi (relativa),
# Fi (absoluta acumulada) y Hi (relativa acumulada)
fi <- table(datos$Proyectos_Completados)
hi <- prop.table(fi)
Fi <- cumsum(fi)
Hi <- cumsum(hi)

tabla_proyectos <- data.frame(
    Proyectos= names(fi),
    fi = as.numeric(fi),
    hi = as.numeric(hi),
    Fi = as.numeric(Fi),
    Hi = as.numeric(Hi)
)
tabla_proyectos

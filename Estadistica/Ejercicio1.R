# Vector con los nombres de 4 lenguajes de programación
lenguajes <- c("Python", "R", "Java", "JavaScript")

# Mostrar el segundo elemento
lenguajes[2]

# Matriz de 2 filas y 3 columnas con números del 1 al 6
matriz <- matrix(1:6, nrow = 2, ncol = 3, byrow = TRUE)
matriz


matriz2 <- matrix(c(1, 2, 3, 4, 5, 6), 2, 3)
matriz2

# Dataframe con nombre, edad y carrera (3 personas)
alumnos <- data.frame(
  nombre = c("Ana", "Luis", "Sofia"),
  edad = c(20, 22, 19),
  carrera = c("Estadistica", "Sistemas", "Estadistica")
)
alumnos



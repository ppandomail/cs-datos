# Exploración y Visualización de Datos

* Profesor: Diego Edwards Molina
* TP individual al final del cuatrimestre

## Ciencia de Datos

* Es un enfoque multidisciplinario (prog + informática + estadistica + conoc de negocio)
* Importante: sacar valor a los datos
* Datos -> Clasificar -> Ordenar -> Visualizar y Analizar

## Tipos de datos

* Estructurados: modelo definido
  * Tablas, BD
* Semiestructurados
  * XML, JSON
* No estructurados: sin modelo (sin organización)
  * Textual, Imagen, video, audio
* Metadata: datos acerca de datos

## Machine Learning (ML)

* Algoritmo aprenda por si solo
* Ejemplo distinguir entre perros y gatos

## IA

* IA -> ML -> DL (Deep Learning)
* Estrategias: Arbol de Decisión, Redes Neuronales

## Big Data

* Conjunto de datos extremadamente grande
* Las 5 V:
  * Velocidad: momento oportuno para que no pierdan valor
  * Veracidad:
  * Variedad: diferentes fuentes
  * Volumen: almacenamiento complejo y capacidad de almacenamiento a nivel Tera
  * Valor: información que puedan tener los datos

## Herramientas

* Programación
  * R -> IDE: RStudio -> FW: Shiny
  * Python -> IDE: Jupyter -> FW: scikit learn

* BigData
  * Spark
  * Cloud

## Usos

* Auto autónomos
* Casas inteligentes
* Gestión de tránsito
* Ciudades inteligentes
* Ofertas personalizadas
* Sistema de recomendaciones
* Predecir el comportamiento de los usuarios y mejorar su experiencia en la plataforma

## R

* Es un lenguaje de programación orientado a objetos
* Muchas librerias (software libre)
* Fuerte en estadistica y académico
* [Descarga R](https://cran.r-project.org/)
* [Descarga RStudio](https://posit.co/download/rstudio-desktop/)
* Es un entorno de software libre para el cálculo estadístico y generación de gráficos

### Manejo de datos R

|                           | Sintaxis             | Ejemplos     |
| --                        | --                   | --           |
| Asignación                | <-                   | x <- 1       |
| Comentarios               | #                    | # comentario |
| Comillas                  | ""                   | "hola"       |
| Imprimir                  | print                | print(x)     |
| Tipo objeto               | mode                 | mode(x)      |
| Longitud objeto           | length               | length(x)    |
| Borrar objetos de memoria | rm                   | rm(x)        |
| Ver objetos guardados     | ls                   | ls()         |
| Operadores aritméticos    | +, -, *, /, ^, %%    | 4 %% 2       |
| Funciones matemáticas     | sqrt, log, sum, prod | sum(c(2, 4)) |
| Valores muy grandes       | Inf, -Inf            | 2^2048       |
| Indeterminación           | NaN                  | 0/0          |
| Operadores relacionales   | <, <=, >, >=, ==, != | 9 != 3       |
| Operadores lógicos        | \|, &, !             | !TRUE        |

### Tipos de datos R

|                           | Sintaxis             | Ejemplos                                                 |
| --                        | --                   | --                                                       |
| Caracter                  | ""                   | str <- "Pablo"                                           |
| Numérico                  |                      | n <- 0.5                                                 |
| Entero                    |                      | i <- 5                                                   |
| Complejo                  |                      | c <- 2 + 4i                                              |
| Lógico                    | TRUE, FALSE          | b <- TRUE                                                |
| Vector                    | c(...)               | v <- c(1, 2, 3)                                          |
| Secuencia                 | min:max              | s <- 1:10                                                |
| Factor                    | factor               | f <- factor(c(1, 2))                                     |
| Matriz                    | matriz               | m <- matrix(1:6, nrow=2, ncol=3)                         |
| Lista                     | list                 | l <- list(1:5, c('a', 'b'))                              |
| Data frames               | data.frame           | df<- data.frame(vocal=c('a', 'e', 'o'), cant=c(3, 2, 3)) |

### Funciones sobre tipos

|                           | Sintaxis             | Ejemplos                              |
| --                        | --                   | --                                    |
| Tabla de frecuencias      | table                | table(c(1, 2, 1, 1, 3))               |
| Replica elementos         | rep                  | c(rep("rojo", 2))                     |
| Dimensiones de matriz     | dim                  | dim(matrix(nrow=2, ncol=3))           |
| Número de filas           | nrow                 | nrow(df)                              |
| Número de columnas        | ncol                 | ncol(df)                              |
| Nombre de filas           | rownames             | rownames(df)                          |
| Nombre de columnas        | colnames             | colnames(df)                          |
| Atributos de un objeto    | attributes           | attributes(df)                        |
| Extraer elementos         | [], $                | v[1]; v[c(1, 2, 3)]; v[1:3]; df$vocal |
| Filtro en dataframe       | subset               | subset(df, vocal=="a")                |
| in                        | %in%                 | subset(df, vocal %in% c("a", "o"))    |
| Coerción a numérico       | as.numeric           | as.numeric(c('1.5', '3.2'))           |
| Coerción a caracter       | as.character         | as.character(c(1, 3))                 |
| Coerción a entero         | as.integer           | as.integer(c('1', '3'))               |
| Coerción a lógico         | as.logical           | as.logical(c(0, 1, 2)) # 0:FALSE      |
| Coerción a factor         | as.factor            | as.factor(c("a", "b", "a", "a"))      |

### Importar e exportar datos

|                           | Sintaxis             | Ejemplos                                           |
| --                        | --                   | --                                                 |
| Obtener directorio trabajo| getwd()              | getwd()                                            |
| Setear directorio trabajo | setwd(...)           | setwd("c:/....")                                   |
| Importar básico           | read.table(...)      | df <- read.table("arch.csv", sep=";", header=TRUE) |
| Imp desde CSV             | read.csv(...)        | df <- read.csv("arch.csv", sep=";")                |
| Imp desde Excel [openxlsx]| read.xlsx(...)       | df <- read.xlsx("arch.xlsx")                       |
| Verificar importacion     | head(...)            | head(df)                                           |
| Exportar básico           | write.table(...)     | write.table(x=df, file="xxx.csv", sep=";")         |
| Exp a CSV (sep por ",")   | write.csv(...)       | write.csv(x=df, file="xxx.csv")                    |
| Exp a CSV (sep por ";")   | write.csv2(...)      | write.csv2(x=df, file="xxx.csv")                   |
| Expo a Excel              | write.xlsx(...)      | write.xlsx(x=df, file="xxx.xlsx", rowNames=FALSE)  |

### Transformar datos

|                           | Sintaxis             | Ejemplos                                                          |
| --                        | --                   | --                                                                |
| f(x, y)                   | x %>% f(.,y)         | x <- 1:4; x %>% sum %>% sqrt # sqrt(sum(x))                       |
| Seleccionar var [dplyr]   | select               | df <- df %>% select(v1, v2, v3)                                   |
| Filtrar datos   [dplyr]   | filter               | df <- df %>% filter(v1 %in% c["a", "b"] & v3 > 10)                |
| Filtrar sin NA            | filter               | df %>% filter(complete.cases(v2))                                 |
| Modificar df    [dplyr]   | mutate               | df <- df %>% mutate(v4 = v2*100)                                  |
| Ordenar datos   [dplyr]   | arrange              | df <- df %>% arrange(desc(v2))                                    |
| Calcul posagrupar [dplyr] | summarize            | df <- df %>% group_by(v1) %>% summarize(v= min(v2))               |
| Columnas a 1 col  [tidyr] | pivot_long           |                                                                   |
|                           | pivot_wider          |                                                                   |
| Separa 1 col en n cols    | separatte            | separate(df[, c("v1", "v2")], col="v2", c("v21", "v22"), sep=",") |
| Une n cols en 1 col       | unitte               | unitte(df[, c("v1", "v2")], col="v1v2")                           |
| Unir tablas               | joins                | left_join(df, df2, by="v1")                                       |

### Funciones

|                           | Sintaxis             | Ejemplos                                                          |
| --                        | --                   | --                                                                |
| Mínimo                    | min()                | min(v1)                                                           |
| Máximo                    | max()                | max(v1)                                                           |
| Promedio                  | mean()               | mean(v1)                                                          |
| Mediana                   | median()             | median(v1)  # Valor que separa la muestra ordenada en dos partes  |
| Varianza                  | var()                | var(v1)                                                           |
| Desvío                    | sd()                 | sd(v1)                                                            |
| Quantiles                 | quantile()           | quantile(v1, 0.25)  # Q1: 0.25  Q2: 0.50   Q3: 0.75               |
| Datos Resumen             | summary()            | summary(v1)                                                       |

### BD en R

|                           | Sintaxis             | Ejemplos                                                          |
| --                        | --                   | --                                                                |
| gapminder [gapminder]     |                      | df <- gapminder::gapminder                                        |
| arquality                 |                      | df <- airquality                                                  |

### Estructuras de control y Funciones en R

|                           | Sintaxis             | Ejemplos                                                          |
| --                        | --                   | --                                                                |
| IF                        | if (cond) {} else {} | if (x == 2) { y <- 3 } else { y <- 4 }                            |
| IFELSE                    | ifelse (cond, V, F)  | ifelse(x == 1, "x es igual a 1", "x es distinto de 1")            |
| FOR                       | for (rango) {}       | for (i in 1:5) { print(i) }                                       |
| WHILE                     | while (cond) {}      | cont <- 0; while (cont < 10) { print(cont); cont <- cont + 2; }   |
| FUNCTION                  | function(...) {}     | s <- function(x=1, y=1) { return (x+y) }; print(s(3)); print(s()) |

### Imputación de datos faltantes

|                                   | Sintaxis             | Ejemplos                                                                             |
| --                                | --                   | --                                                                                   |
|                                   | aggr(...)            | aggr(df, numbers=T, sortVar=T)                                                       |
| Reemplazar NA por la media [mice] | mice()               | df <- mice(db[, names(df) %in% c("v1", "v2")], m=1, maxit=1, method="mean", print=F) |
| Completar datos                   | complete(...)        | df <- complete(df)                                                                   |

### Visualización

|                                   | Sintaxis             | Ejemplos                                                                             |
| --                                | --                   | --                                                                                   |
| Histograma                        | hist(...)            | hist(df, breaks=15, col=NA, border="blue", main="", xlab="", ylab="")                |
| Histograma              [ggplot2] | geom_histogram()     | ggplot(df, aes("leyenda para x")) + geom_histogram()                                 |
| Histograma con color    [ggplot2] | geom_histogram()     | ggplot(df, aes("leyenda para x")) + geom_histogram(colour="green", fill="white")     |
| XY                                | xyplot(...)          | xyplot(df, v1~v2)                                                                    |
| Esquema del gráfico     [ggplot2] | ggplot(...)          | ggplot(df, aes(x=v1, y=v2, color = v3)) # df %>% ggplot(aes(...))                    |
| Esquema del gráfico     [ggplot2] | ggplot(...)          | ggplot(df, aes(x=v1, y=v2, shape = v3))                                              |
| Esquema del gráfico     [ggplot2] | ggplot(...)          | ggplot(df, aes(x=v1, y=v2, alpha = v3)) # escala de grises                           |
| Objetos geométricos     [ggplot2] | geom_point()         | ggplot(df, aes(x=v1, y=v2, color = v3)) + geom_point()                               |
| Puntos fluctuantes      [ggplot2] | geom_jitter()        | ggplot(df, aes(x=v1, y=v2)) + geom_jitter()                                          |
| Configuración colores   [ggplot2] | scale_color_manual() | ... + scale_color_manual(values = c("red", "blue", "green", "orange"))               |
| Línea de tendencia      [ggplot2] | geom_smooth()        | ... + geom_smooth()                                                                  |
| Etiquetas en los puntos [ggplot2] | geom_text()          | ... + geom_text(aes(label(...), size=3, hjust=0.5), vjust=1.2)                       |
| Facets (grf en niveles) [ggplot2] | facet_wrap()         | ... + facet_wrap(~ factor)                                                           |
| Temas (apariencia)      [ggplot2] | theme_xxx()          | ... + theme_bw()  # theme_ [light \| classic \| dark \| gray \| linedraw] ()         |
| Título                  [ggplot2] | ggtitle()            | ... + ggtitle("Un título")                                                           |
| Estadisticas            [ggplot2] | stat_summary()       | ... + stat_summary(fun=mean, geom="point", size=2)                                   |
| Barras                  [ggplot2] | geom_bar()           | ... + geom_bar()                                                                     |
| Barras con color        [ggplot2] | geom_bar()           | ... + geom_bar(color="purple", fill="#69b3a2")                                       |
| Barras agrupadas        [ggplot2] | geom_bar()           | ... + geom_bar(position="dodge")                                                     |
| Barras encolumnadas     [ggplot2] | geom_col()           | ... + geom_col(position="fill")                                                      |
| Mosaico                [ggmosaic] | geom_mosaic()        | ... + geom_mosaic(aes(x=product(Cilindrada), fill=Marca), show.legend=FALSE)         |
| Boxplot                 [ggplot2] | geom_boxplot()       | ... + geom_boxplot()                                                                 |
| Boxplot                 [ggplot2] | geom_boxplot()       | ggplot(df, aes(x=v1, y=v2, fill=as.factor(v3))) + geom_boxplo()                      |
| Matriz correlación   [ggcorrplot] | ggcorrplot()         | corr <- round(cor(df), 2); ggcorrplot(corr)                                          |
| Mapa de calor           [ggplot2] | heatmap()            | heatmap(as.matrix(df))                                                               |
| Gráfico interactivo      [plotly] | ggplotly()           | ggplotly(gglot(df, aes(x=v1, y=v2)))                                                 |
| Gráfico animado       [gganimate] | animate()            | animate(ggplot(df), nframes=200, fps=10, render=gifsy_renderer("gganim.gif"))        |
| Gráfico de nubes     [wordcloud2] | wordcloud2()         | wordcloud2(df, size=.2, shape="circle")                                              |

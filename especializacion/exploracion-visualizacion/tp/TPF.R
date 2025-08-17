library(dplyr)
library(ggplot2)
library(ggthemes)
library(hrbrthemes)
library(plotly)
library(tidyr)
library(tidyverse)
library(scales)
library(mice)

setwd("/Users/ppando/Materias/data/materias/exploracion-visualizacion/tp")
datos <- read.csv("googleplaystore.csv", sep=",")  
nrow(datos) > 0
head(datos)
duplicados <- duplicated(datos)
sum(duplicados)
filter(datos, duplicados)
datos <- distinct(datos)
sum(duplicated(datos))

ggplot(datos, aes(Rating)) + geom_boxplot()
datos <- datos %>% filter(Rating != 19)
nrow(datos %>% filter(Rating == 19)) == 0 

datos$Reviews = as.numeric(datos$Reviews)
ggplot(datos, aes(Reviews)) + geom_boxplot()

datos$Size = ifelse(grepl("M", datos$Size), round(as.numeric(sub("M", "", datos$Size)), 2), datos$Size)
datos$Size = ifelse(grepl("k", datos$Size), round(as.numeric(sub("k", "", datos$Size)) / 1024, 2), datos$Size)
datos$Size = as.numeric(sub("Varies with device", "0", datos$Size))
ggplot(datos, aes(Size)) + geom_boxplot() 

datos$Installs = sub("[+]", "", datos$Installs)
datos$Installs = as.numeric(gsub("[,]", "", datos$Installs))
ggplot(datos, aes(Installs)) + geom_boxplot() 

datos$Price = as.numeric(sub("[$]", "", datos$Price))
ggplot(datos, aes(Price)) + geom_boxplot() 
                                         
str(datos)

datos$Category <- as.factor(datos$Category)
datos$Type <- as.factor(datos$Type)
datos$Content.Rating <- as.factor(datos$Content.Rating)
datos$Genres <- as.factor(datos$Genres)

# calcular el promedio, desvío, mediana, y cuartiles para las variables numéricas (cuantitativas) por categoría
datos %>% 
  group_by(Category) %>%
  select(Rating, Reviews, Size, Installs, Price) %>% 
  summarize(
    promedio_rating = mean(Rating, na.rm = TRUE),
    promedio_reviews = mean(Reviews, na.rm = TRUE),
    promedio_size = mean(Size, na.rm = TRUE),
    promedio_installs = mean(Installs, na.rm = TRUE),
    promedio_precio = mean(Price, na.rm = TRUE)
)

datos %>% 
  group_by(Category) %>%
  select(Rating, Reviews, Size, Installs, Price) %>% 
  summarize(
    desvio_rating = sd(Rating, na.rm = TRUE),
    desvio_reviews = sd(Reviews, na.rm = TRUE),
    desvio_size = sd(Size, na.rm = TRUE),
    desvio_installs = sd(Installs, na.rm = TRUE),
    desvio_precio = sd(Price, na.rm = TRUE)
)

datos %>% 
  group_by(Category) %>%
  select(Rating, Reviews, Size, Installs, Price) %>% 
  summarize(
    mediana_rating = median(Rating, na.rm = TRUE),
    mediana_reviews = median(Reviews, na.rm = TRUE),
    mediana_size = median(Size, na.rm = TRUE),
    mediana_installs = median(Installs, na.rm = TRUE),
    mediana_precio = median(Price, na.rm = TRUE)
)

datos %>% 
  group_by(Category) %>%
  select(Rating, Reviews, Size, Installs, Price) %>% 
  summarize(
    quantiles_rating = quantile(Rating, probs = c(0.25, 0.50, 0.75), na.rm = TRUE),
    quantiles_reviews = quantile(Reviews, probs = c(0.25, 0.50, 0.75), na.rm = TRUE),
    quantiles_size = quantile(Size, probs = c(0.25, 0.50, 0.75), na.rm = TRUE),
    quantiles_installs = quantile(Installs, probs = c(0.25, 0.50, 0.75), na.rm = TRUE),
    quantiles_precio = quantile(Price, probs = c(0.25, 0.50, 0.75), na.rm = TRUE)
)

funcion <- function(bd) {
  lista_externa <- list()
  categorias <- distinct(bd %>% select(Category))
  for (cat in categorias$Category) {
    df <- bd %>% filter(Content.Rating == 'Teen') %>% filter(Category == cat) %>% select(App, Reviews)
    lista_interna <- list(c(cat, min(df$Reviews), max(df$Reviews), mean(df$Reviews)), df)
    lista_externa <- append(lista_externa, lista_interna)
  }
  return (lista_externa)
}
print(funcion(datos))

datos$Year <- sapply(strsplit(datos$Last.Updated, ", "), function(x) x[2])

# Cuento actualizaciones por año y categoría
resumen <- datos %>%
  group_by(Year, Category) %>%
  summarise(Total_Actualizaciones = n(), .groups = "drop")


ggplot(resumen, aes(x = Year, y = Total_Actualizaciones, fill = Category)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(title = "Total de Actualizaciones por Año y Categoría",
       x = "Año", y = "Total de Actualizaciones")

resumen <- datos %>% 
  group_by(Category) %>% 
  summarise(
    app_mas_cara = App[which.max(Price)],
    precio_mas_caro = max(Price, na.rm = TRUE),
    .groups = 'drop')
resumen

ggplot(resumen, aes(x = resumen$precio_mas_caro, y = resumen$app_mas_cara, fill = resumen$Category)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Aplicación más cara por categoría",
       y = "Aplicación", x = "Precio")

ggplot(datos, aes(x = Rating, fill = Type, colour = Type)) + 
  geom_histogram(alpha = 0.5, position = "identity")


filtrado <- datos %>% filter(Category %in% c("HEALTH_AND_FITNESS","SPORTS"))

ggplot(filtrado, aes(x = Category, y = Size, fill = Type)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Comparación del tamaño de aplicaciones de salud y deporte",
       x = "Categoría", y = "Tamaño (MB)",
       fill = "Tipo de aplicación")

datos$Month <- sapply(strsplit(datos$Last.Updated, " "), function(x) x[1])
filtrado <- datos %>% 
  filter(Year == "2018" & Category %in% c("HEALTH_AND_FITNESS","EDUCATION","ENTERTAINMENT")) %>% 
  group_by(Month, Category) %>%
  summarise(Total_Actualizaciones = n(), .groups = "drop")

ggplot(filtrado, aes(x = Month, y = Total_Actualizaciones, group = Category, color = Category)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  theme_minimal() +
  labs(title = "Evolución de Actualizaciones por Mes (2018)",
       x = "Mes", y = "Total de Actualizaciones",
       color = "Categoría")

filtrado <- datos %>% filter(Category %in% c("FAMILY", "GAME", "HEALTH_AND_FITNESS"))

# Filtro datos muy atípicos para visualizar correctamente en gráfico
filtrado <- filtrado %>% filter(between(Price, 0, 0.1))

# Visualizo la dispersión, mediana y posibles valores atípicos de los precios en cada categoría
ggplot(filtrado, aes(x = Category, y = Price, fill = Category)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Comparación de precios por categoría",
       x = "Categoría", y = "Precio",
       fill = "Categoría")


# Filtro aplicaciones con Content.Rating "Teen" y creo un indicador para diferenciar grupos
filtrado <- datos %>%
  filter(Content.Rating == "Teen") %>%
  mutate(Grupo = ifelse(Category %in% c("ENTERTAINMENT", "GAME"), "Entretenimiento/Juego", "Otros")) %>%
  group_by(Grupo) %>%
  summarise(
    Promedio_Rating = mean(Rating, na.rm = TRUE),
    Total_Apps = n()
  )

ggplot(filtrado, aes(x = Grupo, y = Total_Apps, fill = Grupo)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  geom_text(aes(label = Total_Apps), vjust = -0.5) + 
  labs(title = "Comparación del total de aplicaciones (Teen)",
       x = "Grupo", y = "Total de Aplicaciones",
       fill = "Grupo")



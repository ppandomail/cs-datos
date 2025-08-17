library(ggplot2)

# Lectura del archivo

grasas<-read.csv("L:/Mi unidad/CienciaDeDatos/EspecializacionUNO/RegresionLinealSimple/Clase1/GrasasConLeverage_2.csv", sep=";")

# Modelo
modelo <- lm(grasas ~ edad, data = grasas)
summary(modelo)

# Scatter plot y recta de regresión
plot(grasas$edad, grasas$grasas, xlab='edad', ylab='grasas')
abline(modelo)
text(grasas$edad, grasas$grasas, labels = ifelse(grasas$edad > 80, rownames(grasas), ""), pos = 2)

# Grafico residuos estandarizados vs predichos - R base
par(mfrow = c(1, 1))
res_stand<-rstandard(modelo)
plot(modelo$fitted.values,res_stand,xlab="valores predichos",ylab="residuos estandarizados",main="Residuos estandarizados vs. predichos")
abline(0,0,col="red",lwd=2)
text(modelo$fitted.values, res_stand, labels = ifelse(abs(res_stand) > 2, rownames(grasas), ""), pos = 2)

qqnorm(rstandard(modelo), main="Qqnorm de residuos estandarizados")
qqline(rstandard(modelo))
text(qqnorm(rstandard(modelo))$x, qqnorm(rstandard(modelo))$y, 
     labels = ifelse(qqnorm(rstandard(modelo))$x > 1.5, rownames(grasas), ""), pos = 2)

# Grafico residuos estandarizados vs predichos - en ggplot
res.pred.df<-data.frame(x=modelo$fitted.values,y=rstandard(modelo))
res.pred.df$obs <- 1:nrow(res.pred.df)  # agregar número de observación

# Extraer la fila con el valor de x más alto
etiqueta <- res.pred.df %>% filter(x == max(x))  # esta fila tiene 'obs'

# Gráfico
ggplot(data = res.pred.df, aes(x, y)) +
  geom_point(size = 1) +
  geom_hline(yintercept = 0, color = "red") +
  theme_minimal() +
  labs(
    title = "Residuos estandarizados vs. predichos",
    x = "valores predichos",
    y = "residuos estandarizados"
  ) +
  geom_text(data = etiqueta, aes(x = x, y = y, label = obs),
            hjust = -0.2, vjust = 0.5, size = 3)

## qqplot

# qqplot residuos estandarizados - en ggplot
ggplot(data = res.pred.df, aes(sample = y)) +
  stat_qq(color = "dodgerblue") +
  stat_qq_line(color = "red", linetype = "dashed") +
  theme_minimal() +
  labs(title = "Q-Q Plot de residuos estandarizados",
       x = "Cuantiles teoricos",
       y = "Cuantiles muestrales")

## Con etiqueta
# Calcular valores de la Q-Q plot
qq <- qqnorm(res.pred.df$y, plot.it = FALSE)
qq_data <- data.frame(
  obs = 1:length(qq$x),
  x = qq$x,
  y = qq$y
)

# Etiquetar, por ejemplo, los 2 valores más extremos
qq_data$label <- ifelse(abs(qq_data$y) > 2, qq_data$obs, "")

# Graficar con ggplot
ggplot(qq_data, aes(x = x, y = y)) +
  geom_point(color = "dodgerblue") +
  geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +
  geom_text(aes(label = label), hjust = -0.1, size = 3) +
  theme_minimal() +
  labs(title = "Q-Q Plot de residuos estandarizados",
       x = "Cuantiles teoricos",
       y = "Cuantiles muestrales")
########

## Análisis sin la observacion 26

grasas.sin<-grasas[-26,]

modelo.sin <- lm(grasas ~ edad, data = grasas.sin)
summary(modelo.sin)

# Scatter plot y recta de regresión
plot(grasas.sin$edad, grasas.sin$grasas, xlab='edad', ylab='grasas')
abline(modelo.sin)

# Grafico residuos estandarizados vs predichos - R base
par(mfrow = c(1, 1))
res_stand.sin<-rstandard(modelo.sin)
plot(modelo.sin$fitted.values,res_stand.sin,xlab="valores predichos",ylab="residuos estandarizados",main="Residuos estandarizados vs. predichos")
abline(0,0,col="red",lwd=2)
#text(modelo.sin$fitted.values, res_stand.sin, labels = ifelse(abs(res_stand.sin) > 2, rownames(grasas.sin), ""), pos = 2)

qqnorm(rstandard(modelo.sin), main="Qqnorm de residuos estandarizados")
qqline(rstandard(modelo.sin))
#text(qqnorm(rstandard(modelo.sin))$x, qqnorm(rstandard(modelo.sin))$y, 
#    labels = ifelse(qqnorm(rstandard(modelo.sin))$x > 1.5, rownames(grasas.sin), ""), pos = 2)

# Grafico residuos estandarizados vs predichos - en ggplot
res.pred.df.sin<-data.frame(x=modelo.sin$fitted.values,y=rstandard(modelo.sin))

# Gráfico
ggplot(data = res.pred.df.sin, aes(x, y)) +
  geom_point(size = 1) +
  geom_hline(yintercept = 0, color = "red") +
  theme_minimal() +
  labs(
    title = "Residuos estandarizados vs. predichos",
    x = "valores predichos",
    y = "residuos estandarizados"
  ) 


## qqplot

# qqplot residuos estandarizados - en ggplot
ggplot(data = res.pred.df.sin, aes(sample = y)) +
  stat_qq(color = "dodgerblue") +
  stat_qq_line(color = "red", linetype = "dashed") +
  theme_minimal() +
  labs(title = "Q-Q Plot de residuos estandarizados",
       x = "Cuantiles teoricos",
       y = "Cuantiles muestrales")



###########################################################
# Intervalos de confianza para los parametros
confint(modelo.sin)

# prediccion
nuevas.edades.sin <- data.frame(edad = c(30,45))
nuevas.edades.sin

predict(modelo.sin, nuevas.edades.sin)

# Intervalo de confianza
predict(modelo.sin, newdata=nuevas.edades.sin, interval="confidence")

# Intervalo de prediccion
predict(modelo.sin, newdata=nuevas.edades.sin, interval="prediction")

# banda de prediccion
nuevas.edades.sin <- data.frame(edad = seq(20, 63))
# Intervalo de confianza para la respuesta media
ic.con <- predict(modelo.sin, nuevas.edades.sin, interval = 'confidence')
# Intervalos de prediccion
ic.pred <- predict(modelo.sin, nuevas.edades.sin, interval = 'prediction')

nuevas.edades.con.df<-cbind(nuevas.edades.sin,ic.con)
nuevas.edades.pred.df<-cbind(nuevas.edades.sin,ic.pred)
head(nuevas.edades.con.df)
head(nuevas.edades.pred.df)

ggplot(grasas.sin, aes(x=edad, y=grasas))+
  geom_point()+
  geom_smooth(method=lm, formula=y~x, se=TRUE, level=0.95, col='blue', fill='pink2') +
  geom_line(data = nuevas.edades.con.df,aes(x=edad,y=lwr), color="red",
            linetype="dashed") +
  geom_line(data = nuevas.edades.con.df,aes(x=edad,y=upr),color="red",
            linetype="dashed")+
  geom_line(data = nuevas.edades.pred.df,aes(x=edad,y=lwr),color="blue",
            linetype="dashed")+
  geom_line(data = nuevas.edades.pred.df,aes(x=edad,y=upr), color="blue",
            linetype="dashed") +
  theme_light()

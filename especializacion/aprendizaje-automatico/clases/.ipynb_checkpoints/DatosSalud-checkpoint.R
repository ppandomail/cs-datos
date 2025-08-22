library(readxl)
library(ggplot2)

# Ver las primeras filas
library(readxl)
datos_salud<-read_excel("L:/Mi unidad/CienciaDeDatos/EspecializacionUNO/RegresionLinealSimple/Practica/DatosSalud.xlsx")

# Ver las primeras filas
head(datos_salud)

# Calculo la correlacion entre variables
cor(datos_salud)

# Muestro graficamente la correlacion entre variables
pairs(datos_salud)


################################
# Ajustar el modelo
modelo <- lm(Presion ~ Edad, data = datos_salud)
summary(modelo)

# Gráficos básicos de diagnóstico
par(mfrow = c(2, 2))
plot(modelo)

ggplot(datos_salud, aes(x = Edad, y = Presion)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE, color = "blue") +
  theme_minimal()

# Grafico residuos estandarizados vs predichos - R base
par(mfrow = c(1, 1))
res_stand<-rstandard(modelo)
plot(modelo$fitted.values,res_stand,xlab="valores predichos",ylab="residuos estandarizados",main="Residuos estandarizados vs. predichos")
abline(0,0,col="red",lwd=2)
qqnorm(rstandard(modelo), main="Qqnorm de residuos estandarizados")
qqline(rstandard(modelo))

# Grafico residuos estandarizados vs predichos - en ggplot
res.pred.df<-data.frame(x=modelo$fitted.values,y=rstandard(modelo))
ggplot(data=res.pred.df,aes(x,y))+
  geom_point(size=1)+
  geom_hline(yintercept = 0, color="red")+
  theme_minimal() +
  labs(title = "Residuos estandarizados vs. predichos",
       x = "valores predichos",
       y = "residuos estandarizados")

# qqplot residuos estandarizados - en ggplot
ggplot(data = data.frame(residuos = rstandard(modelo)), aes(sample = residuos)) +
  stat_qq(color = "dodgerblue") +
  stat_qq_line(color = "red", linetype = "dashed") +
  theme_minimal() +
  labs(title = "Q-Q Plot de residuos estandarizados",
       x = "Cuantiles teóricos",
       y = "Cuantiles muestrales")

# Intervalos de confianza para los parametros
confint(modelo)

# prediccion
nuevas.edades <- data.frame(Edad = c(30,45))
nuevas.edades

predict(modelo, nuevas.edades)

# Intervalo de confianza 
predict(modelo, newdata=nuevas.edades, interval="confidence")

# Intervalo de prediccion
predict(modelo, newdata=nuevas.edades, interval="prediction")

# banda de prediccion
nuevas.edades <- data.frame(Edad = seq(20, 80))
# Intervalo de confianza para la respuesta media
ic.con <- predict(modelo, nuevas.edades, interval = 'confidence')
# Intervalos de prediccion
ic.pred <- predict(modelo, nuevas.edades, interval = 'prediction')

nuevas.edades.con.df<-cbind(nuevas.edades,ic.con)
nuevas.edades.pred.df<-cbind(nuevas.edades,ic.pred)
head(nuevas.edades.con.df)
head(nuevas.edades.pred.df)

ggplot(datos_salud, aes(x=Edad, y=Presion))+
  geom_point()+
  geom_smooth(method=lm, formula=y~x, se=TRUE, level=0.95, col='blue', fill='pink2') +
  geom_line(data = nuevas.edades.con.df,aes(x=Edad,y=lwr), color="red", 
            linetype="dashed") +
  geom_line(data = nuevas.edades.con.df,aes(x=Edad,y=upr),color="red",
            linetype="dashed")+     
  geom_line(data = nuevas.edades.pred.df,aes(x=Edad,y=lwr),color="blue",
            linetype="dashed")+
  geom_line(data = nuevas.edades.pred.df,aes(x=Edad,y=upr), color="blue",
            linetype="dashed") +
  theme_light()

library(MASS) #stepAIC
library(leaps) #regsubset
library(caret) #cross validation


#bridge0 <- read.delim("~/Library/CloudStorage/GoogleDrive-jcassetti@campus.ungs.edu.ar/Mi unidad/CienciaDeDatos/EspecializacionUNO/Clases/Clase5/bridge.txt")
bridge0 <- read.delim("L:/Mi unidad/CienciaDeDatos/EspecializacionUNO/Clases/Clase5/bridge.txt")
bridge<-bridge0[,-1]


head(bridge)

pairs(Time~DArea+CCost+Dwgs+Length+Spans,data=bridge,cex.labels=1.4)

modelo=lm(Time~.,data=bridge)

par(mfrow=c(1,1))
plot(modelo$fitted.values,rstandard(modelo))

# Esto evidencia heteroscedasaticidad. La transformación logaritmo puede resolver 
# el problema

pairs(log(Time)~log(DArea)+log(CCost)+log(Dwgs)+log(Length)+log(Spans),data=bridge)

modelo1=lm(log(Time)~log(DArea)+log(CCost)+log(Dwgs)+log(Length)+log(Spans),data=bridge)
plot(modelo1$fitted.values,rstandard(modelo1))
qqnorm(rstandard(modelo1))
qqline(rstandard(modelo1))
shapiro.test(rstandard(modelo1))

# armo data set con los datos transformados
bridge.log<-log(bridge)

par(mfrow=c(1,1))
plot(bridge.log$DArea,rstandard(modelo1), ylab="Res.est")
plot(bridge.log$Dwgs,rstandard(modelo1), ylab="Res.est")
plot(bridge.log$Length,rstandard(modelo1), ylab="Res.est")
plot(bridge.log$Spans,rstandard(modelo1), ylab="Res.ests")

plot(modelo1$fitted.values,rstandard(modelo1), ylab="Res.est",xlab="Fitted values")
abline(0,0,col="red")

# Estudio puntos influyentes
n<-nrow(bridge.log)
sort(hatvalues(modelo1))
hatvalues(modelo1)[hatvalues(modelo1)>2*5/n]

plot(modelo1)

cooks.distance(modelo1)

p <- length(coef(modelo1)) 
leverage_umbral <- 2 * p / n
cooks_umbral <- qf(0.5,p,n-p)
cooks_umbral

plot(cooks.distance(modelo1))

cooks.distance(modelo1)[cooks.distance(modelo1)>cooks_umbral]
plot(modelo1,which=4)

# si bien no supera el umbral, su distancia de cook es mucho más grande que la del resto de 
# las observaciones. La analizo

############################################
##modelo sin 22

bridge.sin<-bridge.log[-c(22),]


modelo2 <- lm(Time~DArea+CCost+Dwgs+Length+Spans,data=bridge.sin)
summary(modelo1)
summary(modelo2)

# cambió la significatividad de la variable CCost, el Ra mejoró, cambió la estimación 
# de algunos parámetros.
# Me quedo con los datos sin la observación 22

# Analizo multicolinealidad

vif(modelo2)

# Hay multicolinealidad severa
# Hacemos selección de variables, y vemos cómo queda el modelo elegido

####################################################
####################################################
# Seleccion de variables

head(bridge.sin)
## Validacion cruzada

ajuste_full<-lm(Time~., data=bridge.sin)

cant.var=length(ajuste_full$coefficients)-1
cant.var

# División 80/20
set.seed(12)
train_index <- createDataPartition(bridge.sin$Time, p = 0.8, list = FALSE)
train_data <- bridge.sin[train_index, ]
test_data <- bridge.sin[-train_index, ]

#Elijo variables sobre el 80% de los datos
# Ajuste de modelos con regsubsets
#por default hace el metodo exhaustivo. Opciones: method="backward" o method="backward")

#metodo exhaustivo

ajuste.regsub <- regsubsets(Time ~ ., data = train_data, nvmax = cant.var)
resumen <- summary(ajuste.regsub)

# Crear tabla resumen
tabla <- data.frame(
  Variables = 1:cant.var,
  R2_ajustado = resumen$adjr2,
  BIC = resumen$bic
)

knitr::kable(tabla, digits = 3)


# Identificar el mejor modelo según cada criterio

mejor_R2 <- which.max(resumen$adjr2)
mejor_BIC <- which.min(resumen$bic)


cat("Mejor R2 ajustado →", mejor_R2, "variables\n")
cat("Mejor BIC         →", mejor_BIC, "variables\n")

############## HAGO KFOLDS
# Control de validación cruzada 5-fold en el conjunto de entrenamiento

# modelo BIC

variables_bic <- names(coef(ajuste.regsub, mejor_BIC))[-1]  # quitamos intercept
variables_bic

formula_bic <- as.formula(paste("Time ~", paste(variables_bic, collapse = "+")))
formula_bic
control <- trainControl(method = "cv", number = 5)

# Entrenar modelo lineal con validación cruzada en train_data
cv.bic <- train(formula_bic, data = train_data, 
                method = "lm", trControl = control)

# Resultados entrenamiento con CV
cv.bic

#########################################################
# modelo R2

variables_R2 <- names(coef(ajuste.regsub, mejor_R2))[-1]  # quitamos intercept
variables_R2

formula_R2 <- as.formula(paste("Time ~", paste(variables_R2, collapse = "+")))
formula_R2
control <- trainControl(method = "cv", number = 5)

# Entrenar modelo lineal con validación cruzada en train_data
cv.R2 <- train(formula_R2, data = train_data, 
               method = "lm", trControl = control)

# Resultados entrenamiento con CV
cv.R2

#####################################################################

# Estimación final de parámetros y predicción en conjunto de test

# Si elegimos BIC

## Estimamos los parametros con el 80%
modelo.80.bic<-lm(formula_bic, data=train_data)
summary(modelo.80.bic)
vif(modelo.80.bic)

# validez del modelo
plot(modelo.80.bic$fitted.values,rstandard(modelo.80.bic))
abline(0,0,col="red")

qqnorm(rstandard(modelo.80.bic))
qqline(rstandard(modelo.80.bic))

# terminar de validar el modelo

####################
# Prediccion

# Obtener solo las variables necesarias para test_data
vars_mejor.bic <- all.vars(formula_bic)
test_data_filtrado.bic <- test_data[vars_mejor.bic]

# Predecir con el modelo ganador sobre las variables correctas

test.df<-data.frame(test_data_filtrado.bic[,-1]) #saco la variable respuesta
predicciones_test.bic <- predict(modelo.80.bic, newdata = test.df)

# Calcular RMSE en test_data
rmse_final.bic <- sqrt(mean((test_data_filtrado.bic$Time - predicciones_test.bic)^2))
cat("RMSE final en conjunto test (20%):", rmse_final.bic, "\n")
cv.bic

# no difiere mucho del RMSE obtenido en el entrenamiento
# no hay evidencia de overfitting

################################
################################
# Predicción en test_data
# Si elegimos R2

## Estimamos los parametros con el 80%
modelo.80.R2<-lm(formula_R2, data=train_data)
summary(modelo.80.R2)

#comparo con el modelo completo
summary(ajuste_full)

# validez del modelo
plot(modelo.80.R2$fitted.values,rstandard(modelo.80.R2))
abline(0,0,col="red")

qqnorm(rstandard(modelo.80.R2))
qqline(rstandard(modelo.80.R2))

# terminar de validar el modelo

# Obtener solo las variables necesarias para test_data
vars_mejor.R2 <- all.vars(formula_R2)
test_data_filtrado.R2 <- test_data[vars_mejor.R2]

# Predecir con el modelo ganador sobre las variables correctas

test.df.R2<-data.frame(test_data_filtrado.R2[,-1]) #saco la variable respuesta
predicciones_test.R2 <- predict(modelo.80.R2, newdata = test.df.R2)

# Calcular RMSE en test_data
rmse_final.R2 <- sqrt(mean((test_data_filtrado.R2$Time - predicciones_test.R2)^2))
cat("RMSE final en conjunto test (20%):", rmse_final.R2, "\n")
cv.R2

# Crear tabla resumen
tabla.CV <- data.frame(
  CV_BIC = cv.bic$results$RMSE[1],
  RMSE_bic = rmse_final.bic,
  CV_R2 = cv.R2$results$RMSE[1],
  RMSE_R2 = rmse_final.R2
)

knitr::kable(tabla.CV, digits = 3)

# Se observa que BIC tiene un mejor comportamiento en la muestra de test que R2

########################################################################################
#####################################
## Seleccion de variables

## AIC

modelo_full <- lm(Time ~ ., data = bridge.sin)
modelo_nulo <- lm(Time ~ 1, data = bridge.sin)

step_model <- stepAIC(modelo_nulo, scope = list(lower = modelo_nulo, upper = modelo_full), direction = "both", trace = FALSE)

summary(step_model)

variables_AIC <- names(coef(step_model))[-1]  # quitamos intercept
variables_AIC

formula_AIC <- as.formula(paste("Time ~", paste(variables_AIC, collapse = "+")))
formula_AIC
formula_bic

# El mismo que BIC. Elijo modelo BIC y hago todo el análisis de 
# la validez de los supuestos del modelo

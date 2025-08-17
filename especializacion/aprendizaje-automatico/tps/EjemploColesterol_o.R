## Cargo librerias

library(MASS)
library(leaps)
library(caret)

# Leo datos

#datos0 <- read.csv("L:/Mi unidad/CienciaDeDatos/EspecializacionUNO/Clases/Clase4/colesterol_o.csv", sep=",")
datos0 <- read.csv("/Users/juliacassetti/Library/CloudStorage/GoogleDrive-jcassetti@campus.ungs.edu.ar/Mi unidad/CienciaDeDatos/EspecializacionUNO/Clases/Clase4/Hoy/colesterol_o.csv", sep=",")

head(datos0)
datos<-datos0[,-1]

head(datos)
pairs(datos)
cor(datos)


# hacemos la regresion con el modelo completo

ajuste_full<-lm(colesterol~., data=datos)

summary(ajuste_full)

plot(ajuste_full)

datos<-datos[-201,]

# Vuelvo a hacer el ajuste sin esta observación

ajuste_full<-lm(colesterol~., data=datos)

summary(ajuste_full)

plot(ajuste_full)

plot(ajuste_full$fitted.values,rstandard(ajuste_full))
abline(0,0,col="red")
abline(-2,0,col="green")
abline(2,0,col="green")

#normalidad de los residuos
qqnorm(rstandard(ajuste_full))
qqline(rstandard(ajuste_full))

# Test de shapiro wilks para normalidad
# H_0: Los datos provienen de una distribución normal 
# H_a: Los datos no provienen de una distribución normal.
shapiro.test(rstandard(ajuste_full))

## puntos influyentes

# leverage
n<-nrow(datos)
p <- length(coef(ajuste_full)) 
leverage_umbral <- 2 * p / n

leverage<-hatvalues(ajuste_full)
alto.lev<-leverage[leverage>leverage_umbral]
alto.lev

# Distancia de cook
cooks_umbral <- qf(0.5,p,n-p)
cooks <- cooks.distance(ajuste_full)

alto.cook<-cooks[cooks>cooks_umbral]
alto.cook
######################################################
######################################################

# Eleccion de variables

# cantidad de variables

cant.var=length(ajuste_full$coefficients)-1
cant.var

# División 80/20
set.seed(13)
train_index <- createDataPartition(datos$colesterol, p = 0.8, list = FALSE)
head(train_index)
nrow(datos)
train_data <- datos[train_index, ]
nrow(train_data)
test_data <- datos[-train_index, ] #no se toca hasta el final

# Ajuste de modelos con regsubsets
#por default hace el metodo exhaustivo. Opciones: method="backward" o method="backward")

#metodo exhaustivo
ajuste <- regsubsets(colesterol ~ ., data = train_data, nvmax = cant.var)
resumen <- summary(ajuste)

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


# Visualizar selección con gráfico

par(mfrow = c(1, 1))
plot(ajuste, scale = "adjr2", main = "Mejor R2 adj")
plot(ajuste, scale = "bic", main = "Mejor BIC")

# Extraer nombres de variables del mejor modelo según BIC

# modelo BIC

variables_bic <- names(coef(ajuste, mejor_BIC))[-1]  # quitamos intercept
variables_bic

formula_bic <- as.formula(paste("colesterol ~", paste(variables_bic, collapse = "+")))
formula_bic


# Modelo R2

variables_R2 <- names(coef(ajuste, mejor_R2))[-1]  # quitamos intercept
variables_R2

formula_R2 <- as.formula(paste("colesterol ~", paste(variables_R2, collapse = "+")))
formula_R2

## 

#########################################################
## YA TENGO ELEGIDAS LOS DOS MODELOS

### HAGO CV PARA ELEGIR UNO

# Control de validación cruzada 5-fold en el conjunto de entrenamiento
control <- trainControl(method = "cv", number = 5)

# Entrenar modelo lineal con validación cruzada en train_data
cv.R2 <- train(formula_R2, data = train_data, 
                method = "lm", trControl = control)

# Resultados entrenamiento con CV
cv.R2


## Entrenamos el modelo
## bic

# Entrenar modelo lineal con validación cruzada en train_data
cv.bic <- train(formula_bic, data = train_data, 
                method = "lm", trControl = control)

cv.R2
cv.bic

#####################################################################

# Evaluacion final

# Predicción en test_data
# Si elegimos BIC

## Estimamos los parametros con el 80%
modelo.80<-lm(formula_bic, data=train_data)
summary(modelo.80)

#comparo con el modelo completo
summary(ajuste_full)

library(car)
vif(modelo.80)

# Obtener solo las variables necesarias para test_data
vars_mejor.bic <- all.vars(formula_bic)
test_data_filtrado.bic <- test_data[vars_mejor.bic]

head(test_data_filtrado.bic)
# Predecir con el modelo ganador sobre las variables correctas

test.df<-data.frame(test_data_filtrado.bic[,-1]) #saco la variable respuesta
predicciones_test.bic <- predict(modelo.80, newdata = test.df)

# Calcular RMSE en test_data
rmse_final.bic <- sqrt(mean((test_data_filtrado.bic$colesterol - predicciones_test.bic)^2))
cat("RMSE final en conjunto test (20%):", rmse_final.bic, "\n")

#####################################################

# Si elegimos R2

## Estimamos los parametros con el 80%
modelo.80.R2<-lm(formula_R2, data=train_data)

# Obtener solo las variables necesarias para test_data
vars_mejor.R2 <- all.vars(formula_R2)
test_data_filtrado.R2 <- test_data[vars_mejor.R2]

# Predecir con el modelo ganador sobre las variables correctas

test.df<-data.frame(test_data_filtrado.R2[,-1]) #saco la variable respuesta
predicciones_test.R2 <- predict(modelo.80.R2, newdata = test.df)

# Calcular RMSE en test_data
rmse_final.R2 <- sqrt(mean((test_data_filtrado.R2$colesterol - predicciones_test.R2)^2))
cat("RMSE final en conjunto test (20%):", rmse_final.R2, "\n")

cat("RMSE final en conjunto test (20%):", rmse_final.bic, "\n")

########################################################
########################################################

# Modelo final

modelo.80
summary(modelo.80)
# estimar los parámetro del modelo con la muestra completa de entrenamiento
# es decir, se reentrena el modelo con la muestra completa de entrenamiento

# Observación: si se tiene que predecir una nueva observación que no conocemos la variable respuesta
# entonces tiene sentido reentrenar el modelo con los datos completos

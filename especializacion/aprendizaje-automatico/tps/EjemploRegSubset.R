library(MASS) #AIC
library(leaps) #regsubset
library(caret) #Cross validation

# Simulación de datos
set.seed(121)
n <- 100
x1 <- rnorm(n)
x2 <- rnorm(n)
x3 <- rnorm(n)
x4 <- rnorm(n)
x5 <- rnorm(n)
y <- 3 + 2*x1 - 1.5*x3 + rnorm(n)
datos <- data.frame(y, x1, x2, x3, x4, x5)

head(datos)
# hacemos la regresion con el modelo completo

pairs(datos)
cor(datos)

# se observa que existe correlacion entre y-x1; y-x3
# no se observa correlacion entre "y" y las otras variables
# tampoco se observa multicolinealidad

ajuste_full<-lm(y~., data=datos)

summary(ajuste_full)

plot(ajuste_full)
1
2
3
4

plot(ajuste_full$fitted.values,rstandard(ajuste_full))
abline(0,0,col="red")
abline(-2,0,col="green")
abline(2,0,col="green")

#normalidad de los residuos
qqnorm(rstandard(ajuste_full))
qqline(rstandard(ajuste_full))

boxplot(rstandard(ajuste_full))
hist(rstandard(ajuste_full),probabilty=TRUE)

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

# Ajuste de modelos con regsubsets
#por default hace el metodo exhaustivo. 
#Opciones: method="backward" o method="forward")

#metodo exhaustivo
ajuste <- regsubsets(y ~ ., data = datos, nvmax = cant.var)
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

# Ajustar el modelo elegido y compararlo

# Extraer nombres de variables del mejor modelo según BIC

# modelo BIC

variables_bic <- names(coef(ajuste, mejor_BIC))[-1]  # quitamos intercept
variables_bic

formula_bic <- as.formula(paste("y ~", paste(variables_bic, collapse = "+")))
formula_bic

modelo_bic <- lm(formula_bic, data = datos)
summary(modelo_bic)

plot(modelo_bic)
1
2
3
4

plot(modelo_bic$fitted.values,rstandard(modelo_bic))
abline(0,0,col="red")
abline(-2,0,col="green")
abline(2,0,col="green")

#normalidad de los residuos
qqnorm(rstandard(modelo_bic))
qqline(rstandard(modelo_bic))

# Test de shapiro wilks para normalidad
# H_0: Los datos provienen de una distribución normal 
# H_a: Los datos no provienen de una distribución normal.
shapiro.test(rstandard(modelo_bic))

## puntos influyentes

# leverage
n<-nrow(datos)
p <- length(coef(modelo_bic)) 
leverage_umbral <- 2 * p / n

leverage<-hatvalues(modelo_bic)
alto.lev<-leverage[leverage>leverage_umbral]
alto.lev

# Distancia de cook
cooks_umbral <- qf(0.5,p,n-p)
cooks <- cooks.distance(modelo_bic)

alto.cook<-cooks[cooks>cooks_umbral]
alto.cook

##########################################################
##########################################################

#modelo R^2

variables_R2 <- names(coef(ajuste, mejor_R2))[-1]  # quitamos intercept
variables_R2

formula_R2 <- as.formula(paste("y ~", paste(variables_R2, collapse = "+")))
formula_R2

modelo_R2 <- lm(formula_R2, data = datos)
summary(modelo_R2)

plot(modelo_R2)
1
2
3
4

plot(modelo_R2$fitted.values,rstandard(modelo_R2))
abline(0,0,col="red")
abline(-2,0,col="green")
abline(2,0,col="green")

#normalidad de los residuos
qqnorm(rstandard(modelo_R2))
qqline(rstandard(modelo_R2))

# Test de shapiro wilks para normalidad
# H_0: Los datos provienen de una distribución normal 
# H_a: Los datos no provienen de una distribución normal.
shapiro.test(rstandard(modelo_R2))

## puntos influyentes

# leverage
n<-nrow(datos)
p <- length(coef(modelo_R2)) 
leverage_umbral <- 2 * p / n

leverage<-hatvalues(modelo_R2)
alto.lev<-leverage[leverage>leverage_umbral]
alto.lev

# Distancia de cook
cooks_umbral <- qf(0.5,p,n-p)
cooks <- cooks.distance(modelo_R2)

alto.cook<-cooks[cooks>cooks_umbral]
alto.cook

###########################################
###########################################

summary(modelo_bic)
summary(modelo_R2)
summary(ajuste_full)

####################################################
####################################################

## Validacion cruzada

cant.var=length(ajuste_full$coefficients)-1
cant.var

# División 80/20
set.seed(11)
train_index <- createDataPartition(datos$y, p = 0.8, list = FALSE)
train_data <- datos[train_index, ]
test_data <- datos[-train_index, ]

#Elijo variables sobre el 80% de los datos
# Ajuste de modelos con regsubsets
#por default hace el metodo exhaustivo. Opciones: method="backward" o method="backward")

#metodo exhaustivo
ajuste <- regsubsets(y ~ ., data = train_data, nvmax = cant.var)
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

############## HAGO KFOLDS
# Control de validación cruzada 5-fold en el conjunto de entrenamiento
control <- trainControl(method = "cv", number = 5)

# Entrenar modelo lineal con validación cruzada en train_data
cv.bic <- train(formula_bic, data = train_data, 
                method = "lm", trControl = control)

# Resultados entrenamiento con CV
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

# Obtener solo las variables necesarias para test_data
vars_mejor.bic <- all.vars(formula_bic)
test_data_filtrado.bic <- test_data[vars_mejor.bic]

# Predecir con el modelo ganador sobre las variables correctas

test.df<-data.frame(test_data_filtrado.bic[,-1]) #saco la variable respuesta
predicciones_test.bic <- predict(modelo.80, newdata = test.df)

# Calcular RMSE en test_data
rmse_final.bic <- sqrt(mean((test_data_filtrado.bic$y - predicciones_test.bic)^2))
cat("RMSE final en conjunto test (20%):", rmse_final.bic, "\n")


########################################################
########################################################

# Modelo final

# estimar los parámetro del modelo con la muestra completa de entrenamiento
# es decir, se reentrena el modelo con la muestra completa de entrenamiento

# Observación: si se tiene que predecir una nueva observación que no conocemos la variable respuesta
# entonces tiene sentido reentrenar el modelo con los datos completos

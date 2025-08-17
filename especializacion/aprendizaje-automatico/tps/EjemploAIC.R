# Cargo librerias

library(MASS)
library(leaps)
library(caret)


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

# AIC

# Ajusto con solo el intercept
ajuste_nulo <- lm(y ~ 1, data = datos)

#Ajuste modelo completo
ajuste_full<-lm(y ~ ., data = datos)

# Para ver el proceso de entrada de la variable

step_model.Forw<-stepAIC(ajuste_nulo, 
                         scope = list(lower = ajuste_nulo, upper = ajuste_full),
                         direction = "forward")

# Si no quiero ver el proceso de entrada de la variable
step_model.Forw<-stepAIC(ajuste_nulo, 
                         scope = list(lower = ajuste_nulo, upper = ajuste_full),
                         direction = "forward",trace = FALSE)
summary(step_model.Forw)

## Back
step_model.Back <- stepAIC(ajuste_full, 
                           scope = list(lower = ajuste_nulo, upper = ajuste_full), 
                           direction = "backward", trace = FALSE)

summary(step_model.Back)

## Both
step_model.Both <- stepAIC(ajuste_full, 
                           scope = list(lower = ajuste_nulo, upper = ajuste_full), 
                           direction = "both", trace = FALSE)

summary(step_model.Back)

# Elijo un modelo
# Método backward

summary(step_model.Back)

# Método forward
summary(step_model.Forw)

# Método Both
summary(step_model.Both)

# Cualquier de los métodos arroja el mismo modelo.


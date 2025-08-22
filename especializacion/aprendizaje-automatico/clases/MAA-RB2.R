# clase 2 MAA
# autor: Silvia Pérez
# fecha: 19/8/2025

#------------------#
# REDES BAYESIANAS #
##----------
library(ggplot2)
library(readxl)
library(caret)
library(e1071)
library(dplyr)

##EJEMPLO clasificación multiclase
data(iris)
summary(iris)

# Selección de una submuestra de una cantidad de casos
set.seed(13579)
iris.indices <- sample(1:nrow(iris),size=105)
iris.train <- iris[iris.indices,]
iris.test <- iris[-iris.indices,]

model <- naiveBayes(Species ~ ., data = iris.train)
model

predi.iris <- predict(object = model, newdata=iris.test, type = "class")
confusion.iris <- table(predi.iris,iris.test$Species)
confusion.iris

### mejorando el modelo 
# implemenacion con caret para ajustar el modelo con cross validation
# en train
x <- iris.train[, -5]
y <- iris.train$Species

# modelo NB en el conjunto de entrenamiento
nb.iris <- train(              # usa library(caret)
  x = x,
  y = y,
  method = "nb",
  trControl = trainControl(method = "cv", number = 10) # set up 10-fold CV
)
names(nb.iris)
nb.iris$finalModel$tables

confusionMatrix(nb.iris) #da porcentajes de clasificacion en train

#ahora veamos prediccion en test:
#Esta función predict aplicada a un modelo ajustado por la función train no es el mismo de antes
#admite type="raw" para sacar las clases predichas y "prob" para sacar las probabilidades
predi.iris2 <- predict(nb.iris, newdata = iris.test,type="raw")
#puedo ir directamente a confusionMatrix si predije las clases
confusionMatrix(predi.iris2, iris.test$Species) 
#ver en la salida que las métricas usan "uno contra todos"

## OBS: para hacer la curva ROC necesito 2 clases, y acá hay 3!
# podemos convertir en un problema binario:
# Convertir la variable Species en un problema binario (Setosa vs. No Setosa)
#esto crea una variable nueva indicadora de "setosa". 
iris$Species.setosa <- ifelse(iris$Species == "setosa", 1, 0)
# Luego ajusto modelos con esta y ahí ROC... lo mismo que antes!


########################################
####### REDES BAYESIANAS GENERALES #####

library(bnlearn)
data(asia)
summary(asia)
# construimos la RB sobre un conjunto de entrenamiento
set.seed(123)
indices <- sample(1:nrow(asia), nrow(asia) * 0.70, replace=FALSE)
asiaTrain<-asia[indices,]
asiaTest<-asia[-indices,]


### ESTRUCTURA PREFIJADA ####
modelA1 = empty.graph(names(asiaTrain))
modelstring(modelA1) = "[A][S][B][T|A][L|S][D|B:E][E|T:L][X|E]"
plot(modelA1)

### APRENDIENDO LA ESTRUCTURA con Hill Climbing:
model_hc<-hc(asiaTrain,score="aic")
model_hc
plot(model_hc)
modelstring(model_hc)

#comparamos estructuras ajustadas
#compare(modelA1,modelA2)
par(mfrow = c(1,2))
plot(modelA1, main = "Estructura dada", highlight = c("A", "B"))
plot(model_hc, main = "Hill-Climbing", highlight = c("A", "B"))

## APRENDER PARAMETROS
#aprendemos los parámetros con datos discretos(por ML)
fitA1 = bn.fit(modelA1, asiaTrain,method = "mle")
fitA1
bn.fit.barchart(fitA1$D) 

# aprendemos parámetros con datos discretos con estimación Bayesiana
fitB1 = bn.fit(modelA1, asiaTrain, method = "bayes")
fitB1

fit.hc = bn.fit(model_hc, asiaTrain, method = "bayes") # el default es mle
fit.hc


## PREDICCION ##
# queremos predecir si la persona tiene cancer de pulmón o tuberculosis a partir de los datos
# veamos la prediccion con el modelo fitA1
pred.A1a = predict(fitA1, node = "T", data = asiaTest, method = "parents") #prediccion exacta, no usa el DAG
head(pred.A1a) # muestra la clase predicha
#table(pred.A1a,asiaTest$T)

pred.A1b = predict(fitA1, node = "T", data = asiaTest, prob = TRUE) #predigo con ML
attr(pred.A1b, "prob")[, 1:5] #muestra las probabilidades predichas
table(pred.A1b,asiaTest$T)

pred.A1 = predict(fitA1, node = "T", data = asiaTest, method = "bayes-lw") # prediccion con Bayes con algoritmo de Monte Carlo
confusion.A1 <-  table(pred.A1,asiaTest$T)

library(caret)
confusionMatrix(confusion.A1,positive = "yes") # da mucho mejor!

# veamos la prediccion con el modelo hc
pred.hcb = predict(fit.hc, node = "L", data = asiaTest, prob = TRUE)
table(pred.hcb,asiaTest$L)
pred.hc = predict(fit.hc, node = "L", data = asiaTest, method = "bayes-lw")
confusion.hc <-  table(pred.hc,asiaTest$L)

library(caret)
confusionMatrix(confusion.hc,positive = "yes") # mucho mejor con esta estructura!

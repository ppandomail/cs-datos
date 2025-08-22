# clase  MAA
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
library(gridExtra)

## EJEMPLO con hipoteca ## 
datos <- read_excel("hipoteca25b.xlsx")
str(datos) 
datos <- datos[,-1]

datos$denegado<-as.factor(datos$denegado)
datos$soltero<-as.factor(datos$soltero)
datos$auton<-as.factor(datos$auton)
datos$malhist<-as.factor(datos$malhist)
datos$malhist3<-as.factor(datos$malhist3)
summary(datos)
# Se detectan datos muy atípicos en el préstamo solicitado respecto al valor del bien 
# saco los casos con atípicos (igual al análisis con logística)
datos2<-datos[datos$rat <1.5,]
summary(datos2)

# Vamos a ajustar modelos en conj de entrenamiento y lo evaluamos en conj de testing
set.seed(123)
indices<- createDataPartition(datos2$denegado, p=0.7, list=FALSE)
dataTrain <- datos2[indices, ]
dataTest <- datos2[-indices, ]

#############################
### AJUSTAMOS NAIVE BAYES ###
mod1 <- naiveBayes(denegado ~malhist+auton+soltero, data = dataTrain,laplace=0) #laplace=1 para que lo habilite
mod1

#OJO! no permite interacciones
#admite variables categoricas y/o numéricas
#las categoricas las toma como factores, las numericas como normales

#veamos como hace la prediccion en un caso:
dataTest[1,] #el caso 1 del conjunto de Test
predict(object = mod1, newdata=dataTest[1,], type = "raw") #probabilidades predichas
predict(object = mod1, newdata=dataTest[1,], type = "class") #clase predicha

#evaluamos la predicción en test:
#para ver las probabilidades predichas para cada caso:
proba.1<-predict(object = mod1, newdata=dataTest, type = "raw")
head(proba.1)
#si quiero la clase predicha:
predi.1<- predict(object = mod1, newdata=dataTest, type = "class")
head(predi.1)

confusion.1 <- table(predi.1, dataTest$denegado, dnn = c("predicho","observado"))
library(caret)
confusionMatrix(confusion.1,positive = "1") 
summary(dataTest)
#da muy mal la sensitividad! Pero notar que esto hace la clasificación con umbral=0.5.. se puede cambiar!

#CURVA ROC Y AUC 
library(ROCR)
prediccion1<-prediction(proba.1[,2],dataTest$denegado)
roc_mod1 <- performance(prediccion1, measure = "tpr", x.measure = "fpr")

plot(roc_mod1, main = "Naive Bayes mod1", colorize = T)
abline(a = 0, b = 1)
AUC.mod1 <- performance(prediccion1, "auc")
#para que me de AUC:
AUC.mod1@y.values

## MODELO CON TODAS LAS NUMERICAS ##
mod2 <- naiveBayes(denegado ~gasto+rat+rat.desem, data = dataTrain,laplace=0) #laplace=1 para que lo habilite
mod2
# hacer matriz de confusion y AUC:
proba.2<-predict(object = mod2, newdata=dataTest, type = "raw")
head(proba.2)
#si quiero la clase predicha:
predi.2<- predict(object = mod2, newdata=dataTest, type = "class")
head(predi.2)

confusion.2 <- table(predi.2, dataTest$denegado, dnn = c("predicho","observado"))
#library(caret)
confusionMatrix(confusion.2,positive = "1")
prediccion2<-prediction(proba.2[,2],dataTest$denegado)
roc_mod2 <- performance(prediccion2, measure = "tpr", x.measure = "fpr")

plot(roc_mod2, main = "Naive Bayes mod2", colorize = T)
abline(a = 0, b = 1)
AUC.mod2 <- performance(prediccion2, "auc")
#para que me de AUC:
AUC.mod2@y.values

## graficamos varias curvas:
plot(roc_mod1, col = "darkgreen")
plot(roc_mod2, col = "purple", add = TRUE)
legend("bottomright", legend = c("mod1", "mod2"), col = c("darkgreen", "purple"), lty = 1)
abline(a = 0, b = 1)

################## ###################
## Probemos IMPUTACION ##
# antes creo nueva variable con NA en los datos que antes descartabamos
datos <- mutate(datos, rat2 = ifelse(rat>1.5, NA,rat))
summary(datos)
str(datos)
# podemos imputar con media o mediana o knn o bagging o ... hay muchos métodos!
#Por ejemplo usando caret:
med_imp <- predict(preProcess(datos, method = c("medianImpute")), datos)
summary(med_imp)
bag_imp <- predict(preProcess(datos, method = c("bagImpute")), datos) # usa arboles de decision
summary(bag_imp)
#veamos cómo imputó algún caso:
data.frame(datos[369,c(2,9)],med_imp[369,c(2,9)],bag_imp[369,c(2,9)])

plot(med_imp$rat2,bag_imp$rat2)

#probemos algún modelo:
index<- createDataPartition(med_imp$denegado, p=0.7, list=FALSE)
train <- med_imp[index, ]
test <- med_imp[-index, ]

#veamos el modelo que tiene rat2
mod2.i <- naiveBayes(denegado ~gasto+rat2+rat.desem, data = train,laplace=0) #laplace=1 para que lo habilite
mod2.i
#calculemos capacidad predictiva:
library(ROCR)
proba.2.i<-predict(object = mod2.i, newdata=test, type = "raw")
prediccion2.i<-prediction(proba.2.i[,2],test$denegado)
AUC.mod2.i <- performance(prediccion2.i, "auc")@y.values
AUC.mod2.i

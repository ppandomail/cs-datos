# clase 2 MAA
# autor: Silvia Pérez
# fecha: 5-12/8/2025

#------------------#
library(ggplot2)
library(readxl)
library(GGally) #para matriz de graficos
library(ResourceSelection)
library(DescTools)
library(caret) #para matriz de confusion 
library(ROCR)
library(gridExtra)

##### EJEMPLO hipoteca #####

datos <- read_excel("hipoteca25b.xlsx")
str(datos) 
datos <- datos[, -1]

datos$denegado<-as.factor(datos$denegado)
datos$soltero<-as.factor(datos$soltero)
datos$auton<-as.factor(datos$auton)
datos$malhist<-as.factor(datos$malhist)
datos$malhist3<-as.factor(datos$malhist3)
summary(datos)
sum(is.na(datos)) #no hay faltantes
#	Analicemos las variables disponibles para incluirlas de modo adecuado.

# Analisis basico de cada VARIABLE NUMERICA respecto a denegado (la hipoteca).
bp1 <- ggplot(data = datos, aes(y = gasto), colour = factor(denegado)) +
  geom_boxplot(aes(x = denegado, fill = factor(denegado))) +
  xlab("denegado") + ylab("gastos/ingresos") 
  
bp2 <-ggplot(data = datos, aes(y = rat), colour = factor(denegado)) +
  geom_boxplot(aes(x = denegado, fill = factor(denegado))) +
  xlab("denegado") + ylab("préstamo/valor valor del bien") 
  
bp3 <-ggplot(data = datos, aes(y = rat.desem), colour = factor(denegado)) +
  geom_boxplot(aes(x = denegado, fill = factor(denegado))) +
  xlab("denegado") + ylab("Tasa de desempleo")
  
grid.arrange(bp1, bp2, bp3)

# Se detectan datos muy atípicos en el préstamo solicitado respecto al valor del bien 
which(datos$rat >=2) #son 26 casos
datos2<-datos[datos$rat <1.5,]
summary(datos2)

#veamos otra vez los boxplots:
bp1 <- ggplot(data = datos2, aes(y = gasto), colour = factor(denegado)) +
  geom_boxplot(aes(x = denegado, fill = factor(denegado))) +
  xlab("denegado") + ylab("gastos/ingresos") 
bp2 <-ggplot(data = datos2, aes(y = rat), colour = factor(denegado)) +
  geom_boxplot(aes(x = denegado, fill = factor(denegado))) +
  xlab("denegado") + ylab("préstamo/valor valor del bien") 
bp3 <-ggplot(data = datos2, aes(y = rat.desem), colour = factor(denegado)) +
  geom_boxplot(aes(x = denegado, fill = factor(denegado))) +
  xlab("denegado") + ylab("Tasa de desempleo")
grid.arrange(bp1, bp2, bp3) 

which(datos2$gasto>2)
#se ve un atípico para gastos.. lo dejamos y veremos en el modelo si influye


# Analisis basico de cada VARIABLE CATEGORICA respecto a "denegado"
#ver si no hay casillas con pocos datos
table(datos$denegado,datos$malhist) #
table(datos$denegado,datos$auton)
table(datos$denegado,datos$soltero)
table(datos$denegado,datos$malhist3) #en denegado=1 hay pocos con buen historial
prop.table(table(datos$denegado,datos$malhist3)) # se ven las proporciones del total

## OBS!! hay dos variables que parecen medir lo mismo..
table(datos$malhist3,datos$malhist) 
#tomar en cuenta para no incluirlas en el mismo modelo!

### Veamos todo junto:
ggpairs(datos2,mapping = aes(colour= denegado)) + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + theme_bw()


# Vamos a ajustar modelos en conj de entrenamiento y lo evaluamos en conj de testing
set.seed(123)
#indices <- sample(1:nrow(datos), nrow(datos) * 0.70, replace=FALSE)
indices<- createDataPartition(datos2$denegado, p=0.7, list=FALSE)
dataTrain <- datos2[indices, ]
dataTest <- datos2[-indices, ]

## MODELOS LOGISTICOS
#por ahora no usemos "malhist3" 
mod1 <- glm(denegado ~ .-malhist3, data = dataTrain,family = binomial)
summary(mod1) # modelo completo (o casi..)

mod2 <- glm(denegado ~ rat, data = dataTrain,family = binomial)
summary(mod2) #modelo simple

#modelo con significativas en el modelo completo:
mod3<-glm(denegado ~ gasto+rat+malhist+soltero,data=dataTrain,family = binomial)
summary(mod3)

#modelo con seleccion automática:
mod4<-step(mod1, direction = "backward", trace = 1)
summary(mod4)

#comparo los modelos segun AIC:
AIC(mod1,mod2,mod3,mod4)

# comparación de modelos con devianzas:
anova(mod1,mod2,mod3,mod4)
# cual gana ? parece que mod4

# Para los modelos que elegimos (2 o 3), ver:
# LO HAGO CON mod3, habría que hacerlo con cada uno..
# a) ¿Es significativo el modelo?
mod_null<-glm(denegado ~ 1,data=dataTrain,family = binomial)
anova(mod_null,mod3) #pvalor=< 2.2e-16 *** entonces el modelo es signif!
# b) ¿Son todas las variables significativas para el modelo? ver con Wald y con devianzas
#con Wald variable gasto: pvalor=< 2.2e-16 *** entonces 
# es significativo agregar la variable gasto al modelo estando las otras presentes.
# signif con devianzas:
mod_sin_gasto<-glm(denegado ~ rat+malhist+soltero,data=dataTrain,family = binomial)
anova(mod3,mod_sin_gasto) #pv=2.716e-09 *** entonces es sig la variable gasto

# c)	Considere un test de bondad de ajuste: ¿qué conclusión se obtiene?
hoslem.test(mod1$y, fitted(mod1),g=8) 
hoslem.test(mod2$y, fitted(mod2))
hoslem.test(mod3$y, fitted(mod3)) 
hoslem.test(mod4$y, fitted(mod4)) 

# d) Hay puntos influyentes (ver Cook y leverages)
library(car)
car::influenceIndexPlot(mod3, vars = "Cook",
                        id=T, main = "Cook's distance")
influenceIndexPlot(mod3, vars = "hat",
                   id=T, main = "Leverages")
#notar que el caso con gasto alto no apareció como influyente o de alto leverage

# e)	Indique valores de pseudos R2 
PseudoR2(mod3, c("CoxSnell", "Nagel")) #usa library(DescTools)
PseudoR2(mod4, c("CoxSnell", "Nagel"))

# f) analizar multicolinealidad
vif(mod1)


######################################
## REG LOGISTICA PARA CLASIFICACION ##
######################################

# Trabajemos con un modelo (mod3) para evaluar la clasificación en el conjunto de testeo:

###### MATRIZ DE CONFUSION ##### 

# Generamos la prediccion en los datos de test:
proba <- predict.glm(mod3, newdata = dataTest, type = "response") 
#esto calcula probabilidades predichas en test

##LO SIGUIENTE DEPENDE DEL PUNTO DE CORTE!!!!
# generamos la clase predicha según un punto de corte que fijamos:
predi.y <- ifelse(proba >= 0.5, 1, 0)
matriz_confusion <- table(predi.y,dataTest$denegado, dnn = c("predicho","observado"))
#tener cuidado con el orden! predicho-observado es como lo toma confusionMatrix

matriz_confusion
summary(dataTest) #controlar que la matriz esté en el orden correcto

preci=precision(matriz_confusion,relevant = "1") # 6/(6+6) 
sensi=recall(matriz_confusion,relevant = "1")    # 6/(6+75)
F1 = 2* preci*sensi/(preci+sensi)                # 
especi=recall(matriz_confusion,relevant = "0")   #
data.frame(preci,sensi,especi,F1)

## GRAFICAMOS la tabla de confusion
library(vcd)
mosaic(matriz_confusion, shade = T, colorize =T,
       gp = gpar(fill = matrix(c("green","red","red","green"),2,2)))
matriz_confusion #ver que el gráfico muestra las proporciones como áreas coloreadas.

#lo que sigue calcula directamente los indicadores!!
library(caret)
matriz=confusionMatrix(matriz_confusion,positive = "1")
matriz
names(matriz)
matriz$byClass[[1]] #para extraer el valor de sensitividad
matriz$byClass[[2]] #para extraer el valor de especificidad
matriz$byClass[[3]] #Pos Pred Value es la precision
## se ve que esta clasificación captura bien los negativos pero muy mal los positivos!!
# hay que mejorar el punto de corte (umbral de clasificación). Ver en sección EXTRA.

####### CURVA ROC Y AUC ########
# Veamos sobre dos modelos para compararlos según esto:
#library(ROCR)
# primero generamos la prediccion en los datos de test:
proba3 <- predict.glm(mod3, newdata = dataTest, type = "response") 
prediccion3 <- prediction(proba3, dataTest$denegado)
#prediccion@predictions #da lo mismo que proba pero como lista

# generamos objeto con la prediccion
roc_modelo3 <- performance(prediccion3, measure = "tpr", x.measure = "fpr")
plot(roc_modelo3, main = "curva ROC", colorize = T)
abline(a = 0, b = 1)
AUC3 <- performance(prediccion3, "auc")@y.values
#para que me de el area bajo la curva ROC (AUC):
AUC3 

## Lo habitual es con devianzas y AIC elegir un par de modelos en TRAIN y
## sobre estos calcular las metricas en TEST para elegir el moldelo ganador.

#### Veo el cálculo de AUC con modelo mod4 #####
proba4 <- predict.glm(mod4, newdata = dataTest, type = "response") 
prediccion4 <- prediction(proba4, dataTest$denegado)
roc_modelo4 <- performance(prediccion4, measure = "tpr", x.measure = "fpr")
plot(roc_modelo4, main = "curva ROC", colorize = T)
abline(a = 0, b = 1)
AUC4 <- performance(prediccion4, "auc")@y.values
AUC4

## graficamos las dos curvas:
plot(roc_modelo3, col = "red")
plot(roc_modelo4, col = "purple", add = TRUE)
legend("bottomright", legend = c("mod3", "mod4"), col = c("red", "purple"), lty = 1)
abline(a = 0, b = 1)
 
##############################
      ###### EXTRA ####
## Buscamos un punto de corte adecuado para la matriz de confusion: 
proba <- predict.glm(mod3, newdata = dataTest, type = "response") 
pc = seq(from = 0.1, to = 0.9, by = 0.1)
accu = rep(1,length(pc)) 
#accu=c()
sens = rep(1,length(pc))
spec = rep(1,length(pc))
preci = rep(1,length(pc))
F1 = rep(1,length(pc))

for(i in 1:length(pc))
 {pred_y = ifelse(proba >i/10 , 1, 0)
confusion = table(pred_y,dataTest$denegado)
print(confusion)
VP=confusion[2,2] #lo defino así para que se vea desde la tabla
print(VP)
VN=confusion[1,1]
FP=confusion[2,1]
FN=confusion[1,2]
accu[i] = (VP+VN)/(VP+VN+FP+FN)
sens[i] = VP/(VP+FN)
spec[i] = VN/(VN+FP)
preci[i] = VP/(VP+FP)
F1[i] = 2*preci[i]*sens[i]/(sens[i]+preci[i])

}
df_mod.log = data.frame(
  Umbral = pc,
  Accuracy= accu,
  Precision = preci,
  Sensibilidad = sens,
  Especificidad = spec,
  F1 = F1
)
df_mod.log 
## Vemos que podríamos elegir punto de corte en 0.1-0.5 para maximizar sensit, precis, F1...
#grafico sensitividad y especificidad
ggplot(df_mod.log, aes(x = Umbral) )+
  geom_line(aes(y = Sensibilidad, color = "Sensibilidad")) +
  geom_line(aes(y = Especificidad, color = "Especificidad")) +
  labs(y = "Valor", color = "") +
  theme_minimal()

## para ver qué pasa con los valores altos:
predi.y <- ifelse(proba >= 0.7, 1, 0)
confusion <- table(predi.y,dataTest$denegado, dnn = c("predicho","observado"))
VP=confusion[2,2] #lo defino así para que se vea desde la tabla
VN=confusion[1,1]
FP=confusion[2,1]
FN=confusion[1,2]
accu = (VP+VN)/(VP+VN+FP+FN)
sens = VP/(VP+FN)
spec = VN/(VN+FP)
preci = VP/(VP+FP)
F1 = 2*preci*sens/(sens+preci)
#Se ve que tira errores porque la matriz de confusión tiene una sola fila!
# esto es porque ningún caso queda clasificado como 1. 
# Entonces los cálculos de las métricas no son reales.. 
# Se ve raro en el gráfico y también en el data frame de métricas "df_mod.log", hay que saber detectar cuando hay estos errores!

######### EXTRA 2 #######
mod5 <- glm(denegado ~ gasto+malhist, data = dataTrain,family = binomial)
summary(mod5) # hay una sola dummy porque malhist tiene dos categorías.

# Modelo con una categórica de 3 categorías (surgen dos dummies)
mod5b <- glm(denegado ~ gasto+malhist3, data = dataTrain,family = binomial)
summary(mod5b)
#cómo interpretamos los coeficientes de las dummies??

# acá se ve la necesidad de colapsar categorías...
#podríamos hacerlo con lo siguiente, pero en realidad ya tenemos esa variable en el dataset
#datos$histo2<-ifelse(datos$histo=="3",1,0) #con esto juntamos categ 1 y 2 de malhist3


####### EXTRA 3 ########
### GRAFICOS EN UN MODELO SIMPLE ###
# en mod2: denegado ~ rat
mod2 <- glm(denegado ~ rat, data = dataTrain,family = binomial)

binomial_smooth <- function(...) {
  geom_smooth(method = "glm", method.args = list(family = "binomial"), ...)
}
ggplot(data = dataTrain,aes(x = rat, y = predict.glm(mod2,type = "response"))) +
  geom_jitter(height = 0.03) +
  binomial_smooth()

# Otra
dataTrain$proba<-predict.glm(mod2,type = "response")
ggplot(data = dataTrain,aes(x = rat, y = proba)) +
  geom_jitter(height = 0.03) +
  geom_smooth(method = "loess") 
# OJO! loess da una forma de suavizar que no tiene en cuenta que son probabilidades


